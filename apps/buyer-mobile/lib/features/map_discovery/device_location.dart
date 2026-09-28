import 'package:geolocator/geolocator.dart';

import 'discovery_models.dart';

enum DeviceLocationStatus {
  granted,
  denied,
  deniedForever,
  serviceDisabled,
  unavailable,
}

class DeviceLocationResult {
  const DeviceLocationResult(this.status, [this.point]);
  final DeviceLocationStatus status;
  final GeoPoint? point;
}

/// Optional, foreground-only device location. The app asks only after the Buyer chooses
/// "Use current location"; denial never blocks manual address entry or pin placement, and the
/// returned point is kept in memory only unless the Buyer explicitly saves a location.
abstract interface class DeviceLocationService {
  Future<DeviceLocationResult> requestCurrent();

  Future<bool> openSettings();
}

final class GeolocatorDeviceLocationService implements DeviceLocationService {
  const GeolocatorDeviceLocationService();

  @override
  Future<DeviceLocationResult> requestCurrent() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        return const DeviceLocationResult(DeviceLocationStatus.serviceDisabled);
      }
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever) {
        return const DeviceLocationResult(DeviceLocationStatus.deniedForever);
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.unableToDetermine) {
        return const DeviceLocationResult(DeviceLocationStatus.denied);
      }
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 12),
        ),
      );
      return DeviceLocationResult(
        DeviceLocationStatus.granted,
        GeoPoint(position.latitude, position.longitude),
      );
    } catch (_) {
      return const DeviceLocationResult(DeviceLocationStatus.unavailable);
    }
  }

  @override
  Future<bool> openSettings() => Geolocator.openAppSettings();
}
