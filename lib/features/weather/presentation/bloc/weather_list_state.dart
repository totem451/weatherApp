import 'package:equatable/equatable.dart';
import '../../domain/entities/weather.dart';

abstract class WeatherListState extends Equatable {
  const WeatherListState();

  @override
  List<Object> get props => [];
}

class WeatherListInitial extends WeatherListState {}

class WeatherListLoading extends WeatherListState {}

class WeatherListUpdated extends WeatherListState {
  final List<WeatherEntity> weatherList;

  const WeatherListUpdated(this.weatherList);

  @override
  List<Object> get props => [weatherList];
}

class WeatherListError extends WeatherListState {
  final String message;

  const WeatherListError(this.message);

  @override
  List<Object> get props => [message];
}
