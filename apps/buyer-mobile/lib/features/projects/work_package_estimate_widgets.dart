import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../design_system/theme.dart';
import 'projects_repository.dart';
import 'work_package_material_widgets.dart';

BoxDecoration _card(BuildContext context) => BoxDecoration(
  color: Theme.of(context).colorScheme.surface,
  borderRadius: BorderRadius.circular(16),
  border: Border.all(color: BuyerTheme.border),
);

/// Advisory materials-only estimate (owner decision 2026-10-12): the total,
/// a reminder of what it excludes, and the per-line breakdown. It never
/// replaces a system-compiled estimate or a Vendor quotation.
class WorkPackageEstimateSection extends StatelessWidget {
  const WorkPackageEstimateSection({
    super.key,
    required this.lines,
    required this.estimate,
    required this.loading,
    required this.error,
    required this.budgetCentavos,
    required this.ready,
    required this.onRetry,
    required this.onUseAsBudget,
  });
  final List<ProjectData> lines;
  final ProjectData? estimate;
  final bool loading;
  final String? error;
  final int? budgetCentavos;

  /// False until a site and at least one material are set.
  final bool ready;
  final VoidCallback onRetry;
  final ValueChanged<int> onUseAsBudget;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final total = projectInt(estimate?['materials_total_centavos']);
    final priced = projectInt(estimate?['priced_line_count']);
    final rows = {
      for (final row in projectRows(estimate?['lines']))
        projectInt(row['index']): row,
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: _card(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Material Budget Cost Estimate',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              if (!ready)
                Text(
                  'Add materials and choose a Project site to see an estimate.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: BuyerTheme.muted,
                  ),
                )
              else if (error != null)
                Column(
                  children: [
                    Text(
                      error!,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium,
                    ),
                    TextButton.icon(
                      onPressed: onRetry,
                      icon: const Icon(LucideIcons.refreshCw, size: 18),
                      label: const Text('Try again'),
                    ),
                  ],
                )
              else if (estimate == null)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: LinearProgressIndicator(),
                )
              else ...[
                Semantics(
                  label: 'Estimated total cost ${projectMoney(total)}',
                  excludeSemantics: true,
                  child: Column(
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          projectMoney(total),
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Estimated total cost',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: BuyerTheme.muted,
                        ),
                      ),
                    ],
                  ),
                ),
                if (loading)
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: LinearProgressIndicator(),
                  ),
                const SizedBox(height: 12),
                Text(
                  '$priced of ${lines.length} materials priced · average of nearby Vendors within ${projectInt(estimate!['radius_km'])} km',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: BuyerTheme.muted,
                  ),
                ),
                if (budgetCentavos != null && total > 0) ...[
                  const SizedBox(height: 12),
                  _BudgetFit(budget: budgetCentavos!, total: total),
                ],
                if (total > 0 && total != budgetCentavos)
                  Center(
                    child: TextButton.icon(
                      onPressed: () => onUseAsBudget(total),
                      icon: const Icon(LucideIcons.arrowDownToLine, size: 18),
                      label: const Text('Use estimate as budget'),
                    ),
                  ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              LucideIcons.triangleAlert,
              size: 18,
              color: BuyerTheme.muted,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Reminder\n',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const TextSpan(
                      text:
                          'The estimate covers materials only. It excludes delivery fees and labor, and it is not a Vendor quotation.',
                    ),
                  ],
                ),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: BuyerTheme.muted,
                ),
              ),
            ),
          ],
        ),
        if (estimate != null && ready && error == null) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            decoration: _card(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Estimate Budget Summary',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                for (final (i, line) in lines.indexed)
                  EstimateLineRow(line: line, row: rows[i]),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _BudgetFit extends StatelessWidget {
  const _BudgetFit({required this.budget, required this.total});
  final int budget, total;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final over = total > budget;
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color: over
              ? theme.colorScheme.error.withValues(alpha: 0.1)
              : BuyerTheme.success.withValues(alpha: 0.12),
        ),
        child: Text(
          over
              ? 'Over your budget by ${projectMoney(total - budget)}'
              : 'Within your budget · ${projectMoney(budget - total)} left',
          style: theme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: over ? theme.colorScheme.error : BuyerTheme.successStrong,
          ),
        ),
      ),
    );
  }
}

/// One material: quantity × average unit price, and its line amount.
class EstimateLineRow extends StatelessWidget {
  const EstimateLineRow({super.key, required this.line, required this.row});
  final ProjectData line;
  final ProjectData? row;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final quantity =
        '${materialQuantity(line['quantity'])} ${projectText(line['unit_code'])}'
            .trim();
    final status = projectText(row?['status']);
    final detail = switch (status) {
      'PRICED' =>
        '$quantity × ${projectMoney(row!['average_unit_price_centavos'])}',
      'UNLISTED' => '$quantity · unlisted, not priced',
      _ => '$quantity · no matching listing nearby',
    };
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  projectText(line['name']),
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 2),
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
            status == 'PRICED' ? projectMoney(row!['amount_centavos']) : '—',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
