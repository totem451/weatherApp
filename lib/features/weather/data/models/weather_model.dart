import 'package:hive/hive.dart';
import '../../domain/entities/weather.dart';

part 'weather_model.g.dart';

// Data model for weather information, extending the domain entity
// Includes mapping logic from and to JSON for API interactions
@HiveType(typeId: 0)
class WeatherModel extends WeatherEntity {
  @HiveField(0)
  @HiveField(0)
  @override
  String get cityName => super.cityName;

  @HiveField(1)
  @override
  String get main => super.main;

  @HiveField(2)
  @override
  String get description => super.description;

  @HiveField(3)
  @override
  String get icon => super.icon;

  @HiveField(4)
  @override
  double get temperature => super.temperature;

  @HiveField(5)
  @override
  double get tempMin => super.tempMin;

  @HiveField(6)
  @override
  double get tempMax => super.tempMax;

  @HiveField(7)
  @override
  int get humidity => super.humidity;

  @HiveField(8)
  @override
  double get windSpeed => super.windSpeed;

  @HiveField(9, defaultValue: 0.0)
  @override
  double get latitude => super.latitude;

  @HiveField(10, defaultValue: 0.0)
  @override
  double get longitude => super.longitude;

  const WeatherModel({
    required super.cityName,
    required super.main,
    required super.description,
    required super.icon,
    required super.temperature,
    required super.tempMin,
    required super.tempMax,
    required super.humidity,
    required super.windSpeed,
    required super.latitude,
    required super.longitude,
  });

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
