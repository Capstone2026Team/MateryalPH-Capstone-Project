import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../design_system/theme.dart';
import 'projects_repository.dart';
import 'work_package_material_widgets.dart';

/// Comparison orderings, matching the server's `sort` values.
const vendorSorts = [
  ('BEST_MATCH', 'Best match'),
  ('BUDGET_FIT', 'Budget fit'),
  ('RATING', 'Rating'),
  ('PRICE', 'Price'),
];

BoxDecoration vendorCardDecoration(
  BuildContext context, {
  bool selected = false,
}) => BoxDecoration(
  color: Theme.of(context).colorScheme.surface,
  borderRadius: BorderRadius.circular(20),
  border: Border.all(
    color: selected ? BuyerTheme.action : BuyerTheme.border,
    width: selected ? 1.5 : 1,
  ),
);

String kilometres(Object? meters) =>
    '${(projectInt(meters) / 1000).toStringAsFixed(1)} km';

String fulfillmentLabel(Object? method) =>
    projectText(method) == 'DELIVERY' ? 'Site delivery' : 'Self pick-up';

String paymentLabel(Object? method) => switch (projectText(method)) {
  'CASH_ON_DELIVERY' => 'Cash on delivery',
  'IN_STORE' => 'In-store payment',
  _ => 'Online payment',
};

/// Lines the Vendor can fully supply, out of all required lines.
(int, int) fulfilledLines(ProjectData candidate) {
  final lines = projectRows(candidate['lines']);
  final full = lines
      .where(
        (l) => (double.tryParse(projectText(l['missing_quantity'])) ?? 1) <= 0,
      )
      .length;
  return (full, lines.length);
}

/// Projected total, or the materials subtotal while delivery is under review.
String candidateTotal(ProjectData c) => c['projected_total_centavos'] == null
    ? projectMoney(c['materials_centavos'])
    : projectMoney(c['projected_total_centavos']);

String deliveryFee(ProjectData c) =>
    projectText(c['fulfillment_method']) == 'PICKUP'
    ? 'Pick-up · ₱0.00'
    : c['delivery_centavos'] == null
    ? 'Vendor review'
    : projectMoney(c['delivery_centavos']);

class BudgetStatusChip extends StatelessWidget {
  const BudgetStatusChip(this.label, {super.key});
  final String label;

  @override
  Widget build(BuildContext context) {
    final error = Theme.of(context).colorScheme.error;
    final (String text, Color color) = switch (label) {
      'UNDER_BUDGET' => ('Under budget', BuyerTheme.successStrong),
      'WITHIN_BUDGET' => ('Within budget', BuyerTheme.actionPressed),
      'OVER_BUDGET' => ('Over budget', error),
      _ => ('Cost review', BuyerTheme.muted),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class VendorMetricTile extends StatelessWidget {
  const VendorMetricTile({super.key, required this.label, required this.value});
  final String label, value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: BuyerTheme.canvas,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(color: BuyerTheme.muted),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

/// One Vendor in the comparison: total, four facts, budget status and the
/// Message / View quotation actions.
class VendorResultCard extends StatelessWidget {
  const VendorResultCard({
    super.key,
    required this.candidate,
    required this.selected,
    required this.onSelect,
    required this.onMessage,
    required this.onViewQuotation,
  });
  final ProjectData candidate;
  final bool selected;
  final VoidCallback onSelect;

  /// Null when messaging is not available (closed project, stale estimate).
  final VoidCallback? onMessage;
  final VoidCallback onViewQuotation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = candidate;
    final (full, total) = fulfilledLines(c);
    final fms = projectObject(c['fms'])['score'];
    final quotation = projectText(c['current_quotation_state']);
    final missing = projectRows(c['missing_lines']).length;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onSelect,
          child: Ink(
            decoration: vendorCardDecoration(context, selected: selected),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            spacing: 6,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                projectText(c['store_name']),
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              if (c['is_favorite'] == true)
                                const Tooltip(
                                  message: 'Preferred seller',
                                  child: Icon(
                                    LucideIcons.heart,
                                    size: 16,
                                    color: BuyerTheme.action,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Wrap(
                            spacing: 12,
                            children: [
                              _Fact(
                                LucideIcons.mapPin,
                                kilometres(c['distance_meters']),
                              ),
                              _Fact(
                                LucideIcons.star,
                                projectText(c['score_label']),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          candidateTotal(c),
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          c['projected_total_centavos'] == null
                              ? 'Materials only'
                              : 'Total incl. delivery',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: BuyerTheme.muted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _MetricRow(
                  VendorMetricTile(
                    label: 'Item fulfillment',
                    value: '$full/$total',
                  ),
                  VendorMetricTile(
                    label: 'Delivery fee',
                    value: deliveryFee(c),
                  ),
                ),
                const SizedBox(height: 8),
                _MetricRow(
                  VendorMetricTile(
                    label: 'Quotation',
                    value: quotation == 'NO_INQUIRY'
                        ? 'Not requested'
                        : projectStatus(quotation),
                  ),
                  VendorMetricTile(
                    label: 'FMS score',
                    value: fms == null ? 'Cost review' : '$fms/100',
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      'Budget status',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: BuyerTheme.muted,
                      ),
                    ),
                    BudgetStatusChip(projectText(c['budget_label'])),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: onMessage,
                        icon: const Icon(LucideIcons.messageCircle, size: 18),
                        label: const Text('Message'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: onViewQuotation,
                        child: const Text('View quotation'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  missing == 0
                      ? '• Package deal: every material from this Vendor'
                      : '• $missing material${missing == 1 ? '' : 's'} missing — buy separately',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: BuyerTheme.muted,
                  ),
                ),
                Text(
                  '• ${fulfillmentLabel(c['fulfillment_method'])} · ${paymentLabel(c['payment_method'])}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: BuyerTheme.muted,
                  ),
                ),
                if (c['stale'] == true) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Prices or stock changed. Refresh the estimate before choosing this Vendor.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Two equal-height metric tiles side by side.
class _MetricRow extends StatelessWidget {
  const _MetricRow(this.left, this.right);
  final Widget left, right;

  @override
  Widget build(BuildContext context) => IntrinsicHeight(
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(child: left),
        const SizedBox(width: 8),
        Expanded(child: right),
      ],
    ),
  );
}

class _Fact extends StatelessWidget {
  const _Fact(this.icon, this.text);
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 14, color: BuyerTheme.muted),
      const SizedBox(width: 4),
      Text(
        text,
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: BuyerTheme.muted),
      ),
    ],
  );
}

/// Sort tabs with an underline on the active ordering.
class VendorSortTabs extends StatelessWidget {
  const VendorSortTabs({
    super.key,
    required this.value,
    required this.onChanged,
  });
  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final (code, label) in vendorSorts)
            Semantics(
              selected: code == value,
              button: true,
              child: InkWell(
                onTap: () => onChanged(code),
                child: Container(
                  constraints: const BoxConstraints(minHeight: 44),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: code == value
                            ? BuyerTheme.action
                            : Colors.transparent,
                        width: 2.5,
                      ),
                    ),
                  ),
                  child: Text(
                    label,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: code == value
                          ? BuyerTheme.action
                          : BuyerTheme.muted,
                      fontWeight: code == value
                          ? FontWeight.w700
                          : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Filters that narrow the comparison (owner decision 2026-10-12: delivery
/// mode is locked in the package, so it is not a filter).
class VendorFilterChips extends StatelessWidget {
  const VendorFilterChips({
    super.key,
    required this.favorites,
    required this.complete,
    required this.withinBudget,
    required this.onChanged,
  });
  final bool favorites, complete, withinBudget;
  final void Function({bool? favorites, bool? complete, bool? withinBudget})
  onChanged;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: [
        FilterChip(
          label: const Text('Preferred sellers'),
          selected: favorites,
          onSelected: (v) => onChanged(favorites: v),
        ),
        const SizedBox(width: 8),
        FilterChip(
          label: const Text('Complete match'),
          selected: complete,
          onSelected: (v) => onChanged(complete: v),
        ),
        const SizedBox(width: 8),
        FilterChip(
          label: const Text('Within budget'),
          selected: withinBudget,
          onSelected: (v) => onChanged(withinBudget: v),
        ),
      ],
    ),
  );
}

/// Missing quantity in the line's own unit, e.g. "7 BAG".
String missingQuantity(ProjectData line) =>
    '${materialQuantity(line['quantity'])} ${projectText(line['unit_code'])}'
        .trim();
