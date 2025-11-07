import 'package:intl/intl.dart';
class Helpers {
  static String formatTemperature(double temperature, {bool celsius = true}) {
    return '${temperature.toStringAsFixed(1)}°${celsius ? 'C' : 'F'}';
  }
  static double celsiusToFahrenheit(double celsius) {
    return (celsius * 9 / 5) + 32;
  }
  static double fahrenheitToCelsius(double fahrenheit) {
    return (fahrenheit - 32) * 5 / 9;
  }
  static String formatDate(DateTime date, {String format = 'MMM dd, yyyy'}) {
    return DateFormat(format).format(date);
  }
  static String formatTime(DateTime time, {String format = 'HH:mm'}) {
    return DateFormat(format).format(time);
  }
  static String getDayName(DateTime date) {
    return DateFormat('EEEE').format(date);
  }
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }
  static String formatHumidity(double humidity) {
    return '${humidity.toStringAsFixed(0)}%';
  }
  static String formatWindSpeed(double speed, {String unit = 'km/h'}) {
    return '${speed.toStringAsFixed(1)} $unit';
  }
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }
}
