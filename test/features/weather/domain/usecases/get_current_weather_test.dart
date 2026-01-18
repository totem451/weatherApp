import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/core/usecases/usecase.dart';
import 'package:weather_app/features/weather/domain/entities/weather.dart';
import 'package:weather_app/features/weather/domain/repositories/weather_repository.dart';
import 'package:weather_app/features/weather/domain/usecases/get_current_weather.dart';

class MockWeatherRepository extends Mock implements WeatherRepository {}

void main() {
  late GetCurrentWeather usecase;
  late MockWeatherRepository mockRepository;

  setUp(() {
    mockRepository = MockWeatherRepository();
    usecase = GetCurrentWeather(mockRepository);
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

  test('should get weather from the repository', () async {
    // arrange
    when(
      () => mockRepository.getCurrentWeather(),
    ).thenAnswer((_) async => const Right(tWeatherDetail));

    // act
    final result = await usecase(const NoParams());

    // assert
    expect(result, const Right(tWeatherDetail));
    verify(() => mockRepository.getCurrentWeather());
    verifyNoMoreInteractions(mockRepository);
  });
}
