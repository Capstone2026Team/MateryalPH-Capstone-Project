import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../design_system/components/buyer_overlays.dart';
import '../../design_system/components/ranking_indicator.dart';
import '../../design_system/theme.dart';
import '../map_discovery/discovery_models.dart';
import 'projects_repository.dart';
import 'work_package_material_widgets.dart';

/// Comparison orderings, matching the server's `sort` values.
const vendorSorts = [
  ('BEST_MATCH', 'Best match'),
  ('BUDGET_FIT', 'Budget fit'),
  ('RATING', 'Rating'),
  ('PRICE', 'Price'),
];

/// Whether each reversible ordering opens high to low. Best Match is a fixed
/// ranking, so it has no entry and no arrow. Budget fit and Rating open best
/// first; Price opens cheapest first.
const vendorSortDescending = {
  'BUDGET_FIT': true,
  'RATING': true,
  'PRICE': false,
};

/// The server's `direction` value: ASC is low to high, DESC high to low.
String vendorSortDirection(bool descending) => descending ? 'DESC' : 'ASC';

/// What the tab announces, e.g. "Sort by Price, low to high".
String vendorSortLabel(String label, bool descending) =>
    'Sort by $label, ${descending ? 'high to low' : 'low to high'}';

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

/// Methods this Vendor offers for the package. More than one (a Both package)
/// means the Buyer picks Delivery or Pickup before inquiring or selecting.
List<String> fulfillmentOptions(ProjectData c) => [
  for (final m in (c['fulfillment_options'] as List?) ?? const [])
    projectText(m),
];

bool needsFulfillmentChoice(ProjectData c) => fulfillmentOptions(c).length > 1;

/// The card's method line: the priced method, plus the other one when offered.
String candidateFulfillmentLabel(ProjectData c) {
  final label = fulfillmentLabel(c['fulfillment_method']);
  if (!needsFulfillmentChoice(c)) return label;
  final other = fulfillmentOptions(
    c,
  ).where((m) => m != projectText(c['fulfillment_method']));
  return '$label · ${other.map(fulfillmentLabel).join(', ').toLowerCase()} also offered';
}

String paymentLabel(Object? method) => switch (projectText(method)) {
  'CASH_ON_DELIVERY' => 'Cash on delivery',
  'IN_STORE' => 'In-store payment',
  _ => 'Online payment',
};

/// The server's fulfillment for a quotation. The Vendor card, the quotation
/// page and its order summary all read this one result, so no screen keeps
/// its own count of what is covered.
ProjectData candidateFulfillment(ProjectData candidate) =>
    projectObject(candidate['fulfillment']);

/// Lines fully covered, out of all required lines.
(int, int) fulfilledLines(ProjectData candidate) {
  final f = candidateFulfillment(candidate);
  return (projectInt(f['lines_fulfilled']), projectInt(f['lines_total']));
}

/// Lines not yet fully covered: partly covered or not covered at all.
int linesToSource(ProjectData candidate) {
  final (full, total) = fulfilledLines(candidate);
  return total - full;
}

/// "2/4", with the partly covered lines noted: "2/4 · 1 partial".
String fulfillmentSummary(ProjectData candidate) {
  final (full, total) = fulfilledLines(candidate);
  final partial = projectInt(candidateFulfillment(candidate)['lines_partial']);
  return partial > 0 ? '$full/$total · $partial partial' : '$full/$total';
}

/// Why recommendations could not be loaded. A connection or server problem
/// says so and offers a retry; it is never presented as "no matching products".
String alternativesError(DiscoveryFailure failure) => switch (failure.kind) {
  DiscoveryFailureKind.offline =>
    'You appear to be offline, so other stores could not be checked. Retry when you are connected.',
  DiscoveryFailureKind.provider ||
  DiscoveryFailureKind.unknown ||
  DiscoveryFailureKind.rateLimited =>
    'We could not check other stores right now. This is a connection or server problem, not a lack of matching products. Retry in a moment.',
  _ => failure.message,
};

/// The server's fulfillment row for one Work Package line.
ProjectData fulfillmentLine(ProjectData candidate, String lineId) {
  for (final l in projectRows(candidateFulfillment(candidate)['lines'])) {
    if (projectText(l['line_id']) == lineId) return l;
  }
  return const {};
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
    this.rankingPosition,
  });
  final ProjectData candidate;
  final int? rankingPosition;
  final bool selected;
  final VoidCallback onSelect;

  /// Null when messaging is not available (closed project, stale estimate).
  final VoidCallback? onMessage;
  final VoidCallback onViewQuotation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = candidate;
    final fms = projectObject(c['fms'])['score'];
    final quotation = projectText(c['current_quotation_state']);
    final missing = linesToSource(c);
    final fulfillment = candidateFulfillment(c);
    final fullTotal = c['procurement_total_centavos'];
    final separate = projectInt(fulfillment['separate_total_centavos']);
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
                if (rankingPosition != null) ...[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: RankingIndicator(
                      position: rankingPosition!,
                      recommendation: RankingRecommendation.bestMatch,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
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
                          fullTotal == null
                              ? 'Cost review'
                              : projectMoney(fullTotal),
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          fullTotal == null
                              ? 'Delivery or price review'
                              : 'All suppliers · incl. delivery',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: BuyerTheme.muted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _VendorCostRow(
                  'Materials · all suppliers',
                  projectMoney(c['procurement_materials_centavos']),
                ),
                _VendorCostRow(
                  'Delivery · all suppliers',
                  c['procurement_delivery_centavos'] == null
                      ? 'Vendor review'
                      : projectMoney(c['procurement_delivery_centavos']),
                ),
                if (separate > 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 4, bottom: 8),
                    child: Text(
                      'Includes separate materials ${projectMoney(separate)} and delivery ${c['separate_delivery_centavos'] == null ? 'under review' : projectMoney(c['separate_delivery_centavos'])}.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: BuyerTheme.muted,
                      ),
                    ),
                  ),
                const SizedBox(height: 8),
                _MetricRow(
                  VendorMetricTile(
                    label: 'Item fulfillment',
                    value: fulfillmentSummary(c),
                  ),
                  VendorMetricTile(
                    label: 'Other suppliers',
                    value:
                        '${projectRows(fulfillment['separate_items']).map((item) => projectText(item['vendor_id'])).toSet().length}',
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
                    BudgetStatusChip(
                      projectText(c['procurement_budget_label']),
                    ),
                  ],
                ),
                if (rankingPosition != null)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: () => showVendorRankingExplanation(
                        context: context,
                        candidate: c,
                        position: rankingPosition!,
                      ),
                      icon: const Icon(LucideIcons.info, size: 16),
                      label: const Text('Why this ranking'),
                    ),
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
                if (missing == 0)
                  Text(
                    projectInt(fulfillment['vendor_lines_fulfilled']) ==
                            projectInt(fulfillment['lines_total'])
                        ? '• Package deal: every material from this Vendor'
                        : '• All materials covered, including selected items from other suppliers',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: BuyerTheme.muted,
                    ),
                  )
                else
                  TextButton.icon(
                    onPressed: onViewQuotation,
                    style: TextButton.styleFrom(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(44, 44),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    icon: const Icon(LucideIcons.packageSearch, size: 18),
                    label: Text(
                      '$missing material${missing == 1 ? '' : 's'} to source — see recommendations from other stores',
                    ),
                  ),
                Text(
                  '• ${candidateFulfillmentLabel(c)} · ${paymentLabel(c['payment_method'])}',
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

Future<void> showVendorRankingExplanation({
  required BuildContext context,
  required ProjectData candidate,
  int position = 0,
  bool arrangement = false,
}) => showDialog<void>(
  context: context,
  builder: (context) => BuyerContentDialog(
    title: 'Why this ranking',
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: VendorRankingExplanation(
        candidate: candidate,
        position: position,
        arrangement: arrangement,
      ),
    ),
  ),
);

/// Compact entry point shared by quotation cards and quotation details.
class FulfillmentScoreTile extends StatelessWidget {
  const FulfillmentScoreTile({
    super.key,
    required this.candidate,
    this.position = 0,
    this.arrangement = false,
    this.outlined = true,
  });

  final ProjectData candidate;
  final int position;
  final bool arrangement, outlined;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final score = projectObject(candidate['fms'])['score'];
    return Container(
      decoration: outlined ? vendorCardDecoration(context) : null,
      clipBehavior: outlined ? Clip.antiAlias : Clip.none,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => showVendorRankingExplanation(
            context: context,
            candidate: candidate,
            position: position,
            arrangement: arrangement,
          ),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: outlined ? 16 : 0,
              vertical: 14,
            ),
            child: Row(
              children: [
                const Icon(LucideIcons.gauge, color: BuyerTheme.muted),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Fulfillment Match Score',
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        score == null
                            ? 'Unavailable · Review costs or supplier data'
                            : '${_rankingPoints(score)} / 100',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: BuyerTheme.actionPressed,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(LucideIcons.chevronRight, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String _rankingPoints(Object? value) {
  final number = num.tryParse(projectText(value));
  return number == null
      ? '—'
      : number.toStringAsFixed(2).replaceFirst(RegExp(r'\.?0+$'), '');
}

/// Shows the components and saved weights from this candidate's FMS snapshot.
class VendorRankingExplanation extends StatelessWidget {
  const VendorRankingExplanation({
    super.key,
    required this.candidate,
    required this.position,
    this.arrangement = false,
  });

  final ProjectData candidate;
  final int position;
  final bool arrangement;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fms = projectObject(candidate['fms']);
    final components = projectObject(fms['components']);
    final weights = projectObject(fms['weights']);
    final total = weights.values.fold<int>(0, (sum, v) => sum + projectInt(v));
    final shares = projectRows(fms['vendor_shares']);
    const labels = {
      'material_match': 'Material fulfillment',
      'budget_fit': 'Budget fit',
      'distance': 'Distance',
      'vps': 'Vendor performance',
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                arrangement
                    ? 'Quotation arrangement'
                    : projectText(candidate['store_name']),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            if (position > 0) ...[
              const SizedBox(width: 12),
              Text(
                'Rank #$position',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: BuyerTheme.actionPressed,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: BuyerTheme.canvas,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(
                LucideIcons.gauge,
                color: BuyerTheme.actionPressed,
                size: 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Fulfillment Match Score',
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      fms['score'] == null
                          ? 'Unavailable'
                          : '${_rankingPoints(fms['score'])} / 100',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: BuyerTheme.actionPressed,
                      ),
                    ),
                    if (fms['score'] == null)
                      const Text('Review current cost or supplier data.'),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'What shapes this score',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Influence reflects your saved Project-Based preferences.',
          style: theme.textTheme.bodySmall?.copyWith(color: BuyerTheme.muted),
        ),
        const SizedBox(height: 12),
        for (final e in labels.entries)
          _RankingFactor(
            label: e.value,
            value: components[e.key],
            influence: total > 0 && weights.containsKey(e.key)
                ? projectInt(weights[e.key]) * 100 / total
                : null,
          ),
        const Divider(height: 24),
        Text(
          'How options rank',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          arrangement
              ? 'Complete arrangements rank first, then FMS using your Project-Based preferences. Ties prefer fewer vendors, then a lower known total including delivery.'
              : 'Complete matches come first, then FMS using the saved ranking weights. Equal scores keep the existing server order. These factors and weights are from this estimate.',
          style: theme.textTheme.bodySmall?.copyWith(color: BuyerTheme.muted),
        ),
        if (arrangement && projectText(fms['basis']).isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            shares.length > 1 ? 'Group calculation' : 'Calculation basis',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            projectText(fms['basis']),
            style: theme.textTheme.bodySmall?.copyWith(color: BuyerTheme.muted),
          ),
          if (shares.length > 1) ...[
            const SizedBox(height: 12),
            Text('Share of material cost', style: theme.textTheme.labelLarge),
          ],
          if (shares.length > 1)
            for (final share in shares)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        '${projectRows(candidate['vendors']).where((v) => v['vendor_id'] == share['vendor_id']).map((v) => projectText(v['store_name'])).join()}${share['new_vendor'] == true ? '\nNew Vendor' : ''}',
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${_rankingPoints(share['material_share_percent'])}%',
                      style: theme.textTheme.labelLarge,
                    ),
                  ],
                ),
              ),
        ],
        const SizedBox(height: 16),
        Text(
          'The highest-ranked option under your active criteria does not guarantee the lowest price, complete fulfillment or the best performance in every category.',
          style: theme.textTheme.bodySmall?.copyWith(color: BuyerTheme.muted),
        ),
      ],
    );
  }
}

class _RankingFactor extends StatelessWidget {
  const _RankingFactor({
    required this.label,
    required this.value,
    required this.influence,
  });

  final String label;
  final Object? value;
  final double? influence;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final score = num.tryParse(projectText(value));
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Text(label, style: theme.textTheme.bodyMedium)),
              const SizedBox(width: 12),
              Flexible(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    score == null
                        ? 'Unavailable'
                        : '${_rankingPoints(value)} / 100',
                    textAlign: TextAlign.right,
                    style: theme.textTheme.labelLarge,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          if (score != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: (score / 100).clamp(0, 1).toDouble(),
                minHeight: 6,
                backgroundColor: BuyerTheme.border,
                color: influence == 0
                    ? BuyerTheme.muted
                    : BuyerTheme.actionPressed,
                semanticsLabel: '$label score',
                semanticsValue: '${_rankingPoints(value)} out of 100',
              ),
            ),
          if (influence != null) ...[
            const SizedBox(height: 4),
            Text(
              influence == 0
                  ? 'Not included in your score'
                  : '${_rankingPoints(influence)}% influence',
              style: theme.textTheme.bodySmall?.copyWith(
                color: BuyerTheme.muted,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Two equal-height metric tiles side by side.
class _VendorCostRow extends StatelessWidget {
  const _VendorCostRow(this.label, this.amount);
  final String label, amount;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 3),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(label, style: Theme.of(context).textTheme.bodySmall),
        ),
        const SizedBox(width: 8),
        Text(
          amount,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700),
        ),
      ],
    ),
  );
}

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
/// The sort tabs. Budget fit, Rating and Price carry a direction arrow (down is
/// high to low, up is low to high): the first tap selects a tab on its default
/// direction, tapping the selected tab reverses it, and only the selected tab's
/// arrow is active. Best Match is a fixed ranking with no arrow.
class VendorSortTabs extends StatelessWidget {
  const VendorSortTabs({
    super.key,
    required this.value,
    required this.descending,
    required this.onChanged,
    this.grouped = false,
  });
  final String value;

  /// The selected tab's direction; ignored for Best Match.
  final bool descending;
  final bool grouped;

  /// The tab tapped and the direction to apply.
  final void Function(String sort, bool descending) onChanged;

  void _tap(String code) {
    final opens = vendorSortDescending[code];
    if (opens == null) {
      // Best Match has no direction; tapping it again changes nothing.
      if (code != value) onChanged(code, false);
      return;
    }
    onChanged(code, code == value ? !descending : opens);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final (code, label) in vendorSorts)
            if (!grouped || code == 'BEST_MATCH' || code == 'PRICE')
              _tab(
                theme,
                code,
                grouped && code == 'BEST_MATCH' ? 'Recommended' : label,
              ),
        ],
      ),
    );
  }

  Widget _tab(ThemeData theme, String code, String label) {
    final selected = code == value;
    final opens = vendorSortDescending[code];
    // An unselected tab shows the direction a tap would open it on, dimmed.
    final down = selected ? descending : opens;
    final color = selected ? BuyerTheme.action : BuyerTheme.muted;
    return Semantics(
      selected: selected,
      button: true,
      excludeSemantics: true,
      label: opens == null ? label : vendorSortLabel(label, down!),
      hint: opens != null && selected ? 'Tap to reverse the order' : null,
      child: Builder(
        builder: (context) => InkWell(
          onTap: () {
            _tap(code);
            // Three arrows widen the row; keep the tapped tab on screen.
            unawaited(
              Scrollable.ensureVisible(
                context,
                alignment: .5,
                duration: MediaQuery.disableAnimationsOf(context)
                    ? Duration.zero
                    : const Duration(milliseconds: 200),
              ),
            );
          },
          child: Container(
            constraints: const BoxConstraints(minHeight: 44, minWidth: 44),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: selected ? BuyerTheme.action : Colors.transparent,
                  width: 2.5,
                ),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: color,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
                if (opens != null) ...[
                  const SizedBox(width: 4),
                  Icon(
                    down! ? LucideIcons.arrowDown : LucideIcons.arrowUp,
                    size: 16,
                    color: selected ? color : color.withValues(alpha: 0.45),
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
