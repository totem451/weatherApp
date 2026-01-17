import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/weather_list_bloc.dart';
import '../bloc/weather_list_event.dart';

// A search bar widget that allows users to input a city name and add it to their weather list
class CitySearchBar extends StatefulWidget {
  const CitySearchBar({super.key});

  @override
  State<CitySearchBar> createState() => _CitySearchBarState();
}

class _CitySearchBarState extends State<CitySearchBar> {
  // Controller to manage the text input in the search field
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    // Always dispose controllers to avoid memory leaks
    _controller.dispose();
    super.dispose();
  }

  // Helper method to trigger the city addition logic
  void _onAddCity() {
    if (_controller.text.isNotEmpty) {
      // Dispatch an AddCityEvent to the WeatherListBloc
      context.read<WeatherListBloc>().add(AddCityEvent(_controller.text));
      _controller.clear();
      // Hide the keyboard after submission
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            style: const TextStyle(color: Colors.white),
            onSubmitted: (_) => _onAddCity(),
            decoration: InputDecoration(
              hintText: 'Add City...',
              hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              prefixIcon: const Icon(Icons.add_location, color: Colors.white),
            ),
          ),
        ),
        const SizedBox(width: 10),
        // Circle button to manually trigger the search/add action
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: _onAddCity,
            icon: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
