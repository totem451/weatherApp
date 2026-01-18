import 'package:equatable/equatable.dart';

// Represents the core weather data structure used in the domain layer
class WeatherEntity extends Equatable {
  final String cityName; // Name of the city
  final String main; // General weather condition (e.g., Rain, Clear)
  final String description; // Detailed description (e.g., light rain)
  final String icon; // Icon code from OpenWeatherMap
  final double temperature; // Current temperature in Celsius
  final double tempMin; // Minimum temperature
  final double tempMax; // Maximum temperature
  final int humidity; // Humidity percentage
  final double windSpeed; // Wind speed in m/s
  final double latitude;
  final double longitude;

  const WeatherEntity({
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
  });

  @override
  List<Object?> get props => [
    cityName,
    main,
    description,
    icon,
    temperature,
    tempMin,
    tempMax,
    humidity,
    windSpeed,
  ];
}
