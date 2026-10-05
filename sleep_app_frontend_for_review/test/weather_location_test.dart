import 'package:flutter_test/flutter_test.dart';
import 'package:sleep_app_frontend/features/home/data/services/location_service.dart';

void main() {
  group('LocationCoordinates', () {
    test('stores latitude, longitude and location label correctly', () {
      const location = LocationCoordinates(
        latitude: 10.7769,
        longitude: 106.7009,
        label: 'Ho Chi Minh City',
      );

      expect(location.latitude, closeTo(10.7769, 0.0001));
      expect(location.longitude, closeTo(106.7009, 0.0001));
      expect(location.label, 'Ho Chi Minh City');
    });
  });
}