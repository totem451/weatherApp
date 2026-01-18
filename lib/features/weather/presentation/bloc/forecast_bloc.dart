import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_five_day_forecast.dart';
import 'forecast_event.dart';
import 'forecast_state.dart';

// BLoC for managing the 5-day weather forecast
class ForecastBloc extends Bloc<ForecastEvent, ForecastState> {
  final GetFiveDayForecast getFiveDayForecast;

  ForecastBloc({required this.getFiveDayForecast}) : super(ForecastInitial()) {
    on<GetFiveDayForecastEvent>((event, emit) async {
      emit(ForecastLoading());

      final result = await getFiveDayForecast(
        ForecastParams(lat: event.lat, lon: event.lon),
      );

      result.fold((failure) => emit(ForecastError(failure.message)), (
        forecast,
      ) {
        if (forecast.isEmpty) {
          emit(
            const ForecastError(
              'No forecast data available for this location.',
            ),
          );
        } else {
          emit(ForecastLoaded(forecast));
        }
      });
    });
  }
}
