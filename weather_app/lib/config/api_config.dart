class ApiConfig {
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';
  static const String iconBase = 'https://openweathermap.org/img/wn/';

  static String buildUrl(String endpoint, Map<String, dynamic> params, {required String apiKey}) {
    final uri = Uri.parse('$baseUrl$endpoint');
    final merged = {
      ...params,
      'appid': apiKey,
      if (!params.containsKey('units')) 'units': 'metric',
    };
    return uri.replace(queryParameters: merged).toString();
  }

  static String iconUrl(String code, {bool x4 = true}) =>
      '$iconBase$code@${x4 ? "4x" : "2x"}.png';
}
