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
  });

  final String label;
  final int? value;
  final ValueChanged<int>? onChanged;
  final String? errorText;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
      Wrap(
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
      ),
      if (errorText != null)
        Text(
          errorText!,
          style: const TextStyle(color: Color(0xFFB91C1C), fontSize: 12),
        ),
    ],
  );
}

/// Read-only stars with the value as text for screen readers.
class StarRatingLine extends StatelessWidget {
  const StarRatingLine({super.key, required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) => Semantics(
    label: '$label: $value of 5',
    excludeSemantics: true,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
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
