import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'procurement_components.dart';

/// The one Buyer page header: an orange round back button at the start, a centred bold title, and
/// optional trailing [actions]. Every pushed Buyer page uses it so the back control and title sit in
/// the same place on every screen. The back button appears only when the page can be popped, or
/// when [onBack] is supplied.
///
/// [titleWidget] replaces the text title for a page whose header carries more than a name (for
/// example a conversation); [toolbarHeight] then overrides the text-scale-aware default.
PreferredSizeWidget buyerAppBar(
  BuildContext context,
  String title, {
  List<Widget>? actions,
  VoidCallback? onBack,
  PreferredSizeWidget? bottom,
  Widget? titleWidget,
  double? toolbarHeight,
  bool centerTitle = true,
}) {
  final showBack = onBack != null || (ModalRoute.of(context)?.canPop ?? false);
  return AppBar(
    automaticallyImplyLeading: false,
    // Grows with the system text size so an enlarged title is never clipped.
    toolbarHeight:
        toolbarHeight ??
        kToolbarHeight +
            (MediaQuery.textScalerOf(context).scale(20) - 20).clamp(0, 48),
    leadingWidth: 60,
    leading: showBack
        ? Center(
            child: RoundIconButton(
              icon: LucideIcons.arrowLeft,
              tooltip: 'Back',
              filled: true,
              onPressed: onBack ?? () => Navigator.of(context).maybePop(),
            ),
          )
        : null,
    centerTitle: centerTitle,
    title:
        titleWidget ??
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
    actions: actions,
    bottom: bottom,
  );
}
