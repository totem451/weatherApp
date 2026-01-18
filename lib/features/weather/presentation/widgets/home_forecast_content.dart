import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/forecast_bloc.dart';
import '../bloc/forecast_state.dart';
import '../bloc/weather_bloc.dart';
import '../bloc/weather_state.dart';
import 'forecast_section.dart';
import 'offline_error_display.dart';
import '../bloc/weather_event.dart';

class HomeForecastContent extends StatelessWidget {
  const HomeForecastContent({super.key});

  @override
  Widget build(BuildContext context) {
    // Hide forecast content if weather is loading to avoid duplicate skeletons
    final weatherState = context.watch<WeatherBloc>().state;
    if (weatherState is WeatherLoading) {
      return const SizedBox.shrink();
    }

    return BlocBuilder<ForecastBloc, ForecastState>(
      builder: (context, state) {
        if (state is ForecastLoading) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (state is ForecastLoaded) {
          return ForecastSection(forecasts: state.forecastList);
        } else if (state is ForecastError) {
          return OfflineErrorDisplay(
            message: state.message,
            onRetry: () {
              context.read<WeatherBloc>().add(const GetCurrentWeatherEvent());
            },
            isFullPage: false,
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
