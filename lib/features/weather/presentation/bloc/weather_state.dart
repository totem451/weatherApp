import 'package:equatable/equatable.dart';
import '../../domain/entities/weather.dart';

// Abstract base class for all states related to the main weather display
abstract class WeatherState extends Equatable {
  const WeatherState();

  @override
  List<Object> get props => [];
}

// Initial state before any weather data is requested
class WeatherEmpty extends WeatherState {}

// State representing that weather data is being fetched
class WeatherLoading extends WeatherState {}

// State representing that weather data has been successfully loaded
class WeatherLoaded extends WeatherState {
  final WeatherEntity weather;

  const WeatherLoaded(this.weather);

  @override
  List<Object> get props => [weather];
}

// State representing an error occurred while fetching weather data
class WeatherError extends WeatherState {
  final String message;

  const WeatherError(this.message);

  @override
  List<Object> get props => [message];
}
