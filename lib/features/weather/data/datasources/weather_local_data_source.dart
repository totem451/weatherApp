import 'package:hive/hive.dart';
import '../models/weather_model.dart';
import '../models/forecast_model.dart';
import '../../../../core/error/exceptions.dart';

abstract class WeatherLocalDataSource {
  Future<void> cacheWeather(WeatherModel weatherToCache, {String? key});
  Future<WeatherModel> getLastWeather({String? key});
  Future<void> cacheForecast(List<ForecastModel> forecastToCache);
  Future<List<ForecastModel>> getLastForecast();
  Future<void> saveFavoriteCity(String cityName);
  Future<void> removeFavoriteCity(String cityName);
  Future<List<String>> getFavoriteCities();
}

class WeatherLocalDataSourceImpl implements WeatherLocalDataSource {
  final Box<WeatherModel> weatherBox;
  final Box<String> favoritesBox;
  final Box<List> forecastBox;

  WeatherLocalDataSourceImpl({
    required this.weatherBox,
    required this.favoritesBox,
    required this.forecastBox,
  });

  @override
  Future<void> cacheWeather(WeatherModel weatherToCache, {String? key}) async {
    final cacheKey = key ?? weatherToCache.cityName.toLowerCase();
    await weatherBox.put(cacheKey, weatherToCache);
  }

  @override
  Future<WeatherModel> getLastWeather({String? key}) {
    final cacheKey = key ?? 'CACHED_WEATHER';
    final weather = weatherBox.get(cacheKey);
    if (weather != null) {
      return Future.value(weather);
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheForecast(List<ForecastModel> forecastToCache) async {
    await forecastBox.put('CACHED_FORECAST', forecastToCache);
  }

  @override
  Future<List<ForecastModel>> getLastForecast() {
    final forecast = forecastBox.get('CACHED_FORECAST');
    if (forecast != null) {
      return Future.value(forecast.cast<ForecastModel>());
    } else {
      throw CacheException();
    }
  }

  @override
  Future<List<String>> getFavoriteCities() {
    return Future.value(favoritesBox.values.toList());
  }

  @override
  Future<void> saveFavoriteCity(String cityName) async {
    if (!favoritesBox.values.contains(cityName)) {
      await favoritesBox.add(cityName);
    }
  }

  @override
  Future<void> removeFavoriteCity(String cityName) async {
    final Map<dynamic, String> favoritesMap = favoritesBox.toMap();
    final dynamic key = favoritesMap.keys.firstWhere(
      (k) => favoritesMap[k] == cityName,
      orElse: () => null,
    );

    if (key != null) {
      await favoritesBox.delete(key);
    }
  }
}
