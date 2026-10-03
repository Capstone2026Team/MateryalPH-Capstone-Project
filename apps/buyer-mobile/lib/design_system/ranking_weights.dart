/// Rebalances whole percentages using largest remainders and stable factor order.
/// Use the weights at drag start as the basis to avoid cumulative rounding drift.
Map<String, int> rebalanceRankingWeights(
  Map<String, int> weights,
  String key,
  int value, {
  required Map<String, int> defaults,
}) {
  final keys = weights.keys.toList();
  if (!keys.contains(key) || keys.length < 2) {
    throw ArgumentError.value(key, 'key');
  }
  final target = value.clamp(0, 100);
  final others = keys.where((item) => item != key).toList();
  var basis = weights;
  var sum = others.fold(0, (sum, item) => sum + basis[item]!);
  if (sum == 0) {
    basis = defaults;
    sum = others.fold(0, (sum, item) => sum + basis[item]!);
  }
  final denominator = sum == 0 ? others.length : sum;
  final numerators = {
    for (final item in others)
      item: (100 - target) * (sum == 0 ? 1 : basis[item]!),
  };
  final allocated = {
    for (final item in others) item: numerators[item]! ~/ denominator,
  };
  final remaining = 100 - target - allocated.values.fold(0, (a, b) => a + b);
  final order = [...others]
    ..sort((a, b) {
      final remainder = (numerators[b]! % denominator).compareTo(
        numerators[a]! % denominator,
      );
      return remainder != 0
          ? remainder
          : keys.indexOf(a).compareTo(keys.indexOf(b));
    });
  for (var i = 0; i < remaining; i++) {
    allocated[order[i]] = allocated[order[i]]! + 1;
  }
  return {
    for (final item in keys) item: item == key ? target : allocated[item]!,
  };
}
