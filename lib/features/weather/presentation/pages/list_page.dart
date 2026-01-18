import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/weather_list_bloc.dart';
import '../bloc/weather_list_event.dart';
import '../bloc/weather_list_state.dart';
import '../widgets/city_search_bar.dart';
import '../widgets/weather_background.dart';
import '../widgets/weather_detail_dialog.dart';
import '../widgets/weather_list_tile.dart';
import '../widgets/offline_error_display.dart';

// Page that displays a list of cities and their weather data
class ListPage extends StatelessWidget {
  const ListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WeatherBackground(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Weather List",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            // Search bar to find and add new cities
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CitySearchBar(),
            ),
            // Expanded list view showing the weather for added cities
            Expanded(
              child: BlocBuilder<WeatherListBloc, WeatherListState>(
                builder: (context, state) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<WeatherListBloc>().add(
                        RefreshWeatherListEvent(),
                      );
                    },
                    child: _buildListContent(context, state),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListContent(BuildContext context, WeatherListState state) {
    if (state is WeatherListUpdated) {
      if (state.weatherList.isEmpty) {
        return const SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: 400,
            child: Center(
              child: Text(
                "No cities added yet.",
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        );
      }
      return ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: state.weatherList.length,
        itemBuilder: (context, index) {
          final weather = state.weatherList[index];
          // Enable swipe-to-dismiss gesture to remove cities from the list
          return Dismissible(
            key: Key(weather.cityName),
            onDismissed: (direction) {
              context.read<WeatherListBloc>().add(
                RemoveCityEvent(weather.cityName),
              );
            },
            // Custom tile to display city weather highlights
            child: WeatherListTile(
              weather: weather,
              onTap: () =>
                  // Show detailed weather information in a dialog
                  WeatherDetailDialog.show(context, weather),
            ),
          );
        },
      );
    } else if (state is WeatherListLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is WeatherListError) {
      return OfflineErrorDisplay(
        message: state.message,
        onRetry: () {
          context.read<WeatherListBloc>().add(RefreshWeatherListEvent());
        },
      );
    }
    return const SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: SizedBox(
        height: 400,
        child: Center(
          child: Text(
            "Add a city to see weather",
            style: TextStyle(color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
