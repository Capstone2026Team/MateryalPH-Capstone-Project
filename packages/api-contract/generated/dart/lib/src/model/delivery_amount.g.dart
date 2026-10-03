// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_amount.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const DeliveryAmountStatusEnum _$deliveryAmountStatusEnum_ESTIMATE =
    const DeliveryAmountStatusEnum._('ESTIMATE');
const DeliveryAmountStatusEnum _$deliveryAmountStatusEnum_NOT_APPLICABLE =
    const DeliveryAmountStatusEnum._('NOT_APPLICABLE');
const DeliveryAmountStatusEnum
    _$deliveryAmountStatusEnum_PENDING_VENDOR_REVIEW =
    const DeliveryAmountStatusEnum._('PENDING_VENDOR_REVIEW');

DeliveryAmountStatusEnum _$deliveryAmountStatusEnumValueOf(String name) {
  switch (name) {
    case 'ESTIMATE':
      return _$deliveryAmountStatusEnum_ESTIMATE;
    case 'NOT_APPLICABLE':
      return _$deliveryAmountStatusEnum_NOT_APPLICABLE;
    case 'PENDING_VENDOR_REVIEW':
      return _$deliveryAmountStatusEnum_PENDING_VENDOR_REVIEW;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DeliveryAmountStatusEnum> _$deliveryAmountStatusEnumValues =
    BuiltSet<DeliveryAmountStatusEnum>(const <DeliveryAmountStatusEnum>[
  _$deliveryAmountStatusEnum_ESTIMATE,
  _$deliveryAmountStatusEnum_NOT_APPLICABLE,
  _$deliveryAmountStatusEnum_PENDING_VENDOR_REVIEW,
]);

Serializer<DeliveryAmountStatusEnum> _$deliveryAmountStatusEnumSerializer =
    _$DeliveryAmountStatusEnumSerializer();

class _$DeliveryAmountStatusEnumSerializer
    implements PrimitiveSerializer<DeliveryAmountStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ESTIMATE': 'ESTIMATE',
    'NOT_APPLICABLE': 'NOT_APPLICABLE',
    'PENDING_VENDOR_REVIEW': 'PENDING_VENDOR_REVIEW',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ESTIMATE': 'ESTIMATE',
    'NOT_APPLICABLE': 'NOT_APPLICABLE',
    'PENDING_VENDOR_REVIEW': 'PENDING_VENDOR_REVIEW',
  };

  @override
  final Iterable<Type> types = const <Type>[DeliveryAmountStatusEnum];
  @override
  final String wireName = 'DeliveryAmountStatusEnum';

  @override
  Object serialize(Serializers serializers, DeliveryAmountStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DeliveryAmountStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DeliveryAmountStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DeliveryAmount extends DeliveryAmount {
  @override
  final DeliveryAmountStatusEnum status;
  @override
  final int? minCentavos;
  @override
  final int? maxCentavos;

  factory _$DeliveryAmount([void Function(DeliveryAmountBuilder)? updates]) =>
      (DeliveryAmountBuilder()..update(updates))._build();

  _$DeliveryAmount._({required this.status, this.minCentavos, this.maxCentavos})
      : super._();
  @override
  DeliveryAmount rebuild(void Function(DeliveryAmountBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DeliveryAmountBuilder toBuilder() => DeliveryAmountBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DeliveryAmount &&
        status == other.status &&
        minCentavos == other.minCentavos &&
        maxCentavos == other.maxCentavos;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, minCentavos.hashCode);
    _$hash = $jc(_$hash, maxCentavos.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DeliveryAmount')
          ..add('status', status)
          ..add('minCentavos', minCentavos)
          ..add('maxCentavos', maxCentavos))
        .toString();
  }
}

class DeliveryAmountBuilder
    implements Builder<DeliveryAmount, DeliveryAmountBuilder> {
  _$DeliveryAmount? _$v;

  DeliveryAmountStatusEnum? _status;
  DeliveryAmountStatusEnum? get status => _$this._status;
  set status(DeliveryAmountStatusEnum? status) => _$this._status = status;

  int? _minCentavos;
  int? get minCentavos => _$this._minCentavos;
  set minCentavos(int? minCentavos) => _$this._minCentavos = minCentavos;

  int? _maxCentavos;
  int? get maxCentavos => _$this._maxCentavos;
  set maxCentavos(int? maxCentavos) => _$this._maxCentavos = maxCentavos;

  DeliveryAmountBuilder() {
    DeliveryAmount._defaults(this);
  }

  DeliveryAmountBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _minCentavos = $v.minCentavos;
      _maxCentavos = $v.maxCentavos;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DeliveryAmount other) {
    _$v = other as _$DeliveryAmount;
  }

  @override
  void update(void Function(DeliveryAmountBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DeliveryAmount build() => _build();

  _$DeliveryAmount _build() {
    final _$result = _$v ??
        _$DeliveryAmount._(
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'DeliveryAmount', 'status'),
          minCentavos: minCentavos,
          maxCentavos: maxCentavos,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
