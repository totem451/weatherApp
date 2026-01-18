import 'package:equatable/equatable.dart';

// Abstract base class for forecast events
abstract class ForecastEvent extends Equatable {
  const ForecastEvent();

  @override
  List<Object?> get props => [];
}

class GetFiveDayForecastEvent extends ForecastEvent {
  final double lat;
  final double lon;

  const GetFiveDayForecastEvent({required this.lat, required this.lon});

  @override
  List<Object?> get props => [lat, lon];
}
