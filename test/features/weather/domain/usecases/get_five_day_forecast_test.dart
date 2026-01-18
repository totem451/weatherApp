import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/features/weather/domain/entities/forecast.dart';
import 'package:weather_app/features/weather/domain/repositories/weather_repository.dart';
import 'package:weather_app/features/weather/domain/usecases/get_five_day_forecast.dart';

class MockWeatherRepository extends Mock implements WeatherRepository {}

void main() {
  late GetFiveDayForecast usecase;
  late MockWeatherRepository mockWeatherRepository;

  setUp(() {
    mockWeatherRepository = MockWeatherRepository();
    usecase = GetFiveDayForecast(mockWeatherRepository);
  });

  final tLat = 40.7128;
  final tLon = -74.0060;
  final tForecastList = [
    ForecastEntity(
      dateTime: DateTime(2023, 1, 1, 12, 0),
      temperature: 20.0,
      main: 'Clear',
      description: 'clear sky',
      icon: '01d',
    ),
  ];

  test('should get forecast from the repository', () async {
    // arrange
    when(
      () => mockWeatherRepository.getFiveDayForecast(any(), any()),
    ).thenAnswer((_) async => Right(tForecastList));
    // act
    final result = await usecase(ForecastParams(lat: tLat, lon: tLon));
    // assert
    expect(result, Right(tForecastList));
    verify(() => mockWeatherRepository.getFiveDayForecast(tLat, tLon));
    verifyNoMoreInteractions(mockWeatherRepository);
  });
}
