import 'package:flutter/material.dart';
import '../services/weather_service.dart';
import '../services/location_service.dart';
import '../services/storage_service.dart';
import '../services/connectivity_service.dart';
import '../models/weather_model.dart';
import '../models/forecast_model.dart';

enum WeatherState { initial, loading, loaded, error }

class WeatherProvider extends ChangeNotifier {
  final WeatherService _ws;
  final LocationService _loc;
  final StorageService _store;
  final ConnectivityService _net;

  WeatherModel? _current;
  List<ForecastModel> _forecast = [];
  WeatherState _state = WeatherState.initial;
  String _error = '';
  bool _isOffline = false;
  String _units = 'metric';

  WeatherProvider(this._ws, this._loc, this._store, this._net);

  WeatherModel? get current => _current;
  List<ForecastModel> get forecast => _forecast;
  WeatherState get state => _state;
  String get error => _error;
  bool get isOffline => _isOffline;
  String get units => _units;

  void updateUnits(String u) {
    _units = u;
    notifyListeners();
    if (_current?.cityName.isNotEmpty == true) {
      fetchByCity(_current!.cityName);
    }
  }

  Future<void> fetchByCity(String city) async {
    _state = WeatherState.loading; notifyListeners();
    final online = await _net.hasConnection();
    _isOffline = !online;

    try {
      if (online) {
        _current = await _ws.getCurrentWeatherByCity(city, units: _units);
        _forecast = await _ws.getForecast(city, units: _units);
        await _store.saveWeatherData(_current!);
        _error = '';
        _state = WeatherState.loaded;
      } else {
        await _loadCacheOrError('No internet connection');
      }
    } catch (e) {
      _state = WeatherState.error; _error = e.toString();
    }
    notifyListeners();
  }

  Future<void> fetchByLocation() async {
    _state = WeatherState.loading; notifyListeners();
    final online = await _net.hasConnection();
    _isOffline = !online;

    try {
      if (online) {
        final pos = await _loc.getCurrentLocation();
        _current = await _ws.getCurrentWeatherByCoordinates(pos.latitude, pos.longitude, units: _units);
        final city = _current?.cityName ?? await _loc.getCityName(pos.latitude, pos.longitude);
        _forecast = await _ws.getForecast(city, units: _units);
        await _store.saveWeatherData(_current!);
        _error = '';
        _state = WeatherState.loaded;
      } else {
        await _loadCacheOrError('No internet connection');
      }
    } catch (e) {
      await _loadCacheOrError(e.toString());
    }
    notifyListeners();
  }

  Future<void> _loadCacheOrError(String msg) async {
    final cached = await _store.getCachedWeather();
    if (cached != null) {
      _current = cached;
      _forecast = [];
      _error = 'Showing cached data. $msg';
      _state = WeatherState.loaded;
    } else {
      _state = WeatherState.error; _error = msg;
    }
  }

  Future<void> refresh() async {
    if (_current?.cityName != null && _current!.cityName.isNotEmpty) {
      await fetchByCity(_current!.cityName);
    } else {
      await fetchByLocation();
    }
  }
}
