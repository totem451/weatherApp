import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'features/weather/data/datasources/weather_remote_data_source.dart';
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
  // Bloc registrations
  // Blocs are registered as factories so a new instance is created each time they are requested
  sl.registerFactory(
    () => WeatherBloc(getCurrentWeather: sl(), getCityWeather: sl()),
  );
  sl.registerFactory(() => WeatherListBloc(getCityWeather: sl()));

  // Usecase registrations
  // Usecases are registered as lazy singletons as they don't hold state
  sl.registerLazySingleton(() => GetCurrentWeather(sl()));
  sl.registerLazySingleton(() => GetCityWeather(sl()));

  // Repository registrations
  sl.registerLazySingleton<WeatherRepository>(
    () => WeatherRepositoryImpl(remoteDataSource: sl()),
  );

  // Data Source registrations
  sl.registerLazySingleton<WeatherRemoteDataSource>(
    () => WeatherRemoteDataSourceImpl(client: sl()),
  );

  // External dependency registrations
  sl.registerLazySingleton(() => http.Client());
}
