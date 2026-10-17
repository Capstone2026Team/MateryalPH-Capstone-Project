import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../design_system/components/procurement_components.dart';
import '../../design_system/theme.dart';
import '../map_discovery/discovery_models.dart';
import 'cart_controller.dart';
import 'procurement_models.dart';

class CartDestinationSection extends StatefulWidget {
  const CartDestinationSection({
    super.key,
    required this.controller,
    required this.destination,
    required this.savedLocations,
    this.chooseDropOff,
    this.onSaved,
  });

  final Future<void> Function()? onSaved;
  final CartController controller;
  final CartDestinationView destination;
  final List<SavedLocationView> savedLocations;
  final Future<DiscoveryOrigin?> Function(
    BuildContext context, {
    required bool useCurrent,
  })?
  chooseDropOff;

  @override
  State<CartDestinationSection> createState() => _CartDestinationSectionState();
}

class _CartDestinationSectionState extends State<CartDestinationSection> {
  late String? _intended = widget.destination.intended?.locationId;
  late String _restriction = widget.destination.heavyVehicleRestriction;
  late String? _alternate = widget.destination.alternateDropOff?.locationId;
  late String? _alternateLabel = widget.destination.alternateDropOff?.title;
  late final TextEditingController _instructions = TextEditingController(
    text: widget.destination.accessInstructions ?? '',
  );

  late String? _intendedLabel = widget.destination.intended?.title;

  Future<void> _pickIntended({required bool useCurrent}) async {
    final origin = await widget.chooseDropOff!(context, useCurrent: useCurrent);
    if (!mounted || origin?.locationId == null) return;
    setState(() {
      _intended = origin!.locationId;
      _intendedLabel = origin.label;
      _errors = {..._errors}..remove('intended_location_id');
    });
  }

  Future<void> _pickDropOff({required bool useCurrent}) async {
    final origin = await widget.chooseDropOff!(context, useCurrent: useCurrent);
    if (!mounted || origin?.locationId == null) return;
    setState(() {
      _alternate = origin!.locationId;
      _alternateLabel = origin.label;
      _errors = {..._errors}..remove('alternate_drop_off_location_id');
    });
  }

  Map<String, Object?> _errors = const {};
  bool _editing = false;

  @override
  void dispose() {
    _instructions.dispose();
    super.dispose();
  }

  String? _error(String field) {
    final value = _errors[field];
    if (value is List && value.isNotEmpty) return '${value.first}';
    return value is String ? value : null;
  }

  Future<void> _save() async {
    final local = <String, Object?>{};
    if (_intended == null) {
      local['intended_location_id'] =
          'Choose the intended destination or Project site.';
    }
    if (_restriction == 'UNANSWERED') {
      local['heavy_vehicle_restriction'] = 'Answer the heavy-vehicle question.';
    }
    if (_restriction == 'YES') {
      if (_alternate == null) {
        local['alternate_drop_off_location_id'] =
            'A heavy-vehicle restriction needs an alternative drop-off location.';
      } else if (_alternate == _intended) {
        local['alternate_drop_off_location_id'] =
            'Choose a drop-off different from the intended destination.';
      }
      if (_instructions.text.trim().length < 5) {
        local['access_instructions'] =
            'Describe access and unloading at the alternative drop-off.';
      }
    }
    if (local.isNotEmpty) {
      setState(() => _errors = local);
      return;
    }
    final errors = await widget.controller.setDestination(
      intendedLocationId: _intended,
      heavyVehicleRestriction: _restriction,
      alternateDropOffLocationId: _restriction == 'YES' ? _alternate : null,
      accessInstructions: _instructions.text.trim().isEmpty
          ? null
          : _instructions.text.trim(),
    );
    if (!mounted) return;
    setState(() {
      _errors = errors ?? const {};
      if (errors == null) _editing = false;
    });
    if (errors == null) {
      await (widget.onSaved?.call() ?? widget.controller.loadPreview());
    }
  }

  @override
  Widget build(BuildContext context) {
    final locations = widget.savedLocations;
    final destination = widget.destination;
    final incomplete =
        destination.intended == null ||
        destination.heavyVehicleRestriction == 'UNANSWERED';
    return ProcurementReviewCard(
      children: [
        _AddressSummary(
          destination: destination,
          expanded: _editing || incomplete,
          onTap: incomplete ? null : () => setState(() => _editing = !_editing),
        ),
        if (locations.isEmpty && widget.chooseDropOff == null)
          const Padding(
            padding: EdgeInsets.only(top: 10),
            child: StatusBand(
              tone: BandTone.warning,
              title: 'Save a location first',
              message:
                  'Delivery needs a saved location. Add one from the Map’s location selector.',
            ),
          )
        else if (_editing || incomplete) ...[
          const Divider(height: 24),
          if (widget.chooseDropOff == null)
            _LocationPicker(
              label: destination.intendedLabel,
              locations: locations,
              selected: _intended,
              error: _error('intended_location_id'),
              onChanged: (value) => setState(() => _intended = value),
            )
          else
            _DropOffChooser(
              label: destination.intendedLabel,
              chosen: _intended == null ? null : _intendedLabel,
              error: _error('intended_location_id'),
              busy: widget.controller.busy,
              onCurrent: () => _pickIntended(useCurrent: true),
              onPick: () => _pickIntended(useCurrent: false),
            ),
          if (destination.intended != null && !destination.intended!.active)
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: StatusBand(
                tone: BandTone.warning,
                title: 'Your earlier destination was removed',
                message:
                    'Choose it again or pick another. It is never replaced automatically.',
              ),
            ),
          const SizedBox(height: 12),
          Text(
            'Do you know of a heavy-vehicle restriction at this site?',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          RadioGroup<String>(
            groupValue: _restriction == 'UNANSWERED' ? null : _restriction,
            onChanged: (value) =>
                setState(() => _restriction = value ?? 'UNANSWERED'),
            child: const Column(
              children: [
                RadioListTile<String>(
                  value: 'NO',
                  contentPadding: EdgeInsets.zero,
                  title: Text('No known restriction'),
                  subtitle: Text(
                    'Vehicles go to the intended destination. Access is still confirmed by the Vendor.',
                  ),
                ),
                RadioListTile<String>(
                  value: 'YES',
                  contentPadding: EdgeInsets.zero,
                  title: Text('Yes, trucks cannot reach it'),
                  subtitle: Text(
                    'Choose an alternative drop-off that delivery vehicles can reach.',
                  ),
                ),
              ],
            ),
          ),
          if (_error('heavy_vehicle_restriction') != null)
            Text(
              _error('heavy_vehicle_restriction')!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          if (_restriction == 'YES') ...[
            if (widget.chooseDropOff == null)
              _LocationPicker(
                label: '${destination.endpointLabel} (alternative drop-off)',
                locations: locations,
                selected: _alternate,
                error: _error('alternate_drop_off_location_id'),
                onChanged: (value) => setState(() => _alternate = value),
              )
            else
              _DropOffChooser(
                label: '${destination.endpointLabel} (alternative drop-off)',
                chosen: _alternate == null ? null : _alternateLabel,
                error: _error('alternate_drop_off_location_id'),
                busy: widget.controller.busy,
                onCurrent: () => _pickDropOff(useCurrent: true),
                onPick: () => _pickDropOff(useCurrent: false),
              ),
            const SizedBox(height: 12),
            TextField(
              controller: _instructions,
              maxLength: 500,
              minLines: 2,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Access and unloading instructions (required)',
                errorText: _error('access_instructions'),
              ),
            ),
          ],
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: widget.controller.busy ? null : _save,
            child: const Text('Save destination'),
          ),
        ],
      ],
    );
  }
}

/// The delivery address card: the intended destination / Project site and, when it differs, the
/// actual vehicle drop-off used for the route and fee. Both stay labelled.
class _AddressSummary extends StatelessWidget {
  const _AddressSummary({
    required this.destination,
    required this.expanded,
    this.onTap,
  });

  final CartDestinationView destination;
  final bool expanded;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final intended = destination.intended;
    final alternate = destination.alternateDropOff;
    final endpoint = destination.vehicleEndpoint == 'ALTERNATE_DROP_OFF'
        ? alternate
        : intended;
    final kind = switch (intended?.kind) {
      'PROJECT_SITE' => 'Project site',
      'DELIVERY' => 'Delivery',
      'HOME' => 'Home',
      'OFFICE' => 'Office',
      _ => null,
    };
    return Semantics(
      container: true,
      button: onTap != null,
      label: onTap == null ? null : 'Change delivery address',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 2),
              child: Icon(
                LucideIcons.mapPin,
                size: 20,
                color: BuyerTheme.action,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        destination.intendedLabel,
                        style: const TextStyle(
                          fontSize: 12,
                          color: BuyerTheme.muted,
                        ),
                      ),
                      if (kind != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: BuyerTheme.action,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            kind,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                  Text(
                    intended?.title ?? 'Choose a delivery address',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  if (intended?.formattedAddress != null &&
                      intended!.formattedAddress != intended.title)
                    Text(
                      intended.formattedAddress!,
                      style: const TextStyle(fontSize: 13),
                    ),
                  if (intended != null && endpoint != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 2),
                          child: Icon(
                            LucideIcons.truck,
                            size: 16,
                            color: BuyerTheme.muted,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            '${destination.endpointLabel}: ${endpoint.title}${destination.vehicleEndpoint == 'ALTERNATE_DROP_OFF' ? ' — used for route distance and the delivery fee' : ''}',
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            if (onTap != null)
              Icon(
                expanded ? LucideIcons.chevronUp : LucideIcons.chevronRight,
                color: BuyerTheme.action,
              ),
          ],
        ),
      ),
    );
  }
}

/// Alternative drop-off entry: use the device location or search/pin a point on the map, instead
/// of choosing from saved locations.
class _DropOffChooser extends StatelessWidget {
  const _DropOffChooser({
    required this.label,
    required this.chosen,
    required this.busy,
    required this.onCurrent,
    required this.onPick,
    this.error,
  });

  final String label;
  final String? chosen;
  final bool busy;
  final VoidCallback onCurrent;
  final VoidCallback onPick;
  final String? error;

  @override
  Widget build(BuildContext context) {
    final errorColor = Theme.of(context).colorScheme.error;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        if (chosen != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  LucideIcons.mapPin,
                  size: 18,
                  color: BuyerTheme.action,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    chosen!,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
        OutlinedButton.icon(
          onPressed: busy ? null : onCurrent,
          icon: const Icon(LucideIcons.locateFixed, size: 18),
          label: const Text('Use current location'),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: busy ? null : onPick,
          icon: const Icon(LucideIcons.map, size: 18),
          label: Text(chosen == null ? 'Pick on map' : 'Pick a different spot'),
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(error!, style: TextStyle(color: errorColor)),
          ),
      ],
    );
  }
}

class _LocationPicker extends StatelessWidget {
  const _LocationPicker({
    required this.label,
    required this.locations,
    required this.selected,
    required this.onChanged,
    this.error,
  });

  final String label;
  final List<SavedLocationView> locations;
  final String? selected;
  final ValueChanged<String?> onChanged;
  final String? error;

  @override
  Widget build(BuildContext context) => DropdownButtonFormField<String>(
    initialValue: locations.any((location) => location.id == selected)
        ? selected
        : null,
    isExpanded: true,
    decoration: InputDecoration(labelText: label, errorText: error),
    items: [
      for (final location in locations)
        DropdownMenuItem(
          value: location.id,
          child: Text(
            '${location.label} · ${location.formattedAddress}',
            overflow: TextOverflow.ellipsis,
          ),
        ),
    ],
    onChanged: onChanged,
  );
}

/// Advisory delivery estimate versus the Vendor's confirmed offer, always labelled apart.
/// One recommended vehicle line. A mixer also shows how the concrete volume is
/// split into trips and the mobilization fee its Vendor charges.
String deliveryOptionLine(DeliveryOptionView option) {
  String plural(int count, String noun) =>
      '$count $noun${count == 1 ? '' : 's'}';
  final mixer = option.vehicleType == 'CONCRETE_MIXER';
  return [
    option.vehicleName,
    mixer
        ? plural(option.vehicles, 'mixer truck')
        : '${option.vehicles} vehicle(s)',
    mixer ? plural(option.trips, 'trip') : '${option.trips} trip(s)',
    if (option.volumePlan != null) option.volumePlan!.tripLoads,
    if (option.mobilizationTotalCentavos > 0)
      'includes ${formatPeso(option.mobilizationTotalCentavos)} mobilization ${option.mobilizationBasis == 'PER_TRIP' ? 'per trip' : 'per truck'}',
    formatPeso(option.feeCentavos),
  ].join(' · ');
}

class DeliveryPreviewPanel extends StatelessWidget {
  const DeliveryPreviewPanel({super.key, required this.delivery});

  final DeliveryPreviewView delivery;

  @override
  Widget build(BuildContext context) {
    final estimate = delivery.estimate;
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          switch (delivery.status) {
            'ADVISORY_ESTIMATE' when estimate != null => StatusBand(
              tone: BandTone.info,
              title: estimate.feeMinCentavos == estimate.feeMaxCentavos
                  ? 'Estimated delivery ${formatPeso(estimate.feeMinCentavos)}'
                  : 'Estimated delivery ${formatPeso(estimate.feeMinCentavos)}–${formatPeso(estimate.feeMaxCentavos)}',
              message:
                  '${_range(estimate.tripsMin, estimate.tripsMax, 'trip')} · ${_range(estimate.vehiclesMin, estimate.vehiclesMax, 'vehicle')}. Estimate only — not an offer.',
            ),
            'MANUAL_REVIEW' => StatusBand(
              tone: BandTone.warning,
              title: 'The Vendor will review this delivery manually',
              message: delivery.issues.isEmpty
                  ? 'Vehicles, trips and the fee are shown after the Vendor confirms.'
                  : delivery.issues.first.message,
            ),
            'BLOCKED' => StatusBand(
              tone: BandTone.danger,
              title: delivery.issues.isEmpty
                  ? 'Delivery cannot be confirmed'
                  : delivery.issues.first.message,
            ),
            _ => StatusBand(
              tone: BandTone.warning,
              title: delivery.issues.isEmpty
                  ? 'Add the delivery destination'
                  : delivery.issues.first.message,
            ),
          },
          if (delivery.status == 'ADVISORY_ESTIMATE' &&
              estimate != null &&
              estimate.options.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: BuyerDeliveryRecommendation(
                lines: estimate.options.map(deliveryOptionLine).toList(),
              ),
            ),
          if (delivery.routeDistanceMeters != null)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                'Route basis: road route from the store to the ${delivery.endpoint == 'ALTERNATE_DROP_OFF' ? 'alternative drop-off' : 'intended destination'}, ${formatDistance(delivery.routeDistanceMeters!)}.',
                style: const TextStyle(fontSize: 13),
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              delivery.confirmedOffer
                  ? 'Confirmed offer from the Vendor is available.'
                  : 'Confirmed offer: none yet. The Vendor confirms vehicles, trips, the drop-off and the final fee before you pay.',
              style: const TextStyle(fontSize: 12, color: BuyerTheme.muted),
            ),
          ),
        ],
      ),
    );
  }

  String _range(int min, int max, String noun) =>
      min == max ? '$min $noun${min == 1 ? '' : 's'}' : '$min–$max ${noun}s';
}
