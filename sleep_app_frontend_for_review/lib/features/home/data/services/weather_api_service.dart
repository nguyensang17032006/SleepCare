import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/weather_model.dart';

class WeatherApiService {
  const WeatherApiService();

  Future<WeatherModel> fetchWeather({
    required double latitude,
    required double longitude,
  }) async {
    final uri = Uri.https(
      'api.open-meteo.com',
      '/v1/forecast',
      {
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'current':
            'temperature_2m,relative_humidity_2m,weather_code,wind_speed_10m',
        'timezone': 'auto',
      },
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception(
        'Không thể lấy dữ liệu thời tiết (${response.statusCode}).',
      );
    }

    final decoded =
        jsonDecode(response.body) as Map<String, dynamic>;

    return WeatherModel.fromOpenMeteoJson(decoded);
  }
}