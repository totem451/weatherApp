import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/weather_list_bloc.dart';
import '../bloc/weather_list_event.dart';
import '../bloc/weather_list_state.dart';
import '../widgets/city_search_bar.dart';
import '../widgets/weather_background.dart';
import '../widgets/weather_detail_dialog.dart';
import '../widgets/weather_list_tile.dart';

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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CitySearchBar(),
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
                          child: WeatherListTile(
                            weather: weather,
                            onTap: () =>
                                WeatherDetailDialog.show(context, weather),
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
}
