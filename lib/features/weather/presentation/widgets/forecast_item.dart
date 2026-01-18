import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/forecast.dart';

class ForecastItem extends StatelessWidget {
  final ForecastEntity forecast;

  const ForecastItem({super.key, required this.forecast});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(25),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withAlpha(25)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            DateFormat('E').format(forecast.dateTime),
            style: const TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Image.network(
            'https://openweathermap.org/img/wn/${forecast.icon}.png',
            height: 40,
            width: 40,
          ),
          const SizedBox(height: 8),
          Text(
            "${forecast.temperature.toStringAsFixed(0)}°",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
