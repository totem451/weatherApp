import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/weather_repository.dart';

class SaveFavoriteCity implements UseCase<void, String> {
  final WeatherRepository repository;

  SaveFavoriteCity(this.repository);

  @override
  Future<Either<Failure, void>> call(String cityName) async {
    return await repository.saveFavoriteCity(cityName);
  }
}
