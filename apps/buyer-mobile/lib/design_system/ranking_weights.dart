/// Updates only the selected criterion. Raw importance values are saved as-is;
/// the server normalizes them when calculating ranking scores.
Map<String, int> updateRankingWeight(
  Map<String, int> weights,
  String key,
  int value,
) {
  if (!weights.containsKey(key)) throw ArgumentError.value(key, 'key');
  return {...weights, key: value.clamp(0, 100)};
}

/// Display-only preview of the server's weight / total normalization.
/// This derived map never replaces the raw values sent to persistence.
Map<String, double> rankingInfluencePercentages(Map<String, int> weights) {
  final total = weights.values.fold(0, (sum, value) => sum + value);
  return {
    for (final entry in weights.entries)
      entry.key: total == 0 ? 0 : entry.value / total * 100,
  };
}
