// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geo_demand.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const GeoDemandMeasureEnum _$geoDemandMeasureEnum_ORDER_COUNT =
    const GeoDemandMeasureEnum._('ORDER_COUNT');
const GeoDemandMeasureEnum _$geoDemandMeasureEnum_QUANTITY =
    const GeoDemandMeasureEnum._('QUANTITY');
const GeoDemandMeasureEnum _$geoDemandMeasureEnum_VALUE =
    const GeoDemandMeasureEnum._('VALUE');

GeoDemandMeasureEnum _$geoDemandMeasureEnumValueOf(String name) {
  switch (name) {
    case 'ORDER_COUNT':
      return _$geoDemandMeasureEnum_ORDER_COUNT;
    case 'QUANTITY':
      return _$geoDemandMeasureEnum_QUANTITY;
    case 'VALUE':
      return _$geoDemandMeasureEnum_VALUE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<GeoDemandMeasureEnum> _$geoDemandMeasureEnumValues =
    BuiltSet<GeoDemandMeasureEnum>(const <GeoDemandMeasureEnum>[
  _$geoDemandMeasureEnum_ORDER_COUNT,
  _$geoDemandMeasureEnum_QUANTITY,
  _$geoDemandMeasureEnum_VALUE,
]);

const GeoDemandDimensionEnum _$geoDemandDimensionEnum_CATEGORY =
    const GeoDemandDimensionEnum._('CATEGORY');
const GeoDemandDimensionEnum _$geoDemandDimensionEnum_MATERIAL =
    const GeoDemandDimensionEnum._('MATERIAL');

GeoDemandDimensionEnum _$geoDemandDimensionEnumValueOf(String name) {
  switch (name) {
    case 'CATEGORY':
      return _$geoDemandDimensionEnum_CATEGORY;
    case 'MATERIAL':
      return _$geoDemandDimensionEnum_MATERIAL;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<GeoDemandDimensionEnum> _$geoDemandDimensionEnumValues =
    BuiltSet<GeoDemandDimensionEnum>(const <GeoDemandDimensionEnum>[
  _$geoDemandDimensionEnum_CATEGORY,
  _$geoDemandDimensionEnum_MATERIAL,
]);

Serializer<GeoDemandMeasureEnum> _$geoDemandMeasureEnumSerializer =
    _$GeoDemandMeasureEnumSerializer();
Serializer<GeoDemandDimensionEnum> _$geoDemandDimensionEnumSerializer =
    _$GeoDemandDimensionEnumSerializer();

class _$GeoDemandMeasureEnumSerializer
    implements PrimitiveSerializer<GeoDemandMeasureEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ORDER_COUNT': 'ORDER_COUNT',
    'QUANTITY': 'QUANTITY',
    'VALUE': 'VALUE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ORDER_COUNT': 'ORDER_COUNT',
    'QUANTITY': 'QUANTITY',
    'VALUE': 'VALUE',
  };

  @override
  final Iterable<Type> types = const <Type>[GeoDemandMeasureEnum];
  @override
  final String wireName = 'GeoDemandMeasureEnum';

  @override
  Object serialize(Serializers serializers, GeoDemandMeasureEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  GeoDemandMeasureEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      GeoDemandMeasureEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$GeoDemandDimensionEnumSerializer
    implements PrimitiveSerializer<GeoDemandDimensionEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'CATEGORY': 'CATEGORY',
    'MATERIAL': 'MATERIAL',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'CATEGORY': 'CATEGORY',
    'MATERIAL': 'MATERIAL',
  };

  @override
  final Iterable<Type> types = const <Type>[GeoDemandDimensionEnum];
  @override
  final String wireName = 'GeoDemandDimensionEnum';

  @override
  Object serialize(Serializers serializers, GeoDemandDimensionEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  GeoDemandDimensionEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      GeoDemandDimensionEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$GeoDemand extends GeoDemand {
  @override
  final GeoScope scope;
  @override
  final GeoDataset dataset;
  @override
  final GeoDemandMeasureEnum measure;
  @override
  final String? unit;
  @override
  final GeoDemandDimensionEnum dimension;
  @override
  final BuiltList<GeoDemandColumnsInner> columns;
  @override
  final BuiltList<GeoDemandRowsInner> rows;
  @override
  final int notComparableLines;
  @override
  final String definition;

  factory _$GeoDemand([void Function(GeoDemandBuilder)? updates]) =>
      (GeoDemandBuilder()..update(updates))._build();

  _$GeoDemand._(
      {required this.scope,
      required this.dataset,
      required this.measure,
      this.unit,
      required this.dimension,
      required this.columns,
      required this.rows,
      required this.notComparableLines,
      required this.definition})
      : super._();
  @override
  GeoDemand rebuild(void Function(GeoDemandBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GeoDemandBuilder toBuilder() => GeoDemandBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GeoDemand &&
        scope == other.scope &&
        dataset == other.dataset &&
        measure == other.measure &&
        unit == other.unit &&
        dimension == other.dimension &&
        columns == other.columns &&
        rows == other.rows &&
        notComparableLines == other.notComparableLines &&
        definition == other.definition;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, scope.hashCode);
    _$hash = $jc(_$hash, dataset.hashCode);
    _$hash = $jc(_$hash, measure.hashCode);
    _$hash = $jc(_$hash, unit.hashCode);
    _$hash = $jc(_$hash, dimension.hashCode);
    _$hash = $jc(_$hash, columns.hashCode);
    _$hash = $jc(_$hash, rows.hashCode);
    _$hash = $jc(_$hash, notComparableLines.hashCode);
    _$hash = $jc(_$hash, definition.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GeoDemand')
          ..add('scope', scope)
          ..add('dataset', dataset)
          ..add('measure', measure)
          ..add('unit', unit)
          ..add('dimension', dimension)
          ..add('columns', columns)
          ..add('rows', rows)
          ..add('notComparableLines', notComparableLines)
          ..add('definition', definition))
        .toString();
  }
}

class GeoDemandBuilder implements Builder<GeoDemand, GeoDemandBuilder> {
  _$GeoDemand? _$v;

  GeoScopeBuilder? _scope;
  GeoScopeBuilder get scope => _$this._scope ??= GeoScopeBuilder();
  set scope(GeoScopeBuilder? scope) => _$this._scope = scope;

  GeoDatasetBuilder? _dataset;
  GeoDatasetBuilder get dataset => _$this._dataset ??= GeoDatasetBuilder();
  set dataset(GeoDatasetBuilder? dataset) => _$this._dataset = dataset;

  GeoDemandMeasureEnum? _measure;
  GeoDemandMeasureEnum? get measure => _$this._measure;
  set measure(GeoDemandMeasureEnum? measure) => _$this._measure = measure;

  String? _unit;
  String? get unit => _$this._unit;
  set unit(String? unit) => _$this._unit = unit;

  GeoDemandDimensionEnum? _dimension;
  GeoDemandDimensionEnum? get dimension => _$this._dimension;
  set dimension(GeoDemandDimensionEnum? dimension) =>
      _$this._dimension = dimension;

  ListBuilder<GeoDemandColumnsInner>? _columns;
  ListBuilder<GeoDemandColumnsInner> get columns =>
      _$this._columns ??= ListBuilder<GeoDemandColumnsInner>();
  set columns(ListBuilder<GeoDemandColumnsInner>? columns) =>
      _$this._columns = columns;

  ListBuilder<GeoDemandRowsInner>? _rows;
  ListBuilder<GeoDemandRowsInner> get rows =>
      _$this._rows ??= ListBuilder<GeoDemandRowsInner>();
  set rows(ListBuilder<GeoDemandRowsInner>? rows) => _$this._rows = rows;

  int? _notComparableLines;
  int? get notComparableLines => _$this._notComparableLines;
  set notComparableLines(int? notComparableLines) =>
      _$this._notComparableLines = notComparableLines;

  String? _definition;
  String? get definition => _$this._definition;
  set definition(String? definition) => _$this._definition = definition;

  GeoDemandBuilder() {
    GeoDemand._defaults(this);
  }

  GeoDemandBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _scope = $v.scope.toBuilder();
      _dataset = $v.dataset.toBuilder();
      _measure = $v.measure;
      _unit = $v.unit;
      _dimension = $v.dimension;
      _columns = $v.columns.toBuilder();
      _rows = $v.rows.toBuilder();
      _notComparableLines = $v.notComparableLines;
      _definition = $v.definition;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GeoDemand other) {
    _$v = other as _$GeoDemand;
  }

  @override
  void update(void Function(GeoDemandBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GeoDemand build() => _build();

  _$GeoDemand _build() {
    _$GeoDemand _$result;
    try {
      _$result = _$v ??
          _$GeoDemand._(
            scope: scope.build(),
            dataset: dataset.build(),
            measure: BuiltValueNullFieldError.checkNotNull(
                measure, r'GeoDemand', 'measure'),
            unit: unit,
            dimension: BuiltValueNullFieldError.checkNotNull(
                dimension, r'GeoDemand', 'dimension'),
            columns: columns.build(),
            rows: rows.build(),
            notComparableLines: BuiltValueNullFieldError.checkNotNull(
                notComparableLines, r'GeoDemand', 'notComparableLines'),
            definition: BuiltValueNullFieldError.checkNotNull(
                definition, r'GeoDemand', 'definition'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'scope';
        scope.build();
        _$failedField = 'dataset';
        dataset.build();

        _$failedField = 'columns';
        columns.build();
        _$failedField = 'rows';
        rows.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'GeoDemand', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
