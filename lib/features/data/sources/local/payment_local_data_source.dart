import 'package:eaqarati_app/features/data/models/payment_model.dart';
import 'package:eaqarati_app/features/data/sources/local/database_helper.dart';
import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

abstract class PaymentLocalDataSource {
  Future<PaymentModel?> getPaymentById(int id);
  Future<List<PaymentModel>> getAllPayments();
  Future<List<PaymentModel>> getPaymentsByLeaseId(int leaseId);
  Future<List<PaymentModel>> getPaymentsByTenantId(int tenantId);
  Future<List<PaymentModel>> getPaymentsByScheduledPaymentId(
    int scheduledPaymentId,
  );
  Future<int> addPayment(PaymentModel payment, {sqflite.Transaction? txn});
  Future<int> updatePayment(PaymentModel payment, {sqflite.Transaction? txn});
  Future<int> deletePayment(int id, {sqflite.Transaction? txn});
}

class PaymentLocalDataSourceImpl implements PaymentLocalDataSource {
  final DatabaseHelper databaseHelper;
  final Logger _logger = Logger();

  PaymentLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<int> addPayment(
    PaymentModel payment, {
    sqflite.Transaction? txn,
  }) async {
    final dbOrTxn = txn ?? await databaseHelper.database;
    Map<String, dynamic> paymentMap = payment.toMap();
    paymentMap.removeWhere(
      (key, value) => key == DatabaseHelper.colPaymentId && value == null,
    );
    _logger.i("Adding payment: ${paymentMap.toString()}");
    try {
      return await dbOrTxn.insert(
        DatabaseHelper.tablePayments,
        paymentMap,
        conflictAlgorithm: sqflite.ConflictAlgorithm.abort,
      );
    } catch (e) {
      _logger.e("Error adding payment: $e");
      rethrow;
    }
  }

  @override
  Future<int> deletePayment(int id, {sqflite.Transaction? txn}) async {
    final dbOrTxn = txn ?? await databaseHelper.database;
    _logger.i("Deleting payment with id: $id");
    try {
      return await dbOrTxn.delete(
        DatabaseHelper.tablePayments,
        where: '${DatabaseHelper.colPaymentId} = ?',
        whereArgs: [id],
      );
    } catch (e) {
      _logger.e("Error deleting payment $id: $e");
      rethrow;
    }
  }

  @override
  Future<List<PaymentModel>> getAllPayments() async {
    final db = await databaseHelper.database;
    _logger.i("Getting all payments");
    try {
      final List<Map<String, dynamic>> maps = await db.query(
        DatabaseHelper.tablePayments,
      );
      return maps.map((map) => PaymentModel.fromMap(map)).toList();
    } catch (e) {
      _logger.e("Error getting all payments: $e");
      rethrow;
    }
  }

  @override
  Future<PaymentModel?> getPaymentById(int id) async {
    final db = await databaseHelper.database;
    _logger.i("Getting payment by id: $id");
    try {
      final List<Map<String, dynamic>> maps = await db.query(
        DatabaseHelper.tablePayments,
        where: '${DatabaseHelper.colPaymentId} = ?',
        whereArgs: [id],
        limit: 1,
      );
      if (maps.isNotEmpty) {
        return PaymentModel.fromMap(maps.first);
      }
      return null;
    } catch (e) {
      _logger.e("Error getting payment by id $id: $e");
      rethrow;
    }
  }

  @override
  Future<List<PaymentModel>> getPaymentsByLeaseId(int leaseId) async {
    final db = await databaseHelper.database;
    _logger.i("Getting payments for lease id: $leaseId");
    try {
      final List<Map<String, dynamic>> maps = await db.query(
        DatabaseHelper.tablePayments,
        where: '${DatabaseHelper.colPaymentLeaseId} = ?',
        whereArgs: [leaseId],
        orderBy: '${DatabaseHelper.colPaymentDate} DESC',
      );
      return maps.map((map) => PaymentModel.fromMap(map)).toList();
    } catch (e) {
      _logger.e("Error getting payments for lease id $leaseId: $e");
      rethrow;
    }
  }

  @override
  Future<List<PaymentModel>> getPaymentsByTenantId(int tenantId) async {
    final db = await databaseHelper.database;
    _logger.i("Getting payments for tenant id: $tenantId");
    try {
      final List<Map<String, dynamic>> maps = await db.query(
        DatabaseHelper.tablePayments,
        where: '${DatabaseHelper.colPaymentTenantId} = ?',
        whereArgs: [tenantId],
        orderBy: '${DatabaseHelper.colPaymentDate} DESC',
      );
      return maps.map((map) => PaymentModel.fromMap(map)).toList();
    } catch (e) {
      _logger.e("Error getting payments for tenant id $tenantId: $e");
      rethrow;
    }
  }

  @override
  Future<List<PaymentModel>> getPaymentsByScheduledPaymentId(
    int scheduledPaymentId,
  ) async {
    final db = await databaseHelper.database;
    _logger.i("Getting payments for scheduled payment id: $scheduledPaymentId");
    try {
      final List<Map<String, dynamic>> maps = await db.query(
        DatabaseHelper.tablePayments,
        where: '${DatabaseHelper.colPaymentScheduledPaymentId} = ?',
        whereArgs: [scheduledPaymentId],
        orderBy: '${DatabaseHelper.colPaymentDate} ASC',
      );
      return maps.map((map) => PaymentModel.fromMap(map)).toList();
    } catch (e) {
      _logger.e(
        "Error getting payments for scheduled payment id $scheduledPaymentId: $e",
      );
      rethrow;
    }
  }

  @override
  Future<int> updatePayment(
    PaymentModel payment, {
    sqflite.Transaction? txn,
  }) async {
    final dbOrTxn = txn ?? await databaseHelper.database;
    _logger.w(
      "Attempting to update payment (use with caution): ${payment.toMap().toString()}",
    );
    try {
      return await dbOrTxn.update(
        DatabaseHelper.tablePayments,
        payment.toMap(),
        where: '${DatabaseHelper.colPaymentId} = ?',
        whereArgs: [payment.paymentId],
      );
    } catch (e) {
      _logger.e("Error updating payment ${payment.paymentId}: $e");
      rethrow;
    }
  }
}
