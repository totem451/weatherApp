import 'package:flutter/material.dart';

class WeatherBackground extends StatelessWidget {
  final Widget child;

  const WeatherBackground({super.key, required this.child});

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
      child: child,
    );
  }
}
