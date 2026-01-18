import 'package:flutter/material.dart';
import '../../domain/entities/forecast.dart';
import 'forecast_item.dart';

class ForecastSection extends StatelessWidget {
  final List<ForecastEntity> forecasts;

  const ForecastSection({super.key, required this.forecasts});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            "Next 5 Days",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: forecasts.length,
            itemBuilder: (context, index) {
              return ForecastItem(forecast: forecasts[index]);
            },
          ),
        ),
      ],
    );
  }
}
