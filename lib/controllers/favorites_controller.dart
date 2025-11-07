import 'package:get/get.dart';
import 'package:wather_app/services/storage_service.dart';
class FavoritesController extends GetxController {
  final StorageService _storageService = Get.find();
  var favorites = <String>[].obs;
  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }
  Future<void> loadFavorites() async {
    try {
      final loadedFavorites = await _storageService.loadFavorites();
      favorites.value = loadedFavorites;
    } catch (e) {
      print('Error loading favorites: $e');
    }
  }
  Future<void> addFavorite(String city) async {
    if (city.isEmpty) return;
    if (!favorites.contains(city)) {
      favorites.add(city);
      await _storageService.saveFavorites(favorites);
      Get.snackbar(
        'Added to Favorites',
        '$city has been added to your favorites',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } else {
      Get.snackbar(
        'Already in Favorites',
        '$city is already in your favorites',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }
  Future<void> removeFavorite(String city) async {
    favorites.remove(city);
    await _storageService.saveFavorites(favorites);
    Get.snackbar(
      'Removed from Favorites',
      '$city has been removed from your favorites',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }
  bool isFavorite(String city) {
    return favorites.contains(city);
  }
  Future<void> toggleFavorite(String city) async {
    if (isFavorite(city)) {
      await removeFavorite(city);
    } else {
      await addFavorite(city);
    }
  }
}
