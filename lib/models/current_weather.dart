class CurrentWeather {
  final String cityName;
  final String country;
  final double temperature;
  final double feelsLike;
  final String condition;
  final String description;
  final String icon;
  final double humidity;
  final double windSpeed;
  final int pressure;
  final int visibility;
  final DateTime timestamp;
  final double lat;
  final double lon;
  CurrentWeather({
    required this.cityName,
    required this.country,
    required this.temperature,
    required this.feelsLike,
    required this.condition,
    required this.description,
    required this.icon,
    required this.humidity,
    required this.windSpeed,
    required this.pressure,
    required this.visibility,
    required this.timestamp,
    required this.lat,
    required this.lon,
  });
  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      cityName: json['name'] ?? '',
      country: json['sys']?['country'] ?? '',
      temperature: (json['main']?['temp'] ?? 0).toDouble(),
      feelsLike: (json['main']?['feels_like'] ?? 0).toDouble(),
      condition: json['weather']?[0]?['main'] ?? '',
      description: json['weather']?[0]?['description'] ?? '',
      icon: json['weather']?[0]?['icon'] ?? '01d',
      humidity: (json['main']?['humidity'] ?? 0).toDouble(),
      windSpeed: (json['wind']?['speed'] ?? 0).toDouble(),
      pressure: json['main']?['pressure'] ?? 0,
      visibility: json['visibility'] ?? 0,
      timestamp: DateTime.fromMillisecondsSinceEpoch((json['dt'] ?? 0) * 1000),
      lat: (json['coord']?['lat'] ?? 0).toDouble(),
      lon: (json['coord']?['lon'] ?? 0).toDouble(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'name': cityName,
      'sys': {'country': country},
      'main': {
        'temp': temperature,
        'feels_like': feelsLike,
        'humidity': humidity,
        'pressure': pressure,
      },
      'weather': [
        {'main': condition, 'description': description, 'icon': icon},
      ],
      'wind': {'speed': windSpeed},
      'visibility': visibility,
      'dt': timestamp.millisecondsSinceEpoch ~/ 1000,
      'coord': {'lat': lat, 'lon': lon},
    };
  }
  String get iconUrl => 'https://openweathermap.org/img/wn/$icon@2x.png';
}
