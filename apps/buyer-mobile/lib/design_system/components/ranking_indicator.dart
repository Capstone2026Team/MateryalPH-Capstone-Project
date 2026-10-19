import 'package:flutter/material.dart';

import '../theme.dart';

enum RankingRecommendation {
  bestDeal(
    'Best Deal',
    'This is your best deal based on your ranking preferences.',
  ),
  bestMatch(
    'Best Match',
    'This vendor is your best match based on your project requirements and ranking preferences.',
  );

  const RankingRecommendation(this.label, this.description);
  final String label, description;
}

/// A position in the current server-ordered result list, shared by both flows.
class RankingIndicator extends StatelessWidget {
  const RankingIndicator({
    super.key,
    required this.position,
    required this.recommendation,
    this.description,
  }) : assert(position > 0);

  final int position;
  final RankingRecommendation recommendation;
  final String? description;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(
      context,
    ).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w700);
    if (position == 1) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: BuyerTheme.brandSoft,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'TOP 1 — ${recommendation.label} for You',
              style: style?.copyWith(color: BuyerTheme.actionPressed),
            ),
            const SizedBox(height: 4),
            Text(
              description ?? recommendation.description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 11,
                height: 1.35,
                color: BuyerTheme.ink,
              ),
            ),
          ],
        ),
      );
    }
    if (position > 3) {
      return Text(
        '#$position',
        semanticsLabel: 'Rank $position',
        style: style?.copyWith(color: BuyerTheme.muted),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: position == 2
            ? BuyerTheme.action.withValues(alpha: 0.08)
            : BuyerTheme.canvas,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        'TOP $position',
        style: style?.copyWith(
          color: position == 2 ? BuyerTheme.actionPressed : BuyerTheme.ink,
        ),
      ),
    );
  }
}
