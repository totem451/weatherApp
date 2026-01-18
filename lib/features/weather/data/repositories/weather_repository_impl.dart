import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/weather.dart';
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
    if (await networkInfo.isConnected) {
      try {
        final remoteWeather = await remoteDataSource.getCityWeather(cityName);
        // Cache searching results specifically if it's considered a primary result
        localDataSource.cacheWeather(remoteWeather);
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
      // Check if the cached weather matches the searched city
      try {
        final localWeather = await localDataSource.getLastWeather();
        if (localWeather.cityName.toLowerCase() == cityName.toLowerCase()) {
          return Right(localWeather);
        }
        return const Left(
          CacheFailure(
            'No internet connection and no cached data for this city.',
          ),
        );
      } on CacheException {
        return const Left(
          CacheFailure('No internet connection and no cached weather data.'),
        );
      }
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
