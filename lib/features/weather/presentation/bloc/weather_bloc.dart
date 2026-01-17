import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_city_weather.dart';
import '../../domain/usecases/get_current_weather.dart';
import 'weather_event.dart';
import 'weather_state.dart';
import '../../../../core/usecases/usecase.dart';

// BLoC for managing the state of weather for the current city or search results
class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final GetCurrentWeather getCurrentWeather;
  final GetCityWeather getCityWeather;

  WeatherBloc({required this.getCurrentWeather, required this.getCityWeather})
    : super(WeatherEmpty()) {
    // Handle GetCurrentWeatherEvent: fetching weather based on user's current location
    on<GetCurrentWeatherEvent>((event, emit) async {
      emit(WeatherLoading());
      final result = await getCurrentWeather(NoParams());
      result.fold(
        (failure) =>
            emit(WeatherError(_mapFailureToMessage(failure.toString()))),
        (weather) => emit(WeatherLoaded(weather)),
      );
    });

    // Handle GetCityWeatherEvent: fetching weather for a specific city name
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

  // Maps failure messages to a more user-friendly format
  String _mapFailureToMessage(String failure) {
    return "Something went wrong: $failure";
  }
}
