import 'package:flutter/material.dart';

String compactBadgeQuantity(String quantity) {
  final parts = quantity.split('.');
  final whole = BigInt.tryParse(parts.first) ?? BigInt.zero;
  if (whole > BigInt.from(99) ||
      (whole == BigInt.from(99) &&
          parts.length > 1 &&
          (int.tryParse(parts[1]) ?? 0) > 0)) {
    return '99+';
  }
  return quantity;
}

bool positiveBadgeQuantity(String quantity) =>
    RegExp(r'^\d+(\.\d{1,4})?$').hasMatch(quantity) &&
    quantity.replaceAll(RegExp(r'[0.]'), '').isNotEmpty;

/// Shared compact geometry for unread, active-record and exact-quantity badges.
class CountBadge extends StatelessWidget {
  const CountBadge({super.key, required this.quantity, this.child});
  final String quantity;
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    final visible = positiveBadgeQuantity(quantity);
    if (child != null) {
      return Badge(
        largeSize: 20,
        isLabelVisible: visible,
        label: Text(compactBadgeQuantity(quantity)),
        backgroundColor: Theme.of(context).colorScheme.error,
        textColor: Colors.white,
        textStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
        child: child,
      );
    }
    if (!visible) return const SizedBox.shrink();
    return ExcludeSemantics(
      child: Container(
        constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.error,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          compactBadgeQuantity(quantity),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
