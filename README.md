# Weather App 🌤️

A modern Flutter weather application built with GetX state management and OpenWeatherMap API.

## Features

- 🌍 Current weather for any city
- 📍 GPS-based location weather
- 📅 5-day weather forecast
- ⭐ Save favorite cities
- 🌡️ Temperature unit conversion (Celsius/Fahrenheit)
- 🎨 Beautiful Material Design 3 UI
- 📱 Responsive design for all screen sizes

## Prerequisites

Before you begin, ensure you have:

- Flutter SDK (^3.8.1)
- Dart SDK
- Android Studio / VS Code with Flutter extensions
- An OpenWeatherMap API key ([Get one free here](https://openweathermap.org/api))

## Setup Instructions

### 1. Clone the Repository

```bash
git clone <repository-url>
cd wather_app
```

### 2. Configure Environment Variables

1. Copy the `.env.example` file to `.env`:
   ```bash
   cp .env.example .env
   ```

2. Open `.env` and replace `your_api_key_here` with your actual OpenWeatherMap API key:
   ```
   OPENWEATHER_API_KEY=your_actual_api_key_here
   ```

### 3. Install Dependencies

```bash
flutter pub get
```

### 4. Run the App

```bash
flutter run
```

## Project Structure

```
lib/
├── main.dart                 # App entry point with GetX configuration
├── models/                   # Data models
│   ├── current_weather.dart
│   └── forecast.dart
├── views/                    # UI screens
│   ├── home_view.dart
│   ├── search_view.dart
│   ├── weather_detail_view.dart
│   └── favorites_view.dart
├── controllers/              # GetX controllers
│   ├── weather_controller.dart
│   └── favorites_controller.dart
├── services/                 # Business logic
│   ├── weather_service.dart
│   ├── location_service.dart
│   └── storage_service.dart
├── widgets/                  # Reusable components
│   ├── weather_card.dart
│   ├── forecast_card.dart
│   └── error_view.dart
└── utils/                    # Helpers and constants
    ├── constants.dart
    └── helpers.dart
```

## Technologies Used

- **Flutter**: Cross-platform UI framework
- **GetX**: State management, dependency injection, and navigation
- **OpenWeatherMap API**: Weather data provider
- **Geolocator**: Location services
- **SharedPreferences**: Local data persistence
- **flutter_dotenv**: Environment variable management

## Important Notes

- **API Key Security**: Never commit your `.env` file to version control. It's already in `.gitignore`.
- **Permissions**: The app requires location permissions on Android/iOS for GPS-based weather.
- **Internet**: An active internet connection is required to fetch weather data.

## Documentation

For detailed implementation guides, see:
- [QUICKSTART.md](docs/QUICKSTART.md) - Quick start guide
- [IMPLEMENTATION_GUIDE.md](docs/IMPLEMENTATION_GUIDE.md) - Detailed implementation
- [GETX_GUIDE.md](docs/GETX_GUIDE.md) - GetX usage patterns

## License

This project is created for educational purposes.
