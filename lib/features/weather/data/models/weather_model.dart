import 'package:hive/hive.dart';
import '../../domain/entities/weather.dart';

part 'weather_model.g.dart';

// Data model for weather information, extending the domain entity
// Includes mapping logic from and to JSON for API interactions
@HiveType(typeId: 0)
class WeatherModel extends WeatherEntity {
  @HiveField(0)
  @override
  final String cityName;

  @HiveField(1)
  @override
  final String main;

  @HiveField(2)
  @override
  final String description;

  @HiveField(3)
  @override
  final String icon;

  @HiveField(4)
  @override
  final double temperature;

  @HiveField(5)
  @override
  final double tempMin;

  @HiveField(6)
  @override
  final double tempMax;

  @HiveField(7)
  @override
  final int humidity;

  @HiveField(8)
  @override
  final double windSpeed;

  @HiveField(9, defaultValue: 0.0)
  @override
  final double latitude;

  @HiveField(10, defaultValue: 0.0)
  @override
  final double longitude;

  const WeatherModel({
    required this.cityName,
    required this.main,
    required this.description,
    required this.icon,
    required this.temperature,
    required this.tempMin,
    required this.tempMax,
    required this.humidity,
    required this.windSpeed,
    required this.latitude,
    required this.longitude,
  }) : super(
         cityName: cityName,
         main: main,
         description: description,
         icon: icon,
         temperature: temperature,
         tempMin: tempMin,
         tempMax: tempMax,
         humidity: humidity,
         windSpeed: windSpeed,
         latitude: latitude,
         longitude: longitude,
       );

  // Factory constructor to create a WeatherModel from OpenWeatherMap API JSON
  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['name'],
      main: json['weather'][0]['main'],
      description: json['weather'][0]['description'],
      icon: json['weather'][0]['icon'],
      temperature: (json['main']['temp'] as num).toDouble(),
      tempMin: (json['main']['temp_min'] as num).toDouble(),
      tempMax: (json['main']['temp_max'] as num).toDouble(),
      humidity: json['main']['humidity'],
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      latitude: (json['coord']['lat'] as num).toDouble(),
      longitude: (json['coord']['lon'] as num).toDouble(),
    );
  }

  // Method to convert the model back to JSON format
  Map<String, dynamic> toJson() {
    return {
      'name': cityName,
      'weather': [
        {'main': main, 'description': description, 'icon': icon},
      ],
      'main': {
        'temp': temperature,
        'temp_min': tempMin,
        'temp_max': tempMax,
        'humidity': humidity,
      },
      'wind': {'speed': windSpeed},
      'coord': {'lat': latitude, 'lon': longitude},
    };
  }
}
