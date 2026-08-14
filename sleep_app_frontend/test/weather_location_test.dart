import 'package:flutter_test/flutter_test.dart';
import 'package:sleep_app_frontend/features/home/data/services/location_service.dart';

void main() {
  test('uses a safe fallback location when GPS is unavailable', () {
    final fallback = LocationService.defaultCoordinates;

    expect(fallback.latitude, closeTo(21.0278, 0.0001));
    expect(fallback.longitude, closeTo(105.8342, 0.0001));
    expect(fallback.label, 'Hanoi');
  });
}
