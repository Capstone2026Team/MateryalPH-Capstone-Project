import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../design_system/components/buyer_app_bar.dart';
import '../../design_system/components/procurement_components.dart';
import '../../design_system/theme.dart';
import '../map_discovery/discovery_models.dart';
import 'cart_controller.dart';
import 'procurement_models.dart';
import 'procurement_navigation.dart';

/// Cart grouped by Vendor. Each group has its own fulfillment choice and validation band; a stale
/// line is shown inline on its own group and never removes the rest of the cart.
class CartScreen extends StatelessWidget {
  const CartScreen({
    super.key,
    required this.controller,
    required this.navigation,
  });

  final CartController controller;
  final ProcurementNavigation navigation;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: controller,
    builder: (context, _) {
      final cart = controller.cart;
      return Scaffold(
        appBar: buyerAppBar(
          context,
          cart == null || cart.lineCount == 0
              ? 'Cart'
              : 'Cart (${cart.lineCount})',
        ),
        bottomNavigationBar: cart == null || cart.empty
            ? null
            : _summary(context, cart),
        body: SafeArea(child: _body(context)),
      );
    },
  );

  Widget _body(BuildContext context) {
    final cart = controller.cart;
    final failure = controller.failure;
    if (cart == null && controller.phase == LoadPhase.loading) {
      return ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          SkeletonBox(height: 100),
          SizedBox(height: 12),
          SkeletonBox(height: 100),
        ],
      );
    }
    if (cart == null) {
      return StateMessage(
        kind: failure?.kind == DiscoveryFailureKind.offline
            ? StateKind.offline
            : StateKind.error,
        title: failure?.kind == DiscoveryFailureKind.offline
            ? 'You are offline'
            : 'Your cart could not load',
        message: failure?.message ?? 'Please retry.',
        actionLabel: 'Retry',
        onAction: controller.load,
      );
    }
    if (cart.empty) {
      return Center(
        child: SingleChildScrollView(
          child: StateMessage(
            kind: StateKind.empty,
            artwork: 'assets/states/cart.png',
            title: 'Your cart is empty',
            message:
                'Add materials from Explore. Adding to the cart never reserves stock.',
            actionLabel: 'Browse materials',
            onAction: () => Navigator.of(context).maybePop(),
          ),
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: controller.load,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 24),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 0, 4, 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: Icon(
                    LucideIcons.info,
                    size: 16,
                    color: BuyerTheme.muted,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    cart.notice,
                    style: const TextStyle(
                      fontSize: 12,
                      color: BuyerTheme.muted,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (controller.notice != null) ...[
            StatusBand(tone: BandTone.warning, title: controller.notice!),
            const SizedBox(height: 8),
          ],
          if (failure != null) ...[
            StatusBand(
              tone: BandTone.warning,
              title: 'Showing your last loaded cart',
              message: failure.message,
              action: TextButton(
                onPressed: controller.load,
                child: const Text('Retry'),
              ),
            ),
            const SizedBox(height: 8),
          ],
          for (final group in cart.groups)
            _GroupSection(controller: controller, group: group),
          if (cart.savedForLater.isNotEmpty)
            _Panel(
              children: [
                Semantics(
                  header: true,
                  child: const Text(
                    'Saved for later',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
                const Text(
                  'Tick an item to include it in checkout.',
                  style: TextStyle(fontSize: 12, color: BuyerTheme.muted),
                ),
                const Divider(height: 16),
                for (final line in cart.savedForLater)
                  _LineTile(
                    controller: controller,
                    line: line,
                    savedForLater: true,
                  ),
              ],
            ),
        ],
      ),
    );
  }

  Future<void> _deleteSelected(BuildContext context, CartView cart) async {
    final count = cart.groups.fold<int>(
      0,
      (sum, group) => sum + group.lines.length,
    );
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Remove $count selected item${count == 1 ? '' : 's'}?'),
        content: const Text(
          'They are removed from your cart. Items saved for later stay.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (confirmed == true) await controller.removeSelected();
  }

  Widget _summary(BuildContext context, CartView cart) {
    final busy = controller.busy;
    final allSelected = cart.groups.isNotEmpty && cart.savedForLater.isEmpty;
    final selectAll = MergeSemantics(
      child: InkWell(
        onTap: busy ? null : () => controller.selectAll(!allSelected),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 44),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Checkbox(
                value: allSelected,
                activeColor: BuyerTheme.action,
                onChanged: busy
                    ? null
                    : (value) => controller.selectAll(value ?? false),
              ),
              const Flexible(
                child: Text('Select all', style: TextStyle(fontSize: 13)),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
    final delete = TextButton.icon(
      onPressed: busy || cart.groups.isEmpty
          ? null
          : () => _deleteSelected(context, cart),
      style: TextButton.styleFrom(
        foregroundColor: BuyerTheme.action,
        minimumSize: const Size(0, 44),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        textStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
      icon: const Icon(LucideIcons.trash2, size: 18),
      label: const Text('Delete'),
    );
    final total = Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          cart.groups.length > 1
              ? 'Total · ${cart.groups.length} stores (advisory)'
              : 'Total (advisory)',
          textAlign: TextAlign.right,
          style: const TextStyle(fontSize: 12, color: BuyerTheme.muted),
        ),
        Text(
          formatPeso(cart.materialsSubtotalCentavos),
          textAlign: TextAlign.right,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
      ],
    );
    final checkout = FilledButton(
      style: FilledButton.styleFrom(
        minimumSize: const Size(0, 48),
        padding: const EdgeInsets.symmetric(horizontal: 22),
      ),
      onPressed: busy || cart.groups.isEmpty
          ? null
          : () => navigation.openCheckout(context),
      child: const Text('Checkout'),
    );
    final stacked =
        MediaQuery.textScalerOf(context).scale(1) > 1.3 ||
        MediaQuery.sizeOf(context).width < 340;
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(8, 6, 16, 8),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: BuyerTheme.border)),
        ),
        child: stacked
            ? Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Wrap(children: [selectAll, delete]),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, bottom: 8),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: total,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: checkout,
                  ),
                ],
              )
            : Row(
                children: [
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [selectAll, delete],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(child: total),
                  const SizedBox(width: 12),
                  checkout,
                ],
              ),
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.fromLTRB(12, 12, 8, 4),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: BuyerTheme.border),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    ),
  );
}

class _GroupSection extends StatelessWidget {
  const _GroupSection({required this.controller, required this.group});

  final CartController controller;
  final CartGroupView group;

  @override
  Widget build(BuildContext context) => _Panel(
    children: [
      Row(
        children: [
          const Icon(LucideIcons.store, size: 18, color: BuyerTheme.action),
          const SizedBox(width: 8),
          Expanded(
            child: Semantics(
              header: true,
              child: Text(
                group.vendorName,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 8),
      if (group.status != 'READY')
        Padding(
          padding: const EdgeInsets.only(bottom: 8, right: 4),
          child: StatusBand(
            tone: group.status == 'BLOCKED'
                ? BandTone.danger
                : BandTone.warning,
            title: group.status == 'BLOCKED'
                ? 'This store group cannot be checked out yet'
                : 'This store group needs your review',
            message: 'Other Vendor groups in your cart are not affected.',
          ),
        ),
      if (group.vacationMode)
        const Padding(
          padding: EdgeInsets.only(bottom: 8, right: 4),
          child: StatusBand(
            tone: BandTone.warning,
            title: 'This store has paused new procurement',
          ),
        ),
      _fulfillment(context),
      const Divider(height: 16),
      for (final line in group.lines)
        _LineTile(controller: controller, line: line, savedForLater: false),
      Padding(
        padding: const EdgeInsets.only(right: 4, bottom: 8),
        child: Text(
          'Store subtotal ${formatPeso(group.materialsSubtotalCentavos)}',
          textAlign: TextAlign.right,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    ],
  );

  Widget _fulfillment(BuildContext context) {
    final options = group.fulfillmentOptions;
    if (options.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(right: 4),
        child: StatusBand(
          tone: BandTone.danger,
          title: 'This store has no fulfillment method available',
        ),
      );
    }
    if (options.length == 1) {
      return Row(
        children: [
          Icon(
            options.first == 'DELIVERY' ? LucideIcons.truck : LucideIcons.store,
            size: 16,
            color: BuyerTheme.successStrong,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              options.first == 'DELIVERY'
                  ? 'Site Delivery only'
                  : 'Self-Pickup only',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Fulfillment for this store',
          style: TextStyle(fontSize: 12, color: BuyerTheme.muted),
        ),
        Wrap(
          spacing: 8,
          children: [
            FilterPill(
              selected: group.fulfillmentMethod == 'DELIVERY',
              label: 'Site Delivery',
              onTap: controller.busy
                  ? null
                  : () => controller.setFulfillment(group.vendorId, 'DELIVERY'),
            ),
            FilterPill(
              selected: group.fulfillmentMethod == 'PICKUP',
              label: 'Self-Pickup',
              onTap: controller.busy
                  ? null
                  : () => controller.setFulfillment(group.vendorId, 'PICKUP'),
            ),
          ],
        ),
        if (group.fulfillmentMethod == null)
          const Text(
            'Choose how you will receive this store’s items.',
            style: TextStyle(fontSize: 12, color: BuyerTheme.muted),
          ),
      ],
    );
  }
}

class _LineTile extends StatelessWidget {
  const _LineTile({
    required this.controller,
    required this.line,
    required this.savedForLater,
  });

  final CartController controller;
  final CartLineView line;
  final bool savedForLater;

  @override
  Widget build(BuildContext context) {
    final busy = controller.busy;
    final whole = line.quantityStep == '1';
    final quantity = double.tryParse(line.quantity) ?? 1;
    final large = MediaQuery.textScalerOf(context).scale(1) > 1.3;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 36,
                child: Checkbox(
                  value: !savedForLater,
                  activeColor: BuyerTheme.action,
                  semanticLabel: 'Select ${line.displayName}',
                  onChanged: busy || (savedForLater && !line.available)
                      ? null
                      : (selected) => controller.saveForLater(
                          line,
                          saved: selected != true,
                        ),
                ),
              ),
              const SizedBox(width: 4),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: large ? 44 : 64,
                  height: large ? 44 : 64,
                  child: line.imageUrl == null
                      ? const ColoredBox(
                          color: BuyerTheme.canvas,
                          child: Icon(
                            LucideIcons.package,
                            color: BuyerTheme.muted,
                          ),
                        )
                      : Image.network(
                          line.imageUrl!,
                          fit: BoxFit.cover,
                          cacheWidth: 192,
                          errorBuilder: (_, _, _) => const ColoredBox(
                            color: BuyerTheme.canvas,
                            child: Icon(LucideIcons.imageOff),
                          ),
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
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (line.variantLabel != null)
                      Text(
                        line.variantLabel!,
                        style: const TextStyle(
                          fontSize: 11,
                          color: BuyerTheme.muted,
                        ),
                      ),
                    if (line.appliedUnitPriceCentavos != null)
                      Text(
                        '${formatPeso(line.appliedUnitPriceCentavos!)} / ${line.unitName}${line.volumeTierApplied ? ' · volume price' : ''}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: BuyerTheme.action,
                        ),
                      ),
                    if (line.stockLabel != null)
                      StockLabelText(label: line.stockLabel, compact: true),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Remove ${line.displayName}',
                onPressed: busy ? null : () => controller.remove(line),
                icon: const Icon(
                  LucideIcons.trash2,
                  size: 18,
                  color: BuyerTheme.muted,
                ),
              ),
            ],
          ),
          for (final issue in line.issues)
            Padding(
              padding: const EdgeInsets.only(top: 6, right: 4),
              child: StatusBand(
                tone: issue.blocking
                    ? BandTone.danger
                    : issue.actionRequired
                    ? BandTone.warning
                    : BandTone.info,
                title: issue.message,
                message:
                    issue.code == 'PRICE_CHANGED' &&
                        line.snapshotUnitPriceCentavos != null &&
                        line.currentUnitPriceCentavos != null
                    ? 'You added it at ${formatPeso(line.snapshotUnitPriceCentavos!)}; it is now ${formatPeso(line.currentUnitPriceCentavos!)}.'
                    : null,
                action: issue.code == 'PRICE_CHANGED'
                    ? TextButton(
                        onPressed: busy
                            ? null
                            : () => controller.acceptCurrentPrice(line),
                        child: const Text('Accept current price'),
                      )
                    : null,
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(left: 40),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              children: [
                Text(
                  savedForLater
                      ? 'Saved for later · ${formatQuantity(line.quantity)} ${line.unitName}'
                      : line.lineTotalCentavos != null
                      ? 'Line total ${formatPeso(line.lineTotalCentavos!)}'
                      : '',
                  style: const TextStyle(fontSize: 12, color: BuyerTheme.muted),
                ),
                if (!savedForLater && line.available && whole)
                  QuantityStepper(
                    compact: true,
                    quantity: quantity.round(),
                    unitName: line.unitName,
                    enabled: !busy,
                    onChanged: (value) =>
                        controller.changeQuantity(line, '$value'),
                  )
                else if (!savedForLater)
                  Text(
                    'Quantity ${formatQuantity(line.quantity)} ${line.unitName}',
                    style: const TextStyle(fontSize: 12),
                  ),
              ],
            ),
          ),
          const Divider(height: 12),
        ],
      ),
    );
  }
}
