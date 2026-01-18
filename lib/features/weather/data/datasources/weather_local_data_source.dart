import 'package:hive/hive.dart';
import '../models/weather_model.dart';
import '../models/forecast_model.dart';
import '../../../../core/error/exceptions.dart';

abstract class WeatherLocalDataSource {
  Future<void> cacheWeather(WeatherModel weatherToCache, {String? key});
  Future<WeatherModel> getLastWeather({String? key});
  Future<void> cacheForecast(List<ForecastModel> forecastToCache);
  Future<List<ForecastModel>> getLastForecast();
  Future<void> saveFavoriteCities(List<String> cityNames);
  Future<List<String>> getFavoriteCities();
}

class WeatherLocalDataSourceImpl implements WeatherLocalDataSource {
  final Box<WeatherModel> weatherBox;
  final Box favoritesBox;
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
    final cities = favoritesBox.get('ORDERED_FAVORITES');
    if (cities != null) {
      return Future.value(List<String>.from(cities));
    }
    // Fallback for legacy data if we want, but since we are changing box name in injection,
    // we start fresh.
    return Future.value([]);
  }

  @override
  Future<void> saveFavoriteCities(List<String> cityNames) async {
    await favoritesBox.put('ORDERED_FAVORITES', cityNames);
  }
}
