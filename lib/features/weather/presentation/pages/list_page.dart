import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/weather.dart';
import '../bloc/weather_list_bloc.dart';
import '../bloc/weather_list_event.dart';
import '../bloc/weather_list_state.dart';

class ListPage extends StatelessWidget {
  const ListPage({super.key});

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
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Weather List",
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildSearchField(context),
            ),
            Expanded(
              child: BlocBuilder<WeatherListBloc, WeatherListState>(
                builder: (context, state) {
                  if (state is WeatherListUpdated) {
                    if (state.weatherList.isEmpty) {
                      return const Center(
                        child: Text(
                          "No cities added yet.",
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: state.weatherList.length,
                      itemBuilder: (context, index) {
                        final weather = state.weatherList[index];
                        return Dismissible(
                          key: Key(weather.cityName),
                          onDismissed: (direction) {
                            context.read<WeatherListBloc>().add(
                              RemoveCityEvent(weather.cityName),
                            );
                          },
                          child: Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            color: Colors.white.withValues(alpha: 0.1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              leading: Image.network(
                                'https://openweathermap.org/img/wn/${weather.icon}@2x.png',
                                width: 50,
                              ),
                              title: Text(
                                weather.cityName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                              subtitle: Text(
                                weather.description,
                                style: const TextStyle(color: Colors.white70),
                              ),
                              trailing: Text(
                                "${weather.temperature.toStringAsFixed(0)}°",
                                style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              onTap: () => _showDetailDialog(context, weather),
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is WeatherListLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is WeatherListError) {
                    return Center(child: Text(state.message));
                  }
                  return const Center(
                    child: Text(
                      "Add a city to see weather",
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDetailDialog(BuildContext context, WeatherEntity weather) {
    showDialog(
      context: context,
      builder: (context) {
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
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  weather.cityName,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Image.network(
                  'https://openweathermap.org/img/wn/${weather.icon}@4x.png',
                  height: 100,
                  width: 100,
                ),
                Text(
                  "${weather.temperature.toStringAsFixed(1)}°C",
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildDialogItem(
                      Icons.water_drop,
                      "${weather.humidity}%",
                      "Humidity",
                    ),
                    _buildDialogItem(
                      Icons.air,
                      "${weather.windSpeed} m/s",
                      "Wind",
                    ),
                  ],
                ),
                const SizedBox(height: 15),
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
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "Close",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

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

  Widget _buildSearchField(BuildContext context) {
    final controller = TextEditingController();
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            style: const TextStyle(color: Colors.white),
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
        IconButton(
          onPressed: () {
            if (controller.text.isNotEmpty) {
              context.read<WeatherListBloc>().add(
                AddCityEvent(controller.text),
              );
              controller.clear();
            }
          },
          icon: const Icon(Icons.add, color: Colors.white),
        ),
      ],
    );
  }
}
