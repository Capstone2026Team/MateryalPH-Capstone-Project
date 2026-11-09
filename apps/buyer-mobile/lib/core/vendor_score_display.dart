/// Reads an already published VPS label, never a review average or ranking fallback.
String? publishedVpsValue(String label, {String? value}) {
  final candidate =
      value ??
      RegExp(
        r'^VPS\s+(\d+(?:\.\d+)?)\b',
        caseSensitive: false,
      ).firstMatch(label.trim())?.group(1);
  final number = double.tryParse(candidate ?? '');
  return number != null && number.isFinite && number >= 1 && number <= 5
      ? candidate
      : null;
}

/// Native map labels and text-only summaries; accessible labels retain VPS provenance.
String vendorScoreDisplayText(String label, {String? value}) {
  final score = publishedVpsValue(label, value: value);
  return score == null ? label : '★ $score';
}
