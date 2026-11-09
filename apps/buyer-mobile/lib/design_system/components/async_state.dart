import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../motion.dart';
import '../theme.dart';

/// One indicator for button, media and section requests. Reduced motion keeps
/// a static progress arc, with the same loading announcement.
class BuyerLoadingIndicator extends StatelessWidget {
  const BuyerLoadingIndicator({
    super.key,
    this.size = 24,
    this.strokeWidth = 2.5,
    this.color,
    this.semanticsLabel = 'Loading…',
  });

  final double size;
  final double strokeWidth;
  final Color? color;
  final String semanticsLabel;

  @override
  Widget build(BuildContext context) => Semantics(
    label: semanticsLabel,
    liveRegion: true,
    child: ExcludeSemantics(
      child: SizedBox.square(
        dimension: size,
        child: CircularProgressIndicator(
          value: BuyerMotion.reduced(context) ? 0.75 : null,
          strokeWidth: strokeWidth,
          color: color ?? BuyerTheme.action,
        ),
      ),
    ),
  );
}

/// A slim indicator for a request updating an already visible section. Numeric
/// progress bars keep their existing determinate values and semantics.
class BuyerLoadingProgress extends StatelessWidget {
  const BuyerLoadingProgress({
    super.key,
    this.minHeight = 3,
    this.color,
    this.backgroundColor,
    this.borderRadius,
    this.semanticsLabel = 'Loading…',
  });

  final double minHeight;
  final Color? color;
  final Color? backgroundColor;
  final BorderRadiusGeometry? borderRadius;
  final String semanticsLabel;

  @override
  Widget build(BuildContext context) => Semantics(
    label: semanticsLabel,
    liveRegion: true,
    child: ExcludeSemantics(
      child: LinearProgressIndicator(
        value: BuyerMotion.reduced(context) ? 0.5 : null,
        minHeight: minHeight,
        color: color ?? BuyerTheme.action,
        backgroundColor: backgroundColor ?? BuyerTheme.canvas,
        borderRadius: borderRadius ?? BorderRadius.circular(2),
      ),
    ),
  );
}

/// Keeps loading inside the section that requested data.
class BuyerLoadingState extends StatelessWidget {
  const BuyerLoadingState({
    super.key,
    this.label = 'Loading…',
    this.compact = false,
  });

  final String label;
  final bool compact;

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: BoxConstraints(minHeight: compact ? 56 : 220),
    child: Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: compact ? 12 : 32,
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BuyerLoadingIndicator(semanticsLabel: label),
            const SizedBox(height: 12),
            ExcludeSemantics(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: BuyerTheme.muted,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

/// Shared with offline, failed-request and access-denied presentation. The
/// caller keeps the specific failure and its existing, explicit retry action.
class BuyerRequestState extends StatelessWidget {
  const BuyerRequestState({
    super.key,
    required this.title,
    required this.message,
    this.icon = LucideIcons.circleAlert,
    this.actionLabel,
    this.onAction,
    this.secondaryLabel,
    this.onSecondary,
    this.compact = false,
  });

  final String title;
  final String message;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;
  final bool compact;

  @override
  Widget build(BuildContext context) => Semantics(
    container: true,
    liveRegion: true,
    child: Center(
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxWidth: 480,
          minHeight: compact ? 0 : 220,
        ),
        margin: const EdgeInsets.all(16),
        padding: EdgeInsets.all(compact ? 16 : 24),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border.all(color: BuyerTheme.border),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24, color: BuyerTheme.muted),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                fontWeight: FontWeight.w600,
                color: BuyerTheme.ink,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                color: BuyerTheme.muted,
              ),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: onAction,
                icon: const Icon(LucideIcons.refreshCw, size: 16),
                label: Text(actionLabel!),
              ),
            ],
            if (secondaryLabel != null && onSecondary != null) ...[
              const SizedBox(height: 8),
              TextButton(onPressed: onSecondary, child: Text(secondaryLabel!)),
            ],
          ],
        ),
      ),
    ),
  );
}
