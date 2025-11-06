class Forecast {
  final DateTime date;
  final double temperature;
  final double maxTemperature;
  final double minTemperature;
  final String condition;
  final String description;
  final String icon;
  final double humidity;
  final double windSpeed;

  Forecast({
    required this.date,
    required this.temperature,
    required this.maxTemperature,
    required this.minTemperature,
    required this.condition,
    required this.description,
    required this.icon,
    required this.humidity,
    required this.windSpeed,
  });

  factory Forecast.fromJson(Map<String, dynamic> json) {
    return Forecast(
      date: DateTime.fromMillisecondsSinceEpoch((json['dt'] ?? 0) * 1000),
      temperature: (json['main']?['temp'] ?? 0).toDouble(),
      maxTemperature: (json['main']?['temp_max'] ?? 0).toDouble(),
      minTemperature: (json['main']?['temp_min'] ?? 0).toDouble(),
      condition: json['weather']?[0]?['main'] ?? '',
      description: json['weather']?[0]?['description'] ?? '',
      icon: json['weather']?[0]?['icon'] ?? '01d',
      humidity: (json['main']?['humidity'] ?? 0).toDouble(),
      windSpeed: (json['wind']?['speed'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dt': date.millisecondsSinceEpoch ~/ 1000,
      'main': {
        'temp': temperature,
        'temp_max': maxTemperature,
        'temp_min': minTemperature,
        'humidity': humidity,
      },
      'weather': [
        {'main': condition, 'description': description, 'icon': icon},
      ],
      'wind': {'speed': windSpeed},
    };
  }

  String get iconUrl => 'https://openweathermap.org/img/wn/$icon@2x.png';
}

class DailyForecast {
  final DateTime date;
  final double maxTemp;
  final double minTemp;
  final String condition;
  final String icon;
  final List<Forecast> hourlyForecasts;

  DailyForecast({
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.condition,
    required this.icon,
    required this.hourlyForecasts,
  });

  String get iconUrl => 'https://openweathermap.org/img/wn/$icon@2x.png';
}
