import 'package:flutter/material.dart';

/// Stable, session-scoped anchors shared by the Buyer shell and its real controls.
class BuyerTutorialScope extends InheritedWidget {
  const BuyerTutorialScope({
    super.key,
    required this.anchors,
    required super.child,
  });
  final Map<String, GlobalKey> anchors;
  static GlobalKey? keyOf(BuildContext context, String name) => context
      .dependOnInheritedWidgetOfExactType<BuyerTutorialScope>()
      ?.anchors
      .putIfAbsent(name, () => GlobalKey(debugLabel: 'tutorial-$name'));
  @override
  bool updateShouldNotify(BuyerTutorialScope oldWidget) =>
      anchors != oldWidget.anchors;
}
