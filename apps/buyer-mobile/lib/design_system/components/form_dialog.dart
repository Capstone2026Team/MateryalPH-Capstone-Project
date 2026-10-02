import 'package:flutter/material.dart';

/// Unlike showDialog's popped future, this completes after the exit animation
/// has removed the fields. Callers can then safely dispose their controllers.
Future<T?> showBuyerFormDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
}) async {
  final navigator = Navigator.of(context, rootNavigator: true);
  final route = DialogRoute<T>(
    context: context,
    builder: builder,
    barrierDismissible: false,
    themes: InheritedTheme.capture(from: context, to: navigator.context),
  );
  final result = await navigator.push(route);
  await route.completed;
  return result;
}
