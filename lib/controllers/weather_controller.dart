import 'package:get/get.dart';
import 'package:wather_app/models/current_weather.dart';
import 'package:wather_app/models/forecast.dart';
import 'package:wather_app/services/weather_service.dart';
import 'package:wather_app/services/location_service.dart';
import 'package:wather_app/services/storage_service.dart';
class WeatherController extends GetxController {
  final WeatherService _weatherService = Get.find();
  final LocationService _locationService = Get.find();
  final StorageService _storageService = Get.find();
  var isLoading = false.obs;
  var isForecastLoading = false.obs;
  var error = ''.obs;
  var currentWeather = Rx<CurrentWeather?>(null);
  var forecasts = <Forecast>[].obs;
  var dailyForecasts = <DailyForecast>[].obs;
  var currentCity = ''.obs;
  var temperatureUnit =
      'metric'.obs; // metric for Celsius, imperial for Fahrenheit
  @override
  void onInit() {
    super.onInit();
    loadTemperatureUnit();
    loadLastLocation();
  }
  Future<void> loadTemperatureUnit() async {
    final unit = await _storageService.getTemperatureUnit();
    temperatureUnit.value = unit;
  }
  Future<void> toggleTemperatureUnit() async {
    temperatureUnit.value = temperatureUnit.value == 'metric'
        ? 'imperial'
        : 'metric';
    await _storageService.saveTemperatureUnit(temperatureUnit.value);
    if (currentCity.value.isNotEmpty) {
      await fetchWeather(currentCity.value);
    }
  }
  Future<void> loadLastLocation() async {
    final lastCity = await _storageService.loadLastLocation();
    if (lastCity != null && lastCity.isNotEmpty) {
      await fetchWeather(lastCity);
    } else {
      await fetchWeatherByCurrentLocation();
    }
  }
  Future<void> fetchWeather(String city) async {
    if (city.isEmpty) {
      error.value = 'Please enter a city name';
      return;
    }
    isLoading.value = true;
    error.value = '';
    try {
      final weather = await _weatherService.getCurrentWeather(
        city,
        units: temperatureUnit.value,
      );
      currentWeather.value = weather;
      currentCity.value = city;
      await _storageService.saveLastLocation(city);
      await fetchForecast(city);
      error.value = '';
    } catch (e) {
      error.value = e.toString().replaceAll('Exception: ', '');
      currentWeather.value = null;
      Get.snackbar(
        'Error',
        error.value,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> fetchWeatherByCurrentLocation() async {
    isLoading.value = true;
    error.value = '';
    try {
      final hasPermission = await _locationService.requestLocationPermission();
      if (!hasPermission) {
        error.value = 'Location permission denied. Please search for a city.';
        isLoading.value = false;
        return;
      }
      final isEnabled = await _locationService.isLocationServiceEnabled();
      if (!isEnabled) {
        error.value =
            'Location service is disabled. Please enable it in settings.';
        isLoading.value = false;
        return;
      }
      final position = await _locationService.getCurrentLocation();
      if (position == null) {
        error.value =
            'Unable to get current location. Please search for a city.';
        isLoading.value = false;
        return;
      }
      final weather = await _weatherService.getCurrentWeatherByCoordinates(
        position.latitude,
        position.longitude,
        units: temperatureUnit.value,
      );
      currentWeather.value = weather;
      currentCity.value = weather.cityName;
      await _storageService.saveLastLocation(weather.cityName);
      await fetchForecastByCoordinates(position.latitude, position.longitude);
      error.value = '';
    } catch (e) {
      error.value = e.toString().replaceAll('Exception: ', '');
      Get.snackbar(
        'Error',
        error.value,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> fetchForecast(String city) async {
    isForecastLoading.value = true;
    try {
      final forecastList = await _weatherService.getForecast(
        city,
        units: temperatureUnit.value,
      );
      forecasts.value = forecastList;
      dailyForecasts.value = _weatherService.groupForecastsByDay(forecastList);
    } catch (e) {
      print('Error fetching forecast: $e');
    } finally {
      isForecastLoading.value = false;
    }
  }
  Future<void> fetchForecastByCoordinates(double lat, double lon) async {
    isForecastLoading.value = true;
    try {
      final forecastList = await _weatherService.getForecastByCoordinates(
        lat,
        lon,
        units: temperatureUnit.value,
      );
      forecasts.value = forecastList;
      dailyForecasts.value = _weatherService.groupForecastsByDay(forecastList);
    } catch (e) {
      print('Error fetching forecast: $e');
    } finally {
      isForecastLoading.value = false;
    }
  }
  Future<void> refreshWeather() async {
    if (currentCity.value.isNotEmpty) {
      await fetchWeather(currentCity.value);
    } else {
      await fetchWeatherByCurrentLocation();
    }
  }
  String getTemperatureSymbol() {
    return temperatureUnit.value == 'metric' ? '°C' : '°F';
  }
  String getWindSpeedUnit() {
    return temperatureUnit.value == 'metric' ? 'km/h' : 'mph';
  }
}
