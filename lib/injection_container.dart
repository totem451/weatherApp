import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'features/weather/data/datasources/weather_remote_data_source.dart';
import 'features/weather/data/repositories/weather_repository_impl.dart';
import 'features/weather/domain/repositories/weather_repository.dart';
import 'features/weather/domain/usecases/get_city_weather.dart';
import 'features/weather/domain/usecases/get_current_weather.dart';
import 'features/weather/presentation/bloc/weather_bloc.dart';
import 'features/weather/presentation/bloc/weather_list_bloc.dart';
import 'core/services/notification_service.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerFactory(
    () => WeatherBloc(getCurrentWeather: sl(), getCityWeather: sl()),
  );
  sl.registerFactory(() => WeatherListBloc(getCityWeather: sl()));

  sl.registerLazySingleton(() => GetCurrentWeather(sl()));
  sl.registerLazySingleton(() => GetCityWeather(sl()));

  sl.registerLazySingleton<WeatherRepository>(
    () => WeatherRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<WeatherRemoteDataSource>(
    () => WeatherRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton(() => http.Client());

  sl.registerLazySingleton(() => NotificationService());
}
