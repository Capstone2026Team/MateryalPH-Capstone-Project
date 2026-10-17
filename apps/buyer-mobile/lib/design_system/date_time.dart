/// API instants are stored in UTC and displayed in Asia/Manila (UTC+8).
String formatManilaIsoDateTime(String value) {
  final instant = DateTime.tryParse(value);
  if (instant == null) return value;
  final local = instant.toUtc().add(const Duration(hours: 8));
  return '${local.toIso8601String().replaceFirst('T', ' ').substring(0, 16)} Manila';
}
