import 'package:flutter/material.dart';

// A reusable background widget that applies a consistent dark gradient to screens
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
          // Dark blue to near-black gradient for a premium weather app feel
          colors: [Color(0xFF1A2344), Color(0xFF121212)],
        ),
      ),
      child: child,
    );
  }
}
