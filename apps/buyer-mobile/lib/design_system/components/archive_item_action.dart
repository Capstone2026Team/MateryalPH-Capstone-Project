import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'buyer_overlays.dart';
import 'form_dialog.dart';

enum ArchiveAction { archive, restore, deletePermanently }

Future<bool> confirmArchiveAction(
  BuildContext context, {
  required String name,
  required ArchiveAction action,
}) async =>
    await showBuyerFormDialog<bool>(
      context: context,
      builder: (context) => BuyerDialog(
        title: Text(switch (action) {
          ArchiveAction.archive => 'Archive $name?',
          ArchiveAction.restore => 'Restore $name?',
          ArchiveAction.deletePermanently => 'Delete permanently?',
        }),
        content: Text(switch (action) {
          ArchiveAction.archive =>
            'You can restore this item from Archived Items for 30 days. New procurement is unavailable while archived. Transaction history is retained.',
          ArchiveAction.restore =>
            'Return this item to its original list and cancel its scheduled deletion. Previously cancelled orders stay cancelled.',
          ArchiveAction.deletePermanently =>
            'Are you sure you want to permanently delete this item? This action cannot be undone.\n\nIt is removed from your workspace. Required transaction and audit records remain retained.',
        }),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(switch (action) {
              ArchiveAction.archive => 'Archive',
              ArchiveAction.restore => 'Restore',
              ArchiveAction.deletePermanently => 'Delete Permanently',
            }),
          ),
        ],
      ),
    ) ??
    false;

/// The disabled reason stays visible and readable without hover or a tap.
class ArchiveItemAction extends StatelessWidget {
  const ArchiveItemAction({
    super.key,
    required this.label,
    required this.allowed,
    required this.onArchive,
    this.blocker,
    this.busy = false,
  });
  final String label;
  final bool allowed, busy;
  final String? blocker;
  final VoidCallback onArchive;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      OutlinedButton.icon(
        onPressed: busy || !allowed ? null : onArchive,
        icon: const Icon(LucideIcons.archive, size: 18),
        label: Text(label),
      ),
      if (!allowed && blocker != null)
        Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(blocker!, style: Theme.of(context).textTheme.bodySmall),
        ),
    ],
  );
}
