import 'dart:math' as math;
import 'dart:ui';

import 'discovery_models.dart';

/// Decodes a Google encoded polyline (precision 5) returned by the Routes API.
List<GeoPoint> decodePolyline(String encoded) {
  final points = <GeoPoint>[];
  var index = 0;
  var latitude = 0;
  var longitude = 0;
  while (index < encoded.length) {
    for (var axis = 0; axis < 2; axis++) {
      var shift = 0;
      var result = 0;
      int byte;
      do {
        if (index >= encoded.length) return points;
        byte = encoded.codeUnitAt(index++) - 63;
        result |= (byte & 0x1f) << shift;
        shift += 5;
      } while (byte >= 0x20);
      final delta = (result & 1) != 0 ? ~(result >> 1) : result >> 1;
      if (axis == 0) {
        latitude += delta;
      } else {
        longitude += delta;
      }
    }
    points.add(GeoPoint(latitude / 1e5, longitude / 1e5));
  }
  return points;
}

/// Web Mercator world coordinates in logical pixels for a zoom level.
Offset projectToWorld(GeoPoint point, double zoom) {
  final scale = 256 * math.pow(2, zoom).toDouble();
  final sinLatitude = math
      .sin(point.latitude * math.pi / 180)
      .clamp(-0.9999, 0.9999);
  final x = (point.longitude + 180) / 360 * scale;
  final y =
      (0.5 - math.log((1 + sinLatitude) / (1 - sinLatitude)) / (4 * math.pi)) *
      scale;
  return Offset(x, y);
}

/// One marker or one cluster on the map.
class MapGroup {
  MapGroup(this.members);

  final List<SupplierResultView> members;

  bool get isCluster => members.length > 1;

  SupplierResultView get single => members.single;

  int get verifiedCount => members.where((item) => item.isVerified).length;

  int get directoryCount => members.length - verifiedCount;

  int get favoriteCount => members.where((item) => item.isFavorite).length;

  GeoPoint get center => GeoPoint(
    members.map((item) => item.point.latitude).reduce((a, b) => a + b) /
        members.length,
    members.map((item) => item.point.longitude).reduce((a, b) => a + b) /
        members.length,
  );

  String get id => isCluster
      ? 'cluster:${members.map((item) => item.resultId).join(',').hashCode}'
      : 'supplier:${single.resultId}';

  /// Accessible description that states the total and tier composition.
  String get semanticsLabel {
    if (!isCluster) {
      final item = single;
      return '${item.name}, ${item.isVerified ? 'Verified Vendor' : 'Directory Supplier'}, ${item.scoreText}${item.isFavorite ? ', Favorite Supplier' : ''}';
    }
    final parts = [
      if (verifiedCount > 0)
        '$verifiedCount Verified Vendor${verifiedCount == 1 ? '' : 's'}',
      if (directoryCount > 0)
        '$directoryCount Directory Supplier${directoryCount == 1 ? '' : 's'}',
    ];
    return '${members.length} suppliers in this area: ${parts.join(' and ')}. Zoom in to separate them.';
  }
}

/// Suppliers drawn on the map. A selection isolates its supplier: every other marker is hidden
/// until the selection is cleared. A stale selection that is no longer in the results shows all.
/// The synchronized list is unaffected and keeps every supplier.
List<SupplierResultView> mapVisibleSuppliers(
  List<SupplierResultView> items,
  String? selectedId,
) {
  if (selectedId == null) return items;
  final selected = items.where((item) => item.resultId == selectedId).toList();
  return selected.isEmpty ? items : selected;
}

/// Clustering cell size by zoom: strong clustering below 11, adaptive between 11 and 13.9 and
/// individual markers from 14. The selected supplier is never hidden inside a cluster.
double clusterCellSize(double zoom) {
  if (zoom >= 14) return 0;
  if (zoom >= 11) return 44 + (14 - zoom) * 12;
  return 88;
}

/// Grid clustering in world pixel space. Deterministic: groups keep result order (rank).
List<MapGroup> clusterSuppliers(
  List<SupplierResultView> items,
  double zoom, {
  String? selectedId,
}) {
  final cell = clusterCellSize(zoom);
  final groups = <String, List<SupplierResultView>>{};
  final order = <String>[];
  for (final item in items) {
    final String key;
    if (cell == 0 || item.resultId == selectedId) {
      key = 'single:${item.resultId}';
    } else {
      final world = projectToWorld(item.point, zoom);
      key = '${(world.dx / cell).floor()}:${(world.dy / cell).floor()}';
    }
    if (!groups.containsKey(key)) order.add(key);
    groups.putIfAbsent(key, () => []).add(item);
  }
  return [for (final key in order) MapGroup(groups[key]!)];
}

/// Estimated rendered size of a store-name label; the renderer uses the same metrics.
Size estimateLabelSize(String text, {double textScale = 1}) {
  final characters = math.min(text.length, 28);
  return Size((characters * 7.2 + 28) * textScale, 30 * textScale);
}

/// Collision-safe individual labels. Placement priority is the selected supplier, then result
/// rank (the server order); a label that would overlap an already placed one is omitted while
/// the marker itself stays visible and the supplier stays in the synchronized list. This is a
/// rendering rule only and never changes ranking.
Set<String> placeLabels(
  List<MapGroup> groups,
  double zoom, {
  String? selectedId,
  double textScale = 1,
}) {
  final singles = groups.where((group) => !group.isCluster).toList()
    ..sort((a, b) {
      if (a.single.resultId == selectedId) return -1;
      if (b.single.resultId == selectedId) return 1;
      return a.single.rank.compareTo(b.single.rank);
    });
  final placed = <Rect>[];
  final labeled = <String>{};
  for (final group in singles) {
    final item = group.single;
    final anchor = projectToWorld(item.point, zoom);
    final size = estimateLabelSize(item.markerLabel, textScale: textScale);
    final rect = Rect.fromCenter(
      center: anchor.translate(0, -44 * textScale),
      width: size.width,
      height: size.height,
    ).inflate(2);
    if (item.resultId != selectedId &&
        placed.any((other) => other.overlaps(rect))) {
      continue;
    }
    placed.add(rect);
    labeled.add(item.resultId);
  }
  return labeled;
}

/// Human distance, e.g. 950 m or 1.2 km.
String formatDistance(int meters) => meters < 1000
    ? '$meters m'
    : '${(meters / 1000).toStringAsFixed(meters < 10000 ? 1 : 0)} km';

/// Human duration, e.g. 9 min or 1 h 5 min.
String formatDuration(int seconds) {
  final minutes = (seconds / 60).ceil();
  if (minutes < 60) return '$minutes min';
  return '${minutes ~/ 60} h ${minutes % 60} min';
}
