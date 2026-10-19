import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme.dart';

/// The same independent, accessible priority control for SRS and FMS factors.
class RankingPriorityControl extends StatelessWidget {
  const RankingPriorityControl({
    super.key,
    required this.factorKey,
    required this.label,
    required this.description,
    required this.value,
    required this.onChanged,
  });

  final String factorKey, label, description;
  final int value;
  final ValueChanged<int>? onChanged;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(color: BuyerTheme.border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              label,
              style: text.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              description,
              style: text.bodySmall?.copyWith(color: BuyerTheme.muted),
            ),
          ),
          Row(
            children: [
              IconButton(
                tooltip: 'Decrease $label',
                onPressed: onChanged != null && value > 0
                    ? () => onChanged!(value - 1)
                    : null,
                icon: const Icon(LucideIcons.minus, size: 18),
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 8,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 10,
                    ),
                    overlayShape: const RoundSliderOverlayShape(
                      overlayRadius: 22,
                    ),
                  ),
                  child: Slider(
                    key: ValueKey('ranking-weight-$factorKey'),
                    value: value.toDouble(),
                    max: 100,
                    divisions: 100,
                    label: '$value',
                    semanticFormatterCallback: (value) =>
                        '$label importance ${value.round()} out of 100',
                    onChanged: onChanged == null
                        ? null
                        : (value) => onChanged!(value.round()),
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Increase $label',
                onPressed: onChanged != null && value < 100
                    ? () => onChanged!(value + 1)
                    : null,
                icon: const Icon(LucideIcons.plus, size: 18),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Low priority',
                    style: text.bodySmall?.copyWith(color: BuyerTheme.muted),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'High priority',
                    textAlign: TextAlign.end,
                    style: text.bodySmall?.copyWith(color: BuyerTheme.muted),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
