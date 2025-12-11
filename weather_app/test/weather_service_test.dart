import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import 'package:weather_app/services/weather_service.dart';
import 'package:weather_app/models/weather_model.dart';

class FakeClient implements http.Client {
  final Future<http.Response> Function(Uri url) onGet;

  FakeClient(this.onGet);

  @override
  Future<http.Response> get(Uri url, {Map<String, String>? headers}) {
    return onGet(url);
  }

  @override
  void close() {}

  @override
  Future<http.Response> head(Uri url, {Map<String, String>? headers}) {
    throw UnimplementedError();
  }

  @override
  Future<http.Response> post(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    throw UnimplementedError();
  }

  @override
  Future<http.Response> put(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    throw UnimplementedError();
  }

  @override
  Future<http.Response> patch(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    throw UnimplementedError();
  }

  @override
  Future<http.Response> delete(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    throw UnimplementedError();
  }

  @override
  Future<String> read(Uri url, {Map<String, String>? headers}) {
    throw UnimplementedError();
  }

  @override
  Future<Uint8List> readBytes(Uri url, {Map<String, String>? headers}) {
    throw UnimplementedError();
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    throw UnimplementedError();
  }
}

void main() {
  const fakeApiKey = 'FAKE_KEY';

  group('WeatherService getCurrentWeatherByCity', () {
    test('returns WeatherModel when API returns 200', () async {
      const cityName = 'Ho Chi Minh City';

      final sampleJson = {
        "name": "Ho Chi Minh City",
        "sys": {"country": "VN"},
        "main": {
          "temp": 25.0,
          "feels_like": 27.0,
          "humidity": 80,
          "pressure": 1005,
          "temp_min": 24.0,
          "temp_max": 30.0
        },
        "wind": {"speed": 3.5},
        "weather": [
          {
            "description": "clear sky",
            "icon": "01d",
            "main": "Clear",
          }
        ],
        "dt": 1700000000,
        "visibility": 10000,
        "clouds": {"all": 0},
      };

      final client = FakeClient(
        (url) async => http.Response(jsonEncode(sampleJson), 200),
      );

      final weatherService = WeatherService(apiKey: fakeApiKey, client: client);

      final result = await weatherService.getCurrentWeatherByCity(cityName);

      expect(result, isA<WeatherModel>());
      expect(result.cityName, 'Ho Chi Minh City');
    });

    test('throws "City not found" when statusCode is 404', () async {
      const cityName = 'InvalidCity';

      final client = FakeClient(
        (url) async =>
            http.Response('{"cod": "404", "message": "city not found"}', 404),
      );

      final weatherService = WeatherService(apiKey: fakeApiKey, client: client);

      expect(
        () => weatherService.getCurrentWeatherByCity(cityName),
        throwsA(
          predicate(
            (e) =>
                e is Exception && e.toString().contains('City not found'),
          ),
        ),
      );
    });

    test('throws "Invalid API key" when statusCode is 401', () async {
      const cityName = 'London';

      final client = FakeClient(
        (url) async =>
            http.Response('{"cod": 401, "message": "Invalid API key"}', 401),
      );

      final weatherService = WeatherService(apiKey: fakeApiKey, client: client);

      expect(
        () => weatherService.getCurrentWeatherByCity(cityName),
        throwsA(
          predicate(
            (e) =>
                e is Exception && e.toString().contains('Invalid API key'),
          ),
        ),
      );
    });

    test('throws "Rate limit exceeded, please try later" when 429', () async {
      const cityName = 'London';

      final client = FakeClient(
        (url) async =>
            http.Response('{"cod": 429, "message": "limit exceeded"}', 429),
      );

      final weatherService = WeatherService(apiKey: fakeApiKey, client: client);

      expect(
        () => weatherService.getCurrentWeatherByCity(cityName),
        throwsA(
          predicate(
            (e) =>
                e is Exception &&
                e
                    .toString()
                    .contains('Rate limit exceeded, please try later'),
          ),
        ),
      );
    });

    test('throws Exception when client throws', () async {
      const cityName = 'London';

      final client = FakeClient(
        (url) async => throw Exception('Network error'),
      );

      final weatherService = WeatherService(apiKey: fakeApiKey, client: client);

      expect(
        () => weatherService.getCurrentWeatherByCity(cityName),
        throwsA(isA<Exception>()),
      );
    });
  });
}
