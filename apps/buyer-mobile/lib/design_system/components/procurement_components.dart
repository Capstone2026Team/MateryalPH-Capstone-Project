import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../generated/color_tokens.dart';
import '../theme.dart';

/// Severity bands, stock labels, badges, summary cards, skeletons and state messages shared by the
/// Item-Based screens. Status is always text plus an icon, never color alone.
enum BandTone { info, success, warning, danger }

class StatusBand extends StatelessWidget {
  const StatusBand({
    super.key,
    required this.tone,
    required this.title,
    this.message,
    this.action,
  });

  final BandTone tone;
  final String title;
  final String? message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final (IconData icon, Color foreground, Color background) = switch (tone) {
      BandTone.success => (
        LucideIcons.circleCheck,
        const Color(MateryalColorTokens.statusSuccess),
        const Color(MateryalColorTokens.surfaceCanvas),
      ),
      BandTone.warning => (
        LucideIcons.triangleAlert,
        const Color(MateryalColorTokens.actionPrimaryPressed),
        const Color(MateryalColorTokens.brandOrange50),
      ),
      BandTone.danger => (
        LucideIcons.octagonAlert,
        const Color(MateryalColorTokens.statusError),
        const Color(MateryalColorTokens.surfaceCanvas),
      ),
      BandTone.info => (
        LucideIcons.info,
        BuyerTheme.ink,
        const Color(MateryalColorTokens.surfaceCanvas),
      ),
    };
    return Semantics(
      container: true,
      liveRegion: tone == BandTone.danger || tone == BandTone.warning,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(8),
          border: Border(left: BorderSide(color: foreground, width: 4)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 20, color: foreground),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: BuyerTheme.ink,
                    ),
                  ),
                  if (message != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      message!,
                      style: const TextStyle(color: BuyerTheme.ink),
                    ),
                  ],
                  if (action != null) ...[const SizedBox(height: 8), action!],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Public stock vocabulary only: In Stock or Limited Stock. Exact quantities are never shown.
class StockLabelText extends StatelessWidget {
  const StockLabelText({super.key, required this.label});

  final String? label;

  @override
  Widget build(BuildContext context) {
    final (String text, IconData icon, Color color) = switch (label) {
      'IN_STOCK' => (
        'In Stock',
        LucideIcons.packageCheck,
        const Color(MateryalColorTokens.statusSuccess),
      ),
      'LIMITED_STOCK' => (
        'Limited Stock',
        LucideIcons.packageMinus,
        const Color(MateryalColorTokens.actionPrimaryPressed),
      ),
      _ => ('Not currently offered', LucideIcons.packageX, BuyerTheme.muted),
    };
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            text,
            style: TextStyle(fontWeight: FontWeight.w600, color: color),
          ),
        ),
      ],
    );
  }
}

class ListingBadge extends StatelessWidget {
  const ListingBadge({super.key, required this.code});

  /// BEST_PRICE or PS_ICC_VERIFIED. A Favorite is a personal marker, never a badge.
  final String code;

  @override
  Widget build(BuildContext context) {
    final (String text, IconData icon) = switch (code) {
      'BEST_PRICE' => ('Best Price', LucideIcons.badgePercent),
      _ => ('PS/ICC evidence verified', LucideIcons.shieldCheck),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(MateryalColorTokens.brandOrange50),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: BuyerTheme.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: BuyerTheme.actionPressed),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: BuyerTheme.actionPressed,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A neutral placeholder block. Loading never shows a false zero or empty state.
class SkeletonBox extends StatelessWidget {
  const SkeletonBox({super.key, this.height = 16, this.width});

  final double height;
  final double? width;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: const Color(MateryalColorTokens.surfaceCanvas),
        borderRadius: BorderRadius.circular(6),
      ),
    ),
  );
}

/// A dashboard count with its label, unit and scope. While [value] is null a skeleton is shown and
/// the semantics say Loading, so no false zero ever appears.
class SummaryCountCard extends StatelessWidget {
  const SummaryCountCard({
    super.key,
    required this.label,
    required this.icon,
    this.value,
    this.unit,
  });

  final String label;
  final IconData icon;
  final int? value;
  final String? unit;

  @override
  Widget build(BuildContext context) => Semantics(
    container: true,
    label: value == null
        ? '$label, loading'
        : '$label: $value${unit == null ? '' : ' $unit'}',
    excludeSemantics: true,
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: BuyerTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: BuyerTheme.action),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: BuyerTheme.muted,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (value == null)
            const SkeletonBox(height: 28, width: 56)
          else
            Text(
              '$value',
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: BuyerTheme.ink,
              ),
            ),
          if (unit != null)
            Text(
              unit!,
              style: const TextStyle(fontSize: 12, color: BuyerTheme.muted),
            ),
        ],
      ),
    ),
  );
}

enum StateKind { empty, offline, error, needsLocation, forbidden }

/// Empty, offline, error and permission states with a specific cause and a next action.
class StateMessage extends StatelessWidget {
  const StateMessage({
    super.key,
    required this.kind,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.secondaryLabel,
    this.onSecondary,
  });

  final StateKind kind;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;

  @override
  Widget build(BuildContext context) {
    final icon = switch (kind) {
      StateKind.offline => LucideIcons.wifiOff,
      StateKind.error => LucideIcons.circleAlert,
      StateKind.needsLocation => LucideIcons.mapPinOff,
      StateKind.forbidden => LucideIcons.lock,
      StateKind.empty => LucideIcons.searchX,
    };
    return Semantics(
      container: true,
      liveRegion: kind != StateKind.empty,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 40, color: BuyerTheme.muted),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(message, textAlign: TextAlign.center),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 16),
              FilledButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
            if (secondaryLabel != null && onSecondary != null) ...[
              const SizedBox(height: 8),
              TextButton(onPressed: onSecondary, child: Text(secondaryLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}

/// Quantity editor with 48 px targets and a readable value; step comes from the sale unit.
class QuantityStepper extends StatelessWidget {
  const QuantityStepper({
    super.key,
    required this.quantity,
    required this.onChanged,
    required this.unitName,
    this.enabled = true,
    this.minimum = 1,
  });

  final int quantity;
  final ValueChanged<int> onChanged;
  final String unitName;
  final bool enabled;
  final int minimum;

  @override
  Widget build(BuildContext context) => Semantics(
    container: true,
    label: 'Quantity',
    value: '$quantity $unitName',
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton.outlined(
          tooltip: 'Decrease quantity',
          onPressed: enabled && quantity > minimum
              ? () => onChanged(quantity - 1)
              : null,
          icon: const Icon(LucideIcons.minus),
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 44),
          child: Text(
            '$quantity',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
        IconButton.filled(
          tooltip: 'Increase quantity',
          onPressed: enabled ? () => onChanged(quantity + 1) : null,
          icon: const Icon(LucideIcons.plus),
        ),
      ],
    ),
  );
}

/// A section heading with a 1 px rule, used instead of nesting more cards.
class SectionHeading extends StatelessWidget {
  const SectionHeading(this.text, {super.key, this.trailing});

  final String text;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 20, bottom: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Semantics(
                header: true,
                child: Text(
                  text,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            ?trailing,
          ],
        ),
        const SizedBox(height: 6),
        const Divider(height: 1),
      ],
    ),
  );
}
