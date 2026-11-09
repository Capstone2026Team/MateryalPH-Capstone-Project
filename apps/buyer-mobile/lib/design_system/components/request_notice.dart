import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../features/map_discovery/discovery_models.dart';
import '../theme.dart';

/// A section-scoped failure notice. The caller retains its content and owns the
/// explicit retry; rendering this notice never starts a request.
class BuyerRequestNotice extends StatelessWidget {
  const BuyerRequestNotice({
    super.key,
    required this.message,
    required this.onRetry,
    this.kind,
    this.detail,
    this.secondaryLabel,
    this.onSecondary,
  });

  final String message;
  final DiscoveryFailureKind? kind;
  final String? detail;
  final VoidCallback? onRetry;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;

  @override
  Widget build(BuildContext context) {
    final (title, icon) = switch (kind) {
      DiscoveryFailureKind.offline => ("You're offline", LucideIcons.wifiOff),
      DiscoveryFailureKind.timeout => ('Request timed out', LucideIcons.clock),
      DiscoveryFailureKind.forbidden => ('Access denied', LucideIcons.lock),
      DiscoveryFailureKind.sessionExpired => (
        'Session ended',
        LucideIcons.lock,
      ),
      _ => ('Request unavailable', LucideIcons.circleAlert),
    };
    return Semantics(
      container: true,
      liveRegion: true,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border.all(color: BuyerTheme.border),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExcludeSemantics(
              child: Icon(icon, size: 24, color: BuyerTheme.muted),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      fontWeight: FontWeight.w600,
                      color: BuyerTheme.ink,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: BuyerTheme.muted,
                    ),
                  ),
                  if (detail != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      detail!,
                      style: const TextStyle(
                        fontSize: 12,
                        height: 1.5,
                        color: BuyerTheme.muted,
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      TextButton.icon(
                        onPressed: onRetry,
                        icon: const Icon(LucideIcons.refreshCw, size: 16),
                        label: const Text('Retry'),
                      ),
                      if (secondaryLabel != null && onSecondary != null)
                        TextButton(
                          onPressed: onSecondary,
                          child: Text(secondaryLabel!),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
