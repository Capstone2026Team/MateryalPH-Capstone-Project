import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../design_system/motion.dart';
import '../../design_system/theme.dart';
import '../../widgets/auth_content.dart';
import 'device_location.dart';
import 'discovery_models.dart';
import 'discovery_repository.dart';

const Map<String, String> kLocationKinds = {
  'DELIVERY': 'Delivery address',
  'PROJECT_SITE': 'Project site',
  'BUSINESS': 'Business address',
  'PICKUP_REFERENCE': 'Pickup reference',
  'OTHER': 'Other',
};

/// Select Location with three complete alternatives: saved locations, a typed address and a
/// dropped pin. Current device location is optional and asked only when the Buyer chooses it.
/// Returns the chosen [DiscoveryOrigin]; nothing is saved unless the Buyer turns on "Save this
/// location". Coordinates are never shown or typed; the pin map owns its drag gestures so tabs
/// and scrolling never steal them.
class SelectLocationScreen extends StatefulWidget {
  const SelectLocationScreen({
    super.key,
    required this.repository,
    required this.deviceLocation,
    required this.savedLocations,
    required this.mapsAvailable,
    this.initialPoint,
    this.requireSave = false,
  });

  final DiscoveryRepository repository;
  final DeviceLocationService deviceLocation;
  final List<SavedLocationView> savedLocations;
  final bool mapsAvailable;
  final GeoPoint? initialPoint;
  final bool requireSave;

  @override
  State<SelectLocationScreen> createState() => _SelectLocationScreenState();
}

class _SelectLocationScreenState extends State<SelectLocationScreen> {
  final _address = TextEditingController();
  final _barangay = TextEditingController();
  final _city = TextEditingController();
  final _province = TextEditingController();
  final _postal = TextEditingController();
  final _label = TextEditingController();
  final _description = TextEditingController();
  final _addressForm = GlobalKey<FormState>();
  final _confirmForm = GlobalKey<FormState>();

  LocationPreviewView? _preview;
  OriginSource _previewSource = OriginSource.mapPin;
  String? _idempotencyKey;
  bool _busy = false;
  String? _error;
  late bool _save = widget.requireSave;
  bool _makePrimary = false;
  String _kind = 'DELIVERY';
  late GeoPoint _pin = widget.initialPoint ?? const GeoPoint(14.5995, 120.9842);
  bool _pinMoving = false;
  int _resolveSequence = 0;

  @override
  void dispose() {
    for (final controller in [
      _address,
      _barangay,
      _city,
      _province,
      _postal,
      _label,
      _description,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _resolve(
    Future<LocationPreviewView> Function() request,
    OriginSource source,
  ) async {
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
        _previewSource = source;
        _idempotencyKey = newIdempotencyKey();
        _description.clear();
      });
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
    setState(() => _error = null);
    final result = await widget.deviceLocation.requestCurrent();
    if (!mounted) return;
    if (result.status != DeviceLocationStatus.granted || result.point == null) {
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
    final preview = _preview;
    if (preview == null || !(_confirmForm.currentState?.validate() ?? false)) {
      return;
    }
    final description = _description.text.trim();
    if (!_save) {
      Navigator.of(context).pop(
        DiscoveryOrigin.point(
          point: preview.point,
          source: _previewSource,
          label: preview.formattedAddress != null
              ? displayAddress(preview.formattedAddress!)
              : (description.isEmpty ? 'Pinned location' : description),
        ),
      );
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final saved = await widget.repository.saveLocation(
        resolutionToken: preview.resolutionToken,
        label: _label.text.trim(),
        kind: _kind,
        makePrimary: _makePrimary,
        addressLine: preview.needsManualDescription ? description : null,
        idempotencyKey: _idempotencyKey ??= newIdempotencyKey(),
      );
      if (!mounted) return;
      Navigator.of(context).pop(
        DiscoveryOrigin.saved(
          locationId: saved.id,
          label: saved.label,
          point: saved.point,
        ),
      );
    } on DiscoveryFailure catch (error) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _error = error.message;
        if (error.code == 'LOCATION_RESOLUTION_EXPIRED') _preview = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) => DefaultTabController(
    length: 3,
    initialIndex: widget.savedLocations.isEmpty || widget.requireSave ? 1 : 0,
    child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.requireSave ? 'Add saved location' : 'Select location',
        ),
        bottom: const TabBar(
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          tabs: [
            Tab(text: 'Saved locations'),
            Tab(text: 'Search address'),
            Tab(text: 'Drop pin'),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: OutlinedButton.icon(
                onPressed: _busy ? null : _useDevice,
                icon: const Icon(LucideIcons.locateFixed, size: 18),
                label: const Text('Use current location (optional)'),
              ),
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: AuthNotice(message: _error!, isError: true),
              ),
            if (_busy)
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: LinearProgressIndicator(),
              ),
            Expanded(
              child: _preview != null
                  ? _confirmation(_preview!)
                  : TabBarView(
                      // Tabs change by tapping only, so a sideways drag on the pin map pans the
                      // map instead of switching tabs.
                      physics: const NeverScrollableScrollPhysics(),
                      children: [_saved(), _addressTab(), _pinTab()],
                    ),
            ),
          ],
        ),
      ),
    ),
  );

  Widget _saved() => widget.savedLocations.isEmpty
      ? const Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'You have no saved locations yet. Search an address or drop a pin to add one.',
          ),
        )
      : ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: widget.savedLocations.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final location = widget.savedLocations[index];
            return ListTile(
              minTileHeight: 64,
              leading: Icon(
                location.isPrimary ? LucideIcons.house : LucideIcons.mapPin,
              ),
              title: Text(
                '${location.label}${location.isPrimary ? ' (primary)' : ''}',
              ),
              subtitle: Text(
                '${location.formattedAddress}\n${location.psgc.description}',
              ),
              isThreeLine: true,
              onTap: widget.requireSave
                  ? null
                  : () => Navigator.of(context).pop(
                      DiscoveryOrigin.saved(
                        locationId: location.id,
                        label: location.label,
                        point: location.point,
                      ),
                    ),
            );
          },
        );

  Widget _addressTab() => AuthContent(
    child: Form(
      key: _addressForm,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _address,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Street, building or landmark',
            ),
            validator: _required,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _barangay,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(labelText: 'Barangay (optional)'),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _city,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'City or municipality',
            ),
            validator: _required,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _province,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(labelText: 'Province (optional)'),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _postal,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'ZIP code (optional)'),
            validator: (value) =>
                value == null ||
                    value.trim().isEmpty ||
                    RegExp(r'^\d{4}$').hasMatch(value.trim())
                ? null
                : 'Enter a 4-digit ZIP code.',
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _busy
                ? null
                : () {
                    if (!(_addressForm.currentState?.validate() ?? false)) {
                      return;
                    }
                    _resolve(
                      () => widget.repository.resolveAddress(
                        addressLine: _address.text.trim(),
                        cityMunicipality: _city.text.trim(),
                        barangay: _barangay.text,
                        province: _province.text,
                        postalCode: _postal.text,
                      ),
                      OriginSource.search,
                    );
                  },
            child: const Text('Find address'),
          ),
          const SizedBox(height: 8),
          const Text(
            'If the address cannot be found, drop a pin instead.',
            style: TextStyle(color: BuyerTheme.muted),
          ),
        ],
      ),
    ),
  );

  /// Full-height pin map. The fixed centre pin marks the chosen point; the Buyer drags the map
  /// underneath it. An eager recognizer gives the map every drag, pinch and fling first.
  Widget _pinTab() {
    if (!widget.mapsAvailable) {
      return const AuthContent(
        child: AuthNotice(
          message:
              'The map is not available in this build. Use Search address to choose a location.',
        ),
      );
    }
    final reduce = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    return Stack(
      children: [
        Positioned.fill(
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(_pin.latitude, _pin.longitude),
              zoom: 16,
            ),
            gestureRecognizers: {
              Factory<OneSequenceGestureRecognizer>(EagerGestureRecognizer.new),
            },
            onCameraMoveStarted: () => setState(() => _pinMoving = true),
            onCameraMove: (position) => _pin = GeoPoint(
              position.target.latitude,
              position.target.longitude,
            ),
            onCameraIdle: () {
              if (_pinMoving) setState(() => _pinMoving = false);
            },
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            rotateGesturesEnabled: false,
            tiltGesturesEnabled: false,
          ),
        ),
        IgnorePointer(
          child: Center(
            child: AnimatedPadding(
              duration: reduce ? Duration.zero : MateryalMotionTokens.fast,
              curve: BuyerMotion.enter,
              // The pin's tip sits on the map centre; it lifts slightly while the map moves.
              padding: EdgeInsets.only(bottom: _pinMoving ? 60 : 48),
              child: const Icon(
                Icons.location_pin,
                size: 48,
                color: BuyerTheme.action,
                semanticLabel: 'Pin at the map centre',
              ),
            ),
          ),
        ),
        const Positioned(
          top: 12,
          left: 16,
          right: 16,
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(12)),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x240F172A),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Row(
                  children: [
                    Icon(LucideIcons.move, size: 18, color: BuyerTheme.muted),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Drag the map to place the pin on the exact spot.',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          left: 16,
          right: 16,
          bottom: 16,
          child: FilledButton.icon(
            onPressed: _busy || _pinMoving
                ? null
                : () => _resolve(
                    () => widget.repository.resolvePoint(_pin, device: false),
                    OriginSource.mapPin,
                  ),
            icon: const Icon(LucideIcons.mapPin, size: 20),
            label: const Text('Use this pin'),
          ),
        ),
      ],
    );
  }

  Widget _confirmation(LocationPreviewView preview) => AuthContent(
    child: Form(
      key: _confirmForm,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            header: true,
            child: Text(
              'Location details',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const SizedBox(height: 8),
          if (preview.formattedAddress != null)
            Text(
              preview.formattedAddress!,
              style: const TextStyle(fontWeight: FontWeight.w600),
            )
          else ...[
            AuthNotice(
              message: preview.providerStatus == 'UNAVAILABLE'
                  ? 'Address lookup is unavailable, but your pin is kept. Describe the place so you recognize it later.'
                  : 'No street address was found for this pin. Describe the place so you recognize it later.',
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _description,
              decoration: const InputDecoration(
                labelText: 'Address or landmark description',
              ),
              validator: (value) => _save ? _required(value) : null,
            ),
          ],
          const SizedBox(height: 8),
          Text(
            preview.psgc.description,
            style: const TextStyle(color: BuyerTheme.muted),
          ),
          const Divider(height: 32),
          if (!widget.requireSave)
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Save this location'),
              subtitle: const Text(
                'Saved locations can be reused for browsing, projects and orders.',
              ),
              value: _save,
              onChanged: (value) => setState(() => _save = value),
            ),
          if (_save) ...[
            TextFormField(
              controller: _label,
              maxLength: 60,
              decoration: const InputDecoration(
                labelText: 'Label, e.g. Home or Taguig site',
              ),
              validator: _required,
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
              onChanged: (value) =>
                  setState(() => _makePrimary = value ?? false),
            ),
          ],
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _busy ? null : _confirm,
            child: Text(_save ? 'Save and use location' : 'Use this location'),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: _busy ? null : () => setState(() => _preview = null),
            child: const Text('Choose a different location'),
          ),
        ],
      ),
    ),
  );

  String? _required(String? value) =>
      value == null || value.trim().isEmpty ? 'This field is required.' : null;
}
