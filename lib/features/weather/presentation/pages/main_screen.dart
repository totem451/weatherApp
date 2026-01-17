import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../../../../injection_container.dart';
import '../bloc/weather_list_bloc.dart';
import '../bloc/weather_list_event.dart';
import 'home_page.dart';
import 'list_page.dart';

// Main screen with bottom navigation bar to switch between Home and List pages
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Index of the currently selected tab
  int _selectedIndex = 0;

  // List of pages to display in the navigation
  final List<Widget> _pages = [const HomePage(), const ListPage()];

  @override
  Widget build(BuildContext context) {
    // Provide WeatherListBloc to the whole screen as both pages might need it
    return BlocProvider(
      create: (_) => sl<WeatherListBloc>()..add(LoadDefaultCitiesEvent()),
      child: Scaffold(
        // IndexedStack preserves the state of child widgets when switching tabs
        body: IndexedStack(index: _selectedIndex, children: _pages),
        bottomNavigationBar: Container(
          color: const Color(0xFF121212),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
            child: GNav(
              backgroundColor: const Color(0xFF121212),
              color: Colors.white,
              activeColor: Colors.white,
              tabBackgroundColor: Colors.white.withValues(alpha: 0.1),
              gap: 8,
              padding: const EdgeInsets.all(16),
              tabs: const [
                GButton(icon: Icons.home, text: 'Home'),
                GButton(icon: Icons.list, text: 'List'),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
