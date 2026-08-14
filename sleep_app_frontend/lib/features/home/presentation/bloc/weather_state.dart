import '../../data/models/weather_model.dart';

sealed class WeatherState {
  const WeatherState();
}

class WeatherInitial extends WeatherState {
  const WeatherInitial();
}

class WeatherLoading extends WeatherState {
  const WeatherLoading();
}

class WeatherLoaded extends WeatherState {
  const WeatherLoaded(this.weather);

  final WeatherModel weather;
}

class WeatherError extends WeatherState {
  const WeatherError(this.message);

  final String message;
}
