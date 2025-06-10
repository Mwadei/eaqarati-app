import 'package:dartz/dartz.dart';
import 'package:eaqarati_app/core/errors/failures.dart';
import 'package:eaqarati_app/features/domain/entities/payment_entity.dart';
import 'package:eaqarati_app/features/domain/repositories/payment_repository.dart';

class GetPaymentsByScheduledPaymentIdUseCase {
  final PaymentRepository paymentRepository;

  GetPaymentsByScheduledPaymentIdUseCase(this.paymentRepository);

  Future<Either<Failure, List<PaymentEntity>>> call(
    int scheduledPaymentId,
  ) async {
    return await paymentRepository.getPaymentsByScheduledPaymentId(
      scheduledPaymentId,
    );
  }
}
