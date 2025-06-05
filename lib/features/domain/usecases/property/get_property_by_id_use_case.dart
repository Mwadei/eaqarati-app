import 'package:dartz/dartz.dart';
import 'package:eaqarati_app/core/errors/failures.dart';
import 'package:eaqarati_app/features/domain/entities/property_entity.dart';
import 'package:eaqarati_app/features/domain/repositories/property_repository.dart';

class GetPropertyByIdUseCase {
  final PropertyRepository propertyRepository;

  GetPropertyByIdUseCase(this.propertyRepository);

  Future<Either<Failure, PropertyEntity>> call(int propertyId) async {
    return await propertyRepository.getPropertyById(propertyId);
  }
}
