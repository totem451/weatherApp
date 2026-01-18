import 'package:hive/hive.dart';
import '../../domain/entities/forecast.dart';

part 'forecast_model.g.dart';

// Model representing a forecast entry, used for JSON serialization and local persistence
@HiveType(typeId: 1)
class ForecastModel extends ForecastEntity {
  @HiveField(0)
  @HiveField(0)
  @override
  DateTime get dateTime => super.dateTime;

  @HiveField(1)
  @override
  double get temperature => super.temperature;

  @HiveField(2)
  @override
  String get main => super.main;

  @HiveField(3)
  @override
  String get description => super.description;

  @HiveField(4)
  @override
  String get icon => super.icon;

  const ForecastModel({
    required super.dateTime,
    required super.temperature,
    required super.main,
    required super.description,
    required super.icon,
  });

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
