import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../design_system/components/order_components.dart';
import '../../design_system/generated/color_tokens.dart';
import '../../design_system/theme.dart';
import '../item_procurement/procurement_models.dart' show formatPeso;
import 'order_details_screen.dart';
import 'order_models.dart';
import 'orders_repository.dart';
import 'orders_screen.dart';

/// Confirmation after submission: the parent checkout reference and one row per Vendor child order
/// with its own state. An auto-accepted order shows its 45-minute payment countdown; the others show
/// the Vendor's 24-hour response deadline. Nothing here claims a payment was made.
class OrderSubmittedScreen extends StatelessWidget {
  const OrderSubmittedScreen({
    super.key,
    required this.checkout,
    required this.repository,
  });

  final CheckoutView checkout;
  final OrdersRepository repository;

  void _openOrders(BuildContext context) =>
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) =>
              OrdersScreen(repository: repository, initialGroup: 'ALL'),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final count = checkout.orders.length;
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () =>
                      Navigator.of(context).popUntil((route) => route.isFirst),
                  child: const Text('Back to Home'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton(
                  onPressed: () => _openOrders(context),
                  child: const Text('View my orders'),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
          children: [
            Center(
              child: Container(
                width: 112,
                height: 112,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(MateryalColorTokens.brandOrange50),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  LucideIcons.circleCheck,
                  size: 56,
                  color: BuyerTheme.action,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Semantics(
              header: true,
              child: Text(
                count == 1
                    ? 'Order request sent'
                    : '$count order requests sent',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              checkout.notice,
              textAlign: TextAlign.center,
              style: const TextStyle(color: BuyerTheme.muted),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: BuyerTheme.canvas,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: BuyerTheme.border),
              ),
              child: Row(
                children: [
                  const Icon(LucideIcons.receiptText, color: BuyerTheme.action),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          checkout.reference,
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                        Text(
                          'Submitted ${formatManilaDateTime(checkout.submittedAt)}',
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
            const SizedBox(height: 12),
            for (final order in checkout.orders)
              _ChildOrderCard(
                order: order,
                onOpen: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => OrderDetailsScreen(
                      orderId: order.id,
                      repository: repository,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ChildOrderCard extends StatelessWidget {
  const _ChildOrderCard({required this.order, required this.onOpen});

  final CheckoutChildView order;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: BuyerTheme.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onOpen,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      order.vendorName,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(child: OrderStateChip(state: order.orderState)),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '${order.reference} · ${order.fulfillmentMethod == 'DELIVERY' ? 'Site Delivery' : 'Self-Pickup'} · ${formatPeso(order.commercialTotalCentavos)}${order.deliveryPending ? ' + delivery' : ''}',
                style: const TextStyle(fontSize: 12, color: BuyerTheme.muted),
              ),
              const SizedBox(height: 8),
              if (order.paymentExpiresAt != null)
                DeadlineCountdown(
                  deadline: order.paymentExpiresAt!,
                  label: order.autoAccepted
                      ? 'Accepted automatically — pay within'
                      : 'Pay within',
                  endedLabel: 'Payment window ended',
                )
              else if (order.vendorResponseDueAt != null)
                Text(
                  'The Vendor responds by ${formatManilaDateTime(order.vendorResponseDueAt!)}. Nothing is reserved or charged until then.',
                  style: const TextStyle(fontSize: 13),
                ),
            ],
          ),
        ),
      ),
    ),
  );
}
