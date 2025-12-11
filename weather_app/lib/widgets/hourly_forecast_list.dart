import 'package:flutter/material.dart';
import '../models/forecast_model.dart';
import '../config/api_config.dart';
import '../utils/date_formatter.dart';

class HourlyForecastList extends StatelessWidget {
  final List<ForecastModel> forecasts;
  const HourlyForecastList({super.key, required this.forecasts});

  @override
  Widget build(BuildContext context) {
    final next24h = forecasts.take(8).toList(); // 8 x 3h = 24h
    if (next24h.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 160,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: next24h.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (_, i) {
          final f = next24h[i];
          return Container(
            width: 90,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.grey.withOpacity(.08),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(formatHour(f.dateTime), style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Image.network(ApiConfig.iconUrl(f.icon, x4: false), height: 44),
                const SizedBox(height: 8),
                Text('${f.temperature.round()}°'),
              ],
            ),
          );
        },
      ),
    );
  }
}
