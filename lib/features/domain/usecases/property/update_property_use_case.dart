import 'package:dartz/dartz.dart';
import 'package:eaqarati_app/core/errors/failures.dart';
import 'package:eaqarati_app/features/domain/entities/Property_entity.dart';
import 'package:eaqarati_app/features/domain/repositories/property_repository.dart';

class UpdatePropertyUseCase {
  final PropertyRepository propertyRepository;

  UpdatePropertyUseCase(this.propertyRepository);

  Future<Either<Failure, Unit>> call(PropertyEntity property) async {
    return await propertyRepository.updateProperty(property);
  }
}
