import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Match the existing Philippine service bounds. These constrain the camera,
/// not Google's geographic content: neighboring coastlines can remain visible
/// at the edge. Keep enough zoom range to fit the full 50 km discovery circle.
abstract final class PhilippineMapView {
  static final cameraBounds = CameraTargetBounds(
    LatLngBounds(
      southwest: const LatLng(4, 116),
      northeast: const LatLng(21.5, 127),
    ),
  );

  static const zoomRange = MinMaxZoomPreference(7, 21);
}
