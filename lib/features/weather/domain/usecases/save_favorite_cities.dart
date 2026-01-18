import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/weather_repository.dart';

class SaveFavoriteCities implements UseCase<void, List<String>> {
  final WeatherRepository repository;

  SaveFavoriteCities(this.repository);

  @override
  Future<Either<Failure, void>> call(List<String> cities) async {
    return await repository.saveFavoriteCities(cities);
  }
}
