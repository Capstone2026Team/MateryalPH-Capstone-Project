import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

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
        appBar: AppBar(
          title: Text(
            cart == null || cart.lineCount == 0
                ? 'Cart'
                : 'Cart (${cart.lineCount})',
          ),
        ),
        bottomNavigationBar: cart == null || cart.groups.isEmpty
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
      return StateMessage(
        kind: StateKind.empty,
        title: 'Your cart is empty',
        message:
            'Add materials from Explore. Adding to the cart never reserves stock.',
        actionLabel: 'Browse materials',
        onAction: () => Navigator.of(context).maybePop(),
      );
    }
    return RefreshIndicator(
      onRefresh: controller.load,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          StatusBand(tone: BandTone.info, title: cart.notice),
          const SizedBox(height: 8),
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
          if (cart.savedForLater.isNotEmpty) ...[
            SectionHeading('Saved for later'),
            for (final line in cart.savedForLater)
              _LineTile(
                controller: controller,
                line: line,
                savedForLater: true,
              ),
          ],
        ],
      ),
    );
  }

  Widget _summary(BuildContext context, CartView cart) => SafeArea(
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
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            children: [
              const Text(
                'Materials subtotal (advisory)',
                style: TextStyle(color: BuyerTheme.muted),
              ),
              Text(
                formatPeso(cart.materialsSubtotalCentavos),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: controller.busy
                ? null
                : () => navigation.openCheckout(context),
            child: Text(
              cart.groups.length > 1
                  ? 'Review ${cart.groups.length} Vendor orders'
                  : 'Review checkout',
            ),
          ),
        ],
      ),
    ),
  );
}

class _GroupSection extends StatelessWidget {
  const _GroupSection({required this.controller, required this.group});

  final CartController controller;
  final CartGroupView group;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
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
            Row(
              children: [
                const Icon(LucideIcons.store, color: BuyerTheme.action),
                const SizedBox(width: 8),
                Expanded(
                  child: Semantics(
                    header: true,
                    child: Text(
                      group.vendorName,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (group.status != 'READY')
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
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
                padding: EdgeInsets.only(bottom: 8),
                child: StatusBand(
                  tone: BandTone.warning,
                  title: 'This store has paused new procurement',
                ),
              ),
            _fulfillment(context),
            const Divider(height: 24),
            for (final line in group.lines)
              _LineTile(
                controller: controller,
                line: line,
                savedForLater: false,
              ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Group subtotal ${formatPeso(group.materialsSubtotalCentavos)}',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Widget _fulfillment(BuildContext context) {
    final options = group.fulfillmentOptions;
    if (options.isEmpty) {
      return const StatusBand(
        tone: BandTone.danger,
        title: 'This store has no fulfillment method available',
      );
    }
    if (options.length == 1) {
      return Text(
        options.first == 'DELIVERY' ? 'Site Delivery only' : 'Self-Pickup only',
        style: const TextStyle(fontWeight: FontWeight.w600),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Fulfillment for this store',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ChoiceChip(
              selected: group.fulfillmentMethod == 'DELIVERY',
              showCheckmark: true,
              avatar: const Icon(LucideIcons.truck, size: 18),
              label: const Text('Site Delivery'),
              onSelected: controller.busy
                  ? null
                  : (_) =>
                        controller.setFulfillment(group.vendorId, 'DELIVERY'),
            ),
            ChoiceChip(
              selected: group.fulfillmentMethod == 'PICKUP',
              showCheckmark: true,
              avatar: const Icon(LucideIcons.store, size: 18),
              label: const Text('Self-Pickup'),
              onSelected: controller.busy
                  ? null
                  : (_) => controller.setFulfillment(group.vendorId, 'PICKUP'),
            ),
          ],
        ),
        if (group.fulfillmentMethod == null)
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Text(
              'Choose how you will receive this store’s items.',
              style: TextStyle(fontSize: 12, color: BuyerTheme.muted),
            ),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 56,
                  height: 56,
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
                          errorBuilder: (_, _, _) => const ColoredBox(
                            color: BuyerTheme.canvas,
                            child: Icon(LucideIcons.imageOff),
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 12),
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
                        style: const TextStyle(
                          fontSize: 12,
                          color: BuyerTheme.muted,
                        ),
                      ),
                    if (line.appliedUnitPriceCentavos != null)
                      Text(
                        '${formatPeso(line.appliedUnitPriceCentavos!)} / ${line.unitName}${line.volumeTierApplied ? ' · volume price' : ''}',
                      ),
                    if (line.stockLabel != null)
                      StockLabelText(label: line.stockLabel),
                    if (line.lineTotalCentavos != null)
                      Text(
                        'Line total ${formatPeso(line.lineTotalCentavos!)}',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                  ],
                ),
              ),
            ],
          ),
          for (final issue in line.issues)
            Padding(
              padding: const EdgeInsets.only(top: 6),
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
          const SizedBox(height: 4),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              if (!savedForLater && line.available && whole)
                QuantityStepper(
                  quantity: quantity.round(),
                  unitName: line.unitName,
                  enabled: !busy,
                  onChanged: (value) =>
                      controller.changeQuantity(line, '$value'),
                )
              else if (!savedForLater)
                Text(
                  'Quantity ${formatQuantity(line.quantity)} ${line.unitName}',
                ),
              TextButton.icon(
                onPressed: busy
                    ? null
                    : () =>
                          controller.saveForLater(line, saved: !savedForLater),
                icon: Icon(
                  savedForLater
                      ? LucideIcons.shoppingCart
                      : LucideIcons.bookmark,
                ),
                label: Text(savedForLater ? 'Move to cart' : 'Save for later'),
              ),
              TextButton.icon(
                onPressed: busy ? null : () => controller.remove(line),
                icon: const Icon(LucideIcons.trash2),
                label: const Text('Remove'),
              ),
            ],
          ),
          const Divider(height: 16),
        ],
      ),
    );
  }
}
