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

  static String _resolveLocationLabel(Placemark placemark) {
    final candidates = [
      placemark.locality,
      placemark.subAdministrativeArea,
      placemark.administrativeArea,
    ];

    for (final candidate in candidates) {
      if (candidate != null && candidate.trim().isNotEmpty) {
        return candidate.trim();
      }
    }

    return 'Vị trí hiện tại';
  }

  Future<LocationCoordinates> getCurrentLocation() async {
    final serviceEnabled =
        await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      throw Exception('Dịch vụ vị trí đang bị tắt.');
    }

    var permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw Exception('Quyền truy cập vị trí đã bị từ chối.');
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'Quyền truy cập vị trí đã bị từ chối vĩnh viễn.',
      );
    }

    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.medium,
      ),
    );

    String label = 'Vị trí hiện tại';

    try {
      final geocoding = Geocoding();

      final placemarks =
          await geocoding.placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        label = _resolveLocationLabel(placemarks.first);
      }
    } catch (_) {
      // Lấy được GPS nhưng reverse geocoding lỗi
      // thì vẫn dùng dữ liệu thời tiết bình thường.
    }

    return LocationCoordinates(
      latitude: position.latitude,
      longitude: position.longitude,
      label: label,
    );
  }
}