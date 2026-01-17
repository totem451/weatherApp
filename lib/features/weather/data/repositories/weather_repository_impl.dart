import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/weather.dart';
import '../../domain/repositories/weather_repository.dart';
import 'package:geolocator/geolocator.dart';
import '../datasources/weather_remote_data_source.dart';

// Implementation of the WeatherRepository interface
class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDataSource remoteDataSource;

  WeatherRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, WeatherEntity>> getCurrentWeather() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      // 1. Check if location services are enabled on the device
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return const Left(PermissionFailure('Location services are disabled.'));
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
      return Right(remoteWeather);
    } on ServerException {
      return const Left(
        ServerFailure('The server is having trouble. Please try again later.'),
      );
    } on NetworkException {
      return const Left(
        NetworkFailure(
          'No internet connection. Please check your network and try again.',
        ),
      );
    } catch (e) {
      // Catch any other errors and return them as a NetworkFailure
      return Left(
        NetworkFailure('An unexpected error occurred: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, WeatherEntity>> getCityWeather(String cityName) async {
    try {
      // Fetch weather for a specific city name from the remote source
      final remoteWeather = await remoteDataSource.getCityWeather(cityName);
      return Right(remoteWeather);
    } on ServerException {
      return const Left(
        ServerFailure('Could not find weather data for this city.'),
      );
    } on NetworkException {
      return const Left(
        NetworkFailure(
          'No internet connection. Please check your network and try again.',
        ),
      );
    } catch (e) {
      return Left(
        NetworkFailure('An unexpected error occurred: ${e.toString()}'),
      );
    }
  }
}
