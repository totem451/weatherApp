import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../bloc/weather_bloc.dart';
import '../bloc/weather_event.dart';
import '../bloc/weather_state.dart';
import '../widgets/weather_background.dart';
import '../widgets/rain_alert_dialog.dart';
import '../bloc/forecast_bloc.dart';
import '../bloc/forecast_event.dart';
import '../bloc/forecast_state.dart';

import '../widgets/home_weather_content.dart';
import '../widgets/home_forecast_content.dart';

// Page that displays the current weather for the user's location
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _currentAlertShown = false;
  bool _forecastAlertShown = false;

  bool _isRainy(String mainCondition) {
    final condition = mainCondition.toLowerCase();
    return condition.contains('rain') ||
        condition.contains('drizzle') ||
        condition.contains('thunderstorm');
  }

  @override
  Widget build(BuildContext context) {
    return WeatherBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (_) =>
                      sl<WeatherBloc>()..add(const GetCurrentWeatherEvent()),
                ),
                BlocProvider(create: (_) => sl<ForecastBloc>()),
              ],
              child: MultiBlocListener(
                listeners: [
                  BlocListener<WeatherBloc, WeatherState>(
                    listener: (context, state) {
                      if (state is WeatherLoaded) {
                        // Fetch forecast once we have coordinates
                        context.read<ForecastBloc>().add(
                          GetFiveDayForecastEvent(
                            lat: state.weather.latitude,
                            lon: state.weather.longitude,
                          ),
                        );

                        // Check for current rain conditions
                        if (!_currentAlertShown &&
                            _isRainy(state.weather.main)) {
                          _currentAlertShown = true;
                          RainAlertDialog.show(context, state.weather.cityName);
                        } else if (!_isRainy(state.weather.main)) {
                          // Reset if condition changes (optional, but good for long sessions)
                          _currentAlertShown = false;
                        }
                      }
                    },
                  ),
                  BlocListener<ForecastBloc, ForecastState>(
                    listener: (context, state) {
                      if (state is ForecastLoaded) {
                        final weatherState = context.read<WeatherBloc>().state;
                        // Only check forecast if it's not currently raining
                        if (weatherState is WeatherLoaded &&
                            !_isRainy(weatherState.weather.main)) {
                          // Check next 4 slots (approx. 12 hours)
                          final upcomingRain = state.forecastList
                              .take(4)
                              .where((f) => _isRainy(f.main))
                              .toList();

                          if (!_forecastAlertShown && upcomingRain.isNotEmpty) {
                            _forecastAlertShown = true;
                            RainAlertDialog.show(
                              context,
                              weatherState.weather.cityName,
                              type: RainAlertType.forecasted,
                              forecastedTime: upcomingRain.first.dateTime,
                            );
                          } else if (upcomingRain.isEmpty) {
                            _forecastAlertShown = false;
                          }
                        }
                      }
                    },
                  ),
                ],
                child: BlocBuilder<WeatherBloc, WeatherState>(
                  builder: (context, weatherState) {
                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<WeatherBloc>().add(
                          const GetCurrentWeatherEvent(),
                        );
                      },
                      child: const SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: Column(
                          children: [
                            HomeWeatherContent(),
                            SizedBox(height: 20),
                            HomeForecastContent(),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
