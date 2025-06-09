import 'package:eaqarati_app/core/utils/enum.dart';
import 'package:eaqarati_app/features/data/models/scheduled_payment_model.dart';
import 'package:eaqarati_app/features/data/sources/local/database_helper.dart';
import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';

abstract class ScheduledPaymentLocalDataSource {
  Future<ScheduledPaymentModel?> getScheduledPaymentById(int id);
  Future<List<ScheduledPaymentModel>> getAllScheduledPayments();
  Future<List<ScheduledPaymentModel>> getScheduledPaymentsByLeaseId(
    int leaseId,
  );
  Future<List<ScheduledPaymentModel>> getScheduledPaymentsByStatus(
    String status,
  ); // e.g., 'Pending', 'Overdue'
  Future<List<ScheduledPaymentModel>> getOverdueScheduledPayments(
    DateTime currentDate,
  );
  Future<int> addScheduledPayment(ScheduledPaymentModel payment);
  Future<List<int>> addScheduledPaymentsBatch(
    List<ScheduledPaymentModel> payments,
  );
  Future<int> updateScheduledPayment(ScheduledPaymentModel payment);
  Future<int> deleteScheduledPayment(int id);
  Future<int> deleteScheduledPaymentsByLeaseId(int leaseId);
}

class ScheduledPaymentLocalDataSourceImpl
    implements ScheduledPaymentLocalDataSource {
  final DatabaseHelper databaseHelper;
  final Logger _logger = Logger();

  ScheduledPaymentLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<int> addScheduledPayment(ScheduledPaymentModel payment) async {
    final db = await databaseHelper.database;
    Map<String, dynamic> paymentMap = payment.toMap();
    paymentMap.removeWhere(
      (key, value) =>
          key == DatabaseHelper.colScheduledPaymentId && value == null,
    );
    _logger.i("Adding scheduled payment: ${paymentMap.toString()}");
    try {
      return await db.insert(
        DatabaseHelper.tableScheduledPayments,
        paymentMap,
        conflictAlgorithm: ConflictAlgorithm.abort,
      );
    } catch (e) {
      _logger.e("Error adding scheduled payment: $e");
      rethrow;
    }
  }

  @override
  Future<List<int>> addScheduledPaymentsBatch(
    List<ScheduledPaymentModel> payments,
  ) async {
    final db = await databaseHelper.database;
    final batch = db.batch();
    _logger.i("Adding batch of ${payments.length} scheduled payments.");
    for (var payment in payments) {
      Map<String, dynamic> paymentMap = payment.toMap();
      paymentMap.removeWhere(
        (key, value) =>
            key == DatabaseHelper.colScheduledPaymentId && value == null,
      );
      batch.insert(
        DatabaseHelper.tableScheduledPayments,
        paymentMap,
        conflictAlgorithm: ConflictAlgorithm.abort,
      );
    }
    try {
      final results = await batch.commit(
        noResult: false,
      ); // noResult: false returns list of IDs
      return results
          .whereType<int>()
          .toList(); // Filter out any potential nulls if driver behavior varies
    } catch (e) {
      _logger.e("Error adding scheduled payments batch: $e");
      rethrow;
    }
  }

  @override
  Future<int> deleteScheduledPayment(int id) async {
    final db = await databaseHelper.database;
    _logger.i("Deleting scheduled payment with id: $id");
    try {
      return await db.delete(
        DatabaseHelper.tableScheduledPayments,
        where: '${DatabaseHelper.colScheduledPaymentId} = ?',
        whereArgs: [id],
      );
    } catch (e) {
      _logger.e("Error deleting scheduled payment $id: $e");
      rethrow;
    }
  }

  @override
  Future<int> deleteScheduledPaymentsByLeaseId(int leaseId) async {
    final db = await databaseHelper.database;
    _logger.i("Deleting scheduled payments for lease id: $leaseId");
    try {
      return await db.delete(
        DatabaseHelper.tableScheduledPayments,
        where: '${DatabaseHelper.colScheduledPaymentLeaseId} = ?',
        whereArgs: [leaseId],
      );
    } catch (e) {
      _logger.e("Error deleting scheduled payments for lease id $leaseId: $e");
      rethrow;
    }
  }

  @override
  Future<List<ScheduledPaymentModel>> getAllScheduledPayments() async {
    final db = await databaseHelper.database;
    _logger.i("Getting all scheduled payments");
    try {
      final List<Map<String, dynamic>> maps = await db.query(
        DatabaseHelper.tableScheduledPayments,
      );
      return maps.map((map) => ScheduledPaymentModel.fromMap(map)).toList();
    } catch (e) {
      _logger.e("Error getting all scheduled payments: $e");
      rethrow;
    }
  }

  @override
  Future<ScheduledPaymentModel?> getScheduledPaymentById(int id) async {
    final db = await databaseHelper.database;
    _logger.i("Getting scheduled payment by id: $id");
    try {
      final List<Map<String, dynamic>> maps = await db.query(
        DatabaseHelper.tableScheduledPayments,
        where: '${DatabaseHelper.colScheduledPaymentId} = ?',
        whereArgs: [id],
        limit: 1,
      );
      if (maps.isNotEmpty) {
        return ScheduledPaymentModel.fromMap(maps.first);
      }
      return null;
    } catch (e) {
      _logger.e("Error getting scheduled payment by id $id: $e");
      rethrow;
    }
  }

  @override
  Future<List<ScheduledPaymentModel>> getScheduledPaymentsByLeaseId(
    int leaseId,
  ) async {
    final db = await databaseHelper.database;
    _logger.i("Getting scheduled payments for lease id: $leaseId");
    try {
      final List<Map<String, dynamic>> maps = await db.query(
        DatabaseHelper.tableScheduledPayments,
        where: '${DatabaseHelper.colScheduledPaymentLeaseId} = ?',
        whereArgs: [leaseId],
        orderBy:
            '${DatabaseHelper.colScheduledPaymentDueDate} ASC', // Good to order them
      );
      return maps.map((map) => ScheduledPaymentModel.fromMap(map)).toList();
    } catch (e) {
      _logger.e("Error getting scheduled payments for lease id $leaseId: $e");
      rethrow;
    }
  }

  @override
  Future<List<ScheduledPaymentModel>> getScheduledPaymentsByStatus(
    String status,
  ) async {
    final db = await databaseHelper.database;
    _logger.i("Getting scheduled payments with status: $status");
    try {
      final List<Map<String, dynamic>> maps = await db.query(
        DatabaseHelper.tableScheduledPayments,
        where: '${DatabaseHelper.colScheduledPaymentStatus} = ?',
        whereArgs: [status],
        orderBy: '${DatabaseHelper.colScheduledPaymentDueDate} ASC',
      );
      return maps.map((map) => ScheduledPaymentModel.fromMap(map)).toList();
    } catch (e) {
      _logger.e("Error getting scheduled payments with status $status: $e");
      rethrow;
    }
  }

  @override
  Future<List<ScheduledPaymentModel>> getOverdueScheduledPayments(
    DateTime currentDate,
  ) async {
    final db = await databaseHelper.database;
    final dateString = currentDate.toIso8601String().substring(0, 10);
    _logger.i("Getting overdue scheduled payments before: $dateString");
    try {
      final List<Map<String, dynamic>> maps = await db.query(
        DatabaseHelper.tableScheduledPayments,
        where:
            '${DatabaseHelper.colScheduledPaymentDueDate} < ? AND ${DatabaseHelper.colScheduledPaymentStatus} IN (?, ?)',
        whereArgs: [
          dateString,
          ScheduledPaymentStatus.pending.value,
          ScheduledPaymentStatus.partiallyPaid.value,
        ],
        orderBy: '${DatabaseHelper.colScheduledPaymentDueDate} ASC',
      );
      return maps.map((map) => ScheduledPaymentModel.fromMap(map)).toList();
    } catch (e) {
      _logger.e("Error getting overdue scheduled payments: $e");
      rethrow;
    }
  }

  @override
  Future<int> updateScheduledPayment(ScheduledPaymentModel payment) async {
    final db = await databaseHelper.database;
    _logger.i("Updating scheduled payment: ${payment.toMap().toString()}");
    try {
      return await db.update(
        DatabaseHelper.tableScheduledPayments,
        payment.toMap(),
        where: '${DatabaseHelper.colScheduledPaymentId} = ?',
        whereArgs: [payment.scheduledPaymentId],
      );
    } catch (e) {
      _logger.e(
        "Error updating scheduled payment ${payment.scheduledPaymentId}: $e",
      );
      rethrow;
    }
  }
}
