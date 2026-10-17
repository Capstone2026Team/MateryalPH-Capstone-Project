import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme.dart';

/// A labelled 1–5 rating with 44 px targets; each star announces its value and selection.
class StarRatingField extends StatelessWidget {
  const StarRatingField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.errorText,
    this.compact = false,
  });

  final String label;
  final int? value;
  final ValueChanged<int>? onChanged;
  final String? errorText;
  final bool compact;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final labelWidget = Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w600),
      );
      final stars = Wrap(
        children: [
          for (var star = 1; star <= 5; star++)
            Semantics(
              button: true,
              selected: value == star,
              label: '$label: $star of 5',
              excludeSemantics: true,
              child: IconButton(
                constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
                onPressed: onChanged == null ? null : () => onChanged!(star),
                icon: Icon(
                  LucideIcons.star,
                  color: value != null && star <= value!
                      ? BuyerTheme.action
                      : BuyerTheme.muted,
                  fill: value != null && star <= value! ? 1 : 0,
                ),
              ),
            ),
        ],
      );
      final inline =
          compact &&
          constraints.maxWidth >= 352 &&
          MediaQuery.textScalerOf(context).scale(14) <= 17;
      final content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (inline)
            Row(
              children: [
                Expanded(child: labelWidget),
                stars,
              ],
            )
          else ...[
            labelWidget,
            stars,
          ],
          if (errorText != null)
            Text(
              errorText!,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontSize: 12,
              ),
            ),
        ],
      );
      return compact
          ? Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: BuyerTheme.border),
                borderRadius: BorderRadius.circular(12),
              ),
              child: content,
            )
          : content;
    },
  );
}

/// Read-only stars with the value as text for screen readers.
class StarRatingLine extends StatelessWidget {
  const StarRatingLine({
    super.key,
    required this.label,
    required this.value,
    this.showLabel = true,
  });

  final String label;
  final int value;
  final bool showLabel;

  @override
  Widget build(BuildContext context) => Semantics(
    label: '$label: $value of 5',
    excludeSemantics: true,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showLabel)
          Text(
            '$label ',
            style: const TextStyle(fontSize: 12, color: BuyerTheme.muted),
          ),
        for (var star = 1; star <= 5; star++)
          Icon(
            LucideIcons.star,
            size: 14,
            color: star <= value ? BuyerTheme.action : BuyerTheme.border,
            fill: star <= value ? 1 : 0,
          ),
      ],
    ),
  );
}
