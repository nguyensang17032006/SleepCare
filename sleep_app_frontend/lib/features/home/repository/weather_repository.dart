import '../data/models/weather_model.dart';
import '../data/services/location_service.dart';
import '../data/services/weather_api_service.dart';

class WeatherRepository {
  const WeatherRepository({
    required this.locationService,
    required this.weatherApiService,
  });

  final LocationService locationService;
  final WeatherApiService weatherApiService;

  Future<WeatherModel> getCurrentWeather() async {
    final location = await locationService.getCurrentLocation();
    final weather = await weatherApiService.fetchWeather(
      latitude: location.latitude,
      longitude: location.longitude,
    );

    return WeatherModel(
      city: location.label,
      temperatureC: weather.temperatureC,
      condition: weather.condition,
      humidity: weather.humidity,
      windSpeedKmh: weather.windSpeedKmh,
    );
  }
}
