import 'package:equatable/equatable.dart';

abstract class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object> get props => [];
}

class GetCurrentWeatherEvent extends WeatherEvent {
  const GetCurrentWeatherEvent();
}

class GetCityWeatherEvent extends WeatherEvent {
  final String cityName;

  const GetCityWeatherEvent(this.cityName);

  @override
  List<Object> get props => [cityName];
}
