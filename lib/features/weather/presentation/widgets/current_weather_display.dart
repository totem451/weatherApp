import 'package:flutter/material.dart';
import '../../domain/entities/weather.dart';
import 'weather_detail_card.dart';

class CurrentWeatherDisplay extends StatelessWidget {
  final WeatherEntity weather;

  const CurrentWeatherDisplay({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            weather.cityName,
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
            'https://openweathermap.org/img/wn/${weather.icon}@4x.png',
            height: 125,
            width: 125,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.error, color: Colors.white, size: 50);
            },
          ),
          Text(
            "${weather.temperature.toStringAsFixed(0)}°",
            style: const TextStyle(
              fontSize: 80,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            weather.description.toUpperCase(),
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
              WeatherDetailCard(
                icon: Icons.water_drop,
                value: "${weather.humidity}%",
                title: "Humidity",
              ),
              WeatherDetailCard(
                icon: Icons.air,
                value: "${weather.windSpeed} m/s",
                title: "Wind",
              ),
              WeatherDetailCard(
                icon: Icons.thermostat,
                value: "${weather.tempMin.toStringAsFixed(1)}°",
                title: "Min Temp",
              ),
              WeatherDetailCard(
                icon: Icons.thermostat,
                value: "${weather.tempMax.toStringAsFixed(1)}°",
                title: "Max Temp",
              ),
            ],
          ),
        ],
      ),
    );
  }
}
