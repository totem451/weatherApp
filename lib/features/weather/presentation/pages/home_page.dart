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

import '../widgets/home_weather_content.dart';
import '../widgets/home_forecast_content.dart';

// Page that displays the current weather for the user's location
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
              child: BlocConsumer<WeatherBloc, WeatherState>(
                listener: (context, state) {
                  if (state is WeatherLoaded) {
                    // Fetch forecast once we have coordinates
                    context.read<ForecastBloc>().add(
                      GetFiveDayForecastEvent(
                        lat: state.weather.latitude,
                        lon: state.weather.longitude,
                      ),
                    );

                    // Check for rain conditions
                    final condition = state.weather.main.toLowerCase();
                    if (condition.contains('rain') ||
                        condition.contains('drizzle') ||
                        condition.contains('thunderstorm')) {
                      RainAlertDialog.show(context, state.weather.cityName);
                    }
                  }
                },
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
    );
  }
}
