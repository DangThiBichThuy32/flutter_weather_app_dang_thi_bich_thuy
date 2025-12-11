import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/weather_model.dart';

class StorageService {
  static const String _weatherKey = 'cached_weather';
  static const String _lastUpdateKey = 'last_update';
  static const String _favoritesKey = 'favorite_cities';

  Future<void> saveWeatherData(WeatherModel weather) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_weatherKey, json.encode(weather.toJson()));
    await p.setInt(_lastUpdateKey, DateTime.now().millisecondsSinceEpoch);
  }

  Future<WeatherModel?> getCachedWeather() async {
    final p = await SharedPreferences.getInstance();
    final s = p.getString(_weatherKey);
    if (s != null) return WeatherModel.fromJson(json.decode(s));
    return null;
  }

  Future<bool> isCacheValid({Duration ttl = const Duration(minutes: 30)}) async {
    final p = await SharedPreferences.getInstance();
    final t = p.getInt(_lastUpdateKey);
    if (t == null) return false;
    final diff = DateTime.now().millisecondsSinceEpoch - t;
    return diff < ttl.inMilliseconds;
  }

  Future<void> saveFavoriteCities(List<String> cities) async {
    final p = await SharedPreferences.getInstance();
    await p.setStringList(_favoritesKey, cities);
  }

  Future<List<String>> getFavoriteCities() async {
    final p = await SharedPreferences.getInstance();
    return p.getStringList(_favoritesKey) ?? [];
  }
}
