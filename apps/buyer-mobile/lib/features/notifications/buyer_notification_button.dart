import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../design_system/components/buyer_app_bar.dart';
import 'notification_scope.dart';

/// All Buyer notification shortcuts share the authenticated unread status.
class BuyerNotificationButton extends StatelessWidget {
  const BuyerNotificationButton({super.key, required this.onPressed});
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final inbox = NotificationScope.of(context)?.inbox;
    Widget button(int count) => BuyerHeaderIconButton(
      icon: LucideIcons.bell,
      tooltip: count > 0 ? 'Notifications, $count unread' : 'Notifications',
      badgeCount: count,
      badgeColor: Theme.of(context).colorScheme.error,
      onPressed: onPressed,
    );
    if (inbox == null) return button(0);
    return ListenableBuilder(
      listenable: inbox,
      builder: (context, _) => button(inbox.unreadCount),
    );
  }
}
