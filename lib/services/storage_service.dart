import 'package:shared_preferences/shared_preferences.dart';
import 'package:wather_app/utils/constants.dart';
class StorageService {
  Future<void> saveFavorites(List<String> favorites) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(AppConstants.favoritesKey, favorites);
    } catch (e) {
      print('Error saving favorites: $e');
      rethrow;
    }
  }
  Future<List<String>> loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getStringList(AppConstants.favoritesKey) ?? [];
    } catch (e) {
      print('Error loading favorites: $e');
      return [];
    }
  }
  Future<void> saveLastLocation(String location) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.lastLocationKey, location);
    } catch (e) {
      print('Error saving last location: $e');
      rethrow;
    }
  }
  Future<String?> loadLastLocation() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(AppConstants.lastLocationKey);
    } catch (e) {
      print('Error loading last location: $e');
      return null;
    }
  }
  Future<void> saveTemperatureUnit(String unit) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.temperatureUnitKey, unit);
    } catch (e) {
      print('Error saving temperature unit: $e');
      rethrow;
    }
  }
  Future<String> getTemperatureUnit() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(AppConstants.temperatureUnitKey) ?? 'metric';
    } catch (e) {
      print('Error getting temperature unit: $e');
      return 'metric';
    }
  }
  Future<void> clearAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (e) {
      print('Error clearing storage: $e');
      rethrow;
    }
  }
}
