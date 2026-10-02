import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../design_system/components/buyer_app_bar.dart';
import '../../design_system/components/procurement_components.dart';
import '../../design_system/theme.dart';
import '../../widgets/buyer_account_widgets.dart' show BuyerUnavailableScreen;
import '../map_discovery/discovery_models.dart';
import '../map_discovery/discovery_repository.dart' show newIdempotencyKey;
import '../orders/order_submitted_screen.dart';
import '../orders/orders_repository.dart';
import 'cart_controller.dart';
import 'checkout_previews.dart';
import 'procurement_models.dart';

/// Checkout preview: one group per Vendor, revalidated by the server. Delivery shows an advisory
/// estimate that is clearly not an offer; the intended destination and any vehicle drop-off stay
/// labelled separately. Nothing is ordered, reserved or charged from this page.
class CheckoutPreviewScreen extends StatefulWidget {
  const CheckoutPreviewScreen({
    super.key,
    required this.controller,
    required this.savedLocations,
    this.orders,
  });

  final CartController controller;
  final List<SavedLocationView> Function() savedLocations;

  /// Order submission; without it the submit action stays unavailable.
  final OrdersRepository? orders;

  @override
  State<CheckoutPreviewScreen> createState() => _CheckoutPreviewScreenState();
}

class _CheckoutPreviewScreenState extends State<CheckoutPreviewScreen> {
  CartController get _controller => widget.controller;
  bool _submitting = false;
  String? _submitError;

  /// Vendor id => chosen payment method; Online unless the Buyer picks an offered alternative.
  final Map<String, String> _methods = {};
  String? _submitKey;

  @override
  void initState() {
    super.initState();
    // After the first frame: loading notifies cart listeners (for example cart badges on the
    // pages underneath), which must not happen while this route is still building.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _controller.loadPreview();
    });
  }

  void _push(Widget page) =>
      Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) => Scaffold(
        appBar: buyerAppBar(context, 'Checkout'),
        bottomNavigationBar: _controller.preview == null
            ? null
            : _submitBar(_controller.preview!),
        body: SafeArea(child: _body()),
      ),
    );
  }

  Widget _body() {
    final preview = _controller.preview;
    final failure = _controller.previewFailure;
    // No preview and no failure yet means the first request is about to start.
    if (preview == null && (_controller.previewLoading || failure == null)) {
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
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 24),
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
          if (preview.blockedGroups + preview.actionRequiredGroups > 0 ||
              preview.requiresSplitConfirmation)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: StatusBand(
                tone: preview.blockedGroups + preview.actionRequiredGroups == 0
                    ? BandTone.info
                    : BandTone.warning,
                title:
                    '${preview.groups.length} Vendor order${preview.groups.length == 1 ? '' : 's'} · ${preview.readyGroups} ready · ${preview.actionRequiredGroups} need action · ${preview.blockedGroups} blocked',
                message: preview.requiresSplitConfirmation
                    ? '${preview.notice} Only ready groups can continue; the others stay in your cart.'
                    : preview.notice,
              ),
            ),
          if (needsDestination)
            _DestinationSection(
              controller: _controller,
              destination: preview.destination,
              savedLocations: widget.savedLocations(),
            ),
          for (final group in preview.groups)
            _GroupPreview(
                      group: group,
                      controller: _controller,
                      selectedMethod: _methodFor(group),
                      onMethod: (method) =>
                          setState(() => _methods[group.vendorId] = method),
                    ),
          _Card(
            padding: EdgeInsets.zero,
            children: [
              _LinkRow(
                icon: LucideIcons.clipboardList,
                title: 'Project Procurement',
                hint: 'Link this order to your Project',
                onTap: () => _push(
                  const BuyerUnavailableScreen(title: 'Project Procurement'),
                ),
              ),
              const Divider(height: 1),
              _LinkRow(
                icon: LucideIcons.receiptText,
                title: 'Request E-Invoice',
                hint: 'Preview',
                onTap: () => _push(const EInvoiceRequestPreviewScreen()),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
            child: Text(
              'Checked ${formatManilaTimestamp(preview.currentAsOf)}',
              style: const TextStyle(fontSize: 12, color: BuyerTheme.muted),
            ),
          ),
        ],
      ),
    );
  }

  /// Submits every READY Vendor group as its own order request. Groups that still need action stay
  /// in the cart, and the Buyer confirms that split first. One Idempotency-Key covers retries of the
  /// same submission so a repeated tap never creates a second checkout.
  Future<void> _submit(CheckoutPreviewView preview) async {
    final orders = widget.orders;
    if (orders == null || _submitting) return;
    final ready = preview.groups.where((group) => group.status == 'READY').toList();
    if (ready.isEmpty) return;
    final split = ready.length < preview.groups.length;
    if (split) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Submit ${ready.length} of ${preview.groups.length} stores?'),
          content: const Text(
            'Only the ready stores are submitted as separate order requests. The others stay in your cart so you can fix them later.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Go back'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Submit ready stores'),
            ),
          ],
        ),
      );
      if (confirmed != true || !mounted) return;
    }
    final key = _submitKey ??= newIdempotencyKey();
    setState(() {
      _submitting = true;
      _submitError = null;
    });
    try {
      final checkout = await orders.submitCheckout(
        cartLockVersion: preview.cartLockVersion,
        vendorIds: [for (final group in ready) group.vendorId],
        splitConfirmed: split,
        idempotencyKey: key,
        paymentMethods: {
          for (final group in ready) group.vendorId: _methodFor(group),
        },
      );
      _submitKey = null;
      unawaited(_controller.load());
      if (!mounted) return;
      await Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) =>
              OrderSubmittedScreen(checkout: checkout, repository: orders),
        ),
      );
    } on DiscoveryFailure catch (error) {
      // Keep the key only when the outcome is unknown (offline), so a retry replays safely.
      if (error.kind != DiscoveryFailureKind.offline) _submitKey = null;
      if (!mounted) return;
      setState(() => _submitError = error.message);
      if (error.kind == DiscoveryFailureKind.conflict) {
        await _controller.loadPreview();
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  String _methodFor(CheckoutGroupView group) {
    final chosen = _methods[group.vendorId];
    final available = [
      for (final method in group.paymentMethods)
        if (method.available) method.method,
    ];
    if (chosen != null && available.contains(chosen)) return chosen;
    return available.contains('ONLINE') || available.isEmpty
        ? 'ONLINE'
        : available.first;
  }

  Widget _submitBar(CheckoutPreviewView preview) {
    final ready = preview.groups.where((group) => group.status == 'READY').length;
    final available = widget.orders != null && ready > 0 && !_submitting;
    return SafeArea(
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
            if (_submitError != null) ...[
              StatusBand(tone: BandTone.danger, title: _submitError!),
              const SizedBox(height: 8),
            ],
            FilledButton(
              onPressed: available ? () => _submit(preview) : null,
              child: Text(
                _submitting
                    ? 'Submitting…'
                    : ready <= 1
                    ? 'Submit order request'
                    : 'Submit $ready order requests',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              ready == 0
                  ? 'Resolve the highlighted stores before submitting.'
                  : 'Each store confirms its own request. Nothing is charged until you accept the final amount.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: BuyerTheme.muted),
            ),
          ],
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({
    required this.children,
    this.padding = const EdgeInsets.all(12),
  });

  final List<Widget> children;
  final EdgeInsets padding;

  // A Material (not a coloured box) so list tiles and ink inside stay visible.
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Material(
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: BuyerTheme.border),
      ),
      child: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ),
      ),
    ),
  );
}

class _LinkRow extends StatelessWidget {
  const _LinkRow({
    required this.icon,
    required this.title,
    required this.hint,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String hint;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 52),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            Icon(icon, size: 18, color: BuyerTheme.action),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            Flexible(
              child: Text(
                hint,
                textAlign: TextAlign.right,
                style: const TextStyle(fontSize: 12, color: BuyerTheme.muted),
              ),
            ),
            const SizedBox(width: 4),
            const Icon(LucideIcons.chevronRight, size: 18),
          ],
        ),
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
    if (errors == null) await widget.controller.loadPreview();
  }

  @override
  Widget build(BuildContext context) {
    final locations = widget.savedLocations;
    final destination = widget.destination;
    final incomplete =
        destination.intended == null ||
        destination.heavyVehicleRestriction == 'UNANSWERED';
    return _Card(
      children: [
        _AddressSummary(
          destination: destination,
          expanded: _editing || incomplete,
          onTap: incomplete ? null : () => setState(() => _editing = !_editing),
        ),
        if (locations.isEmpty)
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
  const _GroupPreview({
    required this.group,
    required this.controller,
    required this.selectedMethod,
    required this.onMethod,
  });

  final CheckoutGroupView group;
  final String selectedMethod;
  final ValueChanged<String> onMethod;
  final CartController controller;

  Future<void> _choose(String method) async {
    if (controller.busy || group.fulfillmentMethod == method) return;
    await controller.setFulfillment(group.vendorId, method);
    await controller.loadPreview();
  }

  @override
  Widget build(BuildContext context) {
    final amounts = group.amounts;
    final items = group.lines.length;
    final (
      IconData statusIcon,
      String statusText,
      Color statusColor,
    ) = switch (group.status) {
      'READY' => (LucideIcons.circleCheck, 'Ready', BuyerTheme.successStrong),
      'BLOCKED' => (
        LucideIcons.octagonAlert,
        'Blocked',
        Theme.of(context).colorScheme.error,
      ),
      _ => (
        LucideIcons.triangleAlert,
        'Needs action',
        BuyerTheme.actionPressed,
      ),
    };
    return _Card(
      children: [
        Row(
          children: [
            const CircleAvatar(
              radius: 18,
              backgroundColor: BuyerTheme.brandSoft,
              child: Icon(
                LucideIcons.store,
                size: 18,
                color: BuyerTheme.action,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Semantics(
                    header: true,
                    child: Text(
                      group.vendorName,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Icon(statusIcon, size: 14, color: statusColor),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          statusText,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: statusColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        if (group.status != 'READY')
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: StatusBand(
              tone: group.status == 'BLOCKED'
                  ? BandTone.danger
                  : BandTone.warning,
              title: group.status == 'BLOCKED'
                  ? 'Blocked — stays in your cart'
                  : 'Needs your action',
              message: group.issues.isEmpty
                  ? null
                  : group.issues.map((issue) => issue.message).join('\n'),
            ),
          ),
        const SizedBox(height: 10),
        for (final line in group.lines) _LineCard(line: line),
        const SizedBox(height: 6),
        const Text(
          'Delivery Mode',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        _ModeSelector(
          options: group.fulfillmentOptions,
          selected: group.fulfillmentMethod,
          enabled: !controller.busy,
          onSelected: _choose,
        ),
        if (group.fulfillmentMethod == 'PICKUP' && group.pickupAddress != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Self-Pickup at ${group.pickupAddress}',
              style: const TextStyle(fontSize: 13),
            ),
          ),
        if (group.fulfillmentMethod == 'DELIVERY')
          DeliveryPreviewPanel(delivery: group.delivery),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: BuyerTheme.border),
          ),
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            spacing: 12,
            children: [
              Text(
                'Total $items item${items == 1 ? '' : 's'}',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              Text(
                formatPeso(amounts.materialsSubtotalCentavos),
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Payment method',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        for (final method in group.paymentMethods)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: _PaymentMethodOption(
              method: method,
              selected: method.available && selectedMethod == method.method,
              detail: method.available
                  ? switch (method.method) {
                      'ONLINE' => 'Pay after the Vendor confirms. Fee shown before you pay.',
                      'CASH_ON_DELIVERY' => 'Pay the Vendor in cash on delivery.',
                      _ => 'Pay the Vendor at the store on pickup.',
                    }
                  : _reason(method.reason),
              onTap: method.available ? () => onMethod(method.method) : null,
            ),
          ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: BuyerTheme.canvas,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Payment Details',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              const Divider(height: 16),
              _AmountRow(
                'Merchandise subtotal',
                formatPeso(amounts.materialsSubtotalCentavos),
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
              const Divider(height: 16),
              _AmountRow(
                'Total before processing fee',
                amounts.totalMinCentavos == null
                    ? 'Pending'
                    : amounts.totalMinCentavos == amounts.totalMaxCentavos
                    ? formatPeso(amounts.totalMinCentavos!)
                    : '${formatPeso(amounts.totalMinCentavos!)}–${formatPeso(amounts.totalMaxCentavos!)}',
                strong: true,
              ),
              const SizedBox(height: 6),
              const Text(
                'Prices already include any applicable VAT. The Vendor’s 2% commission and withholding are not Buyer charges.',
                style: TextStyle(fontSize: 12, color: BuyerTheme.muted),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _reason(String? reason) => switch (reason) {
    'NOT_OFFERED_BY_VENDOR' => 'Not offered by this store',
    'SITE_DELIVERY_ONLY' => 'Only for Site Delivery',
    'SELF_PICKUP_ONLY' => 'Only for Self-Pickup',
    'VENDOR_ONLINE_PAYMENT_NOT_READY' => 'Not ready for this store yet',
    _ => 'Unavailable',
  };
}

class _LineCard extends StatelessWidget {
  const _LineCard({required this.line});

  final CartLineView line;

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: BuyerTheme.border),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 64,
            height: 64,
            color: BuyerTheme.canvas,
            child: line.imageUrl == null
                ? const Icon(LucideIcons.package, color: BuyerTheme.muted)
                : Image.network(
                    line.imageUrl!,
                    fit: BoxFit.cover,
                    cacheWidth: 192,
                    errorBuilder: (_, _, _) => const Icon(LucideIcons.imageOff),
                  ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                line.displayName,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              if (line.variantLabel != null)
                Text(
                  line.variantLabel!,
                  style: const TextStyle(fontSize: 12, color: BuyerTheme.muted),
                ),
              if (line.appliedUnitPriceCentavos != null)
                Text(
                  '${formatPeso(line.appliedUnitPriceCentavos!)} / ${line.unitName}',
                  style: const TextStyle(fontSize: 12, color: BuyerTheme.muted),
                ),
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                spacing: 8,
                children: [
                  Text(
                    line.lineTotalCentavos == null
                        ? 'Unavailable'
                        : formatPeso(line.lineTotalCentavos!),
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: BuyerTheme.action,
                    ),
                  ),
                  Text(
                    '${formatQuantity(line.quantity)} ${line.unitName}',
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              ),
              for (final issue in line.issues)
                Text(
                  '• ${issue.message}',
                  style: TextStyle(
                    fontSize: 12,
                    color: issue.blocking
                        ? Theme.of(context).colorScheme.error
                        : BuyerTheme.ink,
                  ),
                ),
            ],
          ),
        ),
      ],
    ),
  );
}

/// Site Delivery / Self-Pickup for one store. A mode the store does not offer stays visible but
/// disabled and says so.
class _ModeSelector extends StatelessWidget {
  const _ModeSelector({
    required this.options,
    required this.selected,
    required this.enabled,
    required this.onSelected,
  });

  final List<String> options;
  final String? selected;
  final bool enabled;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(3),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: BuyerTheme.border),
    ),
    child: Row(
      children: [
        for (final (method, label) in const [
          ('DELIVERY', 'Site Delivery'),
          ('PICKUP', 'Self-Pickup'),
        ])
          Expanded(child: _segment(method, label)),
      ],
    ),
  );

  Widget _segment(String method, String label) {
    final offered = options.contains(method);
    final isSelected = selected == method;
    final text = offered ? label : '$label (not offered)';
    return Semantics(
      button: true,
      selected: isSelected,
      enabled: offered && enabled,
      label: text,
      excludeSemantics: true,
      child: Material(
        color: isSelected ? BuyerTheme.action : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: offered && enabled ? () => onSelected(method) : null,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 44),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    color: isSelected
                        ? Colors.white
                        : offered
                        ? BuyerTheme.ink
                        : BuyerTheme.muted,
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

/// One selectable payment method row (44 px minimum). Unavailable methods stay listed with their reason.
class _PaymentMethodOption extends StatelessWidget {
  const _PaymentMethodOption({
    required this.method,
    required this.selected,
    required this.detail,
    required this.onTap,
  });

  final PaymentMethodView method;
  final bool selected;
  final String detail;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    inMutuallyExclusiveGroup: true,
    checked: selected,
    enabled: onTap != null,
    label: '${method.label}. $detail',
    excludeSemantics: true,
    button: true,
    child: Material(
      color: selected ? BuyerTheme.brandSoft : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: selected ? BuyerTheme.action : BuyerTheme.border,
          width: selected ? 1.5 : 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 48),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Icon(
                  onTap == null
                      ? LucideIcons.circleSlash
                      : selected
                      ? LucideIcons.circleDot
                      : LucideIcons.circle,
                  size: 18,
                  color: onTap == null
                      ? BuyerTheme.muted
                      : selected
                      ? BuyerTheme.action
                      : BuyerTheme.ink,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        method.label,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: onTap == null ? BuyerTheme.muted : BuyerTheme.ink,
                        ),
                      ),
                      Text(
                        detail,
                        style: const TextStyle(
                          fontSize: 12,
                          color: BuyerTheme.muted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
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
