import 'package:dartz/dartz.dart';
import 'package:eaqarati_app/core/errors/failures.dart';
import 'package:eaqarati_app/features/domain/entities/payment_entity.dart';
import 'package:eaqarati_app/features/domain/repositories/payment_repository.dart';

class GetPaymentByIdUseCase {
  final PaymentRepository repository;
  GetPaymentByIdUseCase(this.repository);
  Future<Either<Failure, PaymentEntity>> call(int id) async {
    return await repository.getPaymentById(id);
  }
}
