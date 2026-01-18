import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/core/error/failures.dart';
import 'package:weather_app/core/usecases/usecase.dart';
import 'package:weather_app/features/weather/domain/entities/weather.dart';
import 'package:weather_app/features/weather/domain/usecases/get_city_weather.dart';
import 'package:weather_app/features/weather/domain/usecases/get_current_weather.dart';
import 'package:weather_app/features/weather/presentation/bloc/weather_bloc.dart';
import 'package:weather_app/features/weather/presentation/bloc/weather_event.dart';
import 'package:weather_app/features/weather/presentation/bloc/weather_state.dart';

class MockGetCurrentWeather extends Mock implements GetCurrentWeather {}

class MockGetCityWeather extends Mock implements GetCityWeather {}

void main() {
  late WeatherBloc bloc;
  late MockGetCurrentWeather mockGetCurrentWeather;
  late MockGetCityWeather mockGetCityWeather;

  setUpAll(() {
    registerFallbackValue(const NoParams());
    registerFallbackValue(const Params(cityName: 'London'));
  });

  setUp(() {
    mockGetCurrentWeather = MockGetCurrentWeather();
    mockGetCityWeather = MockGetCityWeather();
    bloc = WeatherBloc(
      getCurrentWeather: mockGetCurrentWeather,
      getCityWeather: mockGetCityWeather,
    );
  });

  tearDown(() {
    bloc.close();
  });

  const tWeatherDetail = WeatherEntity(
    cityName: 'London',
    main: 'Clouds',
    description: 'overcast clouds',
    icon: '04d',
    temperature: 15.0,
    tempMin: 12.0,
    tempMax: 18.0,
    humidity: 70,
    windSpeed: 4.5,
    latitude: 51.5074,
    longitude: -0.1278,
  );

  const tCityName = 'London';

  group('GetCurrentWeatherEvent', () {
    blocTest<WeatherBloc, WeatherState>(
      'should emit [WeatherLoading, WeatherLoaded] when data is gotten successfully',
      build: () {
        when(
          () => mockGetCurrentWeather(any()),
        ).thenAnswer((_) async => const Right(tWeatherDetail));
        return bloc;
      },
      act: (bloc) => bloc.add(const GetCurrentWeatherEvent()),
      expect: () => [WeatherLoading(), const WeatherLoaded(tWeatherDetail)],
    );

    blocTest<WeatherBloc, WeatherState>(
      'should emit [WeatherLoading, WeatherError] when getting data fails',
      build: () {
        when(
          () => mockGetCurrentWeather(any()),
        ).thenAnswer((_) async => const Left(ServerFailure('Server Error')));
        return bloc;
      },
      act: (bloc) => bloc.add(const GetCurrentWeatherEvent()),
      expect: () => [WeatherLoading(), const WeatherError('Server Error')],
    );
  });

  group('GetCityWeatherEvent', () {
    blocTest<WeatherBloc, WeatherState>(
      'should emit [WeatherLoading, WeatherLoaded] when city data is gotten successfully',
      build: () {
        when(
          () => mockGetCityWeather(any()),
        ).thenAnswer((_) async => const Right(tWeatherDetail));
        return bloc;
      },
      act: (bloc) => bloc.add(const GetCityWeatherEvent(tCityName)),
      expect: () => [WeatherLoading(), const WeatherLoaded(tWeatherDetail)],
    );
  });
}
