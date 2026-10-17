import 'package:flutter/material.dart';
import '../theme.dart';

/// Slim pinned footer: a short status on the left (for example "3 items") and
/// one primary action on the right. Use as `Scaffold.bottomNavigationBar` so
/// the body is laid out above it and nothing scrolls behind the bar.
class BottomActionBar extends StatelessWidget {
  const BottomActionBar({
    super.key,
    required this.status,
    required this.actionLabel,
    required this.onAction,
  });
  final String status;
  final String actionLabel;

  /// Null disables the action, for example while saving.
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: const Border(top: BorderSide(color: BuyerTheme.border)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: SizedBox(
            height: 52,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    status,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: BuyerTheme.muted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                FilledButton(
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(140, 44),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                  ),
                  onPressed: onAction,
                  child: Text(actionLabel),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
