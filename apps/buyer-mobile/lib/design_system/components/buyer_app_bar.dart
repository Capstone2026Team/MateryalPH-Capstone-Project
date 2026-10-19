import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'procurement_components.dart';
import 'count_badge.dart';
import '../theme.dart';

/// Plain outlined header action with an accessible target and optional count.
class BuyerHeaderIconButton extends StatelessWidget {
  const BuyerHeaderIconButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.badgeCount = 0,
    this.badgeColor,
    this.badgeQuantity,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final int badgeCount;
  final Color? badgeColor;
  final String? badgeQuantity;

  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: tooltip,
    onPressed: onPressed,
    style: IconButton.styleFrom(
      minimumSize: const Size(48, 48),
      foregroundColor: BuyerTheme.ink,
    ),
    icon: CountBadge(
      quantity: badgeQuantity ?? '$badgeCount',
      child: Icon(icon, size: 24),
    ),
  );
}

/// Primary tab headers share title alignment, gutters and trailing actions.
/// Reserve two title lines so long names remain readable on narrow screens.
PreferredSizeWidget buyerTabAppBar(
  BuildContext context,
  String title, {
  List<Widget> actions = const [],
}) => buyerAppBar(
  context,
  title,
  centerTitle: false,
  toolbarHeight: 12 + MediaQuery.textScalerOf(context).scale(18) * 26 / 18 * 2,
  titleWidget: Text(
    title,
    maxLines: 2,
    overflow: TextOverflow.ellipsis,
    style: const TextStyle(
      fontSize: 18,
      height: 26 / 18,
      fontWeight: FontWeight.w800,
    ),
  ),
  actions: [...actions, const SizedBox(width: 8)],
);

/// The one Buyer page header: an orange round back button at the start, a centred bold title, and
/// optional trailing [actions]. Every pushed Buyer page uses it so the back control and title sit in
/// the same place on every screen. The back button appears only when the page can be popped, or
/// when [onBack] is supplied.
///
/// [titleWidget] replaces the text title for a page whose header carries more than a name (for
/// example a conversation); [toolbarHeight] then overrides the text-scale-aware default.
/// [showBackButton] lets embedded modal content keep its title without a second navigation control.
PreferredSizeWidget buyerAppBar(
  BuildContext context,
  String title, {
  List<Widget>? actions,
  VoidCallback? onBack,
  PreferredSizeWidget? bottom,
  Widget? titleWidget,
  double? toolbarHeight,
  bool centerTitle = true,
  bool showBackButton = true,
}) {
  final showBack =
      showBackButton &&
      (onBack != null || (ModalRoute.of(context)?.canPop ?? false));
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
