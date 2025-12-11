import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  Future<bool> _ensurePermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return false;
    }
    if (permission == LocationPermission.deniedForever) return false;
    return true;
  }

  Future<Position> getCurrentLocation() async {
    final ok = await _ensurePermission();
    if (!ok) {
      throw Exception('Location permission denied');
    }
    return Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  Future<String> getCityName(double lat, double lon) async {
    final list = await placemarkFromCoordinates(lat, lon);
    if (list.isNotEmpty) {
      return list.first.locality ?? list.first.administrativeArea ?? 'Unknown';
    }
    return 'Unknown';
  }
}
