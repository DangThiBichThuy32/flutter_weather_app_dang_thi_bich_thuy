import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  String _units = 'metric'; // metric | imperial
  bool _is24h = true;

  String get units => _units;
  bool get is24h => _is24h;

  Future<void> load() async {
    final p = await SharedPreferences.getInstance();
    _units = p.getString('units') ?? 'metric';
    _is24h = p.getBool('is24h') ?? true;
    notifyListeners();
  }

  Future<void> toggleUnits() async {
    _units = _units == 'metric' ? 'imperial' : 'metric';
    final p = await SharedPreferences.getInstance();
    await p.setString('units', _units);
    notifyListeners();
  }

  Future<void> toggleClock() async {
    _is24h = !_is24h;
    final p = await SharedPreferences.getInstance();
    await p.setBool('is24h', _is24h);
    notifyListeners();
  }
}
