import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../features/map_discovery/map_geometry.dart';
import '../theme.dart';

/// Accessible list alternative to selecting a supplier's route on a map.
class SupplierRouteTile extends StatelessWidget {
  const SupplierRouteTile({
    super.key,
    required this.name,
    required this.selected,
    required this.loading,
    required this.onSelect,
    required this.onRetry,
    this.distanceMeters,
    this.durationSeconds,
    this.computedAtLabel,
    this.error,
    this.dense = false,
  });

  final String name;
  final bool selected, loading;
  final int? distanceMeters, durationSeconds;
  final String? computedAtLabel, error;
  final VoidCallback onSelect, onRetry;

  /// One-to-two line row for use inside a card: the selected state is the
  /// tint and route icon, and the provider's error detail is left out.
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (dense) return _dense(theme);
    return Semantics(
      selected: selected,
      liveRegion: selected,
      child: Material(
        color: selected ? BuyerTheme.canvas : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onSelect,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Icon(
                    selected ? LucideIcons.route : LucideIcons.mapPin,
                    size: 20,
                    color: selected ? BuyerTheme.action : BuyerTheme.muted,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: theme.textTheme.titleSmall),
                      const SizedBox(height: 4),
                      if (loading)
                        const Text('Calculating road route…')
                      else if (error != null) ...[
                        Text(
                          'Travel time unavailable',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.error,
                          ),
                        ),
                        Text(error!, style: theme.textTheme.bodySmall),
                        TextButton.icon(
                          onPressed: onRetry,
                          icon: const Icon(LucideIcons.refreshCw, size: 16),
                          label: const Text('Retry route'),
                        ),
                      ] else if (distanceMeters != null &&
                          durationSeconds != null) ...[
                        Text(
                          '${formatDistance(distanceMeters!)} · Est. ${formatDuration(durationSeconds!)} drive',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (computedAtLabel != null)
                          Text(
                            'Computed $computedAtLabel',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: BuyerTheme.muted,
                            ),
                          ),
                      ],
                      if (selected)
                        Text(
                          'Selected on map',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: BuyerTheme.actionPressed,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _dense(ThemeData theme) {
    final muted = theme.textTheme.bodySmall?.copyWith(color: BuyerTheme.muted);
    final failed = !loading && error != null;
    return Semantics(
      selected: selected,
      child: Material(
        color: selected ? BuyerTheme.canvas : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: onSelect,
          borderRadius: BorderRadius.circular(10),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 44),
            child: Padding(
              padding: EdgeInsets.fromLTRB(8, 6, failed ? 0 : 8, 6),
              child: Row(
                children: [
                  Icon(
                    selected ? LucideIcons.route : LucideIcons.mapPin,
                    size: 18,
                    color: selected ? BuyerTheme.action : BuyerTheme.muted,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (loading)
                          Text('Calculating road route…', style: muted)
                        else if (failed)
                          Text(
                            'Travel time unavailable',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.error,
                            ),
                          )
                        else if (distanceMeters != null &&
                            durationSeconds != null)
                          Text(
                            '${formatDistance(distanceMeters!)} · Est. ${formatDuration(durationSeconds!)} drive',
                            semanticsLabel: computedAtLabel == null
                                ? null
                                : '${formatDistance(distanceMeters!)}, estimated ${formatDuration(durationSeconds!)} drive, computed $computedAtLabel',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: BuyerTheme.ink,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (failed)
                    TextButton(
                      onPressed: onRetry,
                      child: const Text('Retry route'),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
