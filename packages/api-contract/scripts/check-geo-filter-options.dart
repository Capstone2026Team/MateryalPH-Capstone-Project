import 'package:materyalph_api_client/materyalph_api_client.dart';

void main() {
  final input = <String, Object?>{
    'data': [
      {'id': '019c6e27-e55b-73d1-87d8-4e01f1f75043', 'name': 'Cement'},
    ],
    'meta': {'current_page': 2, 'last_page': 3, 'total': 201},
    'errors': <Object>[],
  };
  final envelope = standardSerializers.deserializeWith(
      GeoFilterOptionsEnvelope.serializer, input)!;
  if (envelope.data.single.name != 'Cement' ||
      envelope.meta.currentPage != 2 ||
      envelope.meta.lastPage != 3 ||
      envelope.meta.total != 201) {
    throw StateError('Taxonomy options and pagination must deserialize.');
  }
  final output = standardSerializers.serializeWith(
      GeoFilterOptionsEnvelope.serializer, envelope) as Map<String, Object?>;
  final meta = output['meta'] as Map<String, Object?>;
  if (meta['current_page'] != 2 || meta['last_page'] != 3) {
    throw StateError('Taxonomy pagination must retain its API field names.');
  }
  final demand = standardSerializers.deserializeWith(GeoDemand.serializer, {
    'scope': {
      'code': null, 'name': 'Philippines', 'level': null,
      'level_label': 'Country', 'label': 'Philippines', 'breadcrumbs': <Object>[],
      'children_label': 'Regions', 'drillable': true, 'psgc_version': null,
    },
    'dataset': {
      'environment': 'TEST', 'label': 'Recorded Marketplace Activity',
      'demo': false, 'last_aggregated_at': null, 'through_date': null,
      'revision': null, 'available': false,
    },
    'measure': 'ORDER_COUNT', 'dimension': 'CATEGORY',
    'columns': <Object>[], 'rows': <Object>[],
    'column_pagination': input['meta'],
    'not_comparable_lines': 0, 'definition': 'Confirmed demand by area.',
  })!;
  if (demand.columnPagination.currentPage != 2 ||
      demand.columnPagination.lastPage != 3) {
    throw StateError('Demand column pagination must deserialize.');
  }
  print('Dart geographic filter options contract passed.');
}
