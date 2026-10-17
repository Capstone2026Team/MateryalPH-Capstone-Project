// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_package_budget_estimate_line.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const WorkPackageBudgetEstimateLineStatusEnum
    _$workPackageBudgetEstimateLineStatusEnum_PRICED =
    const WorkPackageBudgetEstimateLineStatusEnum._('PRICED');
const WorkPackageBudgetEstimateLineStatusEnum
    _$workPackageBudgetEstimateLineStatusEnum_NO_PRICE_DATA =
    const WorkPackageBudgetEstimateLineStatusEnum._('NO_PRICE_DATA');
const WorkPackageBudgetEstimateLineStatusEnum
    _$workPackageBudgetEstimateLineStatusEnum_UNLISTED =
    const WorkPackageBudgetEstimateLineStatusEnum._('UNLISTED');

WorkPackageBudgetEstimateLineStatusEnum
    _$workPackageBudgetEstimateLineStatusEnumValueOf(String name) {
  switch (name) {
    case 'PRICED':
      return _$workPackageBudgetEstimateLineStatusEnum_PRICED;
    case 'NO_PRICE_DATA':
      return _$workPackageBudgetEstimateLineStatusEnum_NO_PRICE_DATA;
    case 'UNLISTED':
      return _$workPackageBudgetEstimateLineStatusEnum_UNLISTED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<WorkPackageBudgetEstimateLineStatusEnum>
    _$workPackageBudgetEstimateLineStatusEnumValues = BuiltSet<
        WorkPackageBudgetEstimateLineStatusEnum>(const <WorkPackageBudgetEstimateLineStatusEnum>[
  _$workPackageBudgetEstimateLineStatusEnum_PRICED,
  _$workPackageBudgetEstimateLineStatusEnum_NO_PRICE_DATA,
  _$workPackageBudgetEstimateLineStatusEnum_UNLISTED,
]);

Serializer<WorkPackageBudgetEstimateLineStatusEnum>
    _$workPackageBudgetEstimateLineStatusEnumSerializer =
    _$WorkPackageBudgetEstimateLineStatusEnumSerializer();

class _$WorkPackageBudgetEstimateLineStatusEnumSerializer
    implements PrimitiveSerializer<WorkPackageBudgetEstimateLineStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PRICED': 'PRICED',
    'NO_PRICE_DATA': 'NO_PRICE_DATA',
    'UNLISTED': 'UNLISTED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PRICED': 'PRICED',
    'NO_PRICE_DATA': 'NO_PRICE_DATA',
    'UNLISTED': 'UNLISTED',
  };

  @override
  final Iterable<Type> types = const <Type>[
    WorkPackageBudgetEstimateLineStatusEnum
  ];
  @override
  final String wireName = 'WorkPackageBudgetEstimateLineStatusEnum';

  @override
  Object serialize(Serializers serializers,
          WorkPackageBudgetEstimateLineStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  WorkPackageBudgetEstimateLineStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      WorkPackageBudgetEstimateLineStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$WorkPackageBudgetEstimateLine extends WorkPackageBudgetEstimateLine {
  @override
  final int index;
  @override
  final WorkPackageBudgetEstimateLineStatusEnum status;
  @override
  final int? averageUnitPriceCentavos;
  @override
  final int? amountCentavos;
  @override
  final int vendorCount;

  factory _$WorkPackageBudgetEstimateLine(
          [void Function(WorkPackageBudgetEstimateLineBuilder)? updates]) =>
      (WorkPackageBudgetEstimateLineBuilder()..update(updates))._build();

  _$WorkPackageBudgetEstimateLine._(
      {required this.index,
      required this.status,
      this.averageUnitPriceCentavos,
      this.amountCentavos,
      required this.vendorCount})
      : super._();
  @override
  WorkPackageBudgetEstimateLine rebuild(
          void Function(WorkPackageBudgetEstimateLineBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  WorkPackageBudgetEstimateLineBuilder toBuilder() =>
      WorkPackageBudgetEstimateLineBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is WorkPackageBudgetEstimateLine &&
        index == other.index &&
        status == other.status &&
        averageUnitPriceCentavos == other.averageUnitPriceCentavos &&
        amountCentavos == other.amountCentavos &&
        vendorCount == other.vendorCount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, index.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, averageUnitPriceCentavos.hashCode);
    _$hash = $jc(_$hash, amountCentavos.hashCode);
    _$hash = $jc(_$hash, vendorCount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'WorkPackageBudgetEstimateLine')
          ..add('index', index)
          ..add('status', status)
          ..add('averageUnitPriceCentavos', averageUnitPriceCentavos)
          ..add('amountCentavos', amountCentavos)
          ..add('vendorCount', vendorCount))
        .toString();
  }
}

class WorkPackageBudgetEstimateLineBuilder
    implements
        Builder<WorkPackageBudgetEstimateLine,
            WorkPackageBudgetEstimateLineBuilder> {
  _$WorkPackageBudgetEstimateLine? _$v;

  int? _index;
  int? get index => _$this._index;
  set index(int? index) => _$this._index = index;

  WorkPackageBudgetEstimateLineStatusEnum? _status;
  WorkPackageBudgetEstimateLineStatusEnum? get status => _$this._status;
  set status(WorkPackageBudgetEstimateLineStatusEnum? status) =>
      _$this._status = status;

  int? _averageUnitPriceCentavos;
  int? get averageUnitPriceCentavos => _$this._averageUnitPriceCentavos;
  set averageUnitPriceCentavos(int? averageUnitPriceCentavos) =>
      _$this._averageUnitPriceCentavos = averageUnitPriceCentavos;

  int? _amountCentavos;
  int? get amountCentavos => _$this._amountCentavos;
  set amountCentavos(int? amountCentavos) =>
      _$this._amountCentavos = amountCentavos;

  int? _vendorCount;
  int? get vendorCount => _$this._vendorCount;
  set vendorCount(int? vendorCount) => _$this._vendorCount = vendorCount;

  WorkPackageBudgetEstimateLineBuilder() {
    WorkPackageBudgetEstimateLine._defaults(this);
  }

  WorkPackageBudgetEstimateLineBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _index = $v.index;
      _status = $v.status;
      _averageUnitPriceCentavos = $v.averageUnitPriceCentavos;
      _amountCentavos = $v.amountCentavos;
      _vendorCount = $v.vendorCount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(WorkPackageBudgetEstimateLine other) {
    _$v = other as _$WorkPackageBudgetEstimateLine;
  }

  @override
  void update(void Function(WorkPackageBudgetEstimateLineBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  WorkPackageBudgetEstimateLine build() => _build();

  _$WorkPackageBudgetEstimateLine _build() {
    final _$result = _$v ??
        _$WorkPackageBudgetEstimateLine._(
          index: BuiltValueNullFieldError.checkNotNull(
              index, r'WorkPackageBudgetEstimateLine', 'index'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'WorkPackageBudgetEstimateLine', 'status'),
          averageUnitPriceCentavos: averageUnitPriceCentavos,
          amountCentavos: amountCentavos,
          vendorCount: BuiltValueNullFieldError.checkNotNull(
              vendorCount, r'WorkPackageBudgetEstimateLine', 'vendorCount'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
