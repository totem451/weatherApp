import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/weather_repository.dart';

class RemoveFavoriteCity implements UseCase<void, String> {
  final WeatherRepository repository;

  RemoveFavoriteCity(this.repository);

  @override
  Future<Either<Failure, void>> call(String cityName) async {
    return await repository.removeFavoriteCity(cityName);
  }
}
