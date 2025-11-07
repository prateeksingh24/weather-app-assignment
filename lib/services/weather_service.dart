import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:wather_app/models/current_weather.dart';
import 'package:wather_app/models/forecast.dart';
import 'package:wather_app/utils/constants.dart';
class WeatherService {
  final String apiKey = AppConstants.weatherApiKey;
  final String baseUrl = AppConstants.weatherApiBaseUrl;
  Future<CurrentWeather> getCurrentWeather(
    String city, {
    String units = 'metric',
  }) async {
    try {
      final url = Uri.parse(
        '$baseUrl/weather?q=$city&appid=$apiKey&units=$units',
      );
      final response = await http
          .get(url)
          .timeout(
            AppConstants.apiTimeout,
            onTimeout: () {
              throw Exception(
                'Connection timeout. Please check your internet connection.',
              );
            },
          );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return CurrentWeather.fromJson(data);
      } else if (response.statusCode == 404) {
        throw Exception(
          'City not found. Please check the city name and try again.',
        );
      } else if (response.statusCode == 401) {
        throw Exception('Invalid API key. Please check your API key.');
      } else {
        throw Exception(
          'Failed to load weather data. Error: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e.toString().contains('City not found') ||
          e.toString().contains('Invalid API key') ||
          e.toString().contains('Connection timeout') ||
          e.toString().contains('API key')) {
        rethrow;
      }
      throw Exception('Failed to fetch weather: ${e.toString()}');
    }
  }
  Future<CurrentWeather> getCurrentWeatherByCoordinates(
    double lat,
    double lon, {
    String units = 'metric',
  }) async {
    try {
      final url = Uri.parse(
        '$baseUrl/weather?lat=$lat&lon=$lon&appid=$apiKey&units=$units',
      );
      final response = await http
          .get(url)
          .timeout(
            AppConstants.apiTimeout,
            onTimeout: () {
              throw Exception(
                'Connection timeout. Please check your internet connection.',
              );
            },
          );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return CurrentWeather.fromJson(data);
      } else {
        throw Exception(
          'Failed to load weather data. Error: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to fetch weather: ${e.toString()}');
    }
  }
  Future<List<Forecast>> getForecast(
    String city, {
    String units = 'metric',
  }) async {
    if (apiKey == 'YOUR_API_KEY_HERE') {
      throw Exception(
        'Please add your OpenWeatherMap API key in lib/utils/constants.dart',
      );
    }
    try {
      final url = Uri.parse(
        '$baseUrl/forecast?q=$city&appid=$apiKey&units=$units',
      );
      final response = await http
          .get(url)
          .timeout(
            AppConstants.apiTimeout,
            onTimeout: () {
              throw Exception(
                'Connection timeout. Please check your internet connection.',
              );
            },
          );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> forecastList = data['list'];
        return forecastList.map((item) => Forecast.fromJson(item)).toList();
      } else if (response.statusCode == 404) {
        throw Exception(
          'City not found. Please check the city name and try again.',
        );
      } else {
        throw Exception(
          'Failed to load forecast data. Error: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e.toString().contains('City not found') ||
          e.toString().contains('Connection timeout') ||
          e.toString().contains('API key')) {
        rethrow;
      }
      throw Exception('Failed to fetch forecast: ${e.toString()}');
    }
  }
  Future<List<Forecast>> getForecastByCoordinates(
    double lat,
    double lon, {
    String units = 'metric',
  }) async {
    if (apiKey == 'YOUR_API_KEY_HERE') {
      throw Exception(
        'Please add your OpenWeatherMap API key in lib/utils/constants.dart',
      );
    }
    try {
      final url = Uri.parse(
        '$baseUrl/forecast?lat=$lat&lon=$lon&appid=$apiKey&units=$units',
      );
      final response = await http
          .get(url)
          .timeout(
            AppConstants.apiTimeout,
            onTimeout: () {
              throw Exception(
                'Connection timeout. Please check your internet connection.',
              );
            },
          );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> forecastList = data['list'];
        return forecastList.map((item) => Forecast.fromJson(item)).toList();
      } else {
        throw Exception(
          'Failed to load forecast data. Error: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to fetch forecast: ${e.toString()}');
    }
  }
  List<DailyForecast> groupForecastsByDay(List<Forecast> forecasts) {
    final Map<String, List<Forecast>> groupedForecasts = {};
    for (var forecast in forecasts) {
      final dateKey =
          '${forecast.date.year}-${forecast.date.month}-${forecast.date.day}';
      if (!groupedForecasts.containsKey(dateKey)) {
        groupedForecasts[dateKey] = [];
      }
      groupedForecasts[dateKey]!.add(forecast);
    }
    final List<DailyForecast> dailyForecasts = [];
    groupedForecasts.forEach((key, hourlyForecasts) {
      if (dailyForecasts.length < 5) {
        final maxTemp = hourlyForecasts
            .map((f) => f.maxTemperature)
            .reduce((a, b) => a > b ? a : b);
        final minTemp = hourlyForecasts
            .map((f) => f.minTemperature)
            .reduce((a, b) => a < b ? a : b);
        final conditions = hourlyForecasts.map((f) => f.condition).toList();
        final mostCommonCondition = conditions.reduce(
          (a, b) =>
              conditions.where((c) => c == a).length >=
                  conditions.where((c) => c == b).length
              ? a
              : b,
        );
        final middayForecast = hourlyForecasts.firstWhere(
          (f) => f.date.hour >= 12 && f.date.hour <= 15,
          orElse: () => hourlyForecasts[hourlyForecasts.length ~/ 2],
        );
        dailyForecasts.add(
          DailyForecast(
            date: hourlyForecasts.first.date,
            maxTemp: maxTemp,
            minTemp: minTemp,
            condition: mostCommonCondition,
            icon: middayForecast.icon,
            hourlyForecasts: hourlyForecasts,
          ),
        );
      }
    });
    return dailyForecasts;
  }
  Future<List<String>> searchCities(String query) async {
    if (query.isEmpty) return [];
    return [query];
  }
}
