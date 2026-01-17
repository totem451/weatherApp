import 'package:dartz/dartz.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/error/failures.dart';
import '../entities/weather.dart';
import '../repositories/weather_repository.dart';

// UseCase to fetch current weather based on the device's location
class GetCurrentWeather implements UseCase<WeatherEntity, NoParams> {
  final WeatherRepository repository;

  GetCurrentWeather(this.repository);

  @override
  Future<Either<Failure, WeatherEntity>> call(NoParams params) async {
    return await repository.getCurrentWeather();
  }
}
