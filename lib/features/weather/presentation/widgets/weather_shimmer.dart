import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class WeatherShimmer extends StatelessWidget {
  const WeatherShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          _shimmerRect(150, 40), // City name
          const SizedBox(height: 8),
          _shimmerRect(100, 20), // Date
          const SizedBox(height: 20),
          _shimmerCircle(125), // Icon
          const SizedBox(height: 10),
          _shimmerRect(120, 80), // Temp
          const SizedBox(height: 10),
          _shimmerRect(180, 25), // Description
          const SizedBox(height: 40),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 1.5,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: List.generate(
              4,
              (_) => _shimmerRect(double.infinity, 80),
            ),
          ),
        ],
      ),
    );
  }

  Widget _shimmerRect(double width, double height) {
    return Shimmer.fromColors(
      baseColor: Colors.white.withAlpha(25),
      highlightColor: Colors.white.withAlpha(51),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _shimmerCircle(double size) {
    return Shimmer.fromColors(
      baseColor: Colors.white.withAlpha(25),
      highlightColor: Colors.white.withAlpha(51),
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
