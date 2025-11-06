import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  // API Configuration
  // API key is loaded from .env file for security
  // Create a .env file in the root directory with: OPENWEATHER_API_KEY=your_key_here
  static final String weatherApiKey =
      dotenv.env['OPENWEATHER_API_KEY'].toString();
  static const String weatherApiBaseUrl =
      'https://api.openweathermap.org/data/2.5';

  // Storage Keys
  static const String favoritesKey = 'favorites';
  static const String lastLocationKey = 'last_location';
  static const String temperatureUnitKey = 'temperature_unit';

  // App Configuration
  static const int defaultForecastDays = 5;
  static const Duration apiTimeout = Duration(seconds: 30);

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double cardBorderRadius = 16.0;

  // Weather Conditions Icons
  static const Map<String, IconData> weatherIcons = {
    'Clear': Icons.wb_sunny,
    'Clouds': Icons.cloud,
    'Rain': Icons.water_drop,
    'Snow': Icons.ac_unit,
    'Thunderstorm': Icons.flash_on,
    'Drizzle': Icons.grain,
    'Mist': Icons.blur_on,
    'Fog': Icons.blur_on,
    'Haze': Icons.blur_circular,
    'Smoke': Icons.cloud_queue,
  };

  // Weather Image Assets
  static const Map<String, String> weatherImages = {
    'Clear': 'assets/sun.png',
    'Clouds': 'assets/cloudy.png',
    'Rain': 'assets/rainy-day.png',
    'Snow': 'assets/sun.png', // You can add a snow asset if you have one
    'Thunderstorm': 'assets/rainy-day.png',
    'Drizzle': 'assets/rainy-day.png',
    'Mist': 'assets/foggy.png',
    'Fog': 'assets/foggy.png',
    'Haze': 'assets/foggy.png',
    'Smoke': 'assets/foggy.png',
  };

  // Weather background colors
  static const Map<String, Color> weatherColors = {
    'Clear': Color(0xFF47BFDF),
    'Clouds': Color(0xFF54717A),
    'Rain': Color(0xFF57575D),
    'Snow': Color(0xFFE0F2F7),
    'Thunderstorm': Color(0xFF4A5A6A),
    'Drizzle': Color(0xFF738289),
    'Mist': Color(0xFF9E9E9E),
    'Fog': Color(0xFF9E9E9E),
    'Haze': Color(0xFFBDBDBD),
  };

  // Default location (if no location is available)
  static const String defaultCity = 'Delhi';

  // Temperature units
  static const String celsius = 'metric';
  static const String fahrenheit = 'imperial';
}
