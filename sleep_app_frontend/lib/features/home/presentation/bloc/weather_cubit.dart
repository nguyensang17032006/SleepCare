import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/services/location_service.dart';
import '../../data/services/weather_api_service.dart';
import '../../repository/weather_repository.dart';
import 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  WeatherCubit({WeatherRepository? repository})
    : _repository =
          repository ??
          const WeatherRepository(
            locationService: LocationService(),
            weatherApiService: WeatherApiService(),
          ),
      super(const WeatherInitial());

  final WeatherRepository _repository;

  Future<void> loadWeather() async {
    emit(const WeatherLoading());

    try {
      final weather = await _repository.getCurrentWeather();
      emit(WeatherLoaded(weather));
    } catch (_) {
      emit(const WeatherError('Unable to load weather right now.'));
    }
  }
}
