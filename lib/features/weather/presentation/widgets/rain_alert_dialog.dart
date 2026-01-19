import 'package:flutter/material.dart';

enum RainAlertType { current, forecasted }

// Modular dialog to alert the user about rain in a specific city
class RainAlertDialog extends StatelessWidget {
  final String cityName;
  final RainAlertType type;
  final DateTime? forecastedTime;

  const RainAlertDialog({
    super.key,
    required this.cityName,
    this.type = RainAlertType.current,
    this.forecastedTime,
  });

  // Static helper to conveniently show the dialog from anywhere in the app
  static Future<void> show(
    BuildContext context,
    String cityName, {
    RainAlertType type = RainAlertType.current,
    DateTime? forecastedTime,
  }) {
    return showDialog(
      context: context,
      builder: (context) => RainAlertDialog(
        cityName: cityName,
        type: type,
        forecastedTime: forecastedTime,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isCurrent = type == RainAlertType.current;
    final String title = isCurrent ? "Rain Alert" : "Upcoming Rain";
    final IconData icon = isCurrent ? Icons.umbrella : Icons.cloudy_snowing;

    String contentText = "It is currently raining in $cityName. Stay dry!";
    if (!isCurrent && forecastedTime != null) {
      final hour = forecastedTime!.hour.toString().padLeft(2, '0');
      final minute = forecastedTime!.minute.toString().padLeft(2, '0');
      contentText =
          "Rain is expected in $cityName around $hour:$minute. Don't forget your umbrella!";
    }

    return AlertDialog(
      backgroundColor: const Color(0xFF1A2344),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Icon(icon, color: Colors.blueAccent),
          const SizedBox(width: 10),
          Text(title, style: const TextStyle(color: Colors.white)),
        ],
      ),
      content: Text(contentText, style: const TextStyle(color: Colors.white70)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context), // Close the dialog
          child: const Text("OK", style: TextStyle(color: Colors.blueAccent)),
        ),
      ],
    );
  }
}
