import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/features/weather/presentation/pages/main_screen.dart';
import 'injection_container.dart' as di;

import 'package:flutter_dotenv/flutter_dotenv.dart';

// Entry point of the application
void main() async {
  // Ensures that widget binding is initialized before using platform channels
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Load environment variables from the .env file (e.g., API keys)
    await dotenv.load(fileName: ".env");
  } catch (e) {
    if (kDebugMode) {
      print("DotEnv load failed: $e");
    }
  }

  // Initialize dependency injection container
  await di.init();

  runApp(const MyApp());
}

// Root widget of the application
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      // Application theme configuration
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: const ColorScheme.dark(
          primary: Colors.deepPurple,
          secondary: Colors.tealAccent,
        ),
      ),
      themeMode: ThemeMode.dark,
      // Initial screen of the app
      home: const MainScreen(),
    );
  }
}
