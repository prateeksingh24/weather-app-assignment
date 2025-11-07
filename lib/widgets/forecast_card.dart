import 'package:flutter/material.dart';
class ForecastCard extends StatelessWidget {
  final String day;
  final String condition;
  final double maxTemp;
  final double minTemp;
  final IconData? icon;
  const ForecastCard({
    super.key,
    required this.day,
    required this.condition,
    required this.maxTemp,
    required this.minTemp,
    this.icon,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(day, style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            if (icon != null)
              Icon(icon, size: 32, color: Theme.of(context).primaryColor),
            const SizedBox(height: 8),
            Text(
              condition,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${maxTemp.toStringAsFixed(0)}°',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '${minTemp.toStringAsFixed(0)}°',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
