import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../design_system/components/peso_amount_field.dart';
import '../../design_system/components/procurement_components.dart';
import '../../design_system/theme.dart';
import 'projects_repository.dart';

/// "25.0000" -> "25", "2.5000" -> "2.5".
String materialQuantity(Object? value) {
  final text = projectText(value);
  return text.contains('.')
      ? text.replaceFirst(RegExp(r'0+$'), '').replaceFirst(RegExp(r'\.$'), '')
      : text;
}

/// "thickness_mm" -> "Thickness mm"; catalog detail codes read as labels.
String detailLabel(String code) {
  final words = code.replaceAll('_', ' ').trim();
  return words.isEmpty
      ? code
      : '${words[0].toUpperCase()}${words.substring(1)}';
}

/// Marks a Buyer-named material that system matching never prices.
class UnlistedBadge extends StatelessWidget {
  const UnlistedBadge({super.key});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(999),
      color: BuyerTheme.canvas,
      border: Border.all(color: BuyerTheme.border),
    ),
    child: Text(
      'Unlisted',
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        color: BuyerTheme.muted,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}

BoxDecoration _panel(BuildContext context, {Color? color}) => BoxDecoration(
  color: color ?? Theme.of(context).colorScheme.surface,
  borderRadius: BorderRadius.circular(16),
  border: Border.all(color: BuyerTheme.border),
);

/// Shows how much of the Project budget is still unallocated and what remains
/// after this Work Package. Allocations may never exceed the Project budget
/// (owner decision 2026-10-12); the server enforces it.
class ProjectReserveHint extends StatelessWidget {
  const ProjectReserveHint({
    super.key,
    required this.controller,
    required this.reserveCentavos,
    required this.projectCentavos,
  });
  final TextEditingController controller;
  final int reserveCentavos;
  final int projectCentavos;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, value, _) {
        final typed = parseProjectMoney(value.text) ?? 0;
        final over = typed > reserveCentavos ? typed - reserveCentavos : 0;
        final useAll = reserveCentavos > 0 && typed != reserveCentavos;
        return Container(
          margin: const EdgeInsets.only(top: 8),
          padding: const EdgeInsets.fromLTRB(10, 6, 4, 6),
          decoration: _panel(context, color: BuyerTheme.canvas),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    LucideIcons.wallet,
                    size: 16,
                    color: BuyerTheme.muted,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Available from Project budget',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: BuyerTheme.muted,
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: projectMoney(reserveCentavos),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextSpan(
                                text: ' of ${projectMoney(projectCentavos)}',
                                style: const TextStyle(color: BuyerTheme.muted),
                              ),
                            ],
                          ),
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  if (useAll)
                    TextButton(
                      onPressed: () =>
                          controller.text = pesoFieldText(reserveCentavos),
                      child: Text(
                        'Use all',
                        semanticsLabel:
                            'Use all ${projectMoney(reserveCentavos)}',
                      ),
                    ),
                ],
              ),
              if (typed > 0)
                Padding(
                  padding: const EdgeInsets.only(left: 24, right: 8, bottom: 2),
                  child: Text(
                    over > 0
                        ? '${projectMoney(over)} more than the available Project budget. Lower it to save.'
                        : 'Remaining after this package: ${projectMoney(reserveCentavos - typed)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: over > 0
                          ? theme.colorScheme.error
                          : BuyerTheme.successStrong,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

/// One-line summary of a line after its quantity: brand, colour, details.
String materialLineSummary(ProjectData line) {
  final brand = projectText(line['preferred_brand']);
  final color = projectText(line['color']);
  final specs = projectObject(line['specifications']).entries;
  return [
    brand.isEmpty ? 'Any brand' : 'Brand: $brand',
    if (color.isNotEmpty) 'Color: $color',
    for (final s in specs) '${detailLabel(s.key)}: ${s.value}',
  ].join(' · ');
}

/// One required material in a single ~64 dp row: number, name and a
/// "50 PC · Any brand" subtitle, with edit and remove as trailing icons.
/// The full line, description included, is announced to screen readers.
class CompactItemTile extends StatelessWidget {
  const CompactItemTile({
    super.key,
    required this.index,
    required this.line,
    required this.onEdit,
    required this.onRemove,
  });
  final int index;
  final ProjectData line;
  final VoidCallback onEdit;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final name = projectText(line['name']);
    final description = projectText(line['description']);
    final unlisted = line['material_id'] == null;
    final amount =
        '${materialQuantity(line['quantity'])} ${projectText(line['unit_code'])}'
            .trim();
    final summary = materialLineSummary(line);
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 64),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 6, 0, 6),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: BuyerTheme.brandSoft,
                shape: BoxShape.circle,
              ),
              child: Text(
                '${index + 1}',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: BuyerTheme.actionPressed,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Semantics(
                label: [
                  'Material ${index + 1}: $name',
                  if (unlisted) 'Unlisted',
                  amount,
                  summary,
                  if (description.isNotEmpty) description,
                ].join(', '),
                excludeSemantics: true,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (unlisted) ...[
                          const SizedBox(width: 6),
                          const UnlistedBadge(),
                        ],
                      ],
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: amount,
                            style: const TextStyle(
                              color: BuyerTheme.action,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextSpan(text: ' · $summary'),
                        ],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: BuyerTheme.muted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              onPressed: onEdit,
              icon: const Icon(LucideIcons.pencil, size: 20),
              tooltip: 'Edit quantity and details',
              style: IconButton.styleFrom(minimumSize: const Size(44, 44)),
            ),
            IconButton(
              onPressed: onRemove,
              icon: Icon(
                LucideIcons.trash2,
                size: 20,
                color: theme.colorScheme.error,
              ),
              tooltip: 'Remove material',
              style: IconButton.styleFrom(minimumSize: const Size(44, 44)),
            ),
          ],
        ),
      ),
    );
  }
}

class MaterialsEmptyState extends StatelessWidget {
  const MaterialsEmptyState({super.key});

  @override
  Widget build(BuildContext context) => const StateMessage(
    kind: StateKind.empty,
    artwork: StateArtwork.cart,
    compact: true,
    title: 'No materials yet',
    message:
        'Tap Add Item to choose a catalog material or name your own, or import a CSV.',
  );
}
