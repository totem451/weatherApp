import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../../../../injection_container.dart';
import '../bloc/weather_list_bloc.dart';
import '../bloc/weather_list_event.dart';
import 'home_page.dart';
import 'list_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [const HomePage(), const ListPage()];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<WeatherListBloc>()..add(LoadDefaultCitiesEvent()),
      child: Scaffold(
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
