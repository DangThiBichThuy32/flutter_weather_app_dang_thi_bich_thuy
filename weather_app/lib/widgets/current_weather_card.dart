import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/weather_model.dart';
import '../config/api_config.dart';

class CurrentWeatherCard extends StatelessWidget {
  final WeatherModel weather;
  const CurrentWeatherCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: _gradient(weather.mainCondition),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('${weather.cityName}, ${weather.country}',
              style: const TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(DateFormat('EEEE, MMM d').format(weather.dateTime),
              style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 12),
          CachedNetworkImage(imageUrl: ApiConfig.iconUrl(weather.icon), height: 110),
          Text('${weather.temperature.round()}°',
              style: const TextStyle(fontSize: 72, color: Colors.white, fontWeight: FontWeight.bold)),
          Text(weather.description.toUpperCase(),
              style: const TextStyle(fontSize: 16, color: Colors.white)),
          Text('Feels like ${weather.feelsLike.round()}°',
              style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  LinearGradient _gradient(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return const LinearGradient(
          colors: [Color(0xFF4A90E2), Color(0xFF87CEEB)],
          begin: Alignment.topCenter, end: Alignment.bottomCenter);
      case 'rain':
        return const LinearGradient(
          colors: [Color(0xFF4A5568), Color(0xFF718096)],
          begin: Alignment.topCenter, end: Alignment.bottomCenter);
      case 'clouds':
        return const LinearGradient(
          colors: [Color(0xFFA0AEC0), Color(0xFFCBD5E0)],
          begin: Alignment.topCenter, end: Alignment.bottomCenter);
      default:
        return const LinearGradient(
          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
          begin: Alignment.topCenter, end: Alignment.bottomCenter);
    }
  }
}
