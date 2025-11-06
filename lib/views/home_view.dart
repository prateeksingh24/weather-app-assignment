import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wather_app/controllers/weather_controller.dart';
import 'package:wather_app/controllers/favorites_controller.dart';
import 'package:wather_app/views/search_view.dart';
import 'package:wather_app/views/favorites_view.dart';
import 'package:wather_app/views/weather_detail_view.dart';
import 'package:wather_app/widgets/error_view.dart';
import 'package:wather_app/utils/helpers.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final WeatherController weatherController = Get.find();
    final FavoritesController favoritesController = Get.find();

    return Scaffold(
      backgroundColor: const Color(0xFF1C1B33),
      body: Obx(() {
        if (weatherController.isLoading.value) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Color(0xFFFDB846)),
                SizedBox(height: 16),
                Text(
                  'Loading weather data...',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          );
        }

        if (weatherController.error.value.isNotEmpty &&
            weatherController.currentWeather.value == null) {
          return ErrorView(
            message: weatherController.error.value,
            onRetry: () => weatherController.refreshWeather(),
          );
        }

        if (weatherController.currentWeather.value == null) {
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF2E335A), Color(0xFF1C1B33)],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.cloud_off, size: 80, color: Colors.white54),
                  const SizedBox(height: 16),
                  const Text(
                    'No weather data available',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Search for a city or enable location',
                    style: TextStyle(color: Colors.white54),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => Get.to(() => const SearchView()),
                    icon: const Icon(Icons.search),
                    label: const Text('Search City'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFDB846),
                      foregroundColor: const Color(0xFF1C1B33),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () =>
                        weatherController.fetchWeatherByCurrentLocation(),
                    icon: const Icon(Icons.my_location),
                    label: const Text('Use Current Location'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white54),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final weather = weatherController.currentWeather.value!;
        final isFavorite = favoritesController.isFavorite(weather.cityName);

        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF2E335A), Color(0xFF1C1B33)],
            ),
          ),
          child: RefreshIndicator(
            onRefresh: () => weatherController.refreshWeather(),
            color: const Color(0xFFFDB846),
            backgroundColor: const Color(0xFF383E5E),
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 60,
                  floating: true,
                  pinned: false,
                  snap: true,
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  surfaceTintColor: Colors.transparent,
                  flexibleSpace: FlexibleSpaceBar(
                    title: const Text(
                      'Weather Forecast',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    centerTitle: false,
                    titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(
                        Icons.favorite_rounded,
                        color: Colors.white,
                      ),
                      onPressed: () => Get.to(() => const FavoritesView()),
                    ),
                    Obx(
                      () => PopupMenuButton(
                        icon: Icon(
                          weatherController.temperatureUnit.value == 'metric'
                              ? Icons.thermostat_rounded
                              : Icons.ac_unit_rounded,
                          color: Colors.white,
                        ),
                        color: const Color(0xFF383E5E),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            child: Text(
                              weatherController.temperatureUnit.value ==
                                      'metric'
                                  ? '°F Fahrenheit'
                                  : '°C Celsius',
                              style: const TextStyle(color: Colors.white),
                            ),
                            onTap: () =>
                                weatherController.toggleTemperatureUnit(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SliverPadding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    bottom: 20,
                    top: 10,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // Header - Today + Date
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Today',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  Helpers.formatDate(DateTime.now()),
                                  style: const TextStyle(
                                    color: Colors.white60,
                                    fontSize: 14,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              isFavorite
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              color: isFavorite
                                  ? const Color(0xFFFDB846)
                                  : Colors.white,
                              size: 28,
                            ),
                            onPressed: () => favoritesController.toggleFavorite(
                              weather.cityName,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      // Main Weather Card
                      GestureDetector(
                        onTap: () => Get.to(
                          () => WeatherDetailView(location: weather.cityName),
                        ),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 28,
                          ),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF454C73), Color(0xFF383E5E)],
                            ),
                            borderRadius: BorderRadius.circular(35),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              // Temperature and Icon Row
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Temperature Section
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                weather.temperature
                                                    .toInt()
                                                    .toString(),
                                                style: const TextStyle(
                                                  fontSize: 90,
                                                  fontWeight: FontWeight.w300,
                                                  color: Colors.white,
                                                  height: 1,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            const Text(
                                              '°C',
                                              style: TextStyle(
                                                fontSize: 36,
                                                fontWeight: FontWeight.w300,
                                                color: Color(0xFFFDB846),
                                                height: 1.8,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          weather.description,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.white70,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(width: 8),

                                  // Weather Icon
                                  Flexible(
                                    flex: 2,
                                    child: CachedNetworkImage(
                                      imageUrl: weather.iconUrl,
                                      height: 130,
                                      width: 130,
                                      fit: BoxFit.contain,
                                      placeholder: (context, url) =>
                                          const CircularProgressIndicator(
                                            color: Color(0xFFFDB846),
                                          ),
                                      errorWidget: (context, url, error) =>
                                          const Icon(
                                            Icons.wb_sunny_rounded,
                                            size: 130,
                                            color: Color(0xFFFDB846),
                                          ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 24),

                              // Location Row
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on_rounded,
                                    color: Colors.white70,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      '${weather.cityName}, ${weather.country}',
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Weather Details Cards (3 in a row)
                      Row(
                        children: [
                          Expanded(
                            child: _buildSmallInfoCard(
                              Icons.thermostat_rounded,
                              'Feels Like',
                              Helpers.formatTemperature(
                                weather.feelsLike,
                                celsius:
                                    weatherController.temperatureUnit.value ==
                                    'metric',
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildSmallInfoCard(
                              Icons.water_drop_rounded,
                              'Humidity',
                              Helpers.formatHumidity(weather.humidity),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildSmallInfoCard(
                              Icons.air_rounded,
                              'Wind',
                              Helpers.formatWindSpeed(weather.windSpeed),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      // 5-Day Forecast Section
                      if (weatherController.dailyForecasts.isNotEmpty) ...[
                        const Text(
                          '5-Day Forecast',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Obx(
                          () => ListView.builder(
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(0),
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: weatherController.dailyForecasts.length,
                            itemBuilder: (context, index) {
                              final forecast =
                                  weatherController.dailyForecasts[index];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xFF454C73),
                                      Color(0xFF383E5E),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl: forecast.iconUrl,
                                      height: 50,
                                      width: 50,
                                      placeholder: (context, url) =>
                                          const CircularProgressIndicator(
                                            color: Color(0xFFFDB846),
                                          ),
                                      errorWidget: (context, url, error) =>
                                          const Icon(
                                            Icons.wb_sunny_rounded,
                                            size: 50,
                                            color: Color(0xFFFDB846),
                                          ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            Helpers.getDayName(forecast.date),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            forecast.condition,
                                            style: const TextStyle(
                                              color: Colors.white70,
                                              fontSize: 13,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      '${forecast.maxTemp.toInt()}° / ${forecast.minTemp.toInt()}°',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ]),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFDB846).withOpacity(0.5),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () => Get.to(() => const SearchView()),
          tooltip: 'Search City',
          backgroundColor: const Color(0xFFFDB846),
          elevation: 0,
          child: const Icon(
            Icons.search_rounded,
            color: Color(0xFF1C1B33),
            size: 28,
          ),
        ),
      ),
    );
  }

  Widget _buildSmallInfoCard(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF383E5E),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xFFFDB846), size: 28),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(color: Colors.white60, fontSize: 11),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
