import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/weather_bloc.dart';
import '../bloc/weather_state.dart';
import 'current_weather_display.dart';
import 'weather_shimmer.dart';
import 'offline_error_display.dart';
import '../bloc/weather_event.dart';

class HomeWeatherContent extends StatelessWidget {
  const HomeWeatherContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherBloc, WeatherState>(
      builder: (context, state) {
        if (state is WeatherLoading) {
          return const WeatherShimmer();
        } else if (state is WeatherLoaded) {
          return CurrentWeatherDisplay(weather: state.weather);
        } else if (state is WeatherError) {
          return OfflineErrorDisplay(
            message: state.message,
            onRetry: () {
              context.read<WeatherBloc>().add(const GetCurrentWeatherEvent());
            },
            isFullPage: false,
          );
        }
        return const SizedBox(
          height: 200,
          child: Center(child: Text('Checking location...')),
        );
      },
    );
  }
}
