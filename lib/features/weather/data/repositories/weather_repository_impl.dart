import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/weather.dart';
import '../../domain/repositories/weather_repository.dart';
import 'package:geolocator/geolocator.dart';
import '../datasources/weather_remote_data_source.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDataSource remoteDataSource;

  WeatherRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, WeatherEntity>> getCurrentWeather() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return const Left(NetworkFailure('Location services are disabled.'));
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return const Left(NetworkFailure('Location permissions are denied'));
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return const Left(
          NetworkFailure(
            'Location permissions are permanently denied, we cannot request permissions.',
          ),
        );
      }

      final position = await Geolocator.getCurrentPosition();
      final remoteWeather = await remoteDataSource.getWeatherByCoordinates(
        position.latitude,
        position.longitude,
      );
      return Right(remoteWeather);
    } on ServerException {
      return const Left(ServerFailure('Server Failure'));
    } catch (e) {
      return Left(NetworkFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, WeatherEntity>> getCityWeather(String cityName) async {
    try {
      final remoteWeather = await remoteDataSource.getCityWeather(cityName);
      return Right(remoteWeather);
    } on ServerException {
      return const Left(ServerFailure('Server Failure'));
    }
  }
}
