import '../quantity_policy.dart';
import 'count_badge.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../generated/color_tokens.dart';
import '../theme.dart';

class BuyerDeliveryRecommendation extends StatelessWidget {
  const BuyerDeliveryRecommendation({super.key, required this.lines});

  final List<String> lines;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'System recommendation',
        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
      ),
      for (final line in lines)
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Text(line, style: const TextStyle(fontSize: 13)),
        ),
      const Text(
        'Estimated delivery fee. The Vendor confirms this plan; you approve any changes before paying.',
        style: TextStyle(fontSize: 12),
      ),
    ],
  );
}

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

/// The approved empty-state illustration set in `assets/states/`.
enum StateArtwork {
  notifications('notifications'),
  cart('cart'),
  inbox('inbox'),
  location('location'),
  noResults('no-results'),
  notFound('not-found'),
  noConnection('no-connection'),
  favorites('favorites'),
  pictures('pictures');

  const StateArtwork(this._file);
  final String _file;
  String get asset => 'assets/states/$_file.png';
}

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
    this.compact = false,
  });

  final StateKind kind;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;

  /// The decorative illustration; empty, offline and location states default to
  /// their set member, while errors and denied access keep a plain icon.
  final StateArtwork? artwork;

  /// A smaller illustration for a state that fills one section of a page.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final icon = switch (kind) {
      StateKind.offline => LucideIcons.wifiOff,
      StateKind.error => LucideIcons.circleAlert,
      StateKind.needsLocation => LucideIcons.mapPinOff,
      StateKind.forbidden => LucideIcons.lock,
      StateKind.empty => LucideIcons.searchX,
    };
    final art =
        artwork ??
        switch (kind) {
          StateKind.empty => StateArtwork.noResults,
          StateKind.offline => StateArtwork.noConnection,
          StateKind.needsLocation => StateArtwork.location,
          StateKind.error || StateKind.forbidden => null,
        };
    final textTheme = Theme.of(context).textTheme;
    final fallback = Icon(icon, size: 40, color: BuyerTheme.muted);
    return Semantics(
      container: true,
      liveRegion: kind != StateKind.empty,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 24,
          vertical: compact ? 16 : 32,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (art != null)
                  Image.asset(
                    art.asset,
                    width: compact ? 120 : 180,
                    height: compact ? 120 : 180,
                    excludeFromSemantics: true,
                    errorBuilder: (_, _, _) => fallback,
                  )
                else
                  fallback,
                SizedBox(height: art == null ? 12 : 8),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: textTheme.bodyMedium?.copyWith(
                    color: BuyerTheme.muted,
                    height: 1.45,
                  ),
                ),
                if (actionLabel != null && onAction != null) ...[
                  const SizedBox(height: 24),
                  FilledButton(onPressed: onAction, child: Text(actionLabel!)),
                ],
                if (secondaryLabel != null && onSecondary != null) ...[
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: onSecondary,
                    child: Text(secondaryLabel!),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Centers a full-page [StateMessage] in the available height and keeps it
/// scrollable at large text sizes, with optional pull-to-refresh.
class StatePage extends StatelessWidget {
  const StatePage({super.key, required this.child, this.onRefresh});

  final Widget child;
  final Future<void> Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    final page = LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        physics: onRefresh == null
            ? null
            : const AlwaysScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Center(child: child),
        ),
      ),
    );
    return onRefresh == null
        ? page
        : RefreshIndicator(onRefresh: onRefresh!, child: page);
  }
}

/// Decimal places allowed by a sale unit's step: '1' → 0, '0.001' → 3.
int stepDecimals(String step) {
  final dot = step.indexOf('.');
  return dot < 0 ? 0 : step.length - dot - 1;
}

/// Whether [text] is a positive quantity with at most [decimals] decimals.
bool validDecimalQuantity(String text, int decimals) {
  if (!validSellingQuantity(text, decimals)) return false;
  final parts = text.trim().split('.');
  final whole = BigInt.parse(parts.first);
  return whole < BigInt.from(1000000) ||
      (whole == BigInt.from(1000000) &&
          (parts.length == 1 || !RegExp(r'[1-9]').hasMatch(parts.last)));
}

/// Quantity entry for units sold in fractions, such as ready-mixed concrete in
/// m³. Edits report their text for parent validation; [commitOnSubmit] waits for Done so a cart line
/// is not updated on every keystroke.
class DecimalQuantityField extends StatefulWidget {
  const DecimalQuantityField({
    super.key,
    required this.label,
    required this.value,
    required this.unitName,
    required this.decimals,
    required this.onChanged,
    this.enabled = true,
    this.commitOnSubmit = false,
    this.hint,
  });

  final String label;
  final String value;
  final String unitName;
  final int decimals;
  final ValueChanged<String> onChanged;
  final bool enabled;
  final bool commitOnSubmit;
  final String? hint;

  @override
  State<DecimalQuantityField> createState() => _DecimalQuantityFieldState();
}

class _DecimalQuantityFieldState extends State<DecimalQuantityField> {
  late final TextEditingController _text = TextEditingController(
    text: widget.value,
  );
  String? _error;

  @override
  void didUpdateWidget(DecimalQuantityField old) {
    super.didUpdateWidget(old);
    if (widget.decimals != old.decimals) {
      _error =
          _text.text.isEmpty ||
              validDecimalQuantity(_text.text, widget.decimals)
          ? null
          : 'Review the quantity for this selling unit.';
    }
    final current = num.tryParse(_text.text.trim());
    if (widget.value != old.value && num.tryParse(widget.value) != current) {
      _text.text = widget.value;
    }
  }

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  void _check(String text, {required bool commit}) {
    final valid = validDecimalQuantity(text, widget.decimals);
    setState(
      () => _error = text.trim().isEmpty || valid
          ? null
          : 'Enter an amount above zero with up to ${widget.decimals} decimal place${widget.decimals == 1 ? '' : 's'}.',
    );
    if (!widget.commitOnSubmit || (valid && commit)) {
      widget.onChanged(text.trim());
    }
  }

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 220),
    child: TextField(
      controller: _text,
      enabled: widget.enabled,
      keyboardType: TextInputType.numberWithOptions(
        decimal: widget.decimals > 0,
      ),
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        labelText: widget.label,
        suffixText: widget.unitName,
        helperText: _error == null ? widget.hint : null,
        helperMaxLines: 3,
        errorText: _error,
        errorMaxLines: 3,
      ),
      onChanged: (text) => _check(text, commit: false),
      onSubmitted: (text) => _check(text, commit: true),
    ),
  );
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
    this.onClear,
    this.textStyle,
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
  final VoidCallback? onClear;
  final TextStyle? textStyle;
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
                          fontSize: 14,
                          fontWeight: hasText
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: hasText ? BuyerTheme.ink : BuyerTheme.muted,
                        ).merge(textStyle),
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
      style: textStyle ?? const TextStyle(fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: BuyerTheme.muted),
        counterText: '',
        isDense: true,
        contentPadding: const EdgeInsets.fromLTRB(18, 12, 8, 12),
        border: _shape,
        enabledBorder: _shape,
        focusedBorder: _shape.copyWith(
          borderSide: const BorderSide(color: BuyerTheme.action, width: 2),
        ),
        suffixIcon: IconButton(
          iconSize: 20,
          tooltip: onClear == null ? 'Search' : 'Clear search',
          onPressed: onClear ?? onSearch,
          icon: Icon(
            onClear == null ? LucideIcons.search : LucideIcons.x,
            color: BuyerTheme.action,
          ),
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
/// remove control for scope filters such as a category or store; a positive [count] shows a
/// count badge after the label, announced as "[count] [countNoun]".
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
    this.count = 0,
    this.countNoun = 'items',
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final IconData? trailingIcon;
  final VoidCallback? onDeleted;
  final String? deleteTooltip;
  final int maxLines;
  final int count;
  final String countNoun;

  @override
  Widget build(BuildContext context) {
    final foreground = selected ? Colors.white : BuyerTheme.ink;
    return Semantics(
      button: true,
      selected: selected,
      label: count > 0 ? '$label, $count $countNoun' : label,
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
                    if (count > 0) ...[
                      const SizedBox(width: 6),
                      CountBadge(quantity: '$count'),
                    ],
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
    this.badgeQuantity,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final bool filled;
  final int badgeCount;
  final String? badgeQuantity;

  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: tooltip,
    onPressed: onPressed,
    style: IconButton.styleFrom(
      minimumSize: const Size(48, 48),
      padding: EdgeInsets.zero,
    ),
    icon: CountBadge(
      quantity: badgeQuantity ?? '$badgeCount',
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

  static const _gap = 3.0;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(_gap),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: BuyerTheme.border),
    ),
    child: LayoutBuilder(
      builder: (context, constraints) {
        final columns = _columns(context, constraints.maxWidth);
        if (columns >= labels.length) {
          return Row(
            children: [
              for (var index = 0; index < labels.length; index++)
                Expanded(child: _tab(index)),
            ],
          );
        }
        // Too narrow for one row (large text, small screens): wrap whole tabs onto further rows
        // instead of breaking a label mid-word.
        final width = (constraints.maxWidth - (columns - 1) * _gap) / columns;
        return Wrap(
          spacing: _gap,
          runSpacing: _gap,
          children: [
            for (var index = 0; index < labels.length; index++)
              SizedBox(width: width, child: _tab(index)),
          ],
        );
      },
    ),
  );

  /// The most equal columns that fit every label's widest word on one line at the current text
  /// scale; multi-word labels may still wrap between words.
  int _columns(BuildContext context, double maxWidth) {
    final scaler = MediaQuery.textScalerOf(context);
    final base = DefaultTextStyle.of(context).style;
    var widest = 0.0;
    for (final label in labels) {
      for (final word in label.split(' ')) {
        final painter = TextPainter(
          text: TextSpan(text: word, style: base.merge(_style(true))),
          textScaler: scaler,
          textDirection: Directionality.of(context),
          maxLines: 1,
        )..layout();
        if (painter.width > widest) widest = painter.width;
        painter.dispose();
      }
    }
    // Label padding plus a pixel of rounding slack.
    final needed = widest + 2 * 4 + 1;
    for (var columns = labels.length; columns > 1; columns--) {
      if ((maxWidth - (columns - 1) * _gap) / columns >= needed) return columns;
    }
    return 1;
  }

  TextStyle _style(bool active) => TextStyle(
    fontSize: 13,
    fontWeight: active ? FontWeight.w700 : FontWeight.w500,
    color: active ? Colors.white : BuyerTheme.ink,
  );

  Widget _tab(int index) => Semantics(
    button: true,
    selected: index == selected,
    label: '${labels[index]} tab',
    excludeSemantics: true,
    child: Material(
      color: index == selected ? BuyerTheme.action : Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => onChanged(index),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 40),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
              child: Text(
                labels[index],
                textAlign: TextAlign.center,
                style: _style(index == selected),
              ),
            ),
          ),
        ),
      ),
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

class ProcurementReviewCard extends StatelessWidget {
  const ProcurementReviewCard({
    super.key,
    required this.children,
    this.padding = const EdgeInsets.all(12),
  });

  final List<Widget> children;
  final EdgeInsets padding;

  // A Material (not a coloured box) so list tiles and ink inside stay visible.
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Material(
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: BuyerTheme.border),
      ),
      child: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ),
      ),
    ),
  );
}
