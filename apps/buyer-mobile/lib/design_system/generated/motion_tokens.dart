// @generated from tokens.json — do not edit directly.
abstract final class MateryalMotionTokens {
  /// Press feedback only
  static const Duration instant = Duration(milliseconds: 80);
  /// Icon, focus, selection and selected marker
  static const Duration fast = Duration(milliseconds: 160);
  /// Sheet or card state and filter application
  static const Duration standard = Duration(milliseconds: 240);
  /// Preview sheet entrance (220-280 ms, ease-out)
  static const Duration sheet = Duration(milliseconds: 250);
  /// Page-level spatial transition
  static const Duration slow = Duration(milliseconds: 360);
  /// Selected-marker camera adjustment (320-450 ms, ease-out cubic)
  static const Duration camera = Duration(milliseconds: 400);
  /// One-time selected route stroke reveal (600-900 ms)
  static const Duration route = Duration(milliseconds: 720);
}
