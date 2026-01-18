import 'package:hive/hive.dart';
import '../models/weather_model.dart';
import '../../../../core/error/exceptions.dart';

abstract class WeatherLocalDataSource {
  Future<void> cacheWeather(WeatherModel weatherToCache);
  Future<WeatherModel> getLastWeather();
  Future<void> saveFavoriteCity(String cityName);
  Future<void> removeFavoriteCity(String cityName);
  Future<List<String>> getFavoriteCities();
}

class WeatherLocalDataSourceImpl implements WeatherLocalDataSource {
  final Box<WeatherModel> weatherBox;
  final Box<String> favoritesBox;

  WeatherLocalDataSourceImpl({
    required this.weatherBox,
    required this.favoritesBox,
  });

  @override
  Future<void> cacheWeather(WeatherModel weatherToCache) async {
    // We only cache the latest weather for the home page / last search
    await weatherBox.put('CACHED_WEATHER', weatherToCache);
  }

  @override
  Future<WeatherModel> getLastWeather() {
    final weather = weatherBox.get('CACHED_WEATHER');
    if (weather != null) {
      return Future.value(weather);
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
