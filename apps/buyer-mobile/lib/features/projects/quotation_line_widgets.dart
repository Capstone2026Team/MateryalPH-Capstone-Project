import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../design_system/components/specification_chips.dart';
import '../../design_system/theme.dart';
import 'projects_repository.dart';
import 'work_package_material_widgets.dart';

typedef OpenProduct = void Function(String listingId, String? variantId);

/// The Buyer's stated details for a line, named as the offered products name
/// them (the category labels), so both read alike.
List<SpecificationDetail> requestedDetails(ProjectData line) {
  final labels = <String, ({String label, String? unit})>{};
  for (final source in [
    ...projectRows(line['options']),
    ...projectRows(line['allocations']),
  ]) {
    for (final row in projectRows(
      source['specifications'] ?? source['offered_specifications'],
    )) {
      labels[projectText(row['code'])] = (
        label: projectText(row['label']),
        unit: row['unit_code'] as String?,
      );
    }
  }
  return [
    for (final e in projectObject(line['specifications']).entries)
      if (projectText(e.value).trim().isNotEmpty)
        (
          label:
              labels[e.key]?.label ??
              e.key
                  .replaceAll('_', ' ')
                  .replaceFirstMapped(RegExp('^.'), (m) => m[0]!.toUpperCase()),
          value: projectText(e.value),
          unit: labels[e.key]?.unit,
        ),
  ];
}

/// One requirement in the quotation's Order summary: what the Buyer asked for,
/// each product this Vendor supplies for it (tap → Product Details on the
/// quoted variant), and — when several specifications fit — the choice the
/// Buyer must make before selecting or messaging.
class QuotationSummaryLine extends StatelessWidget {
  const QuotationSummaryLine({
    super.key,
    required this.line,
    required this.storeName,
    required this.onChoose,
    this.onOpenProduct,
    this.busy = false,
  });
  final ProjectData line;
  final String storeName;
  final VoidCallback onChoose;
  final OpenProduct? onOpenProduct;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final unit = projectText(line['unit_code']);
    final pending = line['selection_required'] == true;
    final options = projectRows(line['options']);
    final requested = requestedDetails(line);
    final short =
        (double.tryParse(projectText(line['missing_quantity'])) ?? 0) > 0;
    final muted = theme.textTheme.bodySmall?.copyWith(color: BuyerTheme.muted);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  projectText(line['name']),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                pending
                    ? 'From ${projectMoney(line['amount_centavos'])}'
                    : projectMoney(line['amount_centavos']),
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          Text(
            'Requested ${materialQuantity(line['quantity'])} $unit',
            style: muted,
          ),
          if (requested.isNotEmpty) ...[
            const SizedBox(height: 4),
            SpecificationChips(details: requested),
          ],
          if (pending)
            _ChoiceNeeded(count: options.length, busy: busy, onChoose: onChoose)
          else
            for (final a in projectRows(line['allocations']))
              _SuppliedProduct(
                allocation: a,
                unit: unit,
                storeName: storeName,
                requested: {for (final r in requested) r.label},
                onOpen: onOpenProduct,
              ),
          if (!pending && options.length > 1)
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: TextButton.icon(
                onPressed: busy ? null : onChoose,
                icon: const Icon(LucideIcons.slidersHorizontal, size: 18),
                label: Text('Change specification (${options.length})'),
              ),
            ),
          if (short)
            Text(
              '${materialQuantity(line['missing_quantity'])} $unit not available from this Vendor',
              style: theme.textTheme.bodySmall?.copyWith(
                color: BuyerTheme.actionPressed,
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );
  }
}

class _ChoiceNeeded extends StatelessWidget {
  const _ChoiceNeeded({
    required this.count,
    required this.busy,
    required this.onChoose,
  });
  final int count;
  final bool busy;
  final VoidCallback onChoose;

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(top: 8),
    padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
    decoration: BoxDecoration(
      color: BuyerTheme.brandSoft,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$count specifications fit your request. Choose one before you select or message this Vendor; until then the price shown is the lowest.',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: BuyerTheme.ink),
        ),
        TextButton.icon(
          onPressed: busy ? null : onChoose,
          icon: const Icon(LucideIcons.listChecks, size: 18),
          label: const Text('Choose specification'),
        ),
      ],
    ),
  );
}

/// A product this Vendor supplies for the line, linked to its Product Details.
class _SuppliedProduct extends StatelessWidget {
  const _SuppliedProduct({
    required this.allocation,
    required this.unit,
    required this.storeName,
    required this.requested,
    required this.onOpen,
  });
  final ProjectData allocation;
  final String unit, storeName;
  final Set<String> requested;
  final OpenProduct? onOpen;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final a = allocation;
    final listingId = a['listing_id'] as String?;
    final name = [
      projectText(a['description']),
      projectText(a['variant_label']),
    ].where((s) => s.isNotEmpty).join(' · ');
    final content = Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name.isEmpty ? 'Listed product' : name,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                SpecificationChips(
                  details: specificationDetails(a['offered_specifications']),
                  highlight: requested,
                ),
                const SizedBox(height: 4),
                Text(
                  [
                    '${materialQuantity(a['matched_quantity'])} $unit × ${projectMoney(a['unit_price_centavos'])}',
                    if (projectText(a['brand']).isNotEmpty)
                      projectText(a['brand']),
                    'Sold by $storeName',
                  ].join(' · '),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: BuyerTheme.muted,
                  ),
                ),
              ],
            ),
          ),
          if (onOpen != null && listingId != null)
            const Icon(LucideIcons.chevronRight, color: BuyerTheme.muted),
        ],
      ),
    );
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Material(
        color: BuyerTheme.canvas,
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias,
        child: onOpen == null || listingId == null
            ? content
            : InkWell(
                onTap: () => onOpen!(listingId, a['variant_id'] as String?),
                child: Semantics(
                  button: true,
                  hint: 'Opens product details',
                  child: content,
                ),
              ),
      ),
    );
  }
}

/// Lets the Buyer pick one of a line's specification options. Resolves to the
/// chosen option id, or null when dismissed.
Future<String?> showSpecificationChoice(
  BuildContext context, {
  required ProjectData line,
  required String storeName,
  OpenProduct? onOpenProduct,
}) => showModalBottomSheet<String>(
  context: context,
  isScrollControlled: true,
  showDragHandle: true,
  builder: (sheet) => DraggableScrollableSheet(
    expand: false,
    initialChildSize: .7,
    maxChildSize: .92,
    builder: (context, controller) => _SpecificationChoice(
      line: line,
      storeName: storeName,
      controller: controller,
      onOpenProduct: onOpenProduct == null
          ? null
          : (listing, variant) {
              Navigator.pop(sheet);
              onOpenProduct(listing, variant);
            },
    ),
  ),
);

class _SpecificationChoice extends StatelessWidget {
  const _SpecificationChoice({
    required this.line,
    required this.storeName,
    required this.controller,
    required this.onOpenProduct,
  });
  final ProjectData line;
  final String storeName;
  final ScrollController controller;
  final OpenProduct? onOpenProduct;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selected = line['selected_option_id'];
    final requested = requestedDetails(line);
    final unit = projectText(line['unit_code']);
    return ListView(
      controller: controller,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      children: [
        Semantics(
          header: true,
          child: Text(
            'Choose a specification',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${projectText(line['name'])} · ${materialQuantity(line['quantity'])} $unit from $storeName. '
          'Each option matches what you stated; pick the one your project needs.',
          style: theme.textTheme.bodySmall?.copyWith(color: BuyerTheme.muted),
        ),
        if (requested.isNotEmpty) ...[
          const SizedBox(height: 8),
          SpecificationChips(details: requested),
        ],
        for (final o in projectRows(line['options']))
          _OptionTile(
            option: o,
            unit: unit,
            selected: o['option_id'] == selected,
            onChoose: () => Navigator.pop(context, projectText(o['option_id'])),
            onOpen: onOpenProduct,
          ),
      ],
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.option,
    required this.unit,
    required this.selected,
    required this.onChoose,
    required this.onOpen,
  });
  final ProjectData option;
  final String unit;
  final bool selected;
  final VoidCallback onChoose;
  final OpenProduct? onOpen;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final o = option;
    final full = o['availability'] == 'FULFILLABLE';
    final name = [
      projectText(o['display_name']),
      projectText(o['variant_label']),
    ].where((s) => s.isNotEmpty).join(' · ');
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: selected ? BuyerTheme.action : BuyerTheme.border,
          width: selected ? 2 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onChoose,
          child: Semantics(
            button: true,
            selected: selected,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 8, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        selected ? LucideIcons.circleCheck : LucideIcons.circle,
                        size: 20,
                        color: selected ? BuyerTheme.action : BuyerTheme.muted,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          name,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        '${projectMoney(o['unit_price_centavos'])} / $unit',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  SpecificationChips(
                    details: specificationDetails(o['specifications']),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          [
                            if (projectText(o['brand']).isNotEmpty)
                              projectText(o['brand']),
                            full
                                ? 'Can supply the full quantity'
                                : 'Can supply part of the quantity',
                          ].join(' · '),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: full
                                ? BuyerTheme.successStrong
                                : BuyerTheme.actionPressed,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (onOpen != null && o['listing_id'] is String)
                        TextButton(
                          onPressed: () => onOpen!(
                            projectText(o['listing_id']),
                            o['variant_id'] as String?,
                          ),
                          child: const Text('View product'),
                        ),
                    ],
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
