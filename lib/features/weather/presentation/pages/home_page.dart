import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../bloc/weather_bloc.dart';
import '../bloc/weather_event.dart';
import '../bloc/weather_state.dart';
import '../widgets/weather_background.dart';
import '../widgets/current_weather_display.dart';
import '../widgets/rain_alert_dialog.dart';

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
            child: BlocProvider(
              // Trigger fetching current weather when the page is built
              create: (_) =>
                  sl<WeatherBloc>()..add(const GetCurrentWeatherEvent()),
              child: BlocConsumer<WeatherBloc, WeatherState>(
                listener: (context, state) {
                  // Check for rain conditions when weather data is loaded
                  if (state is WeatherLoaded) {
                    final condition = state.weather.main.toLowerCase();
                    if (condition.contains('rain') ||
                        condition.contains('drizzle') ||
                        condition.contains('thunderstorm')) {
                      // Show an in-app dialog for rain alerts
                      RainAlertDialog.show(context, state.weather.cityName);
                    }
                  }
                },
                builder: (context, state) {
                  if (state is WeatherLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is WeatherLoaded) {
                    // Display the weather information using a custom widget
                    return CurrentWeatherDisplay(weather: state.weather);
                  } else if (state is WeatherError) {
                    // Show error message if something went wrong
                    return Center(child: Text(state.message));
                  }
                  return const Center(child: Text('Checking location...'));
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
