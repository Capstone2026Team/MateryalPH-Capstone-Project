// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_fulfillment.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ProjectFulfillmentStatusEnum _$projectFulfillmentStatusEnum_COMPLETE =
    const ProjectFulfillmentStatusEnum._('COMPLETE');
const ProjectFulfillmentStatusEnum _$projectFulfillmentStatusEnum_PARTIAL =
    const ProjectFulfillmentStatusEnum._('PARTIAL');
const ProjectFulfillmentStatusEnum _$projectFulfillmentStatusEnum_NONE =
    const ProjectFulfillmentStatusEnum._('NONE');

ProjectFulfillmentStatusEnum _$projectFulfillmentStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'COMPLETE':
      return _$projectFulfillmentStatusEnum_COMPLETE;
    case 'PARTIAL':
      return _$projectFulfillmentStatusEnum_PARTIAL;
    case 'NONE':
      return _$projectFulfillmentStatusEnum_NONE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ProjectFulfillmentStatusEnum>
    _$projectFulfillmentStatusEnumValues =
    BuiltSet<ProjectFulfillmentStatusEnum>(const <ProjectFulfillmentStatusEnum>[
  _$projectFulfillmentStatusEnum_COMPLETE,
  _$projectFulfillmentStatusEnum_PARTIAL,
  _$projectFulfillmentStatusEnum_NONE,
]);

Serializer<ProjectFulfillmentStatusEnum>
    _$projectFulfillmentStatusEnumSerializer =
    _$ProjectFulfillmentStatusEnumSerializer();

class _$ProjectFulfillmentStatusEnumSerializer
    implements PrimitiveSerializer<ProjectFulfillmentStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'COMPLETE': 'COMPLETE',
    'PARTIAL': 'PARTIAL',
    'NONE': 'NONE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'COMPLETE': 'COMPLETE',
    'PARTIAL': 'PARTIAL',
    'NONE': 'NONE',
  };

  @override
  final Iterable<Type> types = const <Type>[ProjectFulfillmentStatusEnum];
  @override
  final String wireName = 'ProjectFulfillmentStatusEnum';

  @override
  Object serialize(Serializers serializers, ProjectFulfillmentStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ProjectFulfillmentStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ProjectFulfillmentStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ProjectFulfillment extends ProjectFulfillment {
  @override
  final ProjectFulfillmentStatusEnum status;
  @override
  final int linesTotal;
  @override
  final int linesFulfilled;
  @override
  final int linesPartial;
  @override
  final int linesUnfulfilled;
  @override
  final int vendorLinesFulfilled;
  @override
  final BuiltList<ProjectFulfillmentLine> lines;
  @override
  final BuiltList<ProjectSeparatePurchase> separateItems;
  @override
  final int separateTotalCentavos;
  @override
  final int combinedTotalCentavos;

  factory _$ProjectFulfillment(
          [void Function(ProjectFulfillmentBuilder)? updates]) =>
      (ProjectFulfillmentBuilder()..update(updates))._build();

  _$ProjectFulfillment._(
      {required this.status,
      required this.linesTotal,
      required this.linesFulfilled,
      required this.linesPartial,
      required this.linesUnfulfilled,
      required this.vendorLinesFulfilled,
      required this.lines,
      required this.separateItems,
      required this.separateTotalCentavos,
      required this.combinedTotalCentavos})
      : super._();
  @override
  ProjectFulfillment rebuild(
          void Function(ProjectFulfillmentBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProjectFulfillmentBuilder toBuilder() =>
      ProjectFulfillmentBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProjectFulfillment &&
        status == other.status &&
        linesTotal == other.linesTotal &&
        linesFulfilled == other.linesFulfilled &&
        linesPartial == other.linesPartial &&
        linesUnfulfilled == other.linesUnfulfilled &&
        vendorLinesFulfilled == other.vendorLinesFulfilled &&
        lines == other.lines &&
        separateItems == other.separateItems &&
        separateTotalCentavos == other.separateTotalCentavos &&
        combinedTotalCentavos == other.combinedTotalCentavos;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, linesTotal.hashCode);
    _$hash = $jc(_$hash, linesFulfilled.hashCode);
    _$hash = $jc(_$hash, linesPartial.hashCode);
    _$hash = $jc(_$hash, linesUnfulfilled.hashCode);
    _$hash = $jc(_$hash, vendorLinesFulfilled.hashCode);
    _$hash = $jc(_$hash, lines.hashCode);
    _$hash = $jc(_$hash, separateItems.hashCode);
    _$hash = $jc(_$hash, separateTotalCentavos.hashCode);
    _$hash = $jc(_$hash, combinedTotalCentavos.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProjectFulfillment')
          ..add('status', status)
          ..add('linesTotal', linesTotal)
          ..add('linesFulfilled', linesFulfilled)
          ..add('linesPartial', linesPartial)
          ..add('linesUnfulfilled', linesUnfulfilled)
          ..add('vendorLinesFulfilled', vendorLinesFulfilled)
          ..add('lines', lines)
          ..add('separateItems', separateItems)
          ..add('separateTotalCentavos', separateTotalCentavos)
          ..add('combinedTotalCentavos', combinedTotalCentavos))
        .toString();
  }
}

class ProjectFulfillmentBuilder
    implements Builder<ProjectFulfillment, ProjectFulfillmentBuilder> {
  _$ProjectFulfillment? _$v;

  ProjectFulfillmentStatusEnum? _status;
  ProjectFulfillmentStatusEnum? get status => _$this._status;
  set status(ProjectFulfillmentStatusEnum? status) => _$this._status = status;

  int? _linesTotal;
  int? get linesTotal => _$this._linesTotal;
  set linesTotal(int? linesTotal) => _$this._linesTotal = linesTotal;

  int? _linesFulfilled;
  int? get linesFulfilled => _$this._linesFulfilled;
  set linesFulfilled(int? linesFulfilled) =>
      _$this._linesFulfilled = linesFulfilled;

  int? _linesPartial;
  int? get linesPartial => _$this._linesPartial;
  set linesPartial(int? linesPartial) => _$this._linesPartial = linesPartial;

  int? _linesUnfulfilled;
  int? get linesUnfulfilled => _$this._linesUnfulfilled;
  set linesUnfulfilled(int? linesUnfulfilled) =>
      _$this._linesUnfulfilled = linesUnfulfilled;

  int? _vendorLinesFulfilled;
  int? get vendorLinesFulfilled => _$this._vendorLinesFulfilled;
  set vendorLinesFulfilled(int? vendorLinesFulfilled) =>
      _$this._vendorLinesFulfilled = vendorLinesFulfilled;

  ListBuilder<ProjectFulfillmentLine>? _lines;
  ListBuilder<ProjectFulfillmentLine> get lines =>
      _$this._lines ??= ListBuilder<ProjectFulfillmentLine>();
  set lines(ListBuilder<ProjectFulfillmentLine>? lines) =>
      _$this._lines = lines;

  ListBuilder<ProjectSeparatePurchase>? _separateItems;
  ListBuilder<ProjectSeparatePurchase> get separateItems =>
      _$this._separateItems ??= ListBuilder<ProjectSeparatePurchase>();
  set separateItems(ListBuilder<ProjectSeparatePurchase>? separateItems) =>
      _$this._separateItems = separateItems;

  int? _separateTotalCentavos;
  int? get separateTotalCentavos => _$this._separateTotalCentavos;
  set separateTotalCentavos(int? separateTotalCentavos) =>
      _$this._separateTotalCentavos = separateTotalCentavos;

  int? _combinedTotalCentavos;
  int? get combinedTotalCentavos => _$this._combinedTotalCentavos;
  set combinedTotalCentavos(int? combinedTotalCentavos) =>
      _$this._combinedTotalCentavos = combinedTotalCentavos;

  ProjectFulfillmentBuilder() {
    ProjectFulfillment._defaults(this);
  }

  ProjectFulfillmentBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _linesTotal = $v.linesTotal;
      _linesFulfilled = $v.linesFulfilled;
      _linesPartial = $v.linesPartial;
      _linesUnfulfilled = $v.linesUnfulfilled;
      _vendorLinesFulfilled = $v.vendorLinesFulfilled;
      _lines = $v.lines.toBuilder();
      _separateItems = $v.separateItems.toBuilder();
      _separateTotalCentavos = $v.separateTotalCentavos;
      _combinedTotalCentavos = $v.combinedTotalCentavos;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProjectFulfillment other) {
    _$v = other as _$ProjectFulfillment;
  }

  @override
  void update(void Function(ProjectFulfillmentBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProjectFulfillment build() => _build();

  _$ProjectFulfillment _build() {
    _$ProjectFulfillment _$result;
    try {
      _$result = _$v ??
          _$ProjectFulfillment._(
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'ProjectFulfillment', 'status'),
            linesTotal: BuiltValueNullFieldError.checkNotNull(
                linesTotal, r'ProjectFulfillment', 'linesTotal'),
            linesFulfilled: BuiltValueNullFieldError.checkNotNull(
                linesFulfilled, r'ProjectFulfillment', 'linesFulfilled'),
            linesPartial: BuiltValueNullFieldError.checkNotNull(
                linesPartial, r'ProjectFulfillment', 'linesPartial'),
            linesUnfulfilled: BuiltValueNullFieldError.checkNotNull(
                linesUnfulfilled, r'ProjectFulfillment', 'linesUnfulfilled'),
            vendorLinesFulfilled: BuiltValueNullFieldError.checkNotNull(
                vendorLinesFulfilled,
                r'ProjectFulfillment',
                'vendorLinesFulfilled'),
            lines: lines.build(),
            separateItems: separateItems.build(),
            separateTotalCentavos: BuiltValueNullFieldError.checkNotNull(
                separateTotalCentavos,
                r'ProjectFulfillment',
                'separateTotalCentavos'),
            combinedTotalCentavos: BuiltValueNullFieldError.checkNotNull(
                combinedTotalCentavos,
                r'ProjectFulfillment',
                'combinedTotalCentavos'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'lines';
        lines.build();
        _$failedField = 'separateItems';
        separateItems.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ProjectFulfillment', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
