import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../features/projects/projects_repository.dart';
import '../../features/projects/work_package_material_widgets.dart';
import '../theme.dart';

const _fulfillment = {'PICKUP': 'Pickup', 'DELIVERY': 'Site delivery'};
const _payment = {
  'ONLINE': 'Online payment',
  'CASH_ON_DELIVERY': 'Cash on delivery',
  'IN_STORE': 'In-store payment',
};

/// One responsive attachment for Project chat, comparison and order review.
class WorkPackageAttachment extends StatelessWidget {
  const WorkPackageAttachment({
    super.key,
    required this.original,
    this.proposed,
    this.version,
    this.locked = true,
    this.title,
  });
  final ProjectData original;
  final ProjectData? proposed;
  final Object? version;
  final bool locked;

  /// Replaces the default "Locked Buyer original" heading, e.g. on the package screen where there is only one copy.
  final String? title;

  Widget _copy(
    BuildContext context,
    String title,
    IconData icon,
    ProjectData value,
  ) {
    final theme = Theme.of(context);
    final lines = projectRows(value['lines']);
    final fulfillment = projectText(value['fulfillment_method']);
    final payment = projectText(value['payment_method']);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: BuyerTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: BuyerTheme.muted),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          if (value['name'] != null) ...[
            const SizedBox(height: 8),
            Text(
              projectText(value['name']),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              if (value['budget_centavos'] != null)
                _Chip('Budget ${projectMoney(value['budget_centavos'])}'),
              if (fulfillment.isNotEmpty)
                _Chip(_fulfillment[fulfillment] ?? fulfillment),
              if (payment.isNotEmpty) _Chip(_payment[payment] ?? payment),
            ],
          ),
          if (lines.isNotEmpty) ...[
            const Divider(height: 24),
            Text(
              'Materials (${lines.length})',
              style: theme.textTheme.labelLarge?.copyWith(
                color: BuyerTheme.muted,
                fontWeight: FontWeight.w700,
              ),
            ),
            for (final (i, line) in lines.indexed) ...[
              if (i > 0) const Divider(height: 1),
              _Line(line: line),
            ],
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final left = _copy(
        context,
        title ??
            '${locked ? 'Locked Buyer original' : 'Editable Buyer draft'}${version == null ? '' : ' · version $version'}',
        title != null
            ? LucideIcons.clipboardList
            : locked
            ? LucideIcons.lock
            : LucideIcons.pencilLine,
        original,
      );
      if (proposed == null) return left;
      final right = _copy(
        context,
        'Vendor proposal',
        LucideIcons.store,
        proposed!,
      );
      return constraints.maxWidth >= 1024
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: left),
                const SizedBox(width: 12),
                Expanded(child: right),
              ],
            )
          : Column(children: [left, right]);
    },
  );
}

class _Chip extends StatelessWidget {
  const _Chip(this.label);
  final String label;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: BuyerTheme.canvas,
      borderRadius: BorderRadius.circular(999),
      border: Border.all(color: BuyerTheme.border),
    ),
    child: Text(label, style: Theme.of(context).textTheme.labelMedium),
  );
}

class _Line extends StatelessWidget {
  const _Line({required this.line});
  final ProjectData line;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final unlisted =
        line.containsKey('material_id') && line['material_id'] == null;
    final details = [
      if (line['preferred_brand'] != null)
        'Preferred brand: ${line['preferred_brand']}',
      if (projectText(line['color']).isNotEmpty) 'Color: ${line['color']}',
      for (final entry in projectObject(line['specifications']).entries)
        '${detailLabel(entry.key)}: ${entry.value}',
      if (line['unit_price_centavos'] != null)
        'Unit price ${projectMoney(line['unit_price_centavos'])}',
    ];
    final name = projectText(
      line['name'] ?? line['description'] ?? line['variant_id'],
    );
    final description = line['name'] == null
        ? ''
        : projectText(line['description']);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      name,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (unlisted) const UnlistedBadge(),
                  ],
                ),
                if (description.isNotEmpty)
                  Text(
                    description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: BuyerTheme.muted,
                    ),
                  ),
                for (final detail in details)
                  Text(
                    detail,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: BuyerTheme.muted,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${materialQuantity(line['quantity'])} ${projectText(line['unit_code'])}'
                .trim(),
            style: theme.textTheme.bodyLarge?.copyWith(
              color: BuyerTheme.action,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
