import 'package:flutter/material.dart';
import '../../domain/entities/weather.dart';

// A detailed dialog showing comprehensive weather metrics for a specific city
class WeatherDetailDialog extends StatelessWidget {
  final WeatherEntity weather;

  const WeatherDetailDialog({super.key, required this.weather});

  // Static helper to display the detail dialog
  static Future<void> show(BuildContext context, WeatherEntity weather) async {
    await showDialog(
      context: context,
      builder: (context) => WeatherDetailDialog(weather: weather),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF2C3E50), Color(0xFF000000)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // City Name Header
            Text(
              weather.cityName,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            // Weather Icon
            Image.network(
              'https://openweathermap.org/img/wn/${weather.icon}@4x.png',
              height: 100,
              width: 100,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.error, color: Colors.white, size: 50),
            ),
            // Main Temperature Display
            Text(
              "${weather.temperature.toStringAsFixed(1)}°C",
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            // Weather Condition Description
            Text(
              weather.description.toUpperCase(),
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white70,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 20),
            const Divider(color: Colors.white24),
            const SizedBox(height: 10),
            // Secondary Metrics (Humidity, Wind)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildDialogItem(
                  Icons.water_drop,
                  "${weather.humidity}%",
                  "Humidity",
                ),
                _buildDialogItem(Icons.air, "${weather.windSpeed} m/s", "Wind"),
              ],
            ),
            const SizedBox(height: 15),
            // Temperature extremes (Min, Max)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildDialogItem(
                  Icons.thermostat,
                  "${weather.tempMin.toStringAsFixed(1)}°",
                  "Min",
                ),
                _buildDialogItem(
                  Icons.thermostat,
                  "${weather.tempMax.toStringAsFixed(1)}°",
                  "Max",
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Close Action
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withValues(alpha: 0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text("Close", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  // Helper to build a consistent layout for each metric item in the dialog
  Widget _buildDialogItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 24),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.white54),
        ),
      ],
    );
  }
}
