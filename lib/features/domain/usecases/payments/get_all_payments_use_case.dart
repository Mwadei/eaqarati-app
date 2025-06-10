import 'package:dartz/dartz.dart';
import 'package:eaqarati_app/core/errors/failures.dart';
import 'package:eaqarati_app/features/domain/entities/payment_entity.dart';
import 'package:eaqarati_app/features/domain/repositories/payment_repository.dart';

class GetAllPaymentsUseCase {
  final PaymentRepository paymentRepository;

  GetAllPaymentsUseCase(this.paymentRepository);
  Future<Either<Failure, List<PaymentEntity>>> call() async {
    return await paymentRepository.getAllPayments();
  }
}
