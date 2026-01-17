import 'package:equatable/equatable.dart';

// Abstract base class for all events related to the city list weather management
abstract class WeatherListEvent extends Equatable {
  const WeatherListEvent();

  @override
  List<Object> get props => [];
}

// Event to trigger loading the weather for a default set of cities
class LoadDefaultCitiesEvent extends WeatherListEvent {}

// Event to trigger adding a new city to the list
class AddCityEvent extends WeatherListEvent {
  final String cityName;

  const AddCityEvent(this.cityName);

  @override
  List<Object> get props => [cityName];
}

// Event to trigger removing a city from the list
class RemoveCityEvent extends WeatherListEvent {
  final String cityName;

  const RemoveCityEvent(this.cityName);

  @override
  List<Object> get props => [cityName];
}
