import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/forecast.dart';
import '../repositories/weather_repository.dart';

// UseCase to fetch 5-day weather forecast based on coordinates
class GetFiveDayForecast
    implements UseCase<List<ForecastEntity>, ForecastParams> {
  final WeatherRepository repository;

  GetFiveDayForecast(this.repository);

  @override
  Future<Either<Failure, List<ForecastEntity>>> call(
    ForecastParams params,
  ) async {
    return await repository.getFiveDayForecast(params.lat, params.lon);
  }
}

class ForecastParams extends Equatable {
  final double lat;
  final double lon;

  const ForecastParams({required this.lat, required this.lon});

  @override
  List<Object?> get props => [lat, lon];
}
