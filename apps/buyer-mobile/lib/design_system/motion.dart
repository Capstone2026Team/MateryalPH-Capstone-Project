import 'package:flutter/widgets.dart';

import 'generated/motion_tokens.dart';

export 'generated/motion_tokens.dart';

/// Approved motion: no bounce or elastic curves, and Reduce Motion renders the final state
/// immediately.
abstract final class BuyerMotion {
  static const Curve enter = Curves.easeOutCubic;
  static const Curve exit = Curves.easeInCubic;

  static bool reduced(BuildContext context) =>
      MediaQuery.maybeDisableAnimationsOf(context) ?? false;

  static Duration of(BuildContext context, Duration token) =>
      reduced(context) ? Duration.zero : token;

  static Duration get route => MateryalMotionTokens.route;
}
