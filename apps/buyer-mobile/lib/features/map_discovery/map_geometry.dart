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

  late final int verifiedCount = members
      .where((item) => item.isVerified)
      .length;

  int get directoryCount => members.length - verifiedCount;

  late final int favoriteCount = members
      .where((item) => item.isFavorite)
      .length;

  late final GeoPoint center = GeoPoint(
    members.map((item) => item.point.latitude).reduce((a, b) => a + b) /
        members.length,
    members.map((item) => item.point.longitude).reduce((a, b) => a + b) /
        members.length,
  );

  late final String id = _id();

  String _id() {
    if (!isCluster) return 'supplier:${single.resultId}';
    final ids = members.map((item) => item.resultId).toList()..sort();
    var hash = 0;
    for (final code in ids.join('|').codeUnits) {
      hash = (hash * 31 + code) & 0xffffffff;
    }
    return 'cluster:${ids.length}:${hash.toRadixString(16)}';
  }

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

/// Only native map rendering is culled; the synchronized list keeps the full result set.
/// Extra screen space keeps pins, labels and nearby cluster members ready while panning.
class SupplierMapViewport {
  const SupplierMapViewport({required this.southwest, required this.northeast});

  final GeoPoint southwest;
  final GeoPoint northeast;

  List<SupplierResultView> suppliers(
    List<SupplierResultView> items,
    double zoom, {
    String? selectedId,
    double padding = 192,
  }) {
    final bounds = Rect.fromPoints(
      projectToWorld(southwest, zoom),
      projectToWorld(northeast, zoom),
    ).inflate(padding);
    return items.where((item) {
      if (item.resultId == selectedId) return true;
      final point = projectToWorld(item.point, zoom);
      return point.dx >= bounds.left &&
          point.dx <= bounds.right &&
          point.dy >= bounds.top &&
          point.dy <= bounds.bottom;
    }).toList();
  }
}

/// A refreshed API model can change list details without changing any marker or label.
bool sameSupplierMarkers(
  List<SupplierResultView> previous,
  List<SupplierResultView> next,
) {
  if (identical(previous, next)) return true;
  if (previous.length != next.length) return false;
  for (var index = 0; index < previous.length; index++) {
    final a = previous[index], b = next[index];
    if (a.resultId != b.resultId ||
        a.tier != b.tier ||
        a.point != b.point ||
        a.rank != b.rank ||
        a.markerLabel != b.markerLabel ||
        a.isFavorite != b.isFavorite) {
      return false;
    }
  }
  return true;
}

/// Logical screen-pixel radius: 64 below 11, 36 at 13, individual pins from 13.5.
/// Owner tuning 2026-10-24; device/performance validation remains required.
double clusterCellSize(double zoom) {
  if (zoom >= 13.5) return 0;
  if (zoom <= 11) return 64;
  return 64 - (zoom.clamp(11, 13) - 11) * 14;
}

/// Greedy distance clustering across cell boundaries; server rank remains the list order.
List<MapGroup> clusterSuppliers(
  List<SupplierResultView> items,
  double zoom, {
  String? selectedId,
}) {
  final radius = clusterCellSize(zoom);
  if (radius == 0) {
    return [
      for (final item in items) MapGroup([item]),
    ];
  }
  final groups = <List<SupplierResultView>>[];
  final anchors = <Offset>[];
  final cells = <(int, int), List<int>>{};
  for (final item in items) {
    final point = projectToWorld(item.point, zoom);
    final x = (point.dx / radius).floor(), y = (point.dy / radius).floor();
    var target = -1;
    if (item.resultId != selectedId) {
      for (var dx = -1; dx <= 1; dx++) {
        for (var dy = -1; dy <= 1; dy++) {
          for (final index in cells[(x + dx, y + dy)] ?? const <int>[]) {
            // Preserve the original greedy choice: the earliest matching anchor.
            if ((target < 0 || index < target) &&
                (anchors[index] - point).distanceSquared <= radius * radius) {
              target = index;
            }
          }
        }
      }
    }
    if (target < 0) {
      if (item.resultId != selectedId) {
        (cells[(x, y)] ??= []).add(groups.length);
      }
      groups.add([item]);
      anchors.add(point);
    } else {
      groups[target].add(item);
    }
  }
  return groups.map(MapGroup.new).toList();
}

GeoPoint unprojectFromWorld(Offset point, double zoom) {
  final scale = 256 * math.pow(2, zoom);
  return GeoPoint(
    (2 * math.atan(math.exp(math.pi * (1 - 2 * point.dy / scale))) -
            math.pi / 2) *
        180 /
        math.pi,
    point.dx / scale * 360 - 180,
  );
}

double pointDistanceMeters(GeoPoint a, GeoPoint b) {
  final lat = (b.latitude - a.latitude) * math.pi / 180;
  final lng = (b.longitude - a.longitude) * math.pi / 180;
  final h =
      math.pow(math.sin(lat / 2), 2) +
      math.cos(a.latitude * math.pi / 180) *
          math.cos(b.latitude * math.pi / 180) *
          math.pow(math.sin(lng / 2), 2);
  return 6371000 * 2 * math.asin(math.sqrt(h.clamp(0, 1)));
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
  const cellSize = 128.0;
  final cells = <(int, int), List<Rect>>{};
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
    final left = (rect.left / cellSize).floor();
    final right = (rect.right / cellSize).floor();
    final top = (rect.top / cellSize).floor();
    final bottom = (rect.bottom / cellSize).floor();
    final keys = [
      for (var x = left; x <= right; x++)
        for (var y = top; y <= bottom; y++) (x, y),
    ];
    if (item.resultId != selectedId &&
        keys.any(
          (key) => cells[key]?.any((other) => other.overlaps(rect)) ?? false,
        )) {
      continue;
    }
    for (final key in keys) {
      (cells[key] ??= []).add(rect);
    }
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
