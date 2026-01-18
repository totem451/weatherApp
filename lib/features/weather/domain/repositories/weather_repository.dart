import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/forecast.dart';
import '../entities/weather.dart';

// Abstract interface for the weather repository
// Defines the contract for fetching weather data
abstract class WeatherRepository {
  // Fetches current weather based on the device's location
  Future<Either<Failure, WeatherEntity>> getCurrentWeather();
  // Fetches weather for a specific city name
  Future<Either<Failure, WeatherEntity>> getCityWeather(String cityName);
  // Fetches 5-day forecast for specific coordinates
  Future<Either<Failure, List<ForecastEntity>>> getFiveDayForecast(
    double lat,
    double lon,
  );
  // Favorites management
  Future<Either<Failure, List<String>>> getFavoriteCities();
  Future<Either<Failure, void>> saveFavoriteCity(String cityName);
  Future<Either<Failure, void>> removeFavoriteCity(String cityName);
}
