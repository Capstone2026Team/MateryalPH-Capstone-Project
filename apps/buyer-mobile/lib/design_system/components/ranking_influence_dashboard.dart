import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../generated/color_tokens.dart';
import '../ranking_weights.dart';
import '../theme.dart';

/// A local preview shared by both ranking editors. Colors follow factor identity,
/// while the legend follows influence; the segmented bar keeps the slider order.
class RankingInfluenceDashboard extends StatelessWidget {
  const RankingInfluenceDashboard({
    super.key,
    required this.weights,
    required this.factors,
  });

  final Map<String, int> weights;
  final List<(String, String, String)> factors;

  @override
  Widget build(BuildContext context) {
    final percentages = rankingInfluencePercentages(weights);
    final order = {for (var i = 0; i < factors.length; i++) factors[i].$1: i};
    final sorted = [...factors]
      ..sort((a, b) {
        final comparison = (weights[b.$1] ?? 0).compareTo(weights[a.$1] ?? 0);
        return comparison != 0
            ? comparison
            : order[a.$1]!.compareTo(order[b.$1]!);
      });
    final active = factors
        .where((factor) => (weights[factor.$1] ?? 0) > 0)
        .toList();
    final highest = active.isEmpty ? 0 : weights[sorted.first.$1]!;
    final leaders = active
        .where((factor) => weights[factor.$1] == highest)
        .toList();
    final equal = leaders.length > 1 && leaders.length == active.length;
    final leadingLabel = active.isEmpty
        ? 'No active factors'
        : equal
        ? 'Equal influence'
        : leaders.map((factor) => factor.$2).join(' & ');
    final text = Theme.of(context).textTheme;

    return Container(
      key: const ValueKey('ranking-influence-dashboard'),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(color: BuyerTheme.border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                LucideIcons.chartLine,
                size: 18,
                color: BuyerTheme.muted,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Semantics(
                  header: true,
                  child: Text(
                    'Ranking Influence',
                    style: text.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: BuyerTheme.canvas,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Live',
                  style: text.labelSmall?.copyWith(color: BuyerTheme.ink),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Semantics(
            liveRegion: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  leaders.length > 1
                      ? 'Your most influential factors'
                      : 'Your most influential factor',
                  style: text.labelMedium?.copyWith(color: BuyerTheme.muted),
                ),
                const SizedBox(height: 4),
                Text(
                  leadingLabel,
                  key: const ValueKey('ranking-leading-factor'),
                  style: text.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            active.isEmpty
                ? 'Set at least one weight above zero to see its influence.'
                : 'Relative influence across all active ranking factors.',
            style: text.bodySmall?.copyWith(color: BuyerTheme.muted),
          ),
          const SizedBox(height: 12),
          ExcludeSemantics(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                key: const ValueKey('ranking-influence-segments'),
                height: 14,
                child: active.isEmpty
                    ? const ColoredBox(color: BuyerTheme.border)
                    : Row(
                        children: [
                          for (var i = 0; i < active.length; i++)
                            Expanded(
                              key: ValueKey('ranking-segment-${active[i].$1}'),
                              flex: weights[active[i].$1]!,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: _factorColor(active[i].$1),
                                  border: i == 0
                                      ? null
                                      : Border(
                                          left: BorderSide(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.surface,
                                            width: 2,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                        ],
                      ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          for (final (key, label, _) in sorted)
            Padding(
              key: ValueKey('ranking-influence-row-$key'),
              padding: const EdgeInsets.only(bottom: 12),
              child: Semantics(
                label:
                    '$label, ${(percentages[key] ?? 0).toStringAsFixed(1)} percent of ranking influence',
                excludeSemantics: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: SizedBox(
                            width: 8,
                            height: 8,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: _factorColor(key),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            label,
                            style: text.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '${(percentages[key] ?? 0).toStringAsFixed(1)}%',
                          key: ValueKey('ranking-influence-percent-$key'),
                          style: text.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    LinearProgressIndicator(
                      key: ValueKey('ranking-influence-bar-$key'),
                      value: (percentages[key] ?? 0) / 100,
                      minHeight: 6,
                      borderRadius: BorderRadius.circular(4),
                      color: _factorColor(key),
                      backgroundColor: BuyerTheme.canvas,
                    ),
                  ],
                ),
              ),
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 2),
                child: Icon(
                  LucideIcons.info,
                  size: 14,
                  color: BuyerTheme.muted,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Influence is calculated automatically and rounded. Your slider values stay independent. Save to apply changes.',
                  style: text.bodySmall?.copyWith(color: BuyerTheme.muted),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _factorColor(String key) => Color(switch (key) {
    'distance' => MateryalColorTokens.rankingDistance,
    'price' || 'budget_fit' => MateryalColorTokens.rankingPriceBudget,
    'vps' => MateryalColorTokens.rankingVendorPerformance,
    'stock' || 'material_match' => MateryalColorTokens.rankingStockMatch,
    'product_rating' => MateryalColorTokens.rankingProductRating,
    _ => MateryalColorTokens.textStrong,
  });
}
