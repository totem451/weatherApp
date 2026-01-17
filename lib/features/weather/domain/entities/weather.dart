import 'package:equatable/equatable.dart';

class WeatherEntity extends Equatable {
  final String cityName;
  final String main;
  final String description;
  final String icon;
  final double temperature;
  final double tempMin;
  final double tempMax;
  final int humidity;
  final double windSpeed;

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
