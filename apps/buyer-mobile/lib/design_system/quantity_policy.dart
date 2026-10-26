/// Quantity presentation follows the explicit selling unit, never product names.
String quantityDimension(String code) => switch (code) {
  'CUM' || 'L' || 'US_GAL' => 'VOLUME',
  'KG' => 'MASS',
  'M' => 'LENGTH',
  'SQM' => 'AREA',
  'BAG' || 'BOX' || 'ROLL' || 'COIL' || 'GAL' => 'PACK',
  'PC' || 'SHEET' => 'COUNT',
  _ => '',
};

bool measuredQuantityUnit(String code) =>
    ['VOLUME', 'MASS', 'LENGTH', 'AREA'].contains(quantityDimension(code));

String sellingQuantityLabel(String code, {String? dimension}) {
  final symbol = switch (code) {
    'CUM' => 'm³',
    'SQM' => 'm²',
    'US_GAL' => 'US gal',
    'M' => 'm',
    'KG' => 'kg',
    _ => code,
  };
  return switch (dimension ?? quantityDimension(code)) {
    'VOLUME' => 'Volume ($symbol)',
    'MASS' => 'Weight ($symbol)',
    'LENGTH' => 'Length ($symbol)',
    'AREA' => 'Area ($symbol)',
    _ => switch (code) {
      'GAL' => 'Gallon cans',
      'BAG' => 'Bags',
      'BOX' => 'Boxes',
      'ROLL' => 'Rolls',
      'COIL' => 'Coils',
      'SHEET' => 'Sheets',
      'PC' => 'Pieces',
      _ => code.isEmpty ? 'Quantity' : 'Quantity ($code)',
    },
  };
}

/// Decimal text validation without floating point or silent truncation.
bool validSellingQuantity(
  String text,
  int precision, {
  bool allowZero = false,
}) {
  final value = text.trim();
  if (!RegExp(r'^\d{1,14}(\.\d{1,4})?$').hasMatch(value)) return false;
  final parts = value.split('.');
  final fraction = parts.length == 1
      ? ''
      : parts[1].replaceFirst(RegExp(r'0+$'), '');
  return fraction.length <= precision &&
      (allowZero || RegExp(r'[1-9]').hasMatch(value));
}
