import 'package:dartz/dartz.dart';
import 'package:eaqarati_app/core/errors/failures.dart';
import 'package:eaqarati_app/features/domain/repositories/property_repository.dart';

class DeletePropertyUseCase {
  final PropertyRepository propertyRepository;

  DeletePropertyUseCase(this.propertyRepository);

  Future<Either<Failure, Unit>> call(int propertyId) async {
    return await propertyRepository.deleteProperty(propertyId);
  }
}
