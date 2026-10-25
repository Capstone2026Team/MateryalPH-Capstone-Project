import 'package:materyalph_api_client/materyalph_api_client.dart' as api;

import 'projects_repository.dart';

/// Shared presentation of a typed candidate/draft or a contract-declared arrangement JSON member.
final class ProjectSupplierView {
  const ProjectSupplierView({
    required this.method,
    required this.methods,
    required this.storeName,
    required this.deliveryCentavos,
    required this.delivery,
    this.items = const [],
  });
  factory ProjectSupplierView.candidate(api.ProjectCandidate c) =>
      ProjectSupplierView(
        method: c.fulfillmentMethod,
        methods: c.fulfillmentOptions?.map((m) => m.name).toList() ?? [],
        storeName: c.storeName,
        deliveryCentavos: c.deliveryCentavos,
        delivery: projectObject(c.delivery),
      );
  factory ProjectSupplierView.draft(api.ProjectDraftVendorGroup g) =>
      ProjectSupplierView(
        method: g.fulfillmentMethod.name,
        methods: g.fulfillmentOptions?.map((m) => m.name).toList() ?? [],
        storeName: g.storeName,
        deliveryCentavos: g.deliveryCentavos,
        delivery: projectObject(g.delivery),
        items: g.items.map(ProjectSupplierItem.purchase).toList(),
      );
  factory ProjectSupplierView.arrangement(ProjectData v) => ProjectSupplierView(
    method: projectText(v['fulfillment_method']),
    methods: (v['fulfillment_options'] as List? ?? [])
        .map(projectText)
        .toList(),
    storeName: projectText(v['store_name']),
    deliveryCentavos: v['delivery_centavos'] as int?,
    delivery: projectObject(v['delivery']),
    items: projectRows(v['items']).map(ProjectSupplierItem.json).toList(),
  );
  final String method, storeName;
  final List<String> methods;
  final int? deliveryCentavos;
  final ProjectData delivery;
  final List<ProjectSupplierItem> items;
  bool get requiresMixer =>
      method == 'DELIVERY' &&
      methods.length == 1 &&
      methods.single == 'DELIVERY' &&
      items.any((item) => item.readyMixed);
}

final class ProjectSupplierItem {
  const ProjectSupplierItem({
    required this.name,
    required this.variant,
    required this.quantity,
    required this.unit,
    required this.readyMixed,
    this.imageUrl,
  });
  factory ProjectSupplierItem.purchase(api.ProjectSeparatePurchase p) =>
      ProjectSupplierItem(
        name: p.displayName,
        variant: p.variantLabel ?? '',
        quantity: p.quantity,
        unit: p.unitCode,
        imageUrl: p.image?.url,
        readyMixed:
            projectObject(p.load)['material_kind'] == 'READY_MIXED_CONCRETE',
      );
  factory ProjectSupplierItem.json(ProjectData p) => ProjectSupplierItem(
    name: projectText(p['display_name']),
    variant: projectText(p['variant_label']),
    quantity: projectText(p['quantity']),
    unit: projectText(p['unit_code']),
    imageUrl: projectObject(p['image'])['url'] as String?,
    readyMixed:
        projectObject(p['load'])['material_kind'] == 'READY_MIXED_CONCRETE',
  );
  final String name, variant, quantity, unit;
  final String? imageUrl;
  final bool readyMixed;
}
