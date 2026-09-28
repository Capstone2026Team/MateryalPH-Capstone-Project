import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../design_system/theme.dart';
import '../../widgets/auth_content.dart';
import 'device_location.dart';
import 'discovery_models.dart';
import 'discovery_repository.dart';
import 'select_location_screen.dart';

/// First-entry location page, shown full screen before Map Home has an origin. The current device
/// location is optional: "Select it manually" opens the saved location, address search and pin
/// alternatives, and a denied permission never blocks them. Pops with the chosen
/// [DiscoveryOrigin], or null when the Buyer leaves without choosing.
class LocationWelcomeScreen extends StatefulWidget {
  const LocationWelcomeScreen({
    super.key,
    required this.repository,
    required this.deviceLocation,
    required this.savedLocations,
    required this.mapsAvailable,
  });

  final DiscoveryRepository repository;
  final DeviceLocationService deviceLocation;
  final List<SavedLocationView> savedLocations;
  final bool mapsAvailable;

  @override
  State<LocationWelcomeScreen> createState() => _LocationWelcomeScreenState();
}

class _LocationWelcomeScreenState extends State<LocationWelcomeScreen> {
  bool _locating = false;
  DeviceLocationStatus? _denied;

  Future<void> _useCurrent() async {
    setState(() {
      _locating = true;
      _denied = null;
    });
    final result = await widget.deviceLocation.requestCurrent();
    if (!mounted) return;
    final point = result.point;
    if (result.status != DeviceLocationStatus.granted || point == null) {
      setState(() {
        _locating = false;
        _denied = result.status;
      });
      return;
    }
    Navigator.of(context).pop(
      DiscoveryOrigin.point(
        point: point,
        source: OriginSource.device,
        label: await _addressFor(point),
      ),
    );
  }

  /// The street address of the device point for the header. The point alone still drives
  /// discovery, so a failed lookup falls back to a generic label instead of blocking.
  Future<String> _addressFor(GeoPoint point) async {
    try {
      final preview = await widget.repository.resolvePoint(point, device: true);
      final address = preview.formattedAddress;
      return address == null ? 'Current location' : displayAddress(address);
    } on DiscoveryFailure {
      return 'Current location';
    }
  }

  Future<void> _selectManually() async {
    final origin = await Navigator.of(context).push<DiscoveryOrigin>(
      MaterialPageRoute(
        builder: (_) => SelectLocationScreen(
          repository: widget.repository,
          deviceLocation: widget.deviceLocation,
          savedLocations: widget.savedLocations,
          mapsAvailable: widget.mapsAvailable,
        ),
      ),
    );
    if (origin != null && mounted) Navigator.of(context).pop(origin);
  }

  String? get _notice => switch (_denied) {
    null => null,
    DeviceLocationStatus.serviceDisabled =>
      'Location services are off. Select a location manually instead.',
    DeviceLocationStatus.deniedForever =>
      'Location permission is blocked for MateryalPH. You can allow it in Settings, or select a location manually.',
    DeviceLocationStatus.denied =>
      'Location permission was not granted. Select a location manually to continue.',
    _ =>
      'Your current location is unavailable. Select a location manually instead.',
  };

  @override
  @override
  Widget build(BuildContext context) {
    final notice = _notice;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          // A minimum-height column spreads the message and the actions apart on tall screens
          // and scrolls on short screens or large text, without intrinsic measurement.
          builder: (context, constraints) => SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                  maxWidth: 560,
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 24),
                          Center(
                            child: Image.asset(
                              'assets/states/location.png',
                              height: 220,
                              excludeFromSemantics: true,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Semantics(
                            header: true,
                            child: Text(
                              'Hi, nice to meet you!',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Choose your location to find construction suppliers around you. Using your current location is optional.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: BuyerTheme.muted),
                          ),
                          if (notice != null) ...[
                            const SizedBox(height: 16),
                            AuthNotice(message: notice, isError: true),
                            if (_denied == DeviceLocationStatus.deniedForever)
                              TextButton(
                                onPressed: widget.deviceLocation.openSettings,
                                child: const Text('Open Settings'),
                              ),
                          ],
                        ],
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 24),
                          FilledButton.icon(
                            onPressed: _locating ? null : _useCurrent,
                            icon: _locating
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(LucideIcons.locateFixed),
                            label: Text(
                              _locating
                                  ? 'Finding your location…'
                                  : 'Use current location',
                            ),
                          ),
                          const SizedBox(height: 12),
                          FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: BuyerTheme.brandSoft,
                              foregroundColor: BuyerTheme.actionPressed,
                            ),
                            onPressed: _locating ? null : _selectManually,
                            child: const Text('Select it manually'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
