import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/weather.dart';
import '../../domain/entities/forecast.dart';
import '../../domain/repositories/weather_repository.dart';
import 'package:geolocator/geolocator.dart';
import '../datasources/weather_remote_data_source.dart';
import '../datasources/weather_local_data_source.dart';

// Implementation of the WeatherRepository interface
class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDataSource remoteDataSource;
  final WeatherLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  WeatherRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, WeatherEntity>> getCurrentWeather() async {
    if (await networkInfo.isConnected) {
      try {
        bool serviceEnabled;
        LocationPermission permission;

        // 1. Check if location services are enabled on the device
        serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) {
          return const Left(
            PermissionFailure('Location services are disabled.'),
          );
        }

        // 2. Check and request location permissions
        permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.denied) {
            return const Left(
              PermissionFailure('Location permissions are denied'),
            );
          }
        }

        // 3. Handle cases where permissions are permanently denied
        if (permission == LocationPermission.deniedForever) {
          return const Left(
            PermissionFailure(
              'Location permissions are permanently denied, we cannot request permissions.',
            ),
          );
        }

        // 4. Get the current position and fetch weather data from the remote source
        final position = await Geolocator.getCurrentPosition();
        final remoteWeather = await remoteDataSource.getWeatherByCoordinates(
          position.latitude,
          position.longitude,
        );

        // Cache the result for offline use
        localDataSource.cacheWeather(remoteWeather);

        return Right(remoteWeather);
      } on ServerException {
        return const Left(
          ServerFailure(
            'The server is having trouble. Please try again later.',
          ),
        );
      } catch (e) {
        // Fallback to cache if possible even on network error
        return await _getLocalWeatherFallback(
          'An unexpected error occurred: ${e.toString()}',
        );
      }
    } else {
      return await _getLocalWeatherFallback(
        'No internet connection and no cached weather data found.',
      );
    }
  }

  @override
  Future<Either<Failure, WeatherEntity>> getCityWeather(String cityName) async {
    final cacheKey = cityName.toLowerCase();
    if (await networkInfo.isConnected) {
      try {
        final remoteWeather = await remoteDataSource.getCityWeather(cityName);
        // Cache searching results specifically by city name
        localDataSource.cacheWeather(remoteWeather, key: cacheKey);
        return Right(remoteWeather);
      } on ServerException {
        return const Left(
          ServerFailure('Could not find weather data for this city.'),
        );
      } catch (e) {
        return Left(
          NetworkFailure('An unexpected error occurred: ${e.toString()}'),
        );
      }
    } else {
      // Check if the cached weather exists for this specific city
      try {
        final localWeather = await localDataSource.getLastWeather(
          key: cacheKey,
        );
        return Right(localWeather);
      } on CacheException {
        return Left(
          CacheFailure(
            'No connection and no cached data for ${cityName.toLowerCase()}.',
          ),
        );
      }
    }
  }

  @override
  Future<Either<Failure, List<ForecastEntity>>> getFiveDayForecast(
    double lat,
    double lon,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteForecasts = await remoteDataSource.getFiveDayForecast(
          lat,
          lon,
        );

        // Cache the raw result for offline use
        localDataSource.cacheForecast(remoteForecasts);

        return Right(_aggregateForecasts(remoteForecasts));
      } on ServerException {
        return await _getLocalForecastFallback(
          'The weather server is currently unreachable. Showing last known forecast.',
        );
      } catch (e) {
        return await _getLocalForecastFallback(
          'Could not update forecast. Showing last known data.',
        );
      }
    } else {
      return await _getLocalForecastFallback(
        'No internet connection. Showing last known forecast.',
      );
    }
  }

  List<ForecastEntity> _aggregateForecasts(List<ForecastEntity> fullList) {
    // Aggregate 3-hour forecasts to 1 per day (e.g., closest to 12:00 PM)
    final Map<String, ForecastEntity> groupedByDay = {};

    for (final forecast in fullList) {
      final dateStr =
          "${forecast.dateTime.year}-${forecast.dateTime.month}-${forecast.dateTime.day}";
      final hour = forecast.dateTime.hour;

      // Prefer data around noon (12:00)
      if (!groupedByDay.containsKey(dateStr) || (hour >= 11 && hour <= 13)) {
        groupedByDay[dateStr] = forecast;
      }
    }

    // Convert Map values to List and take first 5 days
    return groupedByDay.values.take(5).toList();
  }

  @override
  Future<Either<Failure, List<String>>> getFavoriteCities() async {
    try {
      final cities = await localDataSource.getFavoriteCities();
      return Right(cities);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveFavoriteCity(String cityName) async {
    try {
      await localDataSource.saveFavoriteCity(cityName);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeFavoriteCity(String cityName) async {
    try {
      await localDataSource.removeFavoriteCity(cityName);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  Future<Either<Failure, List<ForecastEntity>>> _getLocalForecastFallback(
    String errorMessage,
  ) async {
    try {
      final localForecast = await localDataSource.getLastForecast();
      return Right(_aggregateForecasts(localForecast));
    } on CacheException {
      return Left(CacheFailure(errorMessage));
    }
  }

  Future<Either<Failure, WeatherEntity>> _getLocalWeatherFallback(
    String errorMessage,
  ) async {
    try {
      final localWeather = await localDataSource.getLastWeather();
      return Right(localWeather);
    } on CacheException {
      return Left(CacheFailure(errorMessage));
    }
  }
}
