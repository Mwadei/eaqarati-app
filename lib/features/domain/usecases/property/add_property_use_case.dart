import 'package:dartz/dartz.dart';
import 'package:eaqarati_app/core/errors/failures.dart';
import 'package:eaqarati_app/features/domain/entities/property_entity.dart';
import 'package:eaqarati_app/features/domain/repositories/property_repository.dart';
import 'package:logger/logger.dart';

class AddPropertyUseCase {
  final PropertyRepository propertyRepository;

  AddPropertyUseCase(this.propertyRepository);

  Future<Either<Failure, int>> call(PropertyEntity property) async {
    if (property.name.isEmpty) {
      Logger().e('Property name cannot be empty via AddPropertyUseCase.');
      return Left(
        ValidationFailure(
          'Property name cannot be empty via AddPropertyUseCase.',
        ),
      );
    } else {
      return await propertyRepository.addProperty(property);
    }
  }
}
