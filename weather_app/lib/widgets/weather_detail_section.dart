import 'package:flutter/material.dart';
import '../models/weather_model.dart';

class WeatherDetailSection extends StatelessWidget {
  final WeatherModel weather;
  final String units; // metric | imperial
  const WeatherDetailSection({super.key, required this.weather, required this.units});

  @override
  Widget build(BuildContext context) {
    String wind(double mps) {
      if (units == 'imperial') {
        final mph = mps * 2.23694;
        return '${mph.toStringAsFixed(1)} mph';
      }
      return '${mps.toStringAsFixed(1)} m/s';
    }

    Widget item(String label, String value, IconData icon) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 1.5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            runSpacing: 16,
            children: [
              item('Humidity', '${weather.humidity}%', Icons.water_drop),
              item('Wind', wind(weather.windSpeed), Icons.air),
              item('Pressure', '${weather.pressure} hPa', Icons.speed),
              if (weather.visibility != null)
                item('Visibility', '${(weather.visibility! / 1000).toStringAsFixed(1)} km', Icons.remove_red_eye),
              if (weather.cloudiness != null)
                item('Clouds', '${weather.cloudiness}%', Icons.cloud),
            ],
          ),
        ),
      ),
    );
  }
}
