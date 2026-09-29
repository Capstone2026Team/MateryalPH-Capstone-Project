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
  const StockLabelText({super.key, required this.label, this.compact = false});

  final String? label;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final (String text, IconData icon, Color color) = switch (label) {
      'IN_STOCK' => (
        'In Stock',
        LucideIcons.packageCheck,
        BuyerTheme.successStrong,
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
        Icon(icon, size: compact ? 14 : 16, color: color),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            text,
            style: TextStyle(
              fontSize: compact ? 12 : null,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}

class ListingBadge extends StatelessWidget {
  const ListingBadge({super.key, required this.code, this.solid = false});

  /// BEST_PRICE or PS_ICC_VERIFIED. A Favorite is a personal marker, never a badge.
  final String code;

  /// A filled, compact badge for product cards and photos.
  final bool solid;

  @override
  Widget build(BuildContext context) {
    final (String text, IconData icon) = switch (code) {
      'BEST_PRICE' => ('Best Price', LucideIcons.badgePercent),
      _ => (
        solid ? 'PS/ICC verified' : 'PS/ICC evidence verified',
        LucideIcons.shieldCheck,
      ),
    };
    if (solid) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        decoration: BoxDecoration(
          color: code == 'BEST_PRICE'
              ? BuyerTheme.successStrong
              : BuyerTheme.action,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: Colors.white),
            const SizedBox(width: 3),
            Flexible(
              child: Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  height: 1.2,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      );
    }
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
    this.artwork,
  });

  final StateKind kind;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;

  /// An optional decorative illustration from `assets/states/`, shown in place of the icon.
  final String? artwork;

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
            if (artwork != null)
              Image.asset(
                artwork!,
                height: 160,
                excludeFromSemantics: true,
                errorBuilder: (_, _, _) =>
                    Icon(icon, size: 40, color: BuyerTheme.muted),
              )
            else
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
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: BuyerTheme.muted),
            ),
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
    this.compact = false,
  });

  final int quantity;
  final ValueChanged<int> onChanged;
  final String unitName;
  final bool enabled;
  final int minimum;

  /// Small square steppers for list rows; each keeps a 44 px touch target.
  final bool compact;

  Widget _compactButton({
    required String tooltip,
    required IconData icon,
    required VoidCallback? onPressed,
    required bool filled,
  }) => IconButton(
    tooltip: tooltip,
    onPressed: onPressed,
    style: IconButton.styleFrom(
      minimumSize: const Size(44, 44),
      padding: EdgeInsets.zero,
    ),
    icon: Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: filled
            ? (onPressed == null ? BuyerTheme.border : BuyerTheme.action)
            : Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: filled ? null : Border.all(color: BuyerTheme.border),
      ),
      child: Icon(
        icon,
        size: 16,
        color: filled
            ? Colors.white
            : onPressed == null
            ? BuyerTheme.muted
            : BuyerTheme.ink,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) => Semantics(
    container: true,
    label: 'Quantity',
    value: '$quantity $unitName',
    child: compact
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _compactButton(
                tooltip: 'Decrease quantity',
                icon: LucideIcons.minus,
                filled: false,
                onPressed: enabled && quantity > minimum
                    ? () => onChanged(quantity - 1)
                    : null,
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 24),
                child: Text(
                  '$quantity',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              _compactButton(
                tooltip: 'Increase quantity',
                icon: LucideIcons.plus,
                filled: true,
                onPressed: enabled ? () => onChanged(quantity + 1) : null,
              ),
            ],
          )
        : _regular(),
  );

  Widget _regular() => Row(
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

/// The rounded catalog search field. With [onTap] it is a read-only entry point that opens the
/// dedicated search page; otherwise it edits [controller] directly.
class PillSearchField extends StatelessWidget {
  const PillSearchField({
    super.key,
    this.controller,
    this.text,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.onSearch,
    this.autofocus = false,
    this.hintText = 'Search any materials',
  });

  final TextEditingController? controller;

  /// The current query shown by the read-only form.
  final String? text;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onSearch;
  final bool autofocus;
  final String hintText;

  static final _shape = OutlineInputBorder(
    borderRadius: BorderRadius.circular(999),
    borderSide: const BorderSide(color: BuyerTheme.action, width: 1.5),
  );

  @override
  Widget build(BuildContext context) {
    if (onTap != null) {
      final hasText = text != null && text!.isNotEmpty;
      return Semantics(
        button: true,
        label: hasText ? 'Search materials, current search $text' : hintText,
        excludeSemantics: true,
        child: Material(
          color: Colors.white,
          shape: const StadiumBorder(
            side: BorderSide(color: BuyerTheme.action, width: 1.5),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 48),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 8, 14, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        hasText ? text! : hintText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: hasText
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: hasText ? BuyerTheme.ink : BuyerTheme.muted,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      LucideIcons.search,
                      size: 20,
                      color: BuyerTheme.action,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
    return TextField(
      controller: controller,
      autofocus: autofocus,
      maxLength: 100,
      textInputAction: TextInputAction.search,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      style: const TextStyle(fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        hintText: hintText,
        counterText: '',
        isDense: true,
        contentPadding: const EdgeInsets.fromLTRB(18, 14, 8, 14),
        border: _shape,
        enabledBorder: _shape,
        focusedBorder: _shape.copyWith(
          borderSide: const BorderSide(color: BuyerTheme.action, width: 2),
        ),
        suffixIcon: IconButton(
          tooltip: 'Search',
          onPressed: onSearch,
          icon: const Icon(LucideIcons.search, color: BuyerTheme.action),
        ),
      ),
    );
  }
}

/// A sort option. [directional] options show an up/down marker; [menu] options open a choice.
class SortTabItem {
  const SortTabItem({
    required this.label,
    required this.selected,
    required this.onTap,
    this.directional = false,
    this.descending = false,
    this.menu = false,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool directional;
  final bool descending;
  final bool menu;
}

/// Underlined sort tabs. The selected tab has bold text, an underline and a direction icon, so the
/// state never relies on color alone.
class SortTabBar extends StatelessWidget {
  const SortTabBar({super.key, required this.items});

  final List<SortTabItem> items;

  @override
  Widget build(BuildContext context) => Semantics(
    container: true,
    label: 'Sort results',
    child: DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: BuyerTheme.border)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(children: [for (final item in items) _tab(item)]),
      ),
    ),
  );

  Widget _tab(SortTabItem item) {
    final color = item.selected ? BuyerTheme.action : BuyerTheme.ink;
    final IconData? icon = item.menu
        ? LucideIcons.chevronDown
        : !item.directional
        ? null
        : !item.selected
        ? LucideIcons.chevronsUpDown
        : item.descending
        ? LucideIcons.arrowDown
        : LucideIcons.arrowUp;
    return Semantics(
      button: true,
      selected: item.selected,
      label:
          'Sort by ${item.label}${item.selected && item.directional ? (item.descending ? ', descending' : ', ascending') : ''}',
      excludeSemantics: true,
      child: InkWell(
        onTap: item.onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: 44),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: item.selected ? BuyerTheme.action : Colors.transparent,
                width: 2.5,
              ),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                item.label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: item.selected ? FontWeight.w700 : FontWeight.w500,
                  color: color,
                ),
              ),
              if (icon != null) ...[
                const SizedBox(width: 2),
                Icon(icon, size: 16, color: color),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// A rounded filter toggle. Selected pills are filled with a check icon; [onDeleted] adds a
/// remove control for scope filters such as a category or store.
class FilterPill extends StatelessWidget {
  const FilterPill({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.trailingIcon,
    this.onDeleted,
    this.deleteTooltip,
    this.maxLines = 1,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final IconData? trailingIcon;
  final VoidCallback? onDeleted;
  final String? deleteTooltip;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    final foreground = selected ? Colors.white : BuyerTheme.ink;
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      excludeSemantics: onDeleted == null,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 44),
        child: Center(
          widthFactor: 1,
          child: Material(
            color: selected ? BuyerTheme.action : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                color: selected ? BuyerTheme.action : BuyerTheme.border,
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  12,
                  7,
                  onDeleted == null ? 12 : 4,
                  7,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (selected) ...[
                      Icon(LucideIcons.check, size: 14, color: foreground),
                      const SizedBox(width: 4),
                    ],
                    // Needs a bounded width: a Wrap provides one; a horizontal scroller must
                    // wrap each pill in a max-width box (see [FilterPillRow]).
                    Flexible(
                      child: Text(
                        label,
                        maxLines: maxLines,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: selected
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: foreground,
                        ),
                      ),
                    ),
                    if (trailingIcon != null) ...[
                      const SizedBox(width: 4),
                      Icon(trailingIcon, size: 16, color: foreground),
                    ],
                    if (onDeleted != null)
                      IconButton(
                        tooltip: deleteTooltip ?? 'Remove $label',
                        onPressed: onDeleted,
                        visualDensity: VisualDensity.compact,
                        style: IconButton.styleFrom(
                          minimumSize: const Size(32, 32),
                          padding: EdgeInsets.zero,
                        ),
                        icon: Icon(LucideIcons.x, size: 16, color: foreground),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A single horizontally scrolling line of [FilterPill]s, each capped so long labels ellipsize.
class FilterPillRow extends StatelessWidget {
  const FilterPillRow({super.key, required this.pills});

  final List<Widget> pills;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    child: Row(
      children: [
        for (final pill in pills)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 260),
              child: pill,
            ),
          ),
      ],
    ),
  );
}

/// A round icon control with a 48 px target. [filled] is the orange page-level back action;
/// otherwise a white disc that stays legible over product photos.
class RoundIconButton extends StatelessWidget {
  const RoundIconButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.filled = false,
    this.badgeCount = 0,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final bool filled;
  final int badgeCount;

  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: tooltip,
    onPressed: onPressed,
    style: IconButton.styleFrom(
      minimumSize: const Size(48, 48),
      padding: EdgeInsets.zero,
    ),
    icon: Badge(
      isLabelVisible: badgeCount > 0,
      label: Text('$badgeCount'),
      backgroundColor: BuyerTheme.ink,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: filled ? BuyerTheme.action : Colors.white,
          border: filled ? null : Border.all(color: BuyerTheme.border),
          boxShadow: filled
              ? null
              : const [
                  BoxShadow(
                    color: Color(0x1F0F172A),
                    blurRadius: 4,
                    offset: Offset(0, 1),
                  ),
                ],
        ),
        child: Icon(
          icon,
          size: 20,
          color: filled ? Colors.white : BuyerTheme.ink,
        ),
      ),
    ),
  );
}

/// Boxed segmented tabs (for example Overview, Related, Reviews) switching content in place.
class SegmentedTabs extends StatelessWidget {
  const SegmentedTabs({
    super.key,
    required this.labels,
    required this.selected,
    required this.onChanged,
  });

  final List<String> labels;
  final int selected;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(3),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: BuyerTheme.border),
    ),
    child: Row(
      children: [
        for (var index = 0; index < labels.length; index++)
          Expanded(
            child: Semantics(
              button: true,
              selected: index == selected,
              label: '${labels[index]} tab',
              excludeSemantics: true,
              child: Material(
                color: index == selected
                    ? BuyerTheme.action
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () => onChanged(index),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 40),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 6,
                        ),
                        child: Text(
                          labels[index],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: index == selected
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: index == selected
                                ? Colors.white
                                : BuyerTheme.ink,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    ),
  );
}

/// A label/value specification line: label on the left, value on the right, wrapping under
/// large text instead of overflowing.
class SpecificationRow extends StatelessWidget {
  const SpecificationRow(
    this.label,
    this.value, {
    super.key,
    this.strong = false,
  });

  final String label;
  final String value;
  final bool strong;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: strong ? BuyerTheme.ink : BuyerTheme.muted,
              fontWeight: strong ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 3,
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: strong ? 15 : 13,
              fontWeight: strong ? FontWeight.w800 : FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  );
}
