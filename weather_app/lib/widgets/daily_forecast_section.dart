import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/forecast_model.dart';
import '../config/api_config.dart';

class DailyForecastSection extends StatelessWidget {
  final List<ForecastModel> forecasts;
  const DailyForecastSection({super.key, required this.forecasts});

  @override
  Widget build(BuildContext context) {
    if (forecasts.isEmpty) return const SizedBox.shrink();

    final byDay = <String, List<ForecastModel>>{};
    for (final f in forecasts) {
      final key = DateFormat('yyyy-MM-dd').format(f.dateTime);
      (byDay[key] ??= []).add(f);
    }

    final items = byDay.entries.take(5).toList();

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 16, 8, 0),
      child: Column(
        children: items.map((e) {
          final day = e.value;
          final minT = day.map((f) => f.tempMin).reduce((a, b) => a < b ? a : b).round();
          final maxT = day.map((f) => f.tempMax).reduce((a, b) => a > b ? a : b).round();
          final icon = day[day.length ~/ 2].icon;
          final desc = day[day.length ~/ 2].description;

          return ListTile(
            leading: Image.network(ApiConfig.iconUrl(icon, x4: false), height: 36),
            title: Text(DateFormat('EEE, MMM d').format(day.first.dateTime)),
            subtitle: Text(desc),
            trailing: Text('$maxT° / $minT°'),
          );
        }).toList(),
      ),
    );
  }
}
