import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/models/weather_model.dart';

void main() {
  group('WeatherModel JSON parsing', () {
    test('Parse weather JSON correctly', () {
      final json = {
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

      final weather = WeatherModel.fromJson(json);

      expect(weather.cityName, 'Ho Chi Minh City');
      expect(weather.country, 'VN');
      expect(weather.temperature, 25.0);
      expect(weather.feelsLike, 27.0);
      expect(weather.humidity, 80);
      expect(weather.windSpeed, 3.5);
      expect(weather.pressure, 1005);
      expect(weather.tempMin, 24.0);
      expect(weather.tempMax, 30.0);
      expect(weather.description, 'clear sky');
      expect(weather.icon, '01d');
      expect(weather.mainCondition, 'Clear');
      expect(weather.visibility, 10000);
      expect(weather.cloudiness, 0);
      // dt 1700000000 chỉ check là DateTime, không cần so chính xác
      expect(weather.dateTime, isA<DateTime>());
    });
  });
}
