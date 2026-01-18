import 'package:equatable/equatable.dart';
import '../../domain/entities/forecast.dart';

// Abstract base class for all forecast states
abstract class ForecastState extends Equatable {
  const ForecastState();

  @override
  List<Object?> get props => [];
}

class ForecastInitial extends ForecastState {}

class ForecastLoading extends ForecastState {}

class ForecastLoaded extends ForecastState {
  final List<ForecastEntity> forecastList;

  const ForecastLoaded(this.forecastList);

  @override
  List<Object?> get props => [forecastList];
}

class ForecastError extends ForecastState {
  final String message;

  const ForecastError(this.message);

  @override
  List<Object?> get props => [message];
}
