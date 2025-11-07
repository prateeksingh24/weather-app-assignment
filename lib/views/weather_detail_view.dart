import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wather_app/controllers/weather_controller.dart';
import 'package:wather_app/controllers/favorites_controller.dart';
import 'package:wather_app/widgets/error_view.dart';
import 'package:wather_app/utils/helpers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
class WeatherDetailView extends StatelessWidget {
  final String location;
  const WeatherDetailView({super.key, required this.location});
  @override
  Widget build(BuildContext context) {
    final WeatherController weatherController = Get.find();
    final FavoritesController favoritesController = Get.find();
    return Scaffold(
      backgroundColor: const Color(0xFF1C1B33),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2E335A), Color(0xFF1C1B33)],
          ),
        ),
        child: Obx(() {
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
              onRetry: () => weatherController.fetchWeather(location),
            );
          }
          if (weatherController.currentWeather.value == null) {
            return const Center(
              child: Text(
                'No weather data available',
                style: TextStyle(color: Colors.white),
              ),
            );
          }
          final weather = weatherController.currentWeather.value!;
          return RefreshIndicator(
            onRefresh: () => weatherController.fetchWeather(location),
            color: const Color(0xFFFDB846),
            backgroundColor: const Color(0xFF383E5E),
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverAppBar(
                  expandedHeight: 60,
                  floating: true,
                  pinned: false,
                  snap: true,
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  surfaceTintColor: Colors.transparent,
                  leading: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                    ),
                    onPressed: () => Get.back(),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      location,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    centerTitle: false,
                    titlePadding: const EdgeInsets.only(left: 56, bottom: 16),
                  ),
                  actions: [
                    Obx(() {
                      final isFavorite = favoritesController.isFavorite(
                        location,
                      );
                      return IconButton(
                        icon: Icon(
                          isFavorite
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          color: isFavorite
                              ? const Color(0xFFFDB846)
                              : Colors.white,
                        ),
                        onPressed: () =>
                            favoritesController.toggleFavorite(location),
                        tooltip: isFavorite
                            ? 'Remove from favorites'
                            : 'Add to favorites',
                      );
                    }),
                  ],
                ),
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(top: 10),
                          padding: const EdgeInsets.all(24.0),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF454C73), Color(0xFF383E5E)],
                            ),
                            borderRadius: BorderRadius.circular(30),
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
                              Text(
                                weather.cityName,
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                weather.country,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 20),
                              CachedNetworkImage(
                                imageUrl: weather.iconUrl,
                                height: 100,
                                width: 100,
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(
                                      color: Color(0xFFFDB846),
                                    ),
                                errorWidget: (context, url, error) =>
                                    const Icon(
                                      Icons.wb_sunny_rounded,
                                      size: 100,
                                      color: Color(0xFFFDB846),
                                    ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                Helpers.formatTemperature(
                                  weather.temperature,
                                  celsius:
                                      weatherController.temperatureUnit.value ==
                                      'metric',
                                ),
                                style: const TextStyle(
                                  fontSize: 56,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                weather.description.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                  letterSpacing: 2,
                                ),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Feels like ${Helpers.formatTemperature(weather.feelsLike, celsius: weatherController.temperatureUnit.value == 'metric')}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white60,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Weather Details',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 16),
                            GridView.count(
                              shrinkWrap: true,
                              padding: const EdgeInsets.all(0),
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisCount: 2,
                              childAspectRatio: 1.3,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              children: [
                                _buildDetailCard(
                                  icon: Icons.water_drop_rounded,
                                  title: 'Humidity',
                                  value: Helpers.formatHumidity(
                                    weather.humidity,
                                  ),
                                  color: const Color(0xFFFDB846),
                                ),
                                _buildDetailCard(
                                  icon: Icons.air_rounded,
                                  title: 'Wind Speed',
                                  value: Helpers.formatWindSpeed(
                                    weather.windSpeed,
                                  ),
                                  color: const Color(0xFFFDB846),
                                ),
                                _buildDetailCard(
                                  icon: Icons.compress_rounded,
                                  title: 'Pressure',
                                  value: '${weather.pressure} hPa',
                                  color: const Color(0xFFFDB846),
                                ),
                                _buildDetailCard(
                                  icon: Icons.visibility_rounded,
                                  title: 'Visibility',
                                  value:
                                      '${(weather.visibility / 1000).toStringAsFixed(1)} km',
                                  color: const Color(0xFFFDB846),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            if (weatherController.forecasts.isNotEmpty) ...[
                              const Text(
                                'Hourly Forecast',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                height: 130,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: weatherController.forecasts.length
                                      .clamp(0, 8),
                                  itemBuilder: (context, index) {
                                    final forecast =
                                        weatherController.forecasts[index];
                                    return Container(
                                      width: 90,
                                      margin: const EdgeInsets.only(right: 12),
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF383E5E),
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.2,
                                            ),
                                            blurRadius: 10,
                                            offset: const Offset(0, 5),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            DateFormat(
                                              'HH:mm',
                                            ).format(forecast.date),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          CachedNetworkImage(
                                            imageUrl: forecast.iconUrl,
                                            height: 40,
                                            width: 40,
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(
                                                      Icons.wb_sunny_rounded,
                                                      size: 40,
                                                      color: Color(0xFFFDB846),
                                                    ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            '${forecast.temperature.toInt()}°',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 24),
                            ],
                            if (weatherController
                                .dailyForecasts
                                .isNotEmpty) ...[
                              const Text(
                                '5-Day Forecast',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 12),
                              ListView.builder(
                                shrinkWrap: true,
                                padding: const EdgeInsets.all(0),
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount:
                                    weatherController.dailyForecasts.length,
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
                                                Helpers.getDayName(
                                                  forecast.date,
                                                ),
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
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
  Widget _buildDetailCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
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
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 11, color: Colors.white60),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.white,
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
