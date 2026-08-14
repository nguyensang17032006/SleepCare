import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationCoordinates {
  const LocationCoordinates({
    required this.latitude,
    required this.longitude,
    required this.label,
  });

  final double latitude;
  final double longitude;
  final String label;
}

class LocationService {
  const LocationService();

  static const LocationCoordinates defaultCoordinates = LocationCoordinates(
    latitude: 21.0278,
    longitude: 105.8342,
    label: 'Hanoi',
  );

  static String _resolveLocationLabel(Placemark placemark) {
    final candidates = [
      placemark.locality,
      placemark.subAdministrativeArea,
      placemark.administrativeArea,
      placemark.country,
    ];

    for (final candidate in candidates) {
      if (candidate != null && candidate.trim().isNotEmpty) {
        return candidate;
      }
    }

    return 'Current Location';
  }

  Future<LocationCoordinates> getCurrentLocation() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        return defaultCoordinates;
      }

      var permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return defaultCoordinates;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      final geocoding = Geocoding();
      final placemarks = await geocoding.placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      final label = placemarks.isNotEmpty
          ? _resolveLocationLabel(placemarks.first)
          : defaultCoordinates.label;

      return LocationCoordinates(
        latitude: position.latitude,
        longitude: position.longitude,
        label: label,
      );
    } catch (_) {
      return defaultCoordinates;
    }
  }
}