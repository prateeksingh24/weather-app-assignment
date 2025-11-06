import 'package:intl/intl.dart';

class Helpers {
  /// Format temperature with unit
  static String formatTemperature(double temperature, {bool celsius = true}) {
    return '${temperature.toStringAsFixed(1)}°${celsius ? 'C' : 'F'}';
  }

  /// Convert Celsius to Fahrenheit
  static double celsiusToFahrenheit(double celsius) {
    return (celsius * 9 / 5) + 32;
  }

  /// Convert Fahrenheit to Celsius
  static double fahrenheitToCelsius(double fahrenheit) {
    return (fahrenheit - 32) * 5 / 9;
  }

  /// Format date to readable string
  static String formatDate(DateTime date, {String format = 'MMM dd, yyyy'}) {
    return DateFormat(format).format(date);
  }

  /// Format time to readable string
  static String formatTime(DateTime time, {String format = 'HH:mm'}) {
    return DateFormat(format).format(time);
  }

  /// Get day name from date
  static String getDayName(DateTime date) {
    return DateFormat('EEEE').format(date);
  }

  /// Check if date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Format humidity percentage
  static String formatHumidity(double humidity) {
    return '${humidity.toStringAsFixed(0)}%';
  }

  /// Format wind speed
  static String formatWindSpeed(double speed, {String unit = 'km/h'}) {
    return '${speed.toStringAsFixed(1)} $unit';
  }

  /// Capitalize first letter of string
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }
}
