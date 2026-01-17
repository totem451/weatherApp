import 'package:equatable/equatable.dart';

abstract class WeatherListEvent extends Equatable {
  const WeatherListEvent();

  @override
  List<Object> get props => [];
}

class LoadDefaultCitiesEvent extends WeatherListEvent {}

class AddCityEvent extends WeatherListEvent {
  final String cityName;

  const AddCityEvent(this.cityName);

  @override
  List<Object> get props => [cityName];
}

class RemoveCityEvent extends WeatherListEvent {
  final String cityName;

  const RemoveCityEvent(this.cityName);

  @override
  List<Object> get props => [cityName];
}
