import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../features/item_procurement/cart_controller.dart';
import '../../features/notifications/notification_scope.dart';
import 'buyer_app_bar.dart';
import 'procurement_components.dart';

/// Every cart shortcut uses the same exact quantity snapshot, including before Explore opens.
class BuyerCartButton extends StatelessWidget {
  const BuyerCartButton({
    super.key,
    required this.onPressed,
    this.cart,
    this.round = false,
  });
  final VoidCallback? onPressed;
  final CartController? cart;
  final bool round;
  @override
  Widget build(BuildContext context) {
    final navigation = NotificationScope.of(context)?.navigation;
    Widget button() {
      final remote = navigation?.value;
      final quantity =
          cart?.cart != null &&
              (cart!.cart!.lockVersion >= (remote?.cartVersion ?? 0))
          ? cart!.quantity
          : remote?.cartQuantity ?? '0';
      final tooltip = quantity == '0' ? 'Cart' : 'Cart, $quantity items';
      return round
          ? RoundIconButton(
              icon: LucideIcons.shoppingCart,
              tooltip: tooltip,
              badgeQuantity: quantity,
              onPressed: onPressed,
            )
          : BuyerHeaderIconButton(
              icon: LucideIcons.shoppingCart,
              tooltip: tooltip,
              badgeQuantity: quantity,
              onPressed: onPressed,
            );
    }

    if (navigation == null && cart == null) return button();
    return ListenableBuilder(
      listenable: Listenable.merge([navigation, cart]),
      builder: (_, _) => button(),
    );
  }
}
