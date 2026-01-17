import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/error/failures.dart';
import '../entities/weather.dart';
import '../repositories/weather_repository.dart';

// UseCase to fetch weather for a specific city name
class GetCityWeather implements UseCase<WeatherEntity, Params> {
  final WeatherRepository repository;

  GetCityWeather(this.repository);

  @override
  Future<Either<Failure, WeatherEntity>> call(Params params) async {
    return await repository.getCityWeather(params.cityName);
  }
}

// Parameters needed for the GetCityWeather usecase
class Params extends Equatable {
  final String cityName;
  const Params({required this.cityName});

  @override
  List<Object> get props => [cityName];
}
