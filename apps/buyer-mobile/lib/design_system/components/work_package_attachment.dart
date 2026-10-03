import 'package:flutter/material.dart';
import '../../features/projects/projects_repository.dart';

/// One responsive attachment for Project chat, comparison and order review.
class WorkPackageAttachment extends StatelessWidget {
  const WorkPackageAttachment({
    super.key,
    required this.original,
    this.proposed,
    this.version,
    this.locked = true,
  });
  final ProjectData original;
  final ProjectData? proposed;
  final Object? version;
  final bool locked;
  Widget _copy(BuildContext context, String title, ProjectData value) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          if (value['name'] != null) Text(projectText(value['name'])),
          if (value['budget_centavos'] != null)
            Text('Budget ${projectMoney(value['budget_centavos'])}'),
          Text(
            '${projectText(value['fulfillment_method'])} · ${projectText(value['payment_method'])}',
          ),
          ...projectRows(value['lines']).map(
            (line) => Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    projectText(
                      line['name'] ?? line['description'] ?? line['variant_id'],
                    ),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '${projectText(line['quantity'])} ${projectText(line['unit_code'])}',
                  ),
                  if (line['preferred_brand'] != null)
                    Text('Preferred brand: ${line['preferred_brand']}'),
                  ...projectObject(line['specifications']).entries.map(
                    (entry) => Text('${entry.key}: ${entry.value}'),
                  ),
                  if (line['unit_price_centavos'] != null)
                    Text(
                      'Unit price ${projectMoney(line['unit_price_centavos'])}',
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final left = _copy(
        context,
        '${locked ? 'Locked Buyer original' : 'Editable Buyer draft'}${version == null ? '' : ' · version $version'}',
        original,
      );
      if (proposed == null) return left;
      final right = _copy(context, 'Vendor proposal', proposed!);
      return constraints.maxWidth >= 1024
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: left),
                Expanded(child: right),
              ],
            )
          : Column(children: [left, right]);
    },
  );
}
