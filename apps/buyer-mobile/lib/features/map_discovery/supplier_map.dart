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

enum SupplierMapContext { itemBased, projectBased }

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
    this.procurementContext = SupplierMapContext.itemBased,
    this.highlightedIds = const {},
    this.routePaths = const {},
  });

  final List<SupplierResultView> items;
  final GeoPoint? origin;
  final int radiusKm;
  final String? selectedId;
  final List<GeoPoint>? routePath;

  /// Other decision routes in a selected procurement group, keyed by Vendor.
  /// [routePath] remains the emphasized route for [selectedId].
  final Map<String, List<GeoPoint>> routePaths;
  final ValueChanged<String> onSelect;

  /// Space covered by the preview sheet so the camera keeps marker and route visible.
  final double bottomInset;

  /// Incremented when the Buyer taps Recenter.
  final int recenterToken;

  final BaseMapStyle baseMap;
  final SupplierMapContext procurementContext;
  final Set<String> highlightedIds;
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
  final _icons = <String, BitmapDescriptor>{};
  final _pendingIcons = <String, Future<BitmapDescriptor>>{};
  Timer? _resultsDebounce;
  Timer? _zoomThrottle;
  int _zoomBand = 26;
  List<SupplierResultView> _spiderItems = const [];
  Set<Marker> _markers = {};
  late final AnimationController _reveal = AnimationController(
    vsync: this,
    duration: MateryalMotionTokens.route,
  )..addListener(_revealed);

  /// Each route converted once. Unchanged polylines then compare by identity
  /// and are never resent to the native map on a rebuild.
  static final _routePoints = Expando<List<LatLng>>();
  int _revealedPoints = -1;

  /// The draw-in sends the native map a new polyline per step, so it moves in
  /// at most [_revealSteps] steps instead of on every frame.
  static const _revealSteps = 24;

  List<LatLng> _latLngs(List<GeoPoint> path) => _routePoints[path] ??= [
    for (final point in path) LatLng(point.latitude, point.longitude),
  ];

  int _visiblePoints(List<GeoPoint>? path) {
    if (path == null) return 0;
    if (_reveal.value >= 1) return path.length;
    final step = math.max(1, (path.length / _revealSteps).ceil());
    return (((path.length * _reveal.value) / step).ceil() * step)
        .clamp(math.min(2, path.length), path.length)
        .toInt();
  }

  void _revealed() {
    if (_visiblePoints(props.routePath) != _revealedPoints) setState(() {});
  }

  Timer? _debounce;
  Timer? _cameraFitDebounce;
  LatLngBounds? _fitted;
  double? _fittedInset;
  int _renderSequence = 0;
  SupplierMapViewport? _viewport;
  bool _readingViewport = false;
  bool _viewportAgain = false;
  bool _rendering = false;
  bool _renderAgain = false;
  List<SupplierResultView>? _renderedItems;
  (double, double, double, GeoPoint?, String?)? _renderedSettings;
  Set<String> _renderedHighlights = const {};
  List<SupplierResultView> _renderedSpider = const [];

  SupplierMapProps get props => widget.props;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Rotation, keyboard resizing and text scaling can change native viewport/label bounds.
    MediaQuery.of(context);
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 100), _refreshViewport);
  }

  @override
  void didUpdateWidget(covariant GoogleSupplierMap old) {
    super.didUpdateWidget(old);
    final reduce = BuyerMotion.reduced(context);
    final highlightsChanged =
        old.props.highlightedIds.length != props.highlightedIds.length ||
        !old.props.highlightedIds.containsAll(props.highlightedIds);
    if (old.props.bottomInset != props.bottomInset) {
      _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 100), _refreshViewport);
    }
    if (old.props.bottomInset != props.bottomInset &&
        props.selectedId != null) {
      _scheduleFit(reduce, delay: const Duration(milliseconds: 250));
    }
    if (!sameSupplierMarkers(old.props.items, props.items) ||
        highlightsChanged ||
        old.props.selectedId != props.selectedId ||
        old.props.origin != props.origin) {
      ++_renderSequence;
      _resultsDebounce?.cancel();
      _spiderItems = const [];
      if (old.props.selectedId != props.selectedId ||
          old.props.origin != props.origin) {
        _rebuildMarkers();
      } else {
        _resultsDebounce = Timer(
          const Duration(milliseconds: 100),
          _rebuildMarkers,
        );
      }
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
      _scheduleFit(reduce);
    } else if ((old.props.routePaths != props.routePaths ||
            old.props.selectedId != props.selectedId ||
            highlightsChanged) &&
        props.selectedId != null) {
      _scheduleFit(reduce);
    }
    if (old.props.selectedId != props.selectedId || highlightsChanged) {
      // A new selection always frames itself, even inside the last fit.
      _fitted = null;
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
    _resultsDebounce?.cancel();
    _zoomThrottle?.cancel();
    _controller?.dispose();
    _reveal.dispose();
    super.dispose();
  }

  Future<void> _refreshViewport() async {
    if (_readingViewport) {
      _viewportAgain = true;
      return;
    }
    _readingViewport = true;
    try {
      do {
        _viewportAgain = false;
        final controller = _controller;
        if (!mounted || controller == null) return;
        final LatLngBounds bounds;
        try {
          bounds = await controller.getVisibleRegion();
        } catch (_) {
          // The native view may not be laid out yet; camera idle retries its bounds.
          return;
        }
        if (!mounted) return;
        if (bounds.southwest == bounds.northeast) return;
        _viewport = SupplierMapViewport(
          southwest: GeoPoint(
            bounds.southwest.latitude,
            bounds.southwest.longitude,
          ),
          northeast: GeoPoint(
            bounds.northeast.latitude,
            bounds.northeast.longitude,
          ),
        );
        await _rebuildMarkers();
      } while (_viewportAgain && mounted);
    } finally {
      _readingViewport = false;
    }
  }

  Future<void> _rebuildMarkers() async {
    if (!mounted || _viewport == null) return;
    ++_renderSequence;
    if (_rendering) {
      _renderAgain = true;
      return;
    }
    _rendering = true;
    try {
      do {
        _renderAgain = false;
        await _renderMarkers(_renderSequence);
      } while (_renderAgain && mounted);
    } finally {
      _rendering = false;
    }
  }

  Future<void> _renderMarkers(int sequence) async {
    final ratio = MediaQuery.devicePixelRatioOf(context);
    final textScale = MediaQuery.textScalerOf(context).scale(1).clamp(1.0, 1.6);
    final nearby = _viewport!.suppliers(
      props.items,
      _zoom,
      selectedId: props.selectedId,
    );
    final settings = (_zoom, ratio, textScale, props.origin, props.selectedId);
    final highlights = props.highlightedIds;
    final spider = _spiderItems;
    if (_renderedSettings == settings &&
        identical(_renderedSpider, spider) &&
        _renderedHighlights.length == highlights.length &&
        _renderedHighlights.containsAll(highlights) &&
        _renderedItems != null &&
        sameSupplierMarkers(_renderedItems!, nearby)) {
      return;
    }
    final visible = mapVisibleSuppliers(nearby, props.selectedId);
    final groups = props.highlightedIds.isEmpty
        ? clusterSuppliers(visible, _zoom, selectedId: props.selectedId)
        : [
            ...clusterSuppliers(
              visible
                  .where(
                    (item) => !props.highlightedIds.contains(item.resultId),
                  )
                  .toList(),
              _zoom,
              selectedId: props.selectedId,
            ),
            for (final item in nearby.where(
              (item) => props.highlightedIds.contains(item.resultId),
            ))
              MapGroup([item]),
          ];
    if (_spiderItems.isNotEmpty) {
      final ids = _spiderItems.map((item) => item.resultId).toSet();
      groups.removeWhere(
        (group) => group.members.any((item) => ids.contains(item.resultId)),
      );
      groups.addAll(_spiderItems.map((item) => MapGroup([item])));
    }
    final labeled = placeLabels(
      groups,
      _zoom,
      selectedId: props.selectedId,
      textScale: textScale,
    );
    final markers = <Marker>{};
    await _warmIcons(ratio);
    if (!mounted || sequence != _renderSequence) return;
    final icons = await Future.wait(groups.map((group) => _icon(group, ratio)));
    if (!mounted || sequence != _renderSequence) return;
    final labelIcons = await Future.wait(
      groups.map(
        (group) => !group.isCluster && labeled.contains(group.single.resultId)
            ? _labelIcon(group.single, ratio, textScale)
            : Future<BitmapDescriptor?>.value(null),
      ),
    );
    if (!mounted || sequence != _renderSequence) return;
    final spiderIndices = {
      for (var index = 0; index < _spiderItems.length; index++)
        _spiderItems[index].resultId: index,
    };
    final spiderAnchor = _spiderItems.isEmpty
        ? null
        : projectToWorld(MapGroup(_spiderItems).center, _zoom);
    for (var index = 0; index < groups.length; index++) {
      final group = groups[index];
      final icon = icons[index];
      final isCluster = group.isCluster;
      var center = isCluster ? group.center : group.single.point;
      final spiderIndex = isCluster
          ? -1
          : spiderIndices[group.single.resultId] ?? -1;
      if (spiderIndex >= 0) {
        final radius = math.min(
          100.0,
          math.max(38.0, _spiderItems.length * 7.0),
        );
        final angle = 2 * math.pi * spiderIndex / _spiderItems.length;
        center = unprojectFromWorld(
          spiderAnchor! +
              Offset(math.cos(angle) * radius, math.sin(angle) * radius),
          _zoom,
        );
      }
      final label = labelIcons[index];
      if (label != null) {
        markers.add(
          Marker(
            markerId: MarkerId('label:${group.single.resultId}'),
            position: LatLng(center.latitude, center.longitude),
            icon: label,
            anchor: const Offset(0.5, 2.5),
            zIndexInt: group.single.resultId == props.selectedId ? 11 : 2,
            consumeTapEvents: true,
            onTap: () => _selectSupplier(group.single),
          ),
        );
      }
      markers.add(
        Marker(
          markerId: MarkerId(group.id),
          position: LatLng(center.latitude, center.longitude),
          icon: icon,
          anchor: const Offset(0.5, 1),
          zIndexInt:
              !isCluster &&
                  (group.single.resultId == props.selectedId ||
                      props.highlightedIds.contains(group.single.resultId))
              ? 10
              : 1,
          consumeTapEvents: true,
          infoWindow: InfoWindow(title: group.semanticsLabel),
          onTap: () =>
              isCluster ? _expandCluster(group) : _selectSupplier(group.single),
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
          infoWindow: InfoWindow(
            title: props.procurementContext == SupplierMapContext.projectBased
                ? 'Project site · route origin'
                : 'Your selected location',
          ),
          zIndexInt: 0,
        ),
      );
    }
    if (mounted && sequence == _renderSequence) {
      _renderedItems = nearby;
      _renderedSettings = settings;
      _renderedHighlights = Set.of(highlights);
      _renderedSpider = spider;
      setState(() => _markers = markers);
    }
  }

  Future<BitmapDescriptor> _cachedIcon(
    String key,
    double ratio,
    Future<Uint8List> Function() paint,
  ) async {
    final cached = _icons.remove(key);
    if (cached != null) {
      _icons[key] = cached;
      return cached;
    }
    final pending = _pendingIcons[key];
    if (pending != null) return pending;
    final future = (() async {
      final descriptor = BitmapDescriptor.bytes(
        await paint(),
        imagePixelRatio: ratio,
      );
      _icons[key] = descriptor;
      while (_icons.length > 600) {
        _icons.remove(_icons.keys.first);
      }
      return descriptor;
    })();
    _pendingIcons[key] = future;
    try {
      return await future;
    } finally {
      _pendingIcons.remove(key);
    }
  }

  Future<BitmapDescriptor> _icon(
    MapGroup group,
    double ratio, {
    bool? selectedOverride,
  }) {
    final selected =
        selectedOverride ??
        (!group.isCluster &&
            (group.single.resultId == props.selectedId ||
                props.highlightedIds.contains(group.single.resultId)));
    final key = group.isCluster
        ? 'c:${group.members.length}:${group.verifiedCount}:${group.favoriteCount}:$ratio'
        : 's:${group.single.isVerified}:${group.single.isFavorite}:$selected:$ratio';
    return _cachedIcon(
      key,
      ratio,
      () => group.isCluster
          ? paintClusterMarker(group, ratio)
          : paintSupplierMarker(
              group.single,
              selected: selected,
              showLabel: false,
              ratio: ratio,
            ),
    );
  }

  Future<BitmapDescriptor> _labelIcon(
    SupplierResultView item,
    double ratio,
    double scale,
  ) {
    final selected =
        item.resultId == props.selectedId ||
        props.highlightedIds.contains(item.resultId);
    return _cachedIcon(
      'label:${item.markerLabel}:$selected:$ratio:$scale',
      ratio,
      () => paintSupplierLabel(
        item,
        selected: selected,
        ratio: ratio,
        textScale: scale,
      ),
    );
  }

  Future<void> _warmIcons(double ratio) async {
    await Future.wait([
      for (final tier in SupplierTier.values)
        for (final favorite in [false, true])
          _icon(
            MapGroup([
              SupplierResultView(
                resultId: '',
                tier: tier,
                rank: 0,
                name: '',
                point: const GeoPoint(14.6, 121),
                distanceMeters: 0,
                scoreKind: ScoreKind.directory,
                scoreText: '',
                isFavorite: favorite,
              ),
            ]),
            ratio,
            selectedOverride: false,
          ),
    ]);
  }

  Future<void> _expandCluster(MapGroup group) async {
    final bounds = _bounds(group.members.map((item) => item.point).toList());
    final span = pointDistanceMeters(
      GeoPoint(bounds.southwest.latitude, bounds.southwest.longitude),
      GeoPoint(bounds.northeast.latitude, bounds.northeast.longitude),
    );
    if (span <= 30 || _zoom >= 20.5) {
      _spiderItems = group.members;
      await _rebuildMarkers();
      return;
    }
    await _move(
      CameraUpdate.newLatLngBounds(bounds, 64),
      BuyerMotion.reduced(context),
    );
  }

  void _selectSupplier(SupplierResultView item) {
    if (_spiderItems.isEmpty && _zoom >= 13.5) {
      final nearby = props.items
          .where((other) => pointDistanceMeters(item.point, other.point) <= 15)
          .toList();
      if (nearby.length > 1) {
        _spiderItems = nearby;
        _rebuildMarkers();
        return;
      }
    }
    props.onSelect(item.resultId);
  }

  /// Selection, each arriving route and the settled sheet all ask for a fit
  /// within moments of each other; one camera move after they settle replaces
  /// a chain of competing animations.
  void _scheduleFit(
    bool reduce, {
    Duration delay = const Duration(milliseconds: 200),
  }) {
    _cameraFitDebounce?.cancel();
    _cameraFitDebounce = Timer(delay, () {
      if (mounted) _fitSelection(reduce);
    });
  }

  void _fitSelection(bool reduce) {
    final selected = props.items.where(
      (item) =>
          item.resultId == props.selectedId ||
          props.highlightedIds.contains(item.resultId),
    );
    if (selected.isEmpty) return;
    final points = [
      ...selected.map((item) => item.point),
      ...?props.routePath,
      for (final path in props.routePaths.values) ...path,
      ?props.origin,
    ];
    final bounds = _bounds(points);
    final fitted = _fitted;
    // Already framed (e.g. a route inside the members' area): leave the
    // camera, including wherever the Buyer has since panned it.
    if (fitted != null &&
        _fittedInset == props.bottomInset &&
        fitted.contains(bounds.southwest) &&
        fitted.contains(bounds.northeast)) {
      return;
    }
    _fitted = bounds;
    _fittedInset = props.bottomInset;
    _move(CameraUpdate.newLatLngBounds(bounds, 56), reduce);
  }

  void _fitRadius(bool reduce) {
    final origin = props.origin;
    if (origin == null) return;
    _cameraFitDebounce?.cancel();
    _fitted = null;
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
    final visible = _revealedPoints = _visiblePoints(path);
    return Semantics(
      label: props.highlightedIds.isNotEmpty
          ? 'Map of ${props.highlightedIds.length} selected quotation Vendors. Routes start at the Project site. Select a Vendor pin or its route in the list.'
          : props.selectedId == null
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
          _refreshViewport();
        },
        onCameraMove: (position) {
          _zoom = position.zoom;
          final band = (_zoom * 2).floor();
          final zoomChanged = band != _zoomBand;
          if (zoomChanged) {
            _zoomBand = band;
            _spiderItems = const [];
          }
          _zoomThrottle ??= Timer(
            Duration(milliseconds: zoomChanged ? 60 : 120),
            () {
              _zoomThrottle = null;
              if (mounted) _refreshViewport();
            },
          );
        },
        onCameraIdle: () {
          _zoomThrottle?.cancel();
          _zoomThrottle = null;
          _debounce?.cancel();
          _debounce = Timer(const Duration(milliseconds: 60), _refreshViewport);
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
          for (final entry in props.routePaths.entries)
            if (entry.key != props.selectedId && entry.value.length >= 2)
              Polyline(
                polylineId: PolylineId('vendor-route:${entry.key}'),
                points: _latLngs(entry.value),
                width: 4,
                color: const Color(MateryalColorTokens.actionPrimary),
                startCap: Cap.roundCap,
                endCap: Cap.roundCap,
                consumeTapEvents: true,
                onTap: () => props.onSelect(entry.key),
              ),
          if (path != null && visible >= 2)
            Polyline(
              polylineId: const PolylineId('selected-route'),
              points: visible == path.length
                  ? _latLngs(path)
                  : _latLngs(path).sublist(0, visible),
              width: 5,
              color: const Color(MateryalColorTokens.textStrong),
              startCap: Cap.roundCap,
              endCap: Cap.roundCap,
              zIndex: 1,
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
  final width = math.max(pin + 18, labelWidth + 4);
  final height = pin + 14 + (showLabel ? labelHeight + 6 : 0);
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
          ? MateryalColorTokens.mapTier2Fill
          : MateryalColorTokens.surfacePrimary,
    );
  final outline = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = item.isFavorite ? 3 : 2.5
    ..color = Color(
      item.isFavorite
          ? MateryalColorTokens.mapFavoriteRing
          : verified
          ? MateryalColorTokens.surfacePrimary
          : MateryalColorTokens.mapTier1Outline,
    );
  final path = Path()
    ..moveTo(centerX, top + 40)
    ..cubicTo(
      centerX - 5,
      top + 31,
      centerX - 17,
      top + 25,
      centerX - 17,
      top + 16,
    )
    ..cubicTo(
      centerX - 17,
      top - 5,
      centerX + 17,
      top - 5,
      centerX + 17,
      top + 16,
    )
    ..cubicTo(centerX + 17, top + 25, centerX + 5, top + 31, centerX, top + 40)
    ..close();
  if (selected) {
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = item.isFavorite ? 7 : 6.5
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
    canvas.drawPath(
      Path()
        ..moveTo(c.dx - 7, c.dy + 7)
        ..lineTo(c.dx - 7, c.dy - 7)
        ..lineTo(c.dx + 2, c.dy - 7)
        ..lineTo(c.dx + 2, c.dy - 3)
        ..lineTo(c.dx + 7, c.dy - 3)
        ..lineTo(c.dx + 7, c.dy + 7)
        ..close(),
      glyph..strokeWidth = 1.8,
    );
    canvas.drawRect(Rect.fromLTWH(c.dx - 1, c.dy + 2, 3, 5), glyph);
    final windows = Paint()
      ..color = const Color(MateryalColorTokens.mapTier1Outline);
    for (final x in [-4.0, 0.0]) {
      for (final y in [-4.0, 0.0]) {
        canvas.drawRect(Rect.fromLTWH(c.dx + x, c.dy + y, 2, 2), windows);
      }
    }
  }
  if (item.isFavorite) {
    final star = Offset(centerX + pin / 2 - 3, top + 5);
    canvas.drawCircle(
      star,
      8,
      Paint()..color = const Color(MateryalColorTokens.mapFavoriteRing),
    );
    canvas.drawCircle(
      star,
      8,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..color = const Color(MateryalColorTokens.surfacePrimary),
    );
    canvas.drawPath(
      _star(star, 5),
      Paint()..color = const Color(MateryalColorTokens.textStrong),
    );
  }
  final picture = recorder.endRecording();
  final image = await picture.toImage(
    (width * ratio).ceil(),
    (height * ratio).ceil(),
  );
  picture.dispose();
  final data = await image.toByteData(format: ui.ImageByteFormat.png);
  image.dispose();
  return data!.buffer.asUint8List();
}

/// Cluster marker: count plus a ring segmented by tier (orange Verified, gray Directory).
Future<Uint8List> paintClusterMarker(MapGroup group, double ratio) async {
  const size = 56.0;
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder)..scale(ratio);
  const center = Offset(25, 30);
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
    stroke..color = const Color(MateryalColorTokens.mapClusterTier2),
  );
  canvas.drawArc(
    ring,
    -math.pi / 2 + verifiedSweep,
    2 * math.pi - verifiedSweep,
    false,
    stroke..color = const Color(MateryalColorTokens.mapClusterTier1),
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
  if (group.favoriteCount > 0) {
    final chip = RRect.fromRectAndRadius(
      const Rect.fromLTWH(28, 0, 28, 18),
      const Radius.circular(9),
    );
    canvas.drawRRect(
      chip,
      Paint()..color = const Color(MateryalColorTokens.mapFavoriteRing),
    );
    canvas.drawPath(
      _star(const Offset(35, 9), 4),
      Paint()..color = const Color(MateryalColorTokens.textStrong),
    );
    final count = TextPainter(
      text: TextSpan(
        text: group.favoriteCount.toString(),
        style: const TextStyle(
          fontSize: 10,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w800,
          color: Color(MateryalColorTokens.textStrong),
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    count.paint(canvas, Offset(46 - count.width / 2, 9 - count.height / 2));
  }
  final picture = recorder.endRecording();
  final image = await picture.toImage(
    (size * ratio).ceil(),
    (size * ratio).ceil(),
  );
  picture.dispose();
  final data = await image.toByteData(format: ui.ImageByteFormat.png);
  image.dispose();
  return data!.buffer.asUint8List();
}

Path _star(Offset center, double radius) {
  final path = Path();
  for (var index = 0; index < 10; index++) {
    final angle = -math.pi / 2 + index * math.pi / 5;
    final r = index.isEven ? radius : radius * 0.45;
    final point = center + Offset(math.cos(angle) * r, math.sin(angle) * r);
    if (index == 0) {
      path.moveTo(point.dx, point.dy);
    } else {
      path.lineTo(point.dx, point.dy);
    }
  }
  return path..close();
}

Future<Uint8List> paintSupplierLabel(
  SupplierResultView item, {
  required bool selected,
  required double ratio,
  double textScale = 1,
}) async {
  final label = !selected && item.markerLabel.length > 28
      ? '${item.markerLabel.substring(0, 27)}…'
      : item.markerLabel;
  final text = TextPainter(
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
    ellipsis: '…',
  )..layout(maxWidth: 300);
  final width = text.width + 24;
  final height = text.height + 16;
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder)..scale(ratio);
  final box = RRect.fromRectAndRadius(
    Rect.fromLTWH(2, 2, width - 4, height - 4),
    const Radius.circular(8),
  );
  canvas.drawRRect(
    box,
    Paint()..color = const Color(MateryalColorTokens.surfacePrimary),
  );
  canvas.drawRRect(
    box,
    Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = (selected ? 2 : 1)
      ..color = Color(
        selected
            ? MateryalColorTokens.textStrong
            : MateryalColorTokens.borderDefault,
      ),
  );
  text.paint(canvas, const Offset(12, 8));
  final picture = recorder.endRecording();
  final image = await picture.toImage(
    (width * ratio).ceil(),
    (height * ratio).ceil(),
  );
  final data = await image.toByteData(format: ui.ImageByteFormat.png);
  image.dispose();
  picture.dispose();
  return data!.buffer.asUint8List();
}
