import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../../../core/error/exceptions.dart';
import '../models/weather_model.dart';
import '../models/forecast_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Data source interface for fetching weather data from a remote API
abstract class WeatherRemoteDataSource {
  Future<WeatherModel> getCurrentWeather(String location);
  Future<WeatherModel> getCityWeather(String cityName);
  Future<WeatherModel> getWeatherByCoordinates(double lat, double lon);
  Future<List<ForecastModel>> getFiveDayForecast(double lat, double lon);
}

// Implementation of WeatherRemoteDataSource using the http package
class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  final http.Client client;

  // Retrieve API key from environment variables
  String get apiKey {
    try {
      return dotenv.env['API_KEY'] ?? '';
    } catch (e) {
      if (kDebugMode) {
        print("DotEnv not initialized: $e");
      }
      return '';
    }
  }

  // Base URL for the OpenWeatherMap API
  final String _weatherUrl = 'https://api.openweathermap.org/data/2.5/weather';
  final String _forecastUrl =
      'https://api.openweathermap.org/data/2.5/forecast';

  WeatherRemoteDataSourceImpl({required this.client});

  @override
  Future<WeatherModel> getCurrentWeather(String location) =>
      _getWeatherFromUrl('$_weatherUrl?q=$location&appid=$apiKey&units=metric');

  @override
  Future<WeatherModel> getCityWeather(String cityName) =>
      _getWeatherFromUrl('$_weatherUrl?q=$cityName&appid=$apiKey&units=metric');

  @override
  Future<WeatherModel> getWeatherByCoordinates(double lat, double lon) =>
      _getWeatherFromUrl(
        '$_weatherUrl?lat=$lat&lon=$lon&appid=$apiKey&units=metric',
      );

  @override
  Future<List<ForecastModel>> getFiveDayForecast(double lat, double lon) async {
    final url = '$_forecastUrl?lat=$lat&lon=$lon&appid=$apiKey&units=metric';
    try {
      final response = await client
          .get(Uri.parse(url), headers: {'Content-Type': 'application/json'})
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List list = data['list'];
        return list.map((e) => ForecastModel.fromJson(e)).toList();
      } else {
        throw ServerException();
      }
    } on SocketException {
      throw NetworkException();
    } on HttpException {
      throw NetworkException();
    } on TimeoutException {
      throw NetworkException();
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException();
    }
  }

  // Helper method to perform the GET request and handle the response for current weather
  Future<WeatherModel> _getWeatherFromUrl(String url) async {
    try {
      final response = await client
          .get(Uri.parse(url), headers: {'Content-Type': 'application/json'})
          .timeout(const Duration(seconds: 10));

      // Check if the request was successful
      if (response.statusCode == 200) {
        return WeatherModel.fromJson(json.decode(response.body));
      } else {
        // Throw a ServerException if the API returns an error
        throw ServerException();
      }
    } on SocketException {
      // Throw NetworkException if there's no internet or a socket issue
      throw NetworkException();
    } on HttpException {
      // Throw NetworkException if there's an HTTP protocol error
      throw NetworkException();
    } on TimeoutException {
      // Throw NetworkException if the request times out
      throw NetworkException();
    } catch (e) {
      // Re-throw if it's already a custom exception, otherwise throw ServerException
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException();
    }
  }
}
