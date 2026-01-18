import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'core/network/network_info.dart';
import 'features/weather/data/datasources/weather_local_data_source.dart';
import 'features/weather/data/datasources/weather_remote_data_source.dart';
import 'features/weather/data/models/weather_model.dart';
import 'features/weather/data/repositories/weather_repository_impl.dart';
import 'features/weather/domain/repositories/weather_repository.dart';
import 'features/weather/domain/usecases/get_city_weather.dart';
import 'features/weather/domain/usecases/get_current_weather.dart';
import 'features/weather/presentation/bloc/weather_bloc.dart';
import 'features/weather/presentation/bloc/weather_list_bloc.dart';

// Global instance of GetIt for dependency injection
final sl = GetIt.instance;

// Initializes the dependency injection container
Future<void> init() async {
  // Hive registrations
  await Hive.initFlutter();
  Hive.registerAdapter(WeatherModelAdapter());

  final weatherBox = await Hive.openBox<WeatherModel>('weather_box');
  final favoritesBox = await Hive.openBox<String>('favorites_box');

  // Bloc registrations
  sl.registerFactory(
    () => WeatherBloc(getCurrentWeather: sl(), getCityWeather: sl()),
  );
  sl.registerFactory(() => WeatherListBloc(getCityWeather: sl()));

  // Usecase registrations
  sl.registerLazySingleton(() => GetCurrentWeather(sl()));
  sl.registerLazySingleton(() => GetCityWeather(sl()));

  // Repository registrations
  sl.registerLazySingleton<WeatherRepository>(
    () => WeatherRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data Source registrations
  sl.registerLazySingleton<WeatherRemoteDataSource>(
    () => WeatherRemoteDataSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<WeatherLocalDataSource>(
    () => WeatherLocalDataSourceImpl(weatherBox: sl(), favoritesBox: sl()),
  );

  // Core registrations
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // External dependency registrations
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker.instance);
  sl.registerLazySingleton(() => weatherBox);
  sl.registerLazySingleton(() => favoritesBox);
}
