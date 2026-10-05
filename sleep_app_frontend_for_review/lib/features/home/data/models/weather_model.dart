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

  factory WeatherModel.fromOpenMeteoJson(
    Map<String, dynamic> json,
  ) {
    final current =
        json['current'] as Map<String, dynamic>? ??
            <String, dynamic>{};

    return WeatherModel(
      // API service không chịu trách nhiệm xác định thành phố.
      // Repository sẽ thay bằng location.label.
      city: '',
      temperatureC:
          (current['temperature_2m'] as num?)
                  ?.toDouble() ??
              0,
      condition: _weatherCodeToText(
        (current['weather_code'] as num?)?.toInt(),
      ),
      humidity:
          (current['relative_humidity_2m'] as num?)
                  ?.toInt() ??
              0,
      windSpeedKmh:
          (current['wind_speed_10m'] as num?)
                  ?.toDouble() ??
              0,
    );
  }

  static String _weatherCodeToText(int? code) {
    if (code == null) {
      return 'Không xác định';
    }

    if (code == 0) {
      return 'Trời quang';
    }

    if (code >= 1 && code <= 3) {
      return 'Có mây';
    }

    if (code >= 45 && code <= 48) {
      return 'Sương mù';
    }

    if (code >= 51 && code <= 57) {
      return 'Mưa phùn';
    }

    if (code >= 61 && code <= 67) {
      return 'Mưa';
    }

    if (code >= 71 && code <= 77) {
      return 'Tuyết';
    }

    if (code >= 80 && code <= 82) {
      return 'Mưa rào';
    }

    if (code >= 85 && code <= 86) {
      return 'Mưa tuyết';
    }

    if (code >= 95) {
      return 'Giông bão';
    }

    return 'Nhiều mây';
  }
}