import 'package:flutter/material.dart';
import '../../domain/entities/weather.dart';

class WeatherListTile extends StatelessWidget {
  final WeatherEntity weather;
  final VoidCallback onTap;

  const WeatherListTile({
    super.key,
    required this.weather,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        leading: Image.network(
          'https://openweathermap.org/img/wn/${weather.icon}@2x.png',
          width: 50,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.error, color: Colors.white);
          },
        ),
        title: Text(
          weather.cityName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        subtitle: Text(
          weather.description,
          style: const TextStyle(color: Colors.white70),
        ),
        trailing: Text(
          "${weather.temperature.toStringAsFixed(0)}°",
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
