import 'package:equatable/equatable.dart';

// Entity representing weather forecast for a specific day/time
class ForecastEntity extends Equatable {
  final DateTime dateTime;
  final double temperature;
  final String main;
  final String description;
  final String icon;

  const ForecastEntity({
    required this.dateTime,
    required this.temperature,
    required this.main,
    required this.description,
    required this.icon,
  });

  @override
  List<Object?> get props => [dateTime, temperature, main, description, icon];
}
