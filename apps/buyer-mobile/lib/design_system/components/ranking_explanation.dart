import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/vendor_score_display.dart';
import '../../features/item_procurement/procurement_models.dart';
import '../theme.dart';

/// Buyer-facing facts first, with the server's score breakdown on request.
class RankingExplanation extends StatelessWidget {
  const RankingExplanation({super.key, required this.card, this.position});

  final ListingCardView card;
  final int? position;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Semantics(
              header: true,
              child: Text(
                'Why this Best Deal?',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
          IconButton(
            tooltip: 'Close explanation',
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(LucideIcons.x),
          ),
        ],
      ),
      Text(card.displayName, style: Theme.of(context).textTheme.titleMedium),
      if (position != null) ...[
        const SizedBox(height: 4),
        Text(
          '#$position in your Best Deal results',
          style: const TextStyle(
            color: BuyerTheme.action,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
      const SizedBox(height: 12),
      const Text(
        'Closer search matches come first. Best Deal then compares these factors using your preferences:',
      ),
      const SizedBox(height: 8),
      for (final component in card.components)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: ExcludeSemantics(
                  child: Icon(
                    _icon(component.key),
                    size: 20,
                    color: BuyerTheme.action,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _label(component),
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _summary(component),
                      style: const TextStyle(color: BuyerTheme.muted),
                    ),
                    if (component.weightPercent == 0)
                      const Text(
                        'Not used in your ranking preferences.',
                        style: TextStyle(color: BuyerTheme.muted),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      const Divider(height: 24),
      const Text(
        'Best Deal balances your preferences. It may not be the cheapest option.',
        style: TextStyle(color: BuyerTheme.muted),
      ),
      const SizedBox(height: 8),
      ExpansionTile(
        tilePadding: EdgeInsets.zero,
        childrenPadding: const EdgeInsets.only(bottom: 16),
        shape: const Border(),
        collapsedShape: const Border(),
        title: const Text(
          'View score details',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Best Deal score: ${card.srs} out of 100',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              const Text(
                'Each factor gets a score out of 100. Your preferences decide how much it counts toward the total.',
                style: TextStyle(color: BuyerTheme.muted),
              ),
              const SizedBox(height: 12),
              for (final component in card.components)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        '${component.label}: ${component.score} × ${component.weightPercent.toStringAsFixed(component.weightPercent % 1 == 0 ? 0 : 2)}% = ${component.weighted}',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        component.basis,
                        style: const TextStyle(color: BuyerTheme.muted),
                      ),
                    ],
                  ),
                ),
              const Text(
                'Among equally close search matches, higher totals appear first. If totals are equal, the nearer option comes first, then the lower price. Any remaining tie uses a fixed product order.',
                style: TextStyle(color: BuyerTheme.muted),
              ),
            ],
          ),
        ],
      ),
    ],
  );

  String _summary(RankingComponentView component) => switch (component.key) {
    'distance' =>
      '${formatDistance(card.distanceMeters)} from your selected location (straight-line distance).',
    'price' => _price,
    'vps' => _supplierPerformance,
    'stock' => switch (card.stockLabel) {
      'IN_STOCK' => 'In stock',
      'LIMITED_STOCK' => 'Limited stock',
      _ => component.basis,
    },
    'product_rating' =>
      card.ratingAverage == null
          ? 'No product ratings yet.'
          : component.basis.replaceFirst(' of 5', ' out of 5'),
    _ => component.basis,
  };

  String get _price {
    final comparison = card.normalizedUnitPrice == null
        ? 'No matching prices to compare yet.'
        : card.bestPrice
        ? 'Lowest price among matching product options.'
        : 'Compared with matching product options.';
    return '${formatPeso(card.unitPriceCentavos)} per ${card.unitName.toLowerCase()}. $comparison';
  }

  String get _supplierPerformance {
    final score = publishedVpsValue(card.vendorScore);
    return score == null
        ? 'New supplier — still building a track record.'
        : '$score out of 5, based on the supplier\'s track record (VPS).';
  }

  static String _label(RankingComponentView component) =>
      switch (component.key) {
        'vps' => 'Supplier performance',
        'stock' => 'Availability',
        'product_rating' => 'Product rating',
        _ => component.label,
      };

  static IconData _icon(String key) => switch (key) {
    'distance' => LucideIcons.mapPin,
    'price' => LucideIcons.tag,
    'vps' => LucideIcons.shieldCheck,
    'stock' => LucideIcons.package,
    _ => LucideIcons.star,
  };
}
