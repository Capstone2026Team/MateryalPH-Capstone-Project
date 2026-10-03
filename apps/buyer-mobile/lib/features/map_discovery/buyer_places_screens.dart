import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../design_system/components/buyer_app_bar.dart';
import '../../widgets/auth_content.dart';
import 'device_location.dart';
import 'discovery_models.dart';
import 'discovery_repository.dart';
import 'select_location_screen.dart';
import 'supplier_map.dart';

/// Profile > Saved Locations: add, choose primary and remove (archive) the Buyer's own locations.
class SavedLocationsScreen extends StatefulWidget {
  const SavedLocationsScreen({
    super.key,
    required this.repository,
    required this.deviceLocation,
  });

  final DiscoveryRepository repository;
  final DeviceLocationService deviceLocation;

  @override
  State<SavedLocationsScreen> createState() => _SavedLocationsScreenState();
}

class _SavedLocationsScreenState extends State<SavedLocationsScreen> {
  List<SavedLocationView>? _locations;
  String? _error;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final locations = await widget.repository.locations();
      if (mounted) setState(() => _locations = locations);
    } on DiscoveryFailure catch (error) {
      if (mounted) setState(() => _error = error.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _run(Future<void> Function() action) async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await action();
      await _load();
    } on DiscoveryFailure catch (error) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _error =
            error.kind == DiscoveryFailureKind.conflict &&
                error.code != 'PRIMARY_LOCATION_REQUIRED'
            ? 'This location changed on another device. The list has been refreshed.'
            : error.message;
      });
      if (error.kind == DiscoveryFailureKind.conflict) await _load();
    }
  }

  Future<void> _add() async {
    await Navigator.of(context).push<DiscoveryOrigin>(
      MaterialPageRoute(
        builder: (_) => SelectLocationScreen(
          repository: widget.repository,
          deviceLocation: widget.deviceLocation,
          savedLocations: _locations ?? const [],
          mapsAvailable: kMapsClientConfigured,
          requireSave: true,
        ),
      ),
    );
    if (mounted) await _load();
  }

  Future<void> _remove(SavedLocationView location) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Remove ${location.label}?'),
        content: const Text(
          'It will no longer appear in your saved locations. Past orders keep their captured address.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Keep'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await _run(() => widget.repository.removeLocation(location));
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    appBar: buyerAppBar(context, 'Saved Locations'),
    floatingActionButton: FloatingActionButton.extended(
      onPressed: _busy ? null : _add,
      icon: const Icon(LucideIcons.plus),
      label: const Text('Add location'),
    ),
    body: SafeArea(
      child: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
          children: [
            if (_busy) const LinearProgressIndicator(),
            if (_error != null) ...[
              AuthNotice(message: _error!, isError: true),
              TextButton(onPressed: _load, child: const Text('Retry')),
            ],
            if (_locations != null && _locations!.isEmpty)
              const Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  'No saved locations yet. Add one to reuse it for browsing, projects and orders.',
                ),
              ),
            for (final location
                in _locations ?? const <SavedLocationView>[]) ...[
              ListTile(
                contentPadding: EdgeInsets.zero,
                minTileHeight: 72,
                leading: Icon(
                  location.isPrimary ? LucideIcons.house : LucideIcons.mapPin,
                ),
                title: Text(
                  '${location.label}${location.isPrimary ? ' · Primary' : ''}',
                ),
                subtitle: Text(
                  '${kLocationKinds[location.kind] ?? location.kind}\n${location.formattedAddress}\n${location.psgc.description}',
                ),
                isThreeLine: true,
                trailing: PopupMenuButton<String>(
                  tooltip: 'Actions for ${location.label}',
                  onSelected: (action) => action == 'primary'
                      ? _run(() => widget.repository.makePrimary(location))
                      : _remove(location),
                  itemBuilder: (_) => [
                    if (!location.isPrimary)
                      const PopupMenuItem(
                        value: 'primary',
                        child: Text('Make primary'),
                      ),
                    const PopupMenuItem(value: 'remove', child: Text('Remove')),
                  ],
                ),
              ),
              const Divider(height: 1),
            ],
          ],
        ),
      ),
    ),
  );
}

/// Profile > Favorite Suppliers: the Buyer's personal list of Verified Vendors.
class FavoriteSuppliersScreen extends StatefulWidget {
  const FavoriteSuppliersScreen({
    super.key,
    required this.repository,
    this.onRemove,
  });
  final DiscoveryRepository repository;
  final Future<void> Function(String vendorId)? onRemove;

  @override
  State<FavoriteSuppliersScreen> createState() =>
      _FavoriteSuppliersScreenState();
}

class _FavoriteSuppliersScreenState extends State<FavoriteSuppliersScreen> {
  List<FavoriteSupplierView>? _favorites;
  String? _error;
  final Set<String> _removing = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _error = null);
    try {
      final favorites = await widget.repository.favorites();
      if (mounted) setState(() => _favorites = favorites);
    } on DiscoveryFailure catch (error) {
      if (mounted) setState(() => _error = error.message);
    }
  }

  Future<void> _remove(FavoriteSupplierView favorite) async {
    if (_removing.contains(favorite.vendorId)) return;
    setState(() => _removing.add(favorite.vendorId));
    try {
      if (widget.onRemove != null) {
        await widget.onRemove!(favorite.vendorId);
      } else {
        await widget.repository.setFavorite(favorite.vendorId, favorite: false);
      }
      if (mounted) await _load();
    } on DiscoveryFailure catch (error) {
      if (mounted) setState(() => _error = error.message);
    } finally {
      if (mounted) setState(() => _removing.remove(favorite.vendorId));
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    appBar: buyerAppBar(context, 'Favorite Suppliers'),
    body: SafeArea(
      child: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          children: [
            if (_favorites == null && _error == null)
              const LinearProgressIndicator(),
            if (_error != null) ...[
              AuthNotice(message: _error!, isError: true),
              TextButton(onPressed: _load, child: const Text('Retry')),
            ],
            if (_favorites != null && _favorites!.isEmpty)
              const Text(
                'No Favorite Suppliers yet. Save a Verified Vendor from its map preview.',
              ),
            for (final favorite
                in _favorites ?? const <FavoriteSupplierView>[]) ...[
              ListTile(
                contentPadding: EdgeInsets.zero,
                minTileHeight: 64,
                leading: const Icon(LucideIcons.star),
                title: Text(favorite.name),
                subtitle: Text(
                  '${favorite.scoreText} · ${favorite.currentlyDiscoverable ? 'Currently offering products' : 'No current eligible offerings'}',
                ),
                trailing: IconButton(
                  tooltip: 'Remove ${favorite.name} from favorites',
                  onPressed: _removing.contains(favorite.vendorId)
                      ? null
                      : () => _remove(favorite),
                  icon: const Icon(LucideIcons.x),
                ),
              ),
              const Divider(height: 1),
            ],
          ],
        ),
      ),
    ),
  );
}
