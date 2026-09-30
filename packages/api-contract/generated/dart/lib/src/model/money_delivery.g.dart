// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'money_delivery.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const MoneyDeliveryStatusEnum _$moneyDeliveryStatusEnum_NOT_APPLICABLE =
    const MoneyDeliveryStatusEnum._('NOT_APPLICABLE');
const MoneyDeliveryStatusEnum
    _$moneyDeliveryStatusEnum_PENDING_VENDOR_CONFIRMATION =
    const MoneyDeliveryStatusEnum._('PENDING_VENDOR_CONFIRMATION');
const MoneyDeliveryStatusEnum _$moneyDeliveryStatusEnum_CONFIRMED =
    const MoneyDeliveryStatusEnum._('CONFIRMED');

MoneyDeliveryStatusEnum _$moneyDeliveryStatusEnumValueOf(String name) {
  switch (name) {
    case 'NOT_APPLICABLE':
      return _$moneyDeliveryStatusEnum_NOT_APPLICABLE;
    case 'PENDING_VENDOR_CONFIRMATION':
      return _$moneyDeliveryStatusEnum_PENDING_VENDOR_CONFIRMATION;
    case 'CONFIRMED':
      return _$moneyDeliveryStatusEnum_CONFIRMED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MoneyDeliveryStatusEnum> _$moneyDeliveryStatusEnumValues =
    BuiltSet<MoneyDeliveryStatusEnum>(const <MoneyDeliveryStatusEnum>[
  _$moneyDeliveryStatusEnum_NOT_APPLICABLE,
  _$moneyDeliveryStatusEnum_PENDING_VENDOR_CONFIRMATION,
  _$moneyDeliveryStatusEnum_CONFIRMED,
]);

Serializer<MoneyDeliveryStatusEnum> _$moneyDeliveryStatusEnumSerializer =
    _$MoneyDeliveryStatusEnumSerializer();

class _$MoneyDeliveryStatusEnumSerializer
    implements PrimitiveSerializer<MoneyDeliveryStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'NOT_APPLICABLE': 'NOT_APPLICABLE',
    'PENDING_VENDOR_CONFIRMATION': 'PENDING_VENDOR_CONFIRMATION',
    'CONFIRMED': 'CONFIRMED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'NOT_APPLICABLE': 'NOT_APPLICABLE',
    'PENDING_VENDOR_CONFIRMATION': 'PENDING_VENDOR_CONFIRMATION',
    'CONFIRMED': 'CONFIRMED',
  };

  @override
  final Iterable<Type> types = const <Type>[MoneyDeliveryStatusEnum];
  @override
  final String wireName = 'MoneyDeliveryStatusEnum';

  @override
  Object serialize(Serializers serializers, MoneyDeliveryStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  MoneyDeliveryStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      MoneyDeliveryStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$MoneyDelivery extends MoneyDelivery {
  @override
  final MoneyDeliveryStatusEnum status;
  @override
  final int? amountCentavos;
  @override
  final MoneyRange? estimate;

  factory _$MoneyDelivery([void Function(MoneyDeliveryBuilder)? updates]) =>
      (MoneyDeliveryBuilder()..update(updates))._build();

  _$MoneyDelivery._({required this.status, this.amountCentavos, this.estimate})
      : super._();
  @override
  MoneyDelivery rebuild(void Function(MoneyDeliveryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MoneyDeliveryBuilder toBuilder() => MoneyDeliveryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MoneyDelivery &&
        status == other.status &&
        amountCentavos == other.amountCentavos &&
        estimate == other.estimate;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, amountCentavos.hashCode);
    _$hash = $jc(_$hash, estimate.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MoneyDelivery')
          ..add('status', status)
          ..add('amountCentavos', amountCentavos)
          ..add('estimate', estimate))
        .toString();
  }
}

class MoneyDeliveryBuilder
    implements Builder<MoneyDelivery, MoneyDeliveryBuilder> {
  _$MoneyDelivery? _$v;

  MoneyDeliveryStatusEnum? _status;
  MoneyDeliveryStatusEnum? get status => _$this._status;
  set status(MoneyDeliveryStatusEnum? status) => _$this._status = status;

  int? _amountCentavos;
  int? get amountCentavos => _$this._amountCentavos;
  set amountCentavos(int? amountCentavos) =>
      _$this._amountCentavos = amountCentavos;

  MoneyRangeBuilder? _estimate;
  MoneyRangeBuilder get estimate => _$this._estimate ??= MoneyRangeBuilder();
  set estimate(MoneyRangeBuilder? estimate) => _$this._estimate = estimate;

  MoneyDeliveryBuilder() {
    MoneyDelivery._defaults(this);
  }

  MoneyDeliveryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _amountCentavos = $v.amountCentavos;
      _estimate = $v.estimate?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MoneyDelivery other) {
    _$v = other as _$MoneyDelivery;
  }

  @override
  void update(void Function(MoneyDeliveryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MoneyDelivery build() => _build();

  _$MoneyDelivery _build() {
    _$MoneyDelivery _$result;
    try {
      _$result = _$v ??
          _$MoneyDelivery._(
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'MoneyDelivery', 'status'),
            amountCentavos: amountCentavos,
            estimate: _estimate?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'estimate';
        _estimate?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'MoneyDelivery', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
