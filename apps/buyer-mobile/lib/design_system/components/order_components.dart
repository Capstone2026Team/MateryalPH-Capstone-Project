import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../features/item_procurement/procurement_models.dart'
    show formatPeso;
import '../../features/orders/order_models.dart';
import '../generated/color_tokens.dart';
import '../theme.dart';

/// Order building blocks shared by the order hub, order details, checkout confirmation and the NRPC
/// disclosure. Status is always text plus an icon; money is integer centavos formatted once here.

Color _toneColor(StateTone tone) => switch (tone) {
  StateTone.success => BuyerTheme.successStrong,
  StateTone.warning => const Color(MateryalColorTokens.actionPrimaryPressed),
  StateTone.danger => const Color(MateryalColorTokens.statusError),
  StateTone.info => BuyerTheme.ink,
  StateTone.neutral => BuyerTheme.muted,
};

IconData _toneIcon(StateTone tone) => switch (tone) {
  StateTone.success => LucideIcons.circleCheck,
  StateTone.warning => LucideIcons.clock,
  StateTone.danger => LucideIcons.circleX,
  StateTone.info => LucideIcons.circleDot,
  StateTone.neutral => LucideIcons.circleDashed,
};

/// A compact order-state label for cards.
class OrderStateChip extends StatelessWidget {
  const OrderStateChip({super.key, required this.state});

  final String state;

  @override
  Widget build(BuildContext context) {
    final tone = orderStateTone(state);
    final color = _toneColor(tone);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: tone == StateTone.warning
            ? const Color(MateryalColorTokens.brandOrange50)
            : BuyerTheme.canvas,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: BuyerTheme.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_toneIcon(tone), size: 14, color: color),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              orderStateLabel(state),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Order, payment, fulfillment, refund and dispute as five separate labelled rows, so no single
/// status bar implies the others.
class OrderStateRows extends StatelessWidget {
  const OrderStateRows({super.key, required this.states});

  final List<OrderStateRowView> states;

  static const _familyIcons = {
    'ORDER': LucideIcons.package,
    'PAYMENT': LucideIcons.creditCard,
    'FULFILLMENT': LucideIcons.truck,
    'REFUND': LucideIcons.undo2,
    'DISPUTE': LucideIcons.scale,
  };

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: BuyerTheme.border),
    ),
    child: Column(
      children: [
        for (var index = 0; index < states.length; index++) ...[
          if (index > 0) const Divider(height: 1, color: BuyerTheme.border),
          Semantics(
            container: true,
            label:
                '${orderFamilyLabel(states[index].family)}: ${orderStateLabel(states[index].state)}',
            excludeSemantics: true,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 44),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Icon(
                      _familyIcons[states[index].family] ?? LucideIcons.package,
                      size: 18,
                      color: BuyerTheme.muted,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        orderFamilyLabel(states[index].family),
                        style: const TextStyle(color: BuyerTheme.muted),
                      ),
                    ),
                    Icon(
                      _toneIcon(orderStateTone(states[index].state)),
                      size: 16,
                      color: _toneColor(orderStateTone(states[index].state)),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      flex: 2,
                      child: Text(
                        orderStateLabel(states[index].state),
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: _toneColor(
                            orderStateTone(states[index].state),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ],
    ),
  );
}

String _remaining(Duration left) {
  final seconds = left.inSeconds + (left.inMilliseconds % 1000 > 0 ? 1 : 0);
  final hours = seconds ~/ 3600;
  final minutes = (seconds % 3600) ~/ 60;
  final rest = seconds % 60;
  if (hours >= 24) return '${hours ~/ 24} d ${hours % 24} h';
  if (hours > 0) return '$hours h ${minutes.toString().padLeft(2, '0')} min';
  return '${minutes.toString().padLeft(2, '0')}:${rest.toString().padLeft(2, '0')}';
}

/// A deadline as a live countdown plus the exact Asia/Manila date and time. It ticks every second
/// in the last hour; at zero it shows a resolved "ended" state and calls [onExpired] once so the
/// screen reloads the server state instead of spinning. [now] fixes the clock in tests.
class DeadlineCountdown extends StatefulWidget {
  const DeadlineCountdown({
    super.key,
    required this.deadline,
    required this.label,
    this.endedLabel = 'Window ended',
    this.onExpired,
    this.now,
  });

  final DateTime deadline;
  final String label;
  final String endedLabel;
  final VoidCallback? onExpired;
  final DateTime Function()? now;

  @override
  State<DeadlineCountdown> createState() => _DeadlineCountdownState();
}

class _DeadlineCountdownState extends State<DeadlineCountdown> {
  Timer? _timer;
  bool _fired = false;

  DateTime get _now => (widget.now ?? DateTime.now)();

  @override
  void initState() {
    super.initState();
    _schedule();
  }

  @override
  void didUpdateWidget(DeadlineCountdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.deadline != widget.deadline) {
      _fired = false;
      _schedule();
    }
  }

  void _schedule() {
    _timer?.cancel();
    final left = widget.deadline.difference(_now);
    if (left <= Duration.zero) {
      _expire();
      return;
    }
    _timer = Timer(
      left <= const Duration(hours: 1)
          ? const Duration(seconds: 1)
          : const Duration(seconds: 30),
      () {
        if (!mounted) return;
        setState(() {});
        _schedule();
      },
    );
  }

  void _expire() {
    if (_fired) return;
    _fired = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) widget.onExpired?.call();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final left = widget.deadline.difference(_now);
    final ended = left <= Duration.zero;
    final urgent = !ended && left <= const Duration(minutes: 15);
    final exact = formatManilaDateTime(widget.deadline);
    return Semantics(
      container: true,
      liveRegion: ended,
      label: ended
          ? '${widget.label}: ${widget.endedLabel}. Ended $exact'
          : '${widget.label}: ${_remaining(left)} left, until $exact',
      excludeSemantics: true,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: ended
              ? BuyerTheme.canvas
              : urgent
              ? const Color(MateryalColorTokens.brandOrange50)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: urgent ? BuyerTheme.action : BuyerTheme.border,
          ),
        ),
        child: Row(
          children: [
            Icon(
              ended ? LucideIcons.clockAlert : LucideIcons.timer,
              color: ended ? BuyerTheme.muted : BuyerTheme.action,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.label,
                    style: const TextStyle(
                      fontSize: 12,
                      color: BuyerTheme.muted,
                    ),
                  ),
                  Text(
                    ended ? widget.endedLabel : _remaining(left),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      fontFeatures: const [FontFeature.tabularFigures()],
                      color: ended ? BuyerTheme.muted : BuyerTheme.ink,
                    ),
                  ),
                  Text(
                    '${ended ? 'Ended' : 'Until'} $exact',
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
    );
  }
}

class _MoneyRow extends StatelessWidget {
  const _MoneyRow(
    this.label,
    this.value, {
    this.note,
    this.strong = false,
    this.muted = false,
  });

  final String label;
  final String value;
  final String? note;
  final bool strong;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    final description = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: strong ? FontWeight.w800 : FontWeight.w500,
            color: muted ? BuyerTheme.muted : BuyerTheme.ink,
          ),
        ),
        if (note != null)
          Text(
            note!,
            style: const TextStyle(fontSize: 12, color: BuyerTheme.muted),
          ),
      ],
    );
    final amount = Text(
      value,
      textAlign: TextAlign.right,
      style: TextStyle(
        fontSize: strong ? 17 : 14,
        fontWeight: strong ? FontWeight.w800 : FontWeight.w600,
        color: muted ? BuyerTheme.muted : BuyerTheme.ink,
      ),
    );
    return Padding(
      padding: EdgeInsets.only(top: strong ? 10 : 6, bottom: 6),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final stacked =
              constraints.maxWidth < 400 &&
              MediaQuery.textScalerOf(context).scale(14) >= 21;
          return stacked
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [description, const SizedBox(height: 4), amount],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: description),
                    const SizedBox(width: 12),
                    Flexible(child: amount),
                  ],
                );
        },
      ),
    );
  }
}

/// FIN-02 Buyer amounts: materials, discount, included VAT (never added again), delivery, the NRPC
/// allocation inside the materials value, the processing fee and the total. Vendor commission and
/// merchant withholding are never Buyer charges and never appear here.
class MoneyBreakdownCard extends StatelessWidget {
  const MoneyBreakdownCard({super.key, required this.money});

  final MoneyView money;

  @override
  Widget build(BuildContext context) {
    final delivery = switch (money.deliveryStatus) {
      'NOT_APPLICABLE' => 'None (Self-Pickup)',
      _ when money.deliveryCentavos != null => formatPeso(
        money.deliveryCentavos!,
      ),
      _ when money.deliveryEstimateMin != null =>
        money.deliveryEstimateMin == money.deliveryEstimateMax
            ? 'Est. ${formatPeso(money.deliveryEstimateMin!)}'
            : 'Est. ${formatPeso(money.deliveryEstimateMin!)} – ${formatPeso(money.deliveryEstimateMax!)}',
      _ => 'Set by the Vendor',
    };
    final fee = switch (money.processingFeeStatus) {
      'NOT_APPLICABLE' => 'None',
      _ when money.processingFeeCentavos != null => formatPeso(
        money.processingFeeCentavos!,
      ),
      _ => 'Shown at payment',
    };
    final physical =
        money.paymentPurpose != 'FULL_ORDER_PAYMENT' &&
        (money.physicalBalanceCentavos ?? 0) > 0;
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: BuyerTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            header: true,
            child: const Text(
              'Payment breakdown',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
            ),
          ),
          const SizedBox(height: 4),
          _MoneyRow('Materials', formatPeso(money.materialsGrossCentavos)),
          if (money.vendorDiscountCentavos > 0)
            _MoneyRow(
              'Vendor discount',
              '− ${formatPeso(money.vendorDiscountCentavos)}',
            ),
          _MoneyRow(
            'Materials subtotal',
            formatPeso(money.materialsSubtotalCentavos),
            note: money.pricesIncludeVat
                ? 'Prices include VAT'
                : 'No VAT included',
          ),
          if (money.includedVatCentavos > 0)
            _MoneyRow(
              'Included VAT',
              formatPeso(money.includedVatCentavos),
              note: 'Already in the subtotal',
              muted: true,
            ),
          _MoneyRow(
            'Delivery fee',
            delivery,
            note: money.deliveryStatus == 'PENDING_VENDOR_CONFIRMATION'
                ? 'The Vendor confirms it before you pay'
                : null,
          ),
          if (money.nrpcCentavos > 0)
            _MoneyRow(
              'Preparation cost (NRPC)',
              formatPeso(money.nrpcCentavos),
              note: 'Part of the materials subtotal, not an extra charge',
              muted: true,
            ),
          _MoneyRow(
            'Payment processing fee',
            fee,
            note: money.processingFeeStatus == 'PENDING_PAYMENT_CHANNEL'
                ? 'Disclosed when you choose a payment channel'
                : null,
          ),
          const Divider(height: 12, color: BuyerTheme.border),
          _MoneyRow(
            money.commercialTotalCentavos == null
                ? 'Total before delivery'
                : 'Order total',
            formatPeso(
              money.commercialTotalCentavos ?? money.materialsSubtotalCentavos,
            ),
            note: money.processingFeeStatus == 'PENDING_PAYMENT_CHANNEL'
                ? 'Before the processing fee'
                : null,
            strong: true,
          ),
          if (physical)
            _MoneyRow(
              'Pay the Vendor directly',
              formatPeso(money.physicalBalanceCentavos!),
            ),
        ],
      ),
    );
  }
}
