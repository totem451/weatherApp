import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/weather.dart';
import '../../domain/usecases/get_city_weather.dart';
import 'weather_list_event.dart';
import 'weather_list_state.dart';

class WeatherListBloc extends Bloc<WeatherListEvent, WeatherListState> {
  final GetCityWeather getCityWeather;
  final List<WeatherEntity> _cityList = [];

  WeatherListBloc({required this.getCityWeather})
    : super(WeatherListInitial()) {
    on<LoadDefaultCitiesEvent>((event, emit) async {
      emit(WeatherListLoading());
      final defaultCities = [
        "New York",
        "London",
        "Tokyo",
        "Paris",
        "Berlin",
        "Sydney",
        "Dubai",
        "Rome",
        "Madrid",
        "Toronto",
      ];

      for (final cityName in defaultCities) {
        final result = await getCityWeather(Params(cityName: cityName));
        result.fold((failure) => null, (weather) {
          if (!_cityList.any((e) => e.cityName == weather.cityName)) {
            _cityList.add(weather);
            emit(WeatherListUpdated(List.from(_cityList)));
          }
        });
      }
    });

    on<AddCityEvent>((event, emit) async {
      emit(WeatherListLoading());
      final result = await getCityWeather(Params(cityName: event.cityName));
      result.fold(
        (failure) => emit(WeatherListError("Could not find ${event.cityName}")),
        (weather) {
          if (!_cityList.any(
            (element) => element.cityName == weather.cityName,
          )) {
            _cityList.insert(0, weather);
          }
          emit(WeatherListUpdated(List.from(_cityList)));
        },
      );
    });

    on<RemoveCityEvent>((event, emit) {
      _cityList.removeWhere((element) => element.cityName == event.cityName);
      emit(WeatherListUpdated(List.from(_cityList)));
    });
  }
}
