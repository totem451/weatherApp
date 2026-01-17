import 'package:equatable/equatable.dart';
import '../../domain/entities/weather.dart';

// Abstract base class for all states related to the city list weather management
abstract class WeatherListState extends Equatable {
  const WeatherListState();

  @override
  List<Object> get props => [];
}

// Initial state for the weather list
class WeatherListInitial extends WeatherListState {}

// State representing that the weather list is being fetched or updated
class WeatherListLoading extends WeatherListState {}

// State representing that the weather list has been successfully updated
class WeatherListUpdated extends WeatherListState {
  final List<WeatherEntity> weatherList;

  const WeatherListUpdated(this.weatherList);

  @override
  List<Object> get props => [weatherList];
}

// State representing an error occurred while managing the weather list
class WeatherListError extends WeatherListState {
  final String message;

  const WeatherListError(this.message);

  @override
  List<Object> get props => [message];
}
