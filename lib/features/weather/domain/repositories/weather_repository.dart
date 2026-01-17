import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/weather.dart';

// Abstract interface for the weather repository
// Defines the contract for fetching weather data
abstract class WeatherRepository {
  // Fetches current weather based on the device's location
  Future<Either<Failure, WeatherEntity>> getCurrentWeather();
  // Fetches weather for a specific city name
  Future<Either<Failure, WeatherEntity>> getCityWeather(String cityName);
}
