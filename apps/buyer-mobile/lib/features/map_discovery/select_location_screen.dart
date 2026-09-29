import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../design_system/motion.dart';
import '../../design_system/components/discovery_controls.dart';
import '../../design_system/theme.dart';
import '../../widgets/auth_content.dart';
import 'device_location.dart';
import 'discovery_models.dart';
import 'discovery_repository.dart';
import 'philippine_map_view.dart';

const Map<String, String> kLocationKinds = {
  'DELIVERY': 'Delivery address',
  'PROJECT_SITE': 'Project site',
  'BUSINESS': 'Business address',
  'PICKUP_REFERENCE': 'Pickup reference',
  'OTHER': 'Other',
};

/// One selected point shared by Places search, map panning and optional device location.
/// Choose Location persists through the existing Buyer location API before returning.
class SelectLocationScreen extends StatefulWidget {
  const SelectLocationScreen({
    super.key,
    required this.repository,
    required this.deviceLocation,
    required this.savedLocations,
    required this.mapsAvailable,
    this.initialPoint,
    this.requireSave = false,
    this.initialDeviceLocation = false,
  });

  final DiscoveryRepository repository;
  final DeviceLocationService deviceLocation;
  final List<SavedLocationView> savedLocations;
  final bool mapsAvailable;
  final GeoPoint? initialPoint;
  final bool requireSave;
  final bool initialDeviceLocation;

  @override
  State<SelectLocationScreen> createState() => _SelectLocationScreenState();
}

class _SelectLocationScreenState extends State<SelectLocationScreen> {
  final _label = TextEditingController();
  final _description = TextEditingController();
  final _confirmForm = GlobalKey<FormState>();

  LocationPreviewView? _preview;
  String? _idempotencyKey;
  bool _busy = false;
  String? _error;
  late bool _makePrimary = !widget.requireSave;
  String _kind = 'DELIVERY';
  late GeoPoint _pin = widget.initialPoint ?? const GeoPoint(14.5995, 120.9842);
  bool _pinMoving = false;
  int _resolveSequence = 0;
  int _searchSequence = 0;
  Timer? _searchDebounce;
  String _sessionToken = newIdempotencyKey();
  List<LocationSuggestionView> _suggestions = const [];
  bool _searching = false;
  bool _saving = false;
  bool _programmaticMove = false;
  GeoPoint? _cameraTarget;
  GoogleMapController? _map;
  final _search = TextEditingController();
  final _searchFocus = FocusNode();
  final _detailsKey = GlobalKey();
  double _cardHeight = 220;

  void _measureDetails() {
    final box = _detailsKey.currentContext?.findRenderObject();
    if (mounted &&
        box is RenderBox &&
        box.hasSize &&
        (box.size.height - _cardHeight).abs() > 1) {
      setState(() => _cardHeight = box.size.height);
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialPoint != null) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _resolve(
          () => widget.repository.resolvePoint(
            _pin,
            device: widget.initialDeviceLocation,
          ),
          OriginSource.mapPin,
        ),
      );
    }
  }

  void _searchChanged(String query) {
    _searchDebounce?.cancel();
    final sequence = ++_searchSequence;
    setState(() {
      _suggestions = const [];
      _searching = query.trim().length >= 2;
      _error = null;
    });
    if (!_searching) return;
    _searchDebounce = Timer(const Duration(milliseconds: 400), () async {
      try {
        final items = await widget.repository.autocomplete(
          query.trim(),
          _sessionToken,
        );
        if (!mounted || sequence != _searchSequence) return;
        setState(() => _suggestions = items);
      } on DiscoveryFailure catch (error) {
        if (mounted && sequence == _searchSequence) {
          setState(() => _error = error.message);
        }
      } finally {
        if (mounted && sequence == _searchSequence) {
          setState(() => _searching = false);
        }
      }
    });
  }

  Future<void> _selectSuggestion(LocationSuggestionView suggestion) async {
    _searchDebounce?.cancel();
    _searchSequence++;
    FocusScope.of(context).unfocus();
    setState(() {
      _suggestions = const [];
      _searching = false;
      _search.text = suggestion.title;
    });
    final token = _sessionToken;
    await _resolve(
      () => widget.repository.resolvePlace(suggestion.placeId, token),
      OriginSource.search,
    );
    _sessionToken = newIdempotencyKey();
  }

  Future<void> _moveCamera(GeoPoint point) async {
    final map = _map;
    if (map == null) return;
    _programmaticMove = true;
    _cameraTarget = point;
    final update = CameraUpdate.newLatLng(
      LatLng(point.latitude, point.longitude),
    );
    try {
      if (BuyerMotion.reduced(context)) {
        await map.moveCamera(update);
      } else {
        await map.animateCamera(update);
      }
    } catch (_) {
      _programmaticMove = false;
    }
  }

  Future<void> _useSaved(SavedLocationView location) async {
    if (_saving) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final saved = location.isPrimary || widget.requireSave
          ? location
          : await widget.repository.makePrimary(location);
      if (mounted) {
        Navigator.of(context).pop(
          DiscoveryOrigin.saved(
            locationId: saved.id,
            label: displayAddress(saved.formattedAddress),
            point: saved.point,
          ),
        );
      }
    } on DiscoveryFailure catch (error) {
      if (mounted) {
        setState(() {
          _saving = false;
          _error = error.message;
        });
      }
    }
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _search.dispose();
    _searchFocus.dispose();
    _map?.dispose();
    for (final controller in [_label, _description]) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _resolve(
    Future<LocationPreviewView> Function() request,
    OriginSource source,
  ) async {
    if (_saving) return;
    final sequence = ++_resolveSequence;
    setState(() {
      _busy = true;
      _error = null;
      _preview = null;
    });
    try {
      final preview = await request();
      if (!mounted || sequence != _resolveSequence) return;
      setState(() {
        _preview = preview;
        _pin = preview.point;
        _idempotencyKey = newIdempotencyKey();
        _description.clear();
      });
      if (source != OriginSource.mapPin) await _moveCamera(preview.point);
    } on DiscoveryFailure catch (error) {
      if (!mounted || sequence != _resolveSequence) return;
      setState(() => _error = error.message);
    } finally {
      if (mounted && sequence == _resolveSequence) {
        setState(() => _busy = false);
      }
    }
  }

  Future<void> _useDevice() async {
    if (_busy || _saving) return;
    final sequence = ++_resolveSequence;
    setState(() {
      _busy = true;
      _error = null;
    });
    final result = await widget.deviceLocation.requestCurrent();
    if (!mounted || sequence != _resolveSequence) return;
    if (result.status != DeviceLocationStatus.granted || result.point == null) {
      setState(() => _busy = false);
      setState(
        () => _error = result.status == DeviceLocationStatus.serviceDisabled
            ? 'Location services are off. Search an address or drop a pin instead.'
            : 'Current location is unavailable or not permitted. Search an address or drop a pin instead.',
      );
      return;
    }
    await _resolve(
      () => widget.repository.resolvePoint(result.point!, device: true),
      OriginSource.device,
    );
  }

  Future<void> _confirm() async {
    if (_busy || _saving || _pinMoving) return;
    final preview = _preview;
    if (preview == null ||
        !preview.point.usable ||
        !(_confirmForm.currentState?.validate() ?? false)) {
      return;
    }
    final description = _description.text.trim();
    final matching = widget.savedLocations.where(
      (location) =>
          (location.point.latitude - preview.point.latitude).abs() < 0.000001 &&
          (location.point.longitude - preview.point.longitude).abs() < 0.000001,
    );
    if (!widget.requireSave && matching.isNotEmpty) {
      await _useSaved(matching.first);
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final saved = await widget.repository.saveLocation(
        resolutionToken: preview.resolutionToken,
        label: _label.text.trim().isNotEmpty
            ? _label.text.trim()
            : displayAddress(preview.formattedAddress ?? description).substring(
                0,
                displayAddress(
                  preview.formattedAddress ?? description,
                ).length.clamp(0, 60),
              ),
        kind: _kind,
        makePrimary: _makePrimary,
        addressLine: preview.needsManualDescription ? description : null,
        idempotencyKey: _idempotencyKey ??= newIdempotencyKey(),
      );
      if (!mounted) return;
      Navigator.of(context).pop(
        DiscoveryOrigin.saved(
          locationId: saved.id,
          label: displayAddress(saved.formattedAddress),
          point: saved.point,
        ),
      );
    } on DiscoveryFailure catch (error) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _error = error.message;
        if (error.code == 'LOCATION_RESOLUTION_EXPIRED') _preview = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final keyboard =
              MediaQuery.viewInsetsOf(context).bottom > 0 &&
              _searchFocus.hasFocus;
          final maxCardHeight = constraints.maxHeight * 0.48;
          final bottom = keyboard
              ? 0.0
              : _cardHeight.clamp(0.0, maxCardHeight).toDouble() + 12;
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => _measureDetails(),
          );
          return Stack(
            children: [
              Positioned.fill(
                child: IgnorePointer(ignoring: _saving, child: _pinMap(bottom)),
              ),
              Positioned(
                top: 12,
                left: 16,
                right: 16,
                child: Column(
                  children: [
                    MapFloatingSurface(
                      radius: 12,
                      child: Row(
                        children: [
                          IconButton(
                            tooltip: 'Back',
                            onPressed: _saving
                                ? null
                                : () => Navigator.of(context).pop(),
                            icon: const Icon(LucideIcons.arrowLeft),
                          ),
                          Expanded(
                            child: TextField(
                              controller: _search,
                              focusNode: _searchFocus,
                              enabled: !_saving,
                              maxLength: 200,
                              decoration: const InputDecoration(
                                hintText: 'Search location',
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: BuyerTheme.action,
                                  ),
                                ),
                                filled: false,
                                counterText: '',
                              ),
                              onChanged: _searchChanged,
                            ),
                          ),
                          if (_search.text.isNotEmpty)
                            IconButton(
                              tooltip: 'Clear search',
                              onPressed: _saving
                                  ? null
                                  : () {
                                      _search.clear();
                                      _searchChanged('');
                                    },
                              icon: const Icon(LucideIcons.x),
                            ),
                        ],
                      ),
                    ),
                    if (_searching) const LinearProgressIndicator(),
                    if (_suggestions.isNotEmpty)
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: constraints.maxHeight * 0.46,
                        ),
                        child: MapFloatingSurface(
                          radius: 12,
                          child: ListView(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            children: [
                              for (final suggestion in _suggestions)
                                ListTile(
                                  leading: const Icon(LucideIcons.mapPin),
                                  title: Text(suggestion.title),
                                  subtitle: suggestion.subtitle == null
                                      ? null
                                      : Text(suggestion.subtitle!),
                                  onTap: () => _selectSuggestion(suggestion),
                                ),
                              const Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  'Google Maps',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (_error != null)
                      MapFloatingSurface(
                        radius: 8,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: AuthNotice(message: _error!, isError: true),
                        ),
                      ),
                    if (_suggestions.isEmpty && !_searching)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Wrap(
                          spacing: 8,
                          children: [
                            if (widget.savedLocations.isNotEmpty)
                              ActionChip(
                                label: const Text('Saved locations'),
                                onPressed: _saving ? null : _showSaved,
                              ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              if (!keyboard)
                Positioned(
                  right: 16,
                  bottom: bottom + 12,
                  child: MapFloatingSurface(
                    radius: 999,
                    child: IconButton(
                      tooltip: 'Use current location',
                      onPressed: _busy || _saving ? null : _useDevice,
                      icon: const Icon(LucideIcons.locateFixed),
                    ),
                  ),
                ),
              if (!keyboard)
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 12,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: maxCardHeight),
                    child: MapFloatingSurface(
                      key: _detailsKey,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: _details(),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    ),
  );

  Future<void> _showSaved() => showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) => ListView(
      shrinkWrap: true,
      children: [
        for (final location in widget.savedLocations.where(
          (item) => item.point.usable,
        ))
          ListTile(
            leading: Icon(
              location.isPrimary ? LucideIcons.house : LucideIcons.mapPin,
            ),
            title: Text(location.label),
            subtitle: Text(location.formattedAddress),
            onTap: () {
              Navigator.of(sheetContext).pop();
              _useSaved(location);
            },
          ),
      ],
    ),
  );

  Widget _pinMap(double bottom) {
    if (!widget.mapsAvailable) {
      return const ColoredBox(
        color: BuyerTheme.canvas,
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'The map is unavailable. Use Search location to choose an address.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }
    return Stack(
      children: [
        Positioned.fill(
          child: GoogleMap(
            cameraTargetBounds: PhilippineMapView.cameraBounds,
            minMaxZoomPreference: PhilippineMapView.zoomRange,
            initialCameraPosition: CameraPosition(
              target: LatLng(_pin.latitude, _pin.longitude),
              zoom: 16,
            ),
            onMapCreated: (controller) => _map = controller,
            gestureRecognizers: {
              Factory<OneSequenceGestureRecognizer>(EagerGestureRecognizer.new),
            },
            padding: EdgeInsets.only(top: 100, bottom: bottom + 16),
            onCameraMoveStarted: () {
              if (_programmaticMove || _saving) return;
              _resolveSequence++;
              setState(() {
                _pinMoving = true;
                _preview = null;
                _busy = false;
              });
            },
            onCameraMove: (position) => _pin = GeoPoint(
              position.target.latitude,
              position.target.longitude,
            ),
            onCameraIdle: () {
              if (_programmaticMove) {
                _programmaticMove = false;
                final target = _cameraTarget;
                if (target != null &&
                    (target.latitude - _pin.latitude).abs() < 0.00001 &&
                    (target.longitude - _pin.longitude).abs() < 0.00001) {
                  return;
                }
                // A gesture interrupted the camera move: resolve its actual resting point.
                _pinMoving = true;
              }
              if (!_pinMoving || _saving) return;
              setState(() => _pinMoving = false);
              _resolve(
                () => widget.repository.resolvePoint(_pin, device: false),
                OriginSource.mapPin,
              );
            },
            onTap: (point) async {
              if (_saving) return;
              final selected = GeoPoint(point.latitude, point.longitude);
              await _moveCamera(selected);
              await _resolve(
                () => widget.repository.resolvePoint(selected, device: false),
                OriginSource.mapPin,
              );
            },
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            rotateGesturesEnabled: false,
            tiltGesturesEnabled: false,
          ),
        ),
        Positioned.fill(
          top: 100,
          bottom: bottom + 16,
          child: const IgnorePointer(
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: 48),
                child: Icon(
                  Icons.location_pin,
                  size: 48,
                  color: BuyerTheme.action,
                  semanticLabel: 'Selected location pin',
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _details() => Form(
    key: _confirmForm,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Location Details',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        if (_busy) const LinearProgressIndicator(),
        if (_preview?.formattedAddress != null)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                LucideIcons.mapPin,
                color: BuyerTheme.action,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(child: Text(_preview!.formattedAddress!)),
            ],
          )
        else if (_preview != null) ...[
          const Text(
            'Address lookup is unavailable. Describe this pinned location.',
          ),
          TextFormField(
            controller: _description,
            maxLength: 300,
            decoration: const InputDecoration(
              labelText: 'Address or landmark description',
            ),
            validator: _required,
          ),
        ] else
          Text(
            _pinMoving
                ? 'Move the map to position the pin.'
                : _busy
                ? 'Resolving selected location…'
                : 'Search a location or move the map to choose a pin.',
          ),
        if (widget.requireSave && _preview != null) ...[
          TextFormField(
            controller: _label,
            maxLength: 60,
            decoration: const InputDecoration(
              labelText: 'Location label (optional)',
            ),
          ),
          DropdownButtonFormField<String>(
            initialValue: _kind,
            isExpanded: true,
            decoration: const InputDecoration(labelText: 'Location type'),
            items: [
              for (final entry in kLocationKinds.entries)
                DropdownMenuItem(value: entry.key, child: Text(entry.value)),
            ],
            onChanged: (value) => setState(() => _kind = value ?? 'DELIVERY'),
          ),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Make this my primary location'),
            value: _makePrimary,
            onChanged: (value) => setState(() => _makePrimary = value ?? false),
          ),
        ],
        const SizedBox(height: 12),
        FilledButton(
          onPressed: _busy || _saving || _pinMoving || _preview == null
              ? null
              : _confirm,
          child: Text(_saving ? 'Saving…' : 'Choose Location'),
        ),
        if (!widget.requireSave)
          const Text(
            'Your choice will be saved for your next visit.',
            style: TextStyle(fontSize: 12, color: BuyerTheme.muted),
            textAlign: TextAlign.center,
          ),
      ],
    ),
  );

  String? _required(String? value) =>
      value == null || value.trim().isEmpty ? 'This field is required.' : null;
}
