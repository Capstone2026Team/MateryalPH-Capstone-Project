import 'package:flutter/material.dart';
import '../../design_system/components/ranking_preferences_editor.dart';
import 'procurement_models.dart';
import 'procurement_repository.dart';

class RankingPreferencesScreen extends StatelessWidget {
  const RankingPreferencesScreen({
    super.key,
    required this.repository,
    this.onChanged,
  });
  final ProcurementRepository repository;
  final VoidCallback? onChanged;
  static const factors = [
    ('distance', 'Distance', 'Closer stores score higher within your radius.'),
    ('price', 'Price', 'Lower price than comparable offers scores higher.'),
    (
      'vps',
      'Vendor Performance (VPS)',
      'Earned Vendor score; new Vendors use a neutral value.',
    ),
    ('stock', 'Stock', 'In Stock scores higher than Limited Stock.'),
    (
      'product_rating',
      'Product Rating',
      'Verified product ratings; unrated products use a neutral value.',
    ),
  ];
  RankingPreferenceSnapshot _snapshot(RankingPreferencesView p) =>
      RankingPreferenceSnapshot(
        weights: p.weights.toMap(),
        defaults: p.defaults.toMap(),
        personalized: p.personalized,
        version: p.version,
      );
  @override
  Widget build(BuildContext context) => RankingPreferencesEditor(
    title: 'Ranking preferences',
    description:
        'Customize how MateryalPH orders your product results. Adjusting one preference automatically balances the others so the total always remains 100%. Favorites First remains separate.',
    resetMessage:
        'Best Deal will use the current platform weights again. Your personal weights are removed.',
    factors: factors,
    load: () async => _snapshot(await repository.preferences()),
    save: (weights, version) async => _snapshot(
      await repository.savePreferences(
        RankingWeights.fromMap(weights),
        version: version,
      ),
    ),
    reset: (version) async =>
        _snapshot(await repository.resetPreferences(version: version)),
    onChanged: onChanged,
  );
}
