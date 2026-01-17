import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/error/exceptions.dart';
import '../models/weather_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class WeatherRemoteDataSource {
  Future<WeatherModel> getCurrentWeather(String location);
  Future<WeatherModel> getCityWeather(String cityName);
  Future<WeatherModel> getWeatherByCoordinates(double lat, double lon);
}

class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  final http.Client client;

  String get apiKey {
    try {
      return dotenv.env['API_KEY'] ?? '';
    } catch (e) {
      print("DotEnv not initialized: $e");
      return '';
    }
  }

  final String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  WeatherRemoteDataSourceImpl({required this.client});

  @override
  Future<WeatherModel> getCurrentWeather(String location) =>
      _getWeatherFromUrl('$baseUrl?q=$location&appid=$apiKey&units=metric');

  @override
  Future<WeatherModel> getCityWeather(String cityName) =>
      _getWeatherFromUrl('$baseUrl?q=$cityName&appid=$apiKey&units=metric');

  @override
  Future<WeatherModel> getWeatherByCoordinates(double lat, double lon) =>
      _getWeatherFromUrl(
        '$baseUrl?lat=$lat&lon=$lon&appid=$apiKey&units=metric',
      );

  Future<WeatherModel> _getWeatherFromUrl(String url) async {
    final response = await client.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return WeatherModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
