import 'package:equatable/equatable.dart';

// Abstract base class for all events related to the main weather display
abstract class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object> get props => [];
}

// Event to trigger fetching weather for the current location
class GetCurrentWeatherEvent extends WeatherEvent {
  const GetCurrentWeatherEvent();
}

// Event to trigger fetching weather for a specific city name
class GetCityWeatherEvent extends WeatherEvent {
  final String cityName;

  const GetCityWeatherEvent(this.cityName);

  @override
  List<Object> get props => [cityName];
}
