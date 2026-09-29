import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../design_system/generated/color_tokens.dart';
import '../../design_system/motion.dart';
import 'discovery_models.dart';
import 'map_geometry.dart';
import 'philippine_map_view.dart';

/// Basemap chosen from the map layers control. Satellite imagery keeps road and place labels.
enum BaseMapStyle { standard, satellite }

/// Everything a map surface needs; the same [items] and order as the synchronized list.
class SupplierMapProps {
  const SupplierMapProps({
    required this.items,
    required this.origin,
    required this.radiusKm,
    required this.selectedId,
    required this.routePath,
    required this.onSelect,
    required this.bottomInset,
    required this.recenterToken,
    this.baseMap = BaseMapStyle.standard,
  });

  final List<SupplierResultView> items;
  final GeoPoint? origin;
  final int radiusKm;
  final String? selectedId;
  final List<GeoPoint>? routePath;
  final ValueChanged<String> onSelect;

  /// Space covered by the preview sheet so the camera keeps marker and route visible.
  final double bottomInset;

  /// Incremented when the Buyer taps Recenter.
  final int recenterToken;

  final BaseMapStyle baseMap;
}

typedef SupplierMapBuilder =
    Widget Function(BuildContext context, SupplierMapProps props);

/// Build-time flag set together with the untracked native Maps SDK client keys. Without it the
/// app shows the synchronized list with a clear map-unavailable notice instead of a blank map.
const bool kMapsClientConfigured = bool.fromEnvironment(
  'MAPS_CLIENT_CONFIGURED',
);

Widget defaultSupplierMapBuilder(
  BuildContext context,
  SupplierMapProps props,
) => kMapsClientConfigured
    ? GoogleSupplierMap(props: props)
    : const MapUnavailablePanel(
        message:
            'The map is not available in this build. Every supplier is listed below in the same order.',
      );

class MapUnavailablePanel extends StatelessWidget {
  const MapUnavailablePanel({super.key, required this.message});
  final String message;

  @override
  Widget build(BuildContext context) => Semantics(
    container: true,
    label: message,
    excludeSemantics: true,
    child: ColoredBox(
      color: const Color(MateryalColorTokens.surfaceCanvas),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(message, textAlign: TextAlign.center),
        ),
      ),
    ),
  );
}

class GoogleSupplierMap extends StatefulWidget {
  const GoogleSupplierMap({super.key, required this.props});
  final SupplierMapProps props;

  @override
  State<GoogleSupplierMap> createState() => _GoogleSupplierMapState();
}

class _GoogleSupplierMapState extends State<GoogleSupplierMap>
    with SingleTickerProviderStateMixin {
  static const _manila = GeoPoint(14.5995, 120.9842);
  GoogleMapController? _controller;
  double _zoom = 13;
  final Map<String, BitmapDescriptor> _icons = {};
  Set<Marker> _markers = {};
  late final AnimationController _reveal = AnimationController(
    vsync: this,
    duration: MateryalMotionTokens.route,
  )..addListener(() => setState(() {}));
  Timer? _debounce;
  Timer? _cameraFitDebounce;
  int _renderSequence = 0;

  SupplierMapProps get props => widget.props;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _rebuildMarkers());
  }

  @override
  void didUpdateWidget(covariant GoogleSupplierMap old) {
    super.didUpdateWidget(old);
    final reduce = BuyerMotion.reduced(context);
    if (old.props.bottomInset != props.bottomInset &&
        props.selectedId != null) {
      _cameraFitDebounce?.cancel();
      _cameraFitDebounce = Timer(const Duration(milliseconds: 250), () {
        if (mounted) _fitSelection(reduce);
      });
    }
    if (!identical(old.props.items, props.items) ||
        old.props.selectedId != props.selectedId ||
        old.props.origin != props.origin) {
      _rebuildMarkers();
    }
    if (old.props.routePath != props.routePath) {
      _reveal.stop();
      if (props.routePath == null) {
        _reveal.value = 0;
      } else if (reduce) {
        _reveal.value = 1;
      } else {
        _reveal.forward(from: 0);
      }
      _fitSelection(reduce);
    } else if (old.props.selectedId != props.selectedId &&
        props.selectedId != null) {
      _fitSelection(reduce);
    }
    if (old.props.recenterToken != props.recenterToken ||
        old.props.origin != props.origin ||
        old.props.radiusKm != props.radiusKm) {
      _fitRadius(reduce);
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _cameraFitDebounce?.cancel();
    _reveal.dispose();
    super.dispose();
  }

  Future<void> _rebuildMarkers() async {
    final sequence = ++_renderSequence;
    final ratio = MediaQuery.devicePixelRatioOf(context);
    final textScale = MediaQuery.textScalerOf(context).scale(1).clamp(1.0, 1.6);
    final groups = clusterSuppliers(
      mapVisibleSuppliers(props.items, props.selectedId),
      _zoom,
      selectedId: props.selectedId,
    );
    final labeled = placeLabels(
      groups,
      _zoom,
      selectedId: props.selectedId,
      textScale: textScale,
    );
    final markers = <Marker>{};
    for (final group in groups) {
      final icon = await _icon(group, labeled, ratio, textScale);
      if (!mounted || sequence != _renderSequence) return;
      final isCluster = group.isCluster;
      final center = isCluster ? group.center : group.single.point;
      markers.add(
        Marker(
          markerId: MarkerId(group.id),
          position: LatLng(center.latitude, center.longitude),
          icon: icon,
          anchor: const Offset(0.5, 1),
          zIndexInt: !isCluster && group.single.resultId == props.selectedId
              ? 10
              : 1,
          consumeTapEvents: true,
          infoWindow: InfoWindow(title: group.semanticsLabel),
          onTap: () => isCluster
              ? _expandCluster(group)
              : props.onSelect(group.single.resultId),
        ),
      );
    }
    final origin = props.origin;
    if (origin != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('origin'),
          position: LatLng(origin.latitude, origin.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueAzure,
          ),
          infoWindow: const InfoWindow(title: 'Your selected location'),
          zIndexInt: 0,
        ),
      );
    }
    if (mounted && sequence == _renderSequence) {
      setState(() => _markers = markers);
    }
  }

  Future<BitmapDescriptor> _icon(
    MapGroup group,
    Set<String> labeled,
    double ratio,
    double textScale,
  ) async {
    final selected =
        !group.isCluster && group.single.resultId == props.selectedId;
    final showLabel =
        !group.isCluster && labeled.contains(group.single.resultId);
    final key = group.isCluster
        ? 'c:${group.members.length}:${group.verifiedCount}:$ratio'
        : 's:${group.single.resultId}:${group.single.markerLabel}:${group.single.isFavorite}:$selected:$showLabel:$ratio:$textScale';
    final cached = _icons[key];
    if (cached != null) return cached;
    final bytes = group.isCluster
        ? await paintClusterMarker(group, ratio)
        : await paintSupplierMarker(
            group.single,
            selected: selected,
            showLabel: showLabel,
            ratio: ratio,
            textScale: textScale,
          );
    final descriptor = BitmapDescriptor.bytes(bytes, imagePixelRatio: ratio);
    if (_icons.length > 400) _icons.clear();
    return _icons[key] = descriptor;
  }

  Future<void> _expandCluster(MapGroup group) async {
    final bounds = _bounds(group.members.map((item) => item.point).toList());
    await _move(
      CameraUpdate.newLatLngBounds(bounds, 64),
      BuyerMotion.reduced(context),
    );
  }

  void _fitSelection(bool reduce) {
    final selected = props.items.where(
      (item) => item.resultId == props.selectedId,
    );
    if (selected.isEmpty) return;
    final points = [selected.first.point, ...?props.routePath, ?props.origin];
    _move(CameraUpdate.newLatLngBounds(_bounds(points), 56), reduce);
  }

  void _fitRadius(bool reduce) {
    final origin = props.origin;
    if (origin == null) return;
    final meters = props.radiusKm * 1000.0;
    final dLat = meters / 111320;
    final dLng = meters / (111320 * math.cos(origin.latitude * math.pi / 180));
    _move(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(origin.latitude - dLat, origin.longitude - dLng),
          northeast: LatLng(origin.latitude + dLat, origin.longitude + dLng),
        ),
        24,
      ),
      reduce,
    );
  }

  Future<void> _move(CameraUpdate update, bool reduce) async {
    final controller = _controller;
    if (controller == null) return;
    try {
      if (reduce) {
        await controller.moveCamera(update);
      } else {
        await controller.animateCamera(
          update,
          duration: MateryalMotionTokens.camera,
        );
      }
    } catch (_) {
      // The map may not have a size yet; the next layout will fit again.
    }
  }

  LatLngBounds _bounds(List<GeoPoint> points) {
    var south = points.first.latitude, north = south;
    var west = points.first.longitude, east = west;
    for (final point in points) {
      south = math.min(south, point.latitude);
      north = math.max(north, point.latitude);
      west = math.min(west, point.longitude);
      east = math.max(east, point.longitude);
    }
    return LatLngBounds(
      southwest: LatLng(south, west),
      northeast: LatLng(north, east),
    );
  }

  @override
  Widget build(BuildContext context) {
    final origin = props.origin ?? _manila;
    final path = props.routePath;
    final visible = path == null
        ? 0
        : math
              .max(2, (path.length * _reveal.value).ceil())
              .clamp(0, path.length);
    return Semantics(
      label: props.selectedId == null
          ? 'Map of ${props.items.length} suppliers within ${props.radiusKm} kilometres. The supplier list below has the same suppliers in the same order.'
          : 'Map showing only the selected supplier. Close the preview to show all ${props.items.length} suppliers again.',
      child: GoogleMap(
        cameraTargetBounds: PhilippineMapView.cameraBounds,
        minMaxZoomPreference: PhilippineMapView.zoomRange,
        initialCameraPosition: CameraPosition(
          target: LatLng(origin.latitude, origin.longitude),
          zoom: 13,
        ),
        mapType: props.baseMap == BaseMapStyle.satellite
            ? MapType.hybrid
            : MapType.normal,
        onMapCreated: (controller) {
          _controller = controller;
          _fitRadius(true);
        },
        onCameraMove: (position) => _zoom = position.zoom,
        onCameraIdle: () {
          _debounce?.cancel();
          _debounce = Timer(const Duration(milliseconds: 200), _rebuildMarkers);
        },
        padding: EdgeInsets.only(bottom: props.bottomInset, top: 8),
        myLocationEnabled: false,
        myLocationButtonEnabled: false,
        mapToolbarEnabled: false,
        zoomControlsEnabled: false,
        compassEnabled: false,
        markers: _markers,
        circles: {
          if (props.origin != null)
            Circle(
              circleId: const CircleId('radius'),
              center: LatLng(origin.latitude, origin.longitude),
              radius: props.radiusKm * 1000.0,
              strokeWidth: 2,
              strokeColor: const Color(MateryalColorTokens.brandOrange600),
              fillColor: const Color(
                MateryalColorTokens.brandOrange500,
              ).withValues(alpha: 0.06),
            ),
        },
        polylines: {
          if (path != null && visible >= 2)
            Polyline(
              polylineId: const PolylineId('selected-route'),
              points: [
                for (final point in path.take(visible))
                  LatLng(point.latitude, point.longitude),
              ],
              width: 5,
              color: const Color(MateryalColorTokens.textStrong),
              startCap: Cap.roundCap,
              endCap: Cap.roundCap,
            ),
        },
      ),
    );
  }
}

/// Supplier marker: tier-specific shape and glyph plus a store-name label when it fits.
Future<Uint8List> paintSupplierMarker(
  SupplierResultView item, {
  required bool selected,
  required bool showLabel,
  required double ratio,
  double textScale = 1,
}) async {
  final label = item.markerLabel.length > 28
      ? '${item.markerLabel.substring(0, 27)}…'
      : item.markerLabel;
  final textPainter = TextPainter(
    text: TextSpan(
      text: label,
      style: TextStyle(
        fontSize: 12 * textScale,
        fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
        color: const Color(MateryalColorTokens.textStrong),
        fontFamily: 'Inter',
      ),
    ),
    textDirection: TextDirection.ltr,
    maxLines: 1,
  )..layout();
  const pin = 34.0;
  final labelWidth = showLabel ? textPainter.width + 20 : 0.0;
  final labelHeight = showLabel ? textPainter.height + 12 : 0.0;
  final width = math.max(pin + 8, labelWidth + 4);
  final height = pin + 10 + (showLabel ? labelHeight + 6 : 0);
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder)..scale(ratio);
  final centerX = width / 2;
  if (showLabel) {
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(centerX - labelWidth / 2, 1, labelWidth, labelHeight),
      const Radius.circular(8),
    );
    canvas.drawRRect(rect, Paint()..color = Colors.white);
    canvas.drawRRect(
      rect,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = selected ? 2 : 1
        ..color = Color(
          selected
              ? MateryalColorTokens.textStrong
              : MateryalColorTokens.borderDefault,
        ),
    );
    textPainter.paint(canvas, Offset(centerX - textPainter.width / 2, 7));
  }
  final top = showLabel ? labelHeight + 6 : 2.0;
  final verified = item.isVerified;
  final fill = Paint()
    ..color = Color(
      verified
          ? MateryalColorTokens.actionPrimary
          : MateryalColorTokens.surfacePrimary,
    );
  final outline = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = verified ? 2 : 2.5
    ..color = Color(
      verified
          ? MateryalColorTokens.surfacePrimary
          : MateryalColorTokens.textSecondary,
    );
  final path = Path()
    ..addOval(
      Rect.fromCircle(
        center: Offset(centerX, top + pin / 2),
        radius: pin / 2 - 2,
      ),
    )
    ..moveTo(centerX - 7, top + pin - 6)
    ..lineTo(centerX, top + pin + 8)
    ..lineTo(centerX + 7, top + pin - 6)
    ..close();
  if (selected) {
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5
        ..color = const Color(MateryalColorTokens.textStrong),
    );
  }
  canvas.drawPath(path, fill);
  canvas.drawPath(path, outline);
  final glyph = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.4
    ..strokeCap = StrokeCap.round
    ..color = Color(
      verified
          ? MateryalColorTokens.surfacePrimary
          : MateryalColorTokens.textSecondary,
    );
  final c = Offset(centerX, top + pin / 2);
  if (verified) {
    canvas.drawPath(
      Path()
        ..moveTo(c.dx - 6, c.dy)
        ..lineTo(c.dx - 1.5, c.dy + 4.5)
        ..lineTo(c.dx + 6.5, c.dy - 4.5),
      glyph,
    );
  } else {
    canvas.drawRect(Rect.fromCenter(center: c, width: 11, height: 11), glyph);
    canvas.drawLine(
      c.translate(0, -5.5),
      c.translate(0, 5.5),
      glyph..strokeWidth = 1.5,
    );
  }
  if (item.isFavorite) {
    final star = Offset(centerX + pin / 2 - 3, top + 5);
    canvas.drawCircle(
      star,
      7,
      Paint()..color = const Color(MateryalColorTokens.statusWarning),
    );
    canvas.drawCircle(
      star,
      7,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..color = const Color(MateryalColorTokens.textStrong),
    );
    TextPainter(
        text: const TextSpan(
          text: '★',
          style: TextStyle(
            fontSize: 10,
            color: Color(MateryalColorTokens.textStrong),
          ),
        ),
        textDirection: TextDirection.ltr,
      )
      ..layout()
      ..paint(canvas, star.translate(-5, -7));
  }
  final image = await recorder.endRecording().toImage(
    (width * ratio).ceil(),
    (height * ratio).ceil(),
  );
  final data = await image.toByteData(format: ui.ImageByteFormat.png);
  return data!.buffer.asUint8List();
}

/// Cluster marker: count plus a ring segmented by tier (orange Verified, gray Directory).
Future<Uint8List> paintClusterMarker(MapGroup group, double ratio) async {
  const size = 48.0;
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder)..scale(ratio);
  const center = Offset(size / 2, size / 2);
  canvas.drawCircle(center, 21, Paint()..color = Colors.white);
  final verifiedSweep =
      2 * math.pi * group.verifiedCount / group.members.length;
  final ring = Rect.fromCircle(center: center, radius: 19);
  final stroke = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 5;
  canvas.drawArc(
    ring,
    -math.pi / 2,
    verifiedSweep,
    false,
    stroke..color = const Color(MateryalColorTokens.actionPrimary),
  );
  canvas.drawArc(
    ring,
    -math.pi / 2 + verifiedSweep,
    2 * math.pi - verifiedSweep,
    false,
    stroke..color = const Color(MateryalColorTokens.textSecondary),
  );
  final text = TextPainter(
    text: TextSpan(
      text: '${group.members.length}',
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w800,
        color: Color(MateryalColorTokens.textStrong),
        fontFamily: 'Inter',
      ),
    ),
    textDirection: TextDirection.ltr,
  )..layout();
  text.paint(canvas, center - Offset(text.width / 2, text.height / 2));
  final image = await recorder.endRecording().toImage(
    (size * ratio).ceil(),
    (size * ratio).ceil(),
  );
  final data = await image.toByteData(format: ui.ImageByteFormat.png);
  return data!.buffer.asUint8List();
}
