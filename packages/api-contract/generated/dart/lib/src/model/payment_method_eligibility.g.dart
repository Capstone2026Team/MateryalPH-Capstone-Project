// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_method_eligibility.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PaymentMethodEligibilityMethodEnum
    _$paymentMethodEligibilityMethodEnum_ONLINE =
    const PaymentMethodEligibilityMethodEnum._('ONLINE');
const PaymentMethodEligibilityMethodEnum
    _$paymentMethodEligibilityMethodEnum_CASH_ON_DELIVERY =
    const PaymentMethodEligibilityMethodEnum._('CASH_ON_DELIVERY');
const PaymentMethodEligibilityMethodEnum
    _$paymentMethodEligibilityMethodEnum_IN_STORE =
    const PaymentMethodEligibilityMethodEnum._('IN_STORE');

PaymentMethodEligibilityMethodEnum _$paymentMethodEligibilityMethodEnumValueOf(
    String name) {
  switch (name) {
    case 'ONLINE':
      return _$paymentMethodEligibilityMethodEnum_ONLINE;
    case 'CASH_ON_DELIVERY':
      return _$paymentMethodEligibilityMethodEnum_CASH_ON_DELIVERY;
    case 'IN_STORE':
      return _$paymentMethodEligibilityMethodEnum_IN_STORE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PaymentMethodEligibilityMethodEnum>
    _$paymentMethodEligibilityMethodEnumValues = BuiltSet<
        PaymentMethodEligibilityMethodEnum>(const <PaymentMethodEligibilityMethodEnum>[
  _$paymentMethodEligibilityMethodEnum_ONLINE,
  _$paymentMethodEligibilityMethodEnum_CASH_ON_DELIVERY,
  _$paymentMethodEligibilityMethodEnum_IN_STORE,
]);

Serializer<PaymentMethodEligibilityMethodEnum>
    _$paymentMethodEligibilityMethodEnumSerializer =
    _$PaymentMethodEligibilityMethodEnumSerializer();

class _$PaymentMethodEligibilityMethodEnumSerializer
    implements PrimitiveSerializer<PaymentMethodEligibilityMethodEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ONLINE': 'ONLINE',
    'CASH_ON_DELIVERY': 'CASH_ON_DELIVERY',
    'IN_STORE': 'IN_STORE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ONLINE': 'ONLINE',
    'CASH_ON_DELIVERY': 'CASH_ON_DELIVERY',
    'IN_STORE': 'IN_STORE',
  };

  @override
  final Iterable<Type> types = const <Type>[PaymentMethodEligibilityMethodEnum];
  @override
  final String wireName = 'PaymentMethodEligibilityMethodEnum';

  @override
  Object serialize(
          Serializers serializers, PaymentMethodEligibilityMethodEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PaymentMethodEligibilityMethodEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PaymentMethodEligibilityMethodEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PaymentMethodEligibility extends PaymentMethodEligibility {
  @override
  final PaymentMethodEligibilityMethodEnum method;
  @override
  final bool available;
  @override
  final String? reason;

  factory _$PaymentMethodEligibility(
          [void Function(PaymentMethodEligibilityBuilder)? updates]) =>
      (PaymentMethodEligibilityBuilder()..update(updates))._build();

  _$PaymentMethodEligibility._(
      {required this.method, required this.available, this.reason})
      : super._();
  @override
  PaymentMethodEligibility rebuild(
          void Function(PaymentMethodEligibilityBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PaymentMethodEligibilityBuilder toBuilder() =>
      PaymentMethodEligibilityBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PaymentMethodEligibility &&
        method == other.method &&
        available == other.available &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, method.hashCode);
    _$hash = $jc(_$hash, available.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PaymentMethodEligibility')
          ..add('method', method)
          ..add('available', available)
          ..add('reason', reason))
        .toString();
  }
}

class PaymentMethodEligibilityBuilder
    implements
        Builder<PaymentMethodEligibility, PaymentMethodEligibilityBuilder> {
  _$PaymentMethodEligibility? _$v;

  PaymentMethodEligibilityMethodEnum? _method;
  PaymentMethodEligibilityMethodEnum? get method => _$this._method;
  set method(PaymentMethodEligibilityMethodEnum? method) =>
      _$this._method = method;

  bool? _available;
  bool? get available => _$this._available;
  set available(bool? available) => _$this._available = available;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  PaymentMethodEligibilityBuilder() {
    PaymentMethodEligibility._defaults(this);
  }

  PaymentMethodEligibilityBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _method = $v.method;
      _available = $v.available;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PaymentMethodEligibility other) {
    _$v = other as _$PaymentMethodEligibility;
  }

  @override
  void update(void Function(PaymentMethodEligibilityBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PaymentMethodEligibility build() => _build();

  _$PaymentMethodEligibility _build() {
    final _$result = _$v ??
        _$PaymentMethodEligibility._(
          method: BuiltValueNullFieldError.checkNotNull(
              method, r'PaymentMethodEligibility', 'method'),
          available: BuiltValueNullFieldError.checkNotNull(
              available, r'PaymentMethodEligibility', 'available'),
          reason: reason,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
