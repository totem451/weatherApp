import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_city_weather.dart';
import '../../domain/usecases/get_current_weather.dart';
import 'weather_event.dart';
import 'weather_state.dart';
import '../../../../core/usecases/usecase.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final GetCurrentWeather getCurrentWeather;
  final GetCityWeather getCityWeather;

  WeatherBloc({required this.getCurrentWeather, required this.getCityWeather})
    : super(WeatherEmpty()) {
    on<GetCurrentWeatherEvent>((event, emit) async {
      emit(WeatherLoading());
      final result = await getCurrentWeather(NoParams());
      result.fold(
        (failure) =>
            emit(WeatherError(_mapFailureToMessage(failure.toString()))),
        (weather) => emit(WeatherLoaded(weather)),
      );
    });

    on<GetCityWeatherEvent>((event, emit) async {
      emit(WeatherLoading());
      final result = await getCityWeather(Params(cityName: event.cityName));
      result.fold(
        (failure) =>
            emit(WeatherError(_mapFailureToMessage(failure.toString()))),
        (weather) => emit(WeatherLoaded(weather)),
      );
    });
  }

  String _mapFailureToMessage(String failure) {
    return "Something went wrong: $failure";
  }
}
