import 'package:hive/hive.dart';
import '../../domain/entities/forecast.dart';

part 'forecast_model.g.dart';

// Model representing a forecast entry, used for JSON serialization and local persistence
@HiveType(typeId: 1)
class ForecastModel extends ForecastEntity {
  @HiveField(0)
  @override
  final DateTime dateTime;

  @HiveField(1)
  @override
  final double temperature;

  @HiveField(2)
  @override
  final String main;

  @HiveField(3)
  @override
  final String description;

  @HiveField(4)
  @override
  final String icon;

  const ForecastModel({
    required this.dateTime,
    required this.temperature,
    required this.main,
    required this.description,
    required this.icon,
  }) : super(
         dateTime: dateTime,
         temperature: temperature,
         main: main,
         description: description,
         icon: icon,
       );

  // Factory constructor for creating a ForecastModel from JSON
  factory ForecastModel.fromJson(Map<String, dynamic> json) {
    return ForecastModel(
      dateTime: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      temperature: (json['main']['temp'] as num).toDouble(),
      main: json['weather'][0]['main'],
      description: json['weather'][0]['description'],
      icon: json['weather'][0]['icon'],
    );
  }

  // Converts a ForecastModel instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'dt': dateTime.millisecondsSinceEpoch ~/ 1000,
      'main': {'temp': temperature},
      'weather': [
        {'main': main, 'description': description, 'icon': icon},
      ],
    };
  }
}
