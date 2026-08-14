class WeatherModel {
  const WeatherModel({
    required this.city,
    required this.temperatureC,
    required this.condition,
    required this.humidity,
    required this.windSpeedKmh,
  });

  final String city;
  final double temperatureC;
  final String condition;
  final int humidity;
  final double windSpeedKmh;

  factory WeatherModel.fromOpenMeteoJson(Map<String, dynamic> json) {
    final current = json['current'] as Map<String, dynamic>? ?? <String, dynamic>{};

    return WeatherModel(
      city: (json['timezone'] as String?)?.split('/').last.replaceAll('_', ' ') ??
          'Current Location',
      temperatureC: (current['temperature_2m'] as num?)?.toDouble() ?? 0,
      condition: _weatherCodeToText((current['weather_code'] as num?)?.toInt()),
      humidity: (current['relative_humidity_2m'] as num?)?.toInt() ?? 0,
      windSpeedKmh: (current['wind_speed_10m'] as num?)?.toDouble() ?? 0,
    );
  }

  static String _weatherCodeToText(int? code) {
    if (code == null) {
      return 'Unknown';
    }

    if (code == 0) {
      return 'Clear Sky';
    }

    if (code >= 1 && code <= 3) {
      return 'Partly Cloudy';
    }

    if (code >= 45 && code <= 48) {
      return 'Fog';
    }

    if (code >= 51 && code <= 67) {
      return 'Rain';
    }

    if (code >= 71 && code <= 77) {
      return 'Snow';
    }

    if (code >= 80 && code <= 82) {
      return 'Rain Showers';
    }

    if (code >= 95) {
      return 'Thunderstorm';
    }

    return 'Cloudy';
  }
}
