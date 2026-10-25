import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'buyer_overlays.dart';
import '../../features/map_discovery/discovery_models.dart';
import '../../features/map_discovery/supplier_browsing.dart';
import '../generated/color_tokens.dart';
import '../theme.dart';

/// One accessible toolbar for the supplier sheet, full list and wide-screen list.
class SupplierListControls extends StatelessWidget {
  const SupplierListControls({
    super.key,
    required this.searchController,
    required this.view,
    required this.availableViews,
    required this.sort,
    required this.resultCount,
    required this.onQueryChanged,
    required this.onViewChanged,
    required this.onSortChanged,
    this.onSearchFocused,
  });

  final TextEditingController searchController;
  final SupplierListView view;
  final List<SupplierListView> availableViews;
  final SupplierListSort sort;
  final int? resultCount;
  final ValueChanged<String> onQueryChanged;
  final ValueChanged<SupplierListView> onViewChanged;
  final ValueChanged<SupplierListSort> onSortChanged;
  final VoidCallback? onSearchFocused;

  @override
  Widget build(BuildContext context) {
    final distanceActive =
        sort == SupplierListSort.nearest || sort == SupplierListSort.farthest;
    final ratingActive = !distanceActive;
    void choose(SupplierListSort value) {
      FocusManager.instance.primaryFocus?.unfocus();
      onSortChanged(value);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          label: 'Search store names in ${view.label}',
          child: TextField(
            key: const ValueKey('supplier-name-search'),
            controller: searchController,
            onChanged: onQueryChanged,
            onTap: onSearchFocused,
            textInputAction: TextInputAction.search,
            onSubmitted: (_) => FocusScope.of(context).unfocus(),
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Search store names',
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              constraints: const BoxConstraints(minHeight: 44),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (searchController.text.isNotEmpty)
                    IconButton(
                      tooltip: 'Clear store search',
                      constraints: const BoxConstraints(
                        minWidth: 44,
                        minHeight: 44,
                      ),
                      onPressed: () {
                        searchController.clear();
                        onQueryChanged('');
                      },
                      icon: const Icon(LucideIcons.x, size: 18),
                    ),
                  const Padding(
                    padding: EdgeInsets.only(right: 16, left: 8),
                    child: Icon(
                      LucideIcons.search,
                      size: 20,
                      color: BuyerTheme.action,
                    ),
                  ),
                ],
              ),
              filled: true,
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(28),
                borderSide: const BorderSide(color: BuyerTheme.action),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(28),
                borderSide: const BorderSide(
                  color: BuyerTheme.action,
                  width: 1.5,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 6,
          children: [
            for (final option in availableViews)
              ChoiceChip(
                key: ValueKey('supplier-view-${option.name}'),
                selected: view == option,
                label: Text(option.label),
                labelStyle: const TextStyle(fontSize: 13),
                padding: const EdgeInsets.symmetric(horizontal: 6),
                onSelected: (_) => onViewChanged(option),
                materialTapTargetSize: MaterialTapTargetSize.padded,
              ),
          ],
        ),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 4,
          children: [
            _SupplierSortTab(
              key: const ValueKey('supplier-sort-distance'),
              label: 'Distance',
              selected: distanceActive,
              ascending: sort == SupplierListSort.nearest,
              description: distanceActive
                  ? sort.label(view)
                  : 'Sort by distance',
              onTap: () => choose(
                sort == SupplierListSort.nearest
                    ? SupplierListSort.farthest
                    : SupplierListSort.nearest,
              ),
            ),
            _SupplierSortTab(
              key: const ValueKey('supplier-sort-rating'),
              label: 'Rating',
              selected: ratingActive,
              ascending: sort == SupplierListSort.lowestRating,
              description: ratingActive
                  ? sort.label(view)
                  : view == SupplierListView.directory
                  ? 'Sort by Google rating'
                  : 'Sort by VPS',
              onTap: () => choose(
                sort == SupplierListSort.highestRating
                    ? SupplierListSort.lowestRating
                    : SupplierListSort.highestRating,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Semantics(
                liveRegion: true,
                child: Text(
                  resultCount == null
                      ? 'Finding stores…'
                      : '$resultCount ${resultCount == 1 ? 'store' : 'stores'}${searchController.text.trim().isEmpty ? '' : ' found'}',
                  style: const TextStyle(color: BuyerTheme.muted, fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SupplierSortTab extends StatelessWidget {
  const _SupplierSortTab({
    super.key,
    required this.label,
    required this.selected,
    required this.ascending,
    required this.description,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final bool ascending;
  final String description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    selected: selected,
    label: description,
    excludeSemantics: true,
    onTap: onTap,
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: 44),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: selected ? BuyerTheme.action : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  color: selected ? BuyerTheme.action : BuyerTheme.ink,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                selected
                    ? ascending
                          ? LucideIcons.arrowUp
                          : LucideIcons.arrowDown
                    : LucideIcons.chevronsUpDown,
                size: 15,
                color: selected ? BuyerTheme.action : BuyerTheme.muted,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

/// A tier toggle and its related filters, with one consistent heading and inset.
class SupplierFilterSection extends StatelessWidget {
  const SupplierFilterSection({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
    this.children = const [],
    this.subtitle,
    this.icon,
  });

  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final List<Widget> children;

  /// Optional leading glyph for a section that applies across tiers (e.g. Favorites).
  final IconData? icon;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Semantics(
        header: true,
        child: SwitchListTile(
          contentPadding: EdgeInsets.zero,
          secondary: icon == null
              ? null
              : Icon(icon, size: 22, color: BuyerTheme.action),
          title: Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          subtitle: subtitle == null
              ? null
              : Text(
                  subtitle!,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color: BuyerTheme.muted,
                  ),
                ),
          value: value,
          onChanged: onChanged,
        ),
      ),
      if (children.isNotEmpty)
        Padding(
          padding: const EdgeInsets.only(left: 12, top: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          ),
        ),
    ],
  );
}

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
        BoxShadow(color: shadowColor, blurRadius: 8, offset: Offset(0, 2)),
      ],
    ),
    child: Material(
      type: MaterialType.transparency,
      borderRadius: BorderRadius.circular(radius),
      child: child,
    ),
  );
}

/// Round floating map control (recenter, layers, list) with a tooltip label.
class MapFloatingIconButton extends StatelessWidget {
  const MapFloatingIconButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => MapFloatingSurface(
    radius: 999,
    child: IconButton(tooltip: label, onPressed: onPressed, icon: Icon(icon)),
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
    builder: (context) => BuyerDialog(
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
    this.caption = 'Location',
    this.showAddress = true,
  });

  final String label;
  final String? detail;
  final String caption;
  final bool showAddress;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: showAddress
        ? 'Location: $label${detail == null ? '' : ', $detail'}. Change location'
        : '$caption. Change location on the Map',
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      caption,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: BuyerTheme.muted,
                      ),
                    ),
                  ),
                  const Icon(
                    LucideIcons.chevronDown,
                    size: 16,
                    color: BuyerTheme.action,
                  ),
                ],
              ),
              if (showAddress)
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
