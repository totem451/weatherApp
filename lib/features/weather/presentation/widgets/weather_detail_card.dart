import 'package:flutter/material.dart';

// A modular card used to display specific weather metrics (e.g., Humidity, Wind Speed)
class WeatherDetailCard extends StatelessWidget {
  final IconData icon; // Icon representing the metric
  final String value; // The actual data value (e.g., "50%", "10 m/s")
  final String title; // Subtitle describing the metric

  const WeatherDetailCard({
    super.key,
    required this.icon,
    required this.value,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(
          alpha: 0.05,
        ), // Subtle transparent background
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
