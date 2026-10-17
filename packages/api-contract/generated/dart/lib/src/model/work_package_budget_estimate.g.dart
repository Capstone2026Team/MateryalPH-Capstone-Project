// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_package_budget_estimate.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const WorkPackageBudgetEstimateBasisEnum
    _$workPackageBudgetEstimateBasisEnum_AVERAGE_OF_VENDOR_LOWEST_ELIGIBLE_PRICE =
    const WorkPackageBudgetEstimateBasisEnum._(
        'AVERAGE_OF_VENDOR_LOWEST_ELIGIBLE_PRICE');

WorkPackageBudgetEstimateBasisEnum _$workPackageBudgetEstimateBasisEnumValueOf(
    String name) {
  switch (name) {
    case 'AVERAGE_OF_VENDOR_LOWEST_ELIGIBLE_PRICE':
      return _$workPackageBudgetEstimateBasisEnum_AVERAGE_OF_VENDOR_LOWEST_ELIGIBLE_PRICE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<WorkPackageBudgetEstimateBasisEnum>
    _$workPackageBudgetEstimateBasisEnumValues = BuiltSet<
        WorkPackageBudgetEstimateBasisEnum>(const <WorkPackageBudgetEstimateBasisEnum>[
  _$workPackageBudgetEstimateBasisEnum_AVERAGE_OF_VENDOR_LOWEST_ELIGIBLE_PRICE,
]);

Serializer<WorkPackageBudgetEstimateBasisEnum>
    _$workPackageBudgetEstimateBasisEnumSerializer =
    _$WorkPackageBudgetEstimateBasisEnumSerializer();

class _$WorkPackageBudgetEstimateBasisEnumSerializer
    implements PrimitiveSerializer<WorkPackageBudgetEstimateBasisEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'AVERAGE_OF_VENDOR_LOWEST_ELIGIBLE_PRICE':
        'AVERAGE_OF_VENDOR_LOWEST_ELIGIBLE_PRICE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'AVERAGE_OF_VENDOR_LOWEST_ELIGIBLE_PRICE':
        'AVERAGE_OF_VENDOR_LOWEST_ELIGIBLE_PRICE',
  };

  @override
  final Iterable<Type> types = const <Type>[WorkPackageBudgetEstimateBasisEnum];
  @override
  final String wireName = 'WorkPackageBudgetEstimateBasisEnum';

  @override
  Object serialize(
          Serializers serializers, WorkPackageBudgetEstimateBasisEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  WorkPackageBudgetEstimateBasisEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      WorkPackageBudgetEstimateBasisEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$WorkPackageBudgetEstimate extends WorkPackageBudgetEstimate {
  @override
  final BuiltList<WorkPackageBudgetEstimateLine> lines;
  @override
  final int materialsTotalCentavos;
  @override
  final int pricedLineCount;
  @override
  final int unpricedLineCount;
  @override
  final int radiusKm;
  @override
  final WorkPackageBudgetEstimateBasisEnum basis;
  @override
  final BuiltList<String> excludes;
  @override
  final String computedAt;

  factory _$WorkPackageBudgetEstimate(
          [void Function(WorkPackageBudgetEstimateBuilder)? updates]) =>
      (WorkPackageBudgetEstimateBuilder()..update(updates))._build();

  _$WorkPackageBudgetEstimate._(
      {required this.lines,
      required this.materialsTotalCentavos,
      required this.pricedLineCount,
      required this.unpricedLineCount,
      required this.radiusKm,
      required this.basis,
      required this.excludes,
      required this.computedAt})
      : super._();
  @override
  WorkPackageBudgetEstimate rebuild(
          void Function(WorkPackageBudgetEstimateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  WorkPackageBudgetEstimateBuilder toBuilder() =>
      WorkPackageBudgetEstimateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is WorkPackageBudgetEstimate &&
        lines == other.lines &&
        materialsTotalCentavos == other.materialsTotalCentavos &&
        pricedLineCount == other.pricedLineCount &&
        unpricedLineCount == other.unpricedLineCount &&
        radiusKm == other.radiusKm &&
        basis == other.basis &&
        excludes == other.excludes &&
        computedAt == other.computedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, lines.hashCode);
    _$hash = $jc(_$hash, materialsTotalCentavos.hashCode);
    _$hash = $jc(_$hash, pricedLineCount.hashCode);
    _$hash = $jc(_$hash, unpricedLineCount.hashCode);
    _$hash = $jc(_$hash, radiusKm.hashCode);
    _$hash = $jc(_$hash, basis.hashCode);
    _$hash = $jc(_$hash, excludes.hashCode);
    _$hash = $jc(_$hash, computedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'WorkPackageBudgetEstimate')
          ..add('lines', lines)
          ..add('materialsTotalCentavos', materialsTotalCentavos)
          ..add('pricedLineCount', pricedLineCount)
          ..add('unpricedLineCount', unpricedLineCount)
          ..add('radiusKm', radiusKm)
          ..add('basis', basis)
          ..add('excludes', excludes)
          ..add('computedAt', computedAt))
        .toString();
  }
}

class WorkPackageBudgetEstimateBuilder
    implements
        Builder<WorkPackageBudgetEstimate, WorkPackageBudgetEstimateBuilder> {
  _$WorkPackageBudgetEstimate? _$v;

  ListBuilder<WorkPackageBudgetEstimateLine>? _lines;
  ListBuilder<WorkPackageBudgetEstimateLine> get lines =>
      _$this._lines ??= ListBuilder<WorkPackageBudgetEstimateLine>();
  set lines(ListBuilder<WorkPackageBudgetEstimateLine>? lines) =>
      _$this._lines = lines;

  int? _materialsTotalCentavos;
  int? get materialsTotalCentavos => _$this._materialsTotalCentavos;
  set materialsTotalCentavos(int? materialsTotalCentavos) =>
      _$this._materialsTotalCentavos = materialsTotalCentavos;

  int? _pricedLineCount;
  int? get pricedLineCount => _$this._pricedLineCount;
  set pricedLineCount(int? pricedLineCount) =>
      _$this._pricedLineCount = pricedLineCount;

  int? _unpricedLineCount;
  int? get unpricedLineCount => _$this._unpricedLineCount;
  set unpricedLineCount(int? unpricedLineCount) =>
      _$this._unpricedLineCount = unpricedLineCount;

  int? _radiusKm;
  int? get radiusKm => _$this._radiusKm;
  set radiusKm(int? radiusKm) => _$this._radiusKm = radiusKm;

  WorkPackageBudgetEstimateBasisEnum? _basis;
  WorkPackageBudgetEstimateBasisEnum? get basis => _$this._basis;
  set basis(WorkPackageBudgetEstimateBasisEnum? basis) => _$this._basis = basis;

  ListBuilder<String>? _excludes;
  ListBuilder<String> get excludes =>
      _$this._excludes ??= ListBuilder<String>();
  set excludes(ListBuilder<String>? excludes) => _$this._excludes = excludes;

  String? _computedAt;
  String? get computedAt => _$this._computedAt;
  set computedAt(String? computedAt) => _$this._computedAt = computedAt;

  WorkPackageBudgetEstimateBuilder() {
    WorkPackageBudgetEstimate._defaults(this);
  }

  WorkPackageBudgetEstimateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _lines = $v.lines.toBuilder();
      _materialsTotalCentavos = $v.materialsTotalCentavos;
      _pricedLineCount = $v.pricedLineCount;
      _unpricedLineCount = $v.unpricedLineCount;
      _radiusKm = $v.radiusKm;
      _basis = $v.basis;
      _excludes = $v.excludes.toBuilder();
      _computedAt = $v.computedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(WorkPackageBudgetEstimate other) {
    _$v = other as _$WorkPackageBudgetEstimate;
  }

  @override
  void update(void Function(WorkPackageBudgetEstimateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  WorkPackageBudgetEstimate build() => _build();

  _$WorkPackageBudgetEstimate _build() {
    _$WorkPackageBudgetEstimate _$result;
    try {
      _$result = _$v ??
          _$WorkPackageBudgetEstimate._(
            lines: lines.build(),
            materialsTotalCentavos: BuiltValueNullFieldError.checkNotNull(
                materialsTotalCentavos,
                r'WorkPackageBudgetEstimate',
                'materialsTotalCentavos'),
            pricedLineCount: BuiltValueNullFieldError.checkNotNull(
                pricedLineCount,
                r'WorkPackageBudgetEstimate',
                'pricedLineCount'),
            unpricedLineCount: BuiltValueNullFieldError.checkNotNull(
                unpricedLineCount,
                r'WorkPackageBudgetEstimate',
                'unpricedLineCount'),
            radiusKm: BuiltValueNullFieldError.checkNotNull(
                radiusKm, r'WorkPackageBudgetEstimate', 'radiusKm'),
            basis: BuiltValueNullFieldError.checkNotNull(
                basis, r'WorkPackageBudgetEstimate', 'basis'),
            excludes: excludes.build(),
            computedAt: BuiltValueNullFieldError.checkNotNull(
                computedAt, r'WorkPackageBudgetEstimate', 'computedAt'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'lines';
        lines.build();

        _$failedField = 'excludes';
        excludes.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'WorkPackageBudgetEstimate', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
