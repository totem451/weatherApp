import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/weather.dart';
import '../../domain/usecases/get_city_weather.dart';
import '../../domain/usecases/get_favorite_cities.dart';
import '../../domain/usecases/save_favorite_city.dart';
import '../../domain/usecases/remove_favorite_city.dart';
import 'weather_list_event.dart';
import 'weather_list_state.dart';

// BLoC for managing a list of cities and their weather data
class WeatherListBloc extends Bloc<WeatherListEvent, WeatherListState> {
  final GetCityWeather getCityWeather;
  final GetFavoriteCities getFavoriteCities;
  final SaveFavoriteCity saveFavoriteCity;
  final RemoveFavoriteCity removeFavoriteCity;

  // Internal list to keep track of added cities' weather
  final List<WeatherEntity> _cityList = [];

  WeatherListBloc({
    required this.getCityWeather,
    required this.getFavoriteCities,
    required this.saveFavoriteCity,
    required this.removeFavoriteCity,
  }) : super(WeatherListInitial()) {
    // Handle LoadDefaultCitiesEvent: fills the list with a predefined set of popular cities
    on<LoadDefaultCitiesEvent>((event, emit) async {
      emit(WeatherListLoading());

      // 1. Load favorites from Hive
      final favoritesResult = await getFavoriteCities(NoParams());
      List<String> citiesToLoad = [];

      favoritesResult.fold(
        (failure) => null, // Fallback to default if load fails
        (cities) {
          citiesToLoad = cities;
        },
      );

      // 2. If no favorites, use default list and save them
      if (citiesToLoad.isEmpty) {
        citiesToLoad = [
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
        for (final city in citiesToLoad) {
          await saveFavoriteCity(city);
        }
      }

      // 3. Fetch weather for all cities (remote or local fallback)
      final results = await Future.wait(
        citiesToLoad.map(
          (cityName) => getCityWeather(Params(cityName: cityName)),
        ),
      );

      bool anySuccess = false;
      String? errorMessage;

      _cityList.clear();
      for (final result in results) {
        result.fold(
          (failure) {
            errorMessage = failure.message;
          },
          (weather) {
            anySuccess = true;
            if (!_cityList.any((e) => e.cityName == weather.cityName)) {
              _cityList.add(weather);
            }
          },
        );
      }

      if (!anySuccess && errorMessage != null) {
        emit(WeatherListError(errorMessage!));
      } else {
        emit(WeatherListUpdated(List.from(_cityList)));
      }
    });

    // Handle AddCityEvent: adds a new city to the list based on search results
    on<AddCityEvent>((event, emit) async {
      emit(WeatherListLoading());
      final result = await getCityWeather(Params(cityName: event.cityName));
      await result.fold(
        (failure) async {
          emit(WeatherListError(failure.message));
        },
        (weather) async {
          if (!_cityList.any(
            (element) => element.cityName == weather.cityName,
          )) {
            // Save to Hive
            await saveFavoriteCity(weather.cityName);
            // Insert at the beginning of the list
            _cityList.insert(0, weather);
          }
          emit(WeatherListUpdated(List.from(_cityList)));
        },
      );
    });

    // Handle RemoveCityEvent: removes a city from the list
    on<RemoveCityEvent>((event, emit) async {
      final cityName = event.cityName;
      _cityList.removeWhere((element) => element.cityName == cityName);
      // Remove from Hive
      await removeFavoriteCity(cityName);
      emit(WeatherListUpdated(List.from(_cityList)));
    });

    // Handle RefreshWeatherListEvent: refreshes weather for all cities in the current list
    on<RefreshWeatherListEvent>((event, emit) async {
      if (_cityList.isEmpty) {
        // Might be empty because previous load failed while offline
        add(LoadDefaultCitiesEvent());
        return;
      }

      final currentCities = _cityList.map((e) => e.cityName).toList();

      final results = await Future.wait(
        currentCities.map(
          (cityName) => getCityWeather(Params(cityName: cityName)),
        ),
      );

      final List<WeatherEntity> updatedList = [];
      bool anySuccess = false;
      String? firstFailureMessage;

      for (int i = 0; i < results.length; i++) {
        results[i].fold(
          (failure) {
            firstFailureMessage ??= failure.message;
            // Keep old data if refresh failed
            updatedList.add(_cityList[i]);
          },
          (weather) {
            anySuccess = true;
            updatedList.add(weather);
          },
        );
      }

      _cityList.clear();
      _cityList.addAll(updatedList);

      if (!anySuccess && firstFailureMessage != null) {
        emit(WeatherListError(firstFailureMessage!));
      } else {
        emit(WeatherListUpdated(List.from(_cityList)));
      }
    });
  }
}
