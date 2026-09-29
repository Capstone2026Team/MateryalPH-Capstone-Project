import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../design_system/components/procurement_components.dart';
import '../../design_system/theme.dart';
import '../map_discovery/discovery_models.dart';
import 'cart_controller.dart';
import 'procurement_models.dart';

/// Checkout preview: one group per Vendor, revalidated by the server. Delivery shows an advisory
/// estimate that is clearly not an offer; the intended destination and any vehicle drop-off stay
/// labelled separately. Nothing is ordered, reserved or charged from this page.
class CheckoutPreviewScreen extends StatefulWidget {
  const CheckoutPreviewScreen({
    super.key,
    required this.controller,
    required this.savedLocations,
  });

  final CartController controller;
  final List<SavedLocationView> Function() savedLocations;

  @override
  State<CheckoutPreviewScreen> createState() => _CheckoutPreviewScreenState();
}

class _CheckoutPreviewScreenState extends State<CheckoutPreviewScreen> {
  CartController get _controller => widget.controller;

  @override
  void initState() {
    super.initState();
    _controller.loadPreview();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: _controller,
    builder: (context, _) => Scaffold(
      appBar: AppBar(title: const Text('Checkout preview')),
      bottomNavigationBar: _controller.preview == null ? null : _submitBar(),
      body: SafeArea(child: _body()),
    ),
  );

  Widget _body() {
    final preview = _controller.preview;
    final failure = _controller.previewFailure;
    if (preview == null && _controller.previewLoading) {
      return ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          SkeletonBox(height: 80),
          SizedBox(height: 12),
          SkeletonBox(height: 200),
        ],
      );
    }
    if (preview == null) {
      return StateMessage(
        kind: failure?.kind == DiscoveryFailureKind.offline
            ? StateKind.offline
            : StateKind.error,
        title: 'The checkout preview could not load',
        message: failure?.message ?? 'Please retry.',
        actionLabel: 'Retry',
        onAction: _controller.loadPreview,
      );
    }
    final needsDestination = preview.groups.any(
      (group) => group.fulfillmentMethod == 'DELIVERY',
    );
    return RefreshIndicator(
      onRefresh: _controller.loadPreview,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          if (failure != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: StatusBand(
                tone: BandTone.warning,
                title: 'This preview may be out of date',
                message: failure.message,
                action: TextButton(
                  onPressed: _controller.loadPreview,
                  child: const Text('Retry'),
                ),
              ),
            ),
          StatusBand(
            tone: preview.blockedGroups + preview.actionRequiredGroups == 0
                ? BandTone.success
                : BandTone.warning,
            title:
                '${preview.groups.length} Vendor order${preview.groups.length == 1 ? '' : 's'} · ${preview.readyGroups} ready · ${preview.actionRequiredGroups} need action · ${preview.blockedGroups} blocked',
            message: preview.requiresSplitConfirmation
                ? '${preview.notice} Only ready groups can continue; the others stay in your cart.'
                : preview.notice,
          ),
          Text(
            'Checked ${formatManilaTimestamp(preview.currentAsOf)}',
            style: const TextStyle(fontSize: 12, color: BuyerTheme.muted),
          ),
          if (needsDestination)
            _DestinationSection(
              controller: _controller,
              destination: preview.destination,
              savedLocations: widget.savedLocations(),
            ),
          for (final group in preview.groups) _GroupPreview(group: group),
          const Padding(
            padding: EdgeInsets.only(top: 16),
            child: Text(
              'Submitting order requests opens in the next release. Nothing has been reserved or charged.',
            ),
          ),
        ],
      ),
    );
  }

  Widget _submitBar() => SafeArea(
    top: false,
    child: Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: BuyerTheme.border)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            button: true,
            enabled: false,
            label: 'Submit order requests, not available yet',
            excludeSemantics: true,
            child: const FilledButton(
              onPressed: null,
              child: Text('Submit order requests'),
            ),
          ),
        ],
      ),
    ),
  );
}

class _DestinationSection extends StatefulWidget {
  const _DestinationSection({
    required this.controller,
    required this.destination,
    required this.savedLocations,
  });

  final CartController controller;
  final CartDestinationView destination;
  final List<SavedLocationView> savedLocations;

  @override
  State<_DestinationSection> createState() => _DestinationSectionState();
}

class _DestinationSectionState extends State<_DestinationSection> {
  late String? _intended = widget.destination.intended?.locationId;
  late String _restriction = widget.destination.heavyVehicleRestriction;
  late String? _alternate = widget.destination.alternateDropOff?.locationId;
  late final TextEditingController _instructions = TextEditingController(
    text: widget.destination.accessInstructions ?? '',
  );
  Map<String, Object?> _errors = const {};

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
    setState(() => _errors = errors ?? const {});
    if (errors == null) await widget.controller.loadPreview();
  }

  @override
  Widget build(BuildContext context) {
    final locations = widget.savedLocations;
    final destination = widget.destination;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeading('Delivery destination'),
        if (locations.isEmpty)
          const StatusBand(
            tone: BandTone.warning,
            title: 'Save a location first',
            message:
                'Delivery needs a saved location. Add one from the Map’s location selector.',
          )
        else ...[
          _LocationPicker(
            label: destination.intendedLabel,
            locations: locations,
            selected: _intended,
            error: _error('intended_location_id'),
            onChanged: (value) => setState(() => _intended = value),
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
                  title: Text('No known restriction'),
                  subtitle: Text(
                    'Vehicles go to the intended destination. Access is still confirmed by the Vendor.',
                  ),
                ),
                RadioListTile<String>(
                  value: 'YES',
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
            _LocationPicker(
              label: '${destination.endpointLabel} (alternative drop-off)',
              locations: locations,
              selected: _alternate,
              error: _error('alternate_drop_off_location_id'),
              onChanged: (value) => setState(() => _alternate = value),
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
          if (destination.intended != null) ...[
            const SizedBox(height: 8),
            _SavedDestination(destination: destination),
          ],
        ],
      ],
    );
  }
}

class _SavedDestination extends StatelessWidget {
  const _SavedDestination({required this.destination});

  final CartDestinationView destination;

  @override
  Widget build(BuildContext context) {
    final intended = destination.intended!;
    final alternate = destination.alternateDropOff;
    final endpoint = destination.vehicleEndpoint == 'ALTERNATE_DROP_OFF'
        ? alternate
        : intended;
    return Semantics(
      container: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${destination.intendedLabel}: ${intended.title}',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          if (endpoint != null)
            Text(
              '${destination.endpointLabel}: ${endpoint.title}${destination.vehicleEndpoint == 'ALTERNATE_DROP_OFF' ? ' — used for route distance and the delivery fee' : ''}',
            ),
        ],
      ),
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

class _GroupPreview extends StatelessWidget {
  const _GroupPreview({required this.group});

  final CheckoutGroupView group;

  @override
  Widget build(BuildContext context) {
    final amounts = group.amounts;
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: BuyerTheme.border),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Semantics(
                header: true,
                child: Text(
                  group.vendorName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              StatusBand(
                tone: switch (group.status) {
                  'READY' => BandTone.success,
                  'BLOCKED' => BandTone.danger,
                  _ => BandTone.warning,
                },
                title: switch (group.status) {
                  'READY' => 'Ready for an order request',
                  'BLOCKED' => 'Blocked — stays in your cart',
                  _ => 'Needs your action',
                },
                message: group.issues.isEmpty
                    ? null
                    : group.issues.map((issue) => issue.message).join('\n'),
              ),
              for (final line in group.lines)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${formatQuantity(line.quantity)} × ${line.displayName}${line.variantLabel == null ? '' : ' (${line.variantLabel})'}',
                      ),
                      if (line.lineTotalCentavos != null)
                        Text(
                          formatPeso(line.lineTotalCentavos!),
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      for (final issue in line.issues)
                        Text(
                          '• ${issue.message}',
                          style: TextStyle(
                            color: issue.blocking
                                ? Theme.of(context).colorScheme.error
                                : BuyerTheme.ink,
                          ),
                        ),
                    ],
                  ),
                ),
              const Divider(height: 24),
              Text(
                group.fulfillmentMethod == 'DELIVERY'
                    ? 'Site Delivery'
                    : group.fulfillmentMethod == 'PICKUP'
                    ? 'Self-Pickup${group.pickupAddress == null ? '' : ' at ${group.pickupAddress}'}'
                    : 'Fulfillment not chosen',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              if (group.fulfillmentMethod == 'DELIVERY')
                DeliveryPreviewPanel(delivery: group.delivery),
              const Divider(height: 24),
              const Text(
                'Payment methods',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              for (final method in group.paymentMethods)
                Row(
                  children: [
                    Icon(
                      method.available
                          ? LucideIcons.circleCheck
                          : LucideIcons.circleSlash,
                      size: 16,
                      color: method.available
                          ? BuyerTheme.success
                          : BuyerTheme.muted,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        '${method.label} — ${method.available ? 'available' : _reason(method.reason)}',
                      ),
                    ),
                  ],
                ),
              const Divider(height: 24),
              _AmountRow(
                'Materials subtotal',
                formatPeso(amounts.materialsSubtotalCentavos),
                strong: true,
              ),
              _AmountRow(
                amounts.vatIncluded ? 'Includes VAT' : 'VAT',
                amounts.vatIncluded
                    ? formatPeso(amounts.includedVatCentavos)
                    : 'No VAT included',
              ),
              _AmountRow('Delivery', switch (amounts.deliveryStatus) {
                'NOT_APPLICABLE' => 'Not applicable',
                'ESTIMATE' =>
                  amounts.deliveryMinCentavos == amounts.deliveryMaxCentavos
                      ? 'Estimate ${formatPeso(amounts.deliveryMinCentavos!)}'
                      : 'Estimate ${formatPeso(amounts.deliveryMinCentavos!)}–${formatPeso(amounts.deliveryMaxCentavos!)}',
                _ => 'Pending Vendor review',
              }),
              const _AmountRow(
                'Payment processing fee',
                'Shown when you choose a payment channel',
              ),
              _AmountRow(
                'Total before processing fee',
                amounts.totalMinCentavos == null
                    ? 'Pending'
                    : amounts.totalMinCentavos == amounts.totalMaxCentavos
                    ? formatPeso(amounts.totalMinCentavos!)
                    : '${formatPeso(amounts.totalMinCentavos!)}–${formatPeso(amounts.totalMaxCentavos!)}',
                strong: true,
              ),
              const SizedBox(height: 4),
              const Text(
                'Prices already include any applicable VAT. The Vendor’s 2% commission and withholding are not Buyer charges.',
                style: TextStyle(fontSize: 12, color: BuyerTheme.muted),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _reason(String? reason) => switch (reason) {
    'NOT_OFFERED_BY_VENDOR' => 'not offered by this store',
    'SITE_DELIVERY_ONLY' => 'only for Site Delivery',
    'SELF_PICKUP_ONLY' => 'only for Self-Pickup',
    'VENDOR_ONLINE_PAYMENT_NOT_READY' => 'not ready for this store yet',
    _ => 'unavailable',
  };
}

/// Advisory delivery estimate versus the Vendor's confirmed offer, always labelled apart.
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

class _AmountRow extends StatelessWidget {
  const _AmountRow(this.label, this.value, {this.strong = false});

  final String label;
  final String value;
  final bool strong;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Wrap(
      alignment: WrapAlignment.spaceBetween,
      spacing: 12,
      children: [
        Text(label),
        Text(
          value,
          style: TextStyle(
            fontWeight: strong ? FontWeight.w800 : FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}
