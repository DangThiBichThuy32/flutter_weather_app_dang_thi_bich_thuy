import 'dart:convert';
import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/weather_model.dart';
import '../models/forecast_model.dart';

class WeatherService {
  final String apiKey;
  final http.Client client;

  WeatherService({
    required this.apiKey,
    http.Client? client,
  }) : client = client ?? http.Client();

  Future<WeatherModel> getCurrentWeatherByCity(
    String city, {
    String units = 'metric',
  }) async {
    final url = ApiConfig.buildUrl(
      '/weather',
      {'q': city, 'units': units},
      apiKey: apiKey,
    );
    final r = await client.get(Uri.parse(url));
    return _parseCurrent(r);
  }

  Future<WeatherModel> getCurrentWeatherByCoordinates(
    double lat,
    double lon, {
    String units = 'metric',
  }) async {
    final url = ApiConfig.buildUrl(
      '/weather',
      {'lat': '$lat', 'lon': '$lon', 'units': units},
      apiKey: apiKey,
    );
    final r = await client.get(Uri.parse(url));
    return _parseCurrent(r);
  }

  Future<List<ForecastModel>> getForecast(
    String city, {
    String units = 'metric',
  }) async {
    final url = ApiConfig.buildUrl(
      '/forecast',
      {'q': city, 'units': units},
      apiKey: apiKey,
    );
    final r = await client.get(Uri.parse(url));
    if (r.statusCode == 200) {
      final list = (json.decode(r.body)['list'] as List);
      return list.map((e) => ForecastModel.fromJson(e)).toList();
    }
    _throwHttp(r);
  }

  WeatherModel _parseCurrent(http.Response r) {
    if (r.statusCode == 200) {
      return WeatherModel.fromJson(json.decode(r.body));
    }
    _throwHttp(r);
  }

  Never _throwHttp(http.Response r) {
    switch (r.statusCode) {
      case 401:
        throw Exception('Invalid API key');
      case 404:
        throw Exception('City not found');
      case 429:
        throw Exception('Rate limit exceeded, please try later');
      default:
        throw Exception('Failed: HTTP ${r.statusCode}');
    }
  }
}
