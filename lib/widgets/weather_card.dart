import 'package:flutter/material.dart';
class WeatherCard extends StatelessWidget {
  final String location;
  final double temperature;
  final String condition;
  final VoidCallback? onTap;
  const WeatherCard({
    super.key,
    required this.location,
    required this.temperature,
    required this.condition,
    this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(location, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${temperature.toStringAsFixed(1)}°C',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  Text(
                    condition,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
