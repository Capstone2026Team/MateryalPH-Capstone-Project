import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../features/map_discovery/discovery_models.dart';
import '../generated/color_tokens.dart';
import '../theme.dart';

/// Shared floating map surface for search, location details and map controls.
class MapFloatingSurface extends StatelessWidget {
  static const shadowColor = Color(0x240F172A);
  const MapFloatingSurface({super.key, required this.child, this.radius = 16});
  final Widget child;
  final double radius;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: BuyerTheme.border),
      boxShadow: const [
        BoxShadow(
          color: shadowColor,
          blurRadius: 8,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Material(
      type: MaterialType.transparency,
      borderRadius: BorderRadius.circular(radius),
      child: child,
    ),
  );
}

/// Fixed 5/10/20/30/40/50 km chips with a visible selected state (fill, check icon and bold
/// text, not color alone). Selecting a chip is an explicit Buyer choice; automatic expansion
/// goes through [confirmRadiusExpansion] first.
class RadiusSelector extends StatelessWidget {
  const RadiusSelector({
    super.key,
    required this.selectedKm,
    required this.onSelected,
    this.enabled = true,
  });

  final int selectedKm;
  final ValueChanged<int> onSelected;
  final bool enabled;

  @override
  Widget build(BuildContext context) => Semantics(
    container: true,
    label: 'Search radius',
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final km in kDiscoveryRadiiKm)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Semantics(
                selected: km == selectedKm,
                button: true,
                label: '$km kilometres${km == selectedKm ? ', selected' : ''}',
                excludeSemantics: true,
                child: ChoiceChip(
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                  visualDensity: VisualDensity.standard,
                  showCheckmark: true,
                  checkmarkColor: Colors.white,
                  selected: km == selectedKm,
                  selectedColor: BuyerTheme.action,
                  backgroundColor: Colors.white,
                  side: BorderSide(
                    color: km == selectedKm
                        ? BuyerTheme.action
                        : BuyerTheme.border,
                  ),
                  label: Text(
                    '$km km',
                    style: TextStyle(
                      fontWeight: km == selectedKm
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: km == selectedKm ? Colors.white : BuyerTheme.ink,
                    ),
                  ),
                  onSelected: enabled ? (_) => onSelected(km) : null,
                ),
              ),
            ),
        ],
      ),
    ),
  );
}

/// Asks before any radius expansion. Returns true only when the Buyer confirms.
Future<bool> confirmRadiusExpansion(
  BuildContext context, {
  required int fromKm,
  required int toKm,
  required int verifiedCount,
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Search within $toKm km?'),
      content: Text(
        verifiedCount == 0
            ? 'No Verified Vendors were found within $fromKm km. Expanding shows suppliers up to $toKm km away. Your current radius stays at $fromKm km unless you continue.'
            : 'Only $verifiedCount Verified Vendor${verifiedCount == 1 ? ' was' : 's were'} found within $fromKm km. Expanding shows suppliers up to $toKm km away.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text('Keep $fromKm km'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text('Expand to $toKm km'),
        ),
      ],
    ),
  );
  return confirmed ?? false;
}

/// The active origin in the header: label, location name and a chevron that opens Select Location.
class LocationSelector extends StatelessWidget {
  const LocationSelector({
    super.key,
    required this.label,
    required this.onPressed,
    this.detail,
  });

  final String label;
  final String? detail;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label:
        'Location: $label${detail == null ? '' : ', $detail'}. Change location',
    excludeSemantics: true,
    child: InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 48),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      'Location',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: BuyerTheme.muted,
                      ),
                    ),
                  ),
                  Icon(
                    LucideIcons.chevronDown,
                    size: 16,
                    color: BuyerTheme.action,
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(
                    LucideIcons.mapPin,
                    size: 18,
                    color: BuyerTheme.action,
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: BuyerTheme.ink,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

/// Score semantics are explicit: VPS, New Vendor and Directory never look interchangeable, and a
/// Google rating is a separate [GoogleRatingBadge] shown only inside Place Details.
class ScoreBadge extends StatelessWidget {
  const ScoreBadge({super.key, required this.kind, required this.text});

  final ScoreKind kind;
  final String text;

  @override
  Widget build(BuildContext context) {
    final (IconData icon, Color foreground, Color background) = switch (kind) {
      ScoreKind.vps => (
        LucideIcons.gauge,
        const Color(MateryalColorTokens.actionPrimaryPressed),
        const Color(MateryalColorTokens.brandOrange50),
      ),
      ScoreKind.newVendor => (
        LucideIcons.sprout,
        const Color(MateryalColorTokens.textStrong),
        const Color(MateryalColorTokens.surfaceCanvas),
      ),
      ScoreKind.directory => (
        LucideIcons.building2,
        const Color(MateryalColorTokens.textSecondary),
        const Color(MateryalColorTokens.surfaceCanvas),
      ),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: BuyerTheme.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: foreground),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: foreground,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TierBadge extends StatelessWidget {
  const TierBadge({super.key, required this.tier});

  final SupplierTier tier;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(
        tier == SupplierTier.verified
            ? LucideIcons.badgeCheck
            : LucideIcons.building2,
        size: 16,
        color: tier == SupplierTier.verified
            ? BuyerTheme.action
            : BuyerTheme.muted,
      ),
      const SizedBox(width: 4),
      Flexible(
        child: Text(
          tier == SupplierTier.verified
              ? 'Verified Vendor'
              : 'Directory Supplier',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: BuyerTheme.muted,
          ),
        ),
      ),
    ],
  );
}

class GoogleRatingBadge extends StatelessWidget {
  const GoogleRatingBadge({super.key, required this.value, this.count});

  final String value;
  final int? count;

  @override
  Widget build(BuildContext context) => Semantics(
    label:
        'Google rating $value${count == null ? '' : ' from $count reviews'}. Source: Google',
    excludeSemantics: true,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(LucideIcons.star, size: 16, color: BuyerTheme.ink),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            'Google rating $value${count == null ? '' : ' ($count)'}',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    ),
  );
}
