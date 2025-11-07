import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wather_app/controllers/weather_controller.dart';
import 'package:wather_app/views/weather_detail_view.dart';
class SearchView extends StatelessWidget {
  const SearchView({super.key});
  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();
    final WeatherController weatherController = Get.find();
    return Scaffold(
      backgroundColor: const Color(0xFF1C1B33),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Search City',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2E335A), Color(0xFF1C1B33)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                child: TextField(
                  controller: searchController,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  decoration: InputDecoration(
                    hintText: 'Enter city name...',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: Colors.white70,
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(
                        Icons.clear_rounded,
                        color: Colors.white70,
                      ),
                      onPressed: () => searchController.clear(),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                  ),
                  textInputAction: TextInputAction.search,
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      _searchCity(value, weatherController);
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFFFDB846),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFDB846).withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (searchController.text.isNotEmpty) {
                      _searchCity(searchController.text, weatherController);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  icon: const Icon(
                    Icons.search_rounded,
                    color: Color(0xFF1C1B33),
                  ),
                  label: const Text(
                    'Search Weather',
                    style: TextStyle(
                      color: Color(0xFF1C1B33),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                child: OutlinedButton.icon(
                  onPressed: () {
                    weatherController.fetchWeatherByCurrentLocation().then((_) {
                      if (weatherController.currentWeather.value != null) {
                        Get.back();
                      }
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  icon: const Icon(
                    Icons.my_location_rounded,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Use Current Location',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Divider(color: Colors.white.withOpacity(0.2), thickness: 1),
              const SizedBox(height: 20),
              const Text(
                'POPULAR CITIES',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: [
                    _buildCityTile(
                      'London',
                      'United Kingdom',
                      weatherController,
                    ),
                    _buildCityTile(
                      'New York',
                      'United States',
                      weatherController,
                    ),
                    _buildCityTile('Tokyo', 'Japan', weatherController),
                    _buildCityTile('Paris', 'France', weatherController),
                    _buildCityTile('Dubai', 'UAE', weatherController),
                    _buildCityTile('Sydney', 'Australia', weatherController),
                    _buildCityTile('Mumbai', 'India', weatherController),
                    _buildCityTile('Singapore', 'Singapore', weatherController),
                    _buildCityTile('Toronto', 'Canada', weatherController),
                    _buildCityTile('Berlin', 'Germany', weatherController),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildCityTile(
    String city,
    String country,
    WeatherController controller,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF383E5E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFFDB846).withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.location_city_rounded,
            color: Color(0xFFFDB846),
            size: 24,
          ),
        ),
        title: Text(
          city,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          country,
          style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 13),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 18,
          color: Colors.white70,
        ),
        onTap: () => _searchCity(city, controller),
      ),
    );
  }
  void _searchCity(String city, WeatherController controller) {
    controller.fetchWeather(city).then((_) {
      if (controller.currentWeather.value != null) {
        Get.off(() => WeatherDetailView(location: city));
      }
    });
  }
}
