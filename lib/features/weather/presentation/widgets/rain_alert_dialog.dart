import 'package:flutter/material.dart';

class RainAlertDialog extends StatelessWidget {
  final String cityName;

  const RainAlertDialog({super.key, required this.cityName});

  static Future<void> show(BuildContext context, String cityName) {
    return showDialog(
      context: context,
      builder: (context) => RainAlertDialog(cityName: cityName),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1A2344),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Row(
        children: [
          Icon(Icons.umbrella, color: Colors.blueAccent),
          SizedBox(width: 10),
          Text("Rain Alert", style: TextStyle(color: Colors.white)),
        ],
      ),
      content: Text(
        "It is currently raining in $cityName. Stay dry!",
        style: const TextStyle(color: Colors.white70),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("OK", style: TextStyle(color: Colors.blueAccent)),
        ),
      ],
    );
  }
}
