import 'package:dartz/dartz.dart';
import 'package:eaqarati_app/core/errors/failures.dart';
import 'package:eaqarati_app/features/domain/entities/Property_entity.dart';
import 'package:eaqarati_app/features/domain/repositories/property_repository.dart';

class GetAllPropertiesUseCase {
  final PropertyRepository propertyRepository;

  GetAllPropertiesUseCase(this.propertyRepository);

  Future<Either<Failure, List<PropertyEntity>>> call() async {
    return await propertyRepository.getAllProperties();
  }
}
