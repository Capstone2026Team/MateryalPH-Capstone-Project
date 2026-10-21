import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../design_system/components/buyer_overlays.dart';
import '../../design_system/components/buyer_app_bar.dart';
import '../../design_system/components/procurement_components.dart';
import '../../design_system/components/invoice_request_form.dart';
import '../../design_system/theme.dart';
import '../map_discovery/discovery_models.dart';
import '../map_discovery/discovery_repository.dart' show newIdempotencyKey;
import '../orders/order_submitted_screen.dart';
import '../orders/orders_repository.dart';
import 'cart_controller.dart';
import '../projects/projects_repository.dart';
import 'checkout_project_screen.dart';
import 'delivery_widgets.dart';
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
    this.projects,
    this.chooseDropOff,
  });

  final CartController controller;
  final List<SavedLocationView> Function() savedLocations;

  /// Opens the location picker for the alternative vehicle drop-off (current location or a
  /// searched/pinned point). When absent the drop-off falls back to the saved-location list.
  final Future<DiscoveryOrigin?> Function(
    BuildContext context, {
    required bool useCurrent,
  })?
  chooseDropOff;

  /// Order submission; without it the submit action stays unavailable.
  final OrdersRepository? orders;
  final ProjectsRepository? projects;

  @override
  State<CheckoutPreviewScreen> createState() => _CheckoutPreviewScreenState();
}

class _CheckoutPreviewScreenState extends State<CheckoutPreviewScreen> {
  CartController get _controller => widget.controller;
  bool _submitting = false;
  String? _submitError;
  String? _projectError;

  /// Vendor id => chosen payment method; Online unless the Buyer picks an offered alternative.
  final Map<String, String> _methods = {};
  String? _submitKey;
  String? _submitBody;
  CheckoutProjectLink? _projectLink;
  InvoiceBillingInput? _invoice;
  final _budgetReason = TextEditingController();
  bool _budgetOverrideRequired = false;

  @override
  void dispose() {
    _budgetReason.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // After the first frame: loading notifies cart listeners (for example cart badges on the
    // pages underneath), which must not happen while this route is still building.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _controller.loadPreview();
    });
  }

  Future<void> _chooseProject() async {
    if (_submitting) return;
    // Some checkout entries have no separately injected Project service.
    // Reuse the checkout's authenticated client and session handling in that case.
    final projects = widget.projects ?? widget.orders?.projects;
    if (projects == null) {
      setState(
        () => _projectError =
            'Projects are unavailable. Reopen Checkout and try again.',
      );
      return;
    }
    setState(() => _projectError = null);
    final result = await Navigator.of(context).push<Object>(
      MaterialPageRoute(
        builder: (_) =>
            CheckoutProjectScreen(repository: projects, selected: _projectLink),
      ),
    );
    if (!mounted || result == null) return;
    setState(() {
      _projectLink = result is CheckoutProjectLink ? result : null;
      _budgetOverrideRequired = false;
      _budgetReason.clear();
    });
  }

  Future<void> _editInvoice() async {
    if (_submitting) return;
    final value = await Navigator.of(context).push<InvoiceBillingInput>(
      MaterialPageRoute(
        builder: (_) => InvoiceRequestFormScreen(
          initial: _invoice,
          notice:
              'These billing details will be saved for each order when you submit checkout. After the sale is confirmed, request a copy or correction from Order Details. Business TIN is optional and used only for the invoice.',
          submitLabel: 'Use these invoice details',
          onSubmit: (_) async {},
        ),
      ),
    );
    if (mounted && value != null) setState(() => _invoice = value);
  }

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
            CartDestinationSection(
              controller: _controller,
              destination: preview.destination,
              savedLocations: widget.savedLocations(),
              chooseDropOff: widget.chooseDropOff,
            ),
          for (final group in preview.groups)
            _GroupPreview(
              group: group,
              controller: _controller,
              selectedMethod: _methodFor(group),
              onMethod: (method) =>
                  setState(() => _methods[group.vendorId] = method),
            ),
          if (_projectError != null) ...[
            StatusBand(
              tone: BandTone.warning,
              title: 'Projects could not open',
              message: _projectError,
              action: TextButton(
                onPressed: _chooseProject,
                child: const Text('Retry'),
              ),
            ),
            const SizedBox(height: 12),
          ],
          ProcurementReviewCard(
            padding: EdgeInsets.zero,
            children: [
              _LinkRow(
                icon: LucideIcons.clipboardList,
                title: 'Project Procurement',
                hint: _projectLink == null
                    ? 'Link this order to your Project'
                    : '${_projectLink!.projectName} · ${_projectLink!.packageName}',
                onTap: _chooseProject,
              ),
              const Divider(height: 1),
              _LinkRow(
                icon: LucideIcons.receiptText,
                title: 'Request E-Invoice',
                hint: _invoice == null ? 'Add billing details' : _invoice!.name,
                onTap: _editInvoice,
              ),
              if (_invoice != null)
                TextButton(
                  onPressed: _submitting
                      ? null
                      : () => setState(() => _invoice = null),
                  child: const Text('Remove invoice details'),
                ),
            ],
          ),
          if (_budgetOverrideRequired) ...[
            const StatusBand(
              tone: BandTone.warning,
              title: 'Budget Override required',
              message:
                  'This purchase exceeds the Project or Work Package budget. Enter your reason to acknowledge the deficit and continue.',
            ),
            TextField(
              controller: _budgetReason,
              maxLength: 2000,
              minLines: 2,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Budget Override reason',
                helperText: 'At least 10 characters.',
              ),
            ),
          ],
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

  bool _canSubmit(CheckoutPreviewView preview) =>
      widget.orders != null &&
      !_submitting &&
      !_controller.busy &&
      !_controller.previewLoading &&
      _controller.previewFailure == null &&
      identical(_controller.preview, preview) &&
      preview.groups.any((group) => group.status == 'READY');

  /// Submits every READY Vendor group as its own order request. Groups that still need action stay
  /// in the cart, and the Buyer confirms that split first. One Idempotency-Key covers retries of the
  /// same submission so a repeated tap never creates a second checkout.
  Future<void> _submit(CheckoutPreviewView preview) async {
    final orders = widget.orders;
    if (orders == null || !_canSubmit(preview)) return;
    final ready = preview.groups
        .where((group) => group.status == 'READY')
        .toList();
    if (ready.isEmpty) return;
    final split = ready.length < preview.groups.length;
    if (split) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => BuyerDialog(
          title: Text(
            'Submit ${ready.length} of ${preview.groups.length} stores?',
          ),
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
    if (!_canSubmit(preview)) return;
    final body = [
      preview.cartLockVersion,
      ready.map((g) => '${g.vendorId}:${_methodFor(g)}').join(','),
      split,
      _projectLink?.packageId,
      _projectLink?.lockVersion,
      _budgetReason.text.trim(),
      _invoice?.name,
      _invoice?.address,
      _invoice?.tin,
    ].toString();
    if (_submitBody != body) {
      _submitKey = null;
      _submitBody = body;
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
        workPackageId: _projectLink?.packageId,
        workPackageLockVersion: _projectLink?.lockVersion,
        budgetOverrideReason: _budgetReason.text.trim().isEmpty
            ? null
            : _budgetReason.text.trim(),
        invoiceDetails: _invoice,
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
      if (!error.isTransportFailure) _submitKey = null;
      if (!mounted) return;
      setState(() => _submitError = error.message);
      if (error.code == 'BUDGET_OVERRIDE_REQUIRED') {
        setState(() => _budgetOverrideRequired = true);
      }
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
    final ready = preview.groups
        .where((group) => group.status == 'READY')
        .length;
    final available = _canSubmit(preview);
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
                    : _controller.previewLoading
                    ? 'Checking checkout…'
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
    return ProcurementReviewCard(
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
              action:
                  group.issues.any((issue) => issue.code == 'ROUTE_UNAVAILABLE')
                  ? OutlinedButton.icon(
                      onPressed: controller.previewLoading || controller.busy
                          ? null
                          : controller.loadPreview,
                      icon: const Icon(LucideIcons.refreshCw, size: 18),
                      label: Text(
                        controller.previewLoading
                            ? 'Checking delivery route…'
                            : 'Retry delivery route',
                      ),
                    )
                  : null,
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
                      'ONLINE' =>
                        'Pay after the Vendor confirms. Fee shown before you pay.',
                      'CASH_ON_DELIVERY' =>
                        'Pay the Vendor in cash on delivery.',
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
                _ => 'Estimate unavailable',
              }),
              if (amounts.deliveryStatus == 'PENDING_VENDOR_REVIEW')
                Padding(
                  padding: const EdgeInsets.only(top: 4, bottom: 8),
                  child: Text(
                    group.delivery.issues.firstOrNull?.message ??
                        'The Vendor must review the delivery requirements before a fee can be calculated.',
                    style: const TextStyle(
                      fontSize: 12,
                      color: BuyerTheme.muted,
                    ),
                  ),
                ),
              const _AmountRow(
                'Payment processing fee',
                'Shown when you choose a payment channel',
              ),
              const Divider(height: 16),
              _AmountRow(
                amounts.totalMinCentavos == null
                    ? 'Materials total before delivery'
                    : amounts.deliveryStatus == 'ESTIMATE'
                    ? 'Estimated total before processing fee'
                    : 'Total before processing fee',
                amounts.totalMinCentavos == null
                    ? formatPeso(amounts.materialsSubtotalCentavos)
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
                          color: onTap == null
                              ? BuyerTheme.muted
                              : BuyerTheme.ink,
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
