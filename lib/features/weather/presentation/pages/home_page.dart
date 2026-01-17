import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../bloc/weather_bloc.dart';
import '../bloc/weather_event.dart';
import '../bloc/weather_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1A2344), Color(0xFF121212)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: BlocProvider(
              create: (_) =>
                  sl<WeatherBloc>()..add(const GetCurrentWeatherEvent()),
              child: BlocBuilder<WeatherBloc, WeatherState>(
                builder: (context, state) {
                  if (state is WeatherLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is WeatherLoaded) {
                    return _buildWeatherDisplay(state);
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

  Widget _buildWeatherDisplay(WeatherLoaded state) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            state.weather.cityName,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            DateTime.now().toLocal().toString().split(' ')[0],
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          Image.network(
            'https://openweathermap.org/img/wn/${state.weather.icon}@4x.png',
            height: 125,
            width: 125,
          ),
          Text(
            "${state.weather.temperature.toStringAsFixed(0)}°",
            style: const TextStyle(
              fontSize: 80,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            state.weather.description.toUpperCase(),
            style: const TextStyle(
              fontSize: 20,
              letterSpacing: 2,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 40),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 1.5,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _buildDetailCard(
                Icons.water_drop,
                "${state.weather.humidity}%",
                "Humidity",
              ),
              _buildDetailCard(
                Icons.air,
                "${state.weather.windSpeed} m/s",
                "Wind",
              ),
              _buildDetailCard(
                Icons.thermostat,
                "${state.weather.tempMin.toStringAsFixed(1)}°",
                "Min Temp",
              ),
              _buildDetailCard(
                Icons.thermostat,
                "${state.weather.tempMax.toStringAsFixed(1)}°",
                "Max Temp",
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard(IconData icon, String value, String title) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 30),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            title,
            style: const TextStyle(fontSize: 14, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
