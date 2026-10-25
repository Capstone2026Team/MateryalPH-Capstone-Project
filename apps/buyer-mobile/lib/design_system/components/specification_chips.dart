import 'package:materyalph_api_client/materyalph_api_client.dart' as api;
import 'package:flutter/material.dart';

import '../theme.dart';

/// One technical detail as the category names it ("Thickness 150 mm").
typedef SpecificationDetail = ({String label, String value, String? unit});

/// Reads `{code, label, value, unit_code}` rows from an API response.
List<SpecificationDetail> specificationDetails(Object? rows) => [
  if (rows is Iterable)
    for (final row in rows)
      if (row is api.ProjectSpecificationDetail && row.value.trim().isNotEmpty)
        (label: row.label, value: row.value, unit: row.unitCode)
      else if (row is Map && '${row['value'] ?? ''}'.trim().isNotEmpty)
        (
          label: '${row['label'] ?? row['code'] ?? ''}',
          value: '${row['value']}',
          unit: row['unit_code'] == null || '${row['unit_code']}'.isEmpty
              ? null
              : '${row['unit_code']}',
        ),
];

String specificationText(SpecificationDetail d) =>
    '${d.label} ${d.value}${d.unit == null ? '' : ' ${d.unit}'}';

/// Compact, wrapping chips for a product's or a requirement's technical
/// details. Read-only: one semantics label lists every detail.
class SpecificationChips extends StatelessWidget {
  const SpecificationChips({
    super.key,
    required this.details,
    this.highlight = const {},
  });
  final List<SpecificationDetail> details;

  /// Labels shown with the success tone, e.g. details the Buyer asked for.
  final Set<String> highlight;

  @override
  Widget build(BuildContext context) {
    if (details.isEmpty) return const SizedBox.shrink();
    final style = Theme.of(context).textTheme.labelMedium;
    return LayoutBuilder(
      builder: (context, constraints) => Semantics(
        label: details.map(specificationText).join(', '),
        excludeSemantics: true,
        child: Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            for (final d in details)
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: constraints.maxWidth),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: highlight.contains(d.label)
                        ? BuyerTheme.success.withValues(alpha: 0.12)
                        : BuyerTheme.canvas,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: BuyerTheme.border),
                  ),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '${d.label} ',
                          style: const TextStyle(color: BuyerTheme.muted),
                        ),
                        TextSpan(
                          text: d.unit == null
                              ? d.value
                              : '${d.value} ${d.unit}',
                          style: const TextStyle(
                            color: BuyerTheme.ink,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    style: style,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
