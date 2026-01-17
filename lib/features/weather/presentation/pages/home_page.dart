import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../bloc/weather_bloc.dart';
import '../bloc/weather_event.dart';
import '../bloc/weather_state.dart';
import '../../../../core/services/notification_service.dart';
import '../widgets/weather_background.dart';
import '../widgets/current_weather_display.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _initNotifications();
  }

  Future<void> _initNotifications() async {
    final notificationService = sl<NotificationService>();
    await notificationService.init();
    await notificationService.requestPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return WeatherBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: BlocProvider(
              create: (_) =>
                  sl<WeatherBloc>()..add(const GetCurrentWeatherEvent()),
              child: BlocConsumer<WeatherBloc, WeatherState>(
                listener: (context, state) {
                  if (state is WeatherLoaded) {
                    final condition = state.weather.main.toLowerCase();
                    if (condition.contains('rain') ||
                        condition.contains('drizzle') ||
                        condition.contains('thunderstorm')) {
                      sl<NotificationService>().showRainAlert(
                        state.weather.cityName,
                      );
                    }
                  }
                },
                builder: (context, state) {
                  if (state is WeatherLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is WeatherLoaded) {
                    return CurrentWeatherDisplay(weather: state.weather);
                  } else if (state is WeatherError) {
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
