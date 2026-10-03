// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_payment_availability.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const OrderPaymentAvailabilityPurposeEnum
    _$orderPaymentAvailabilityPurposeEnum_FULL_ORDER_PAYMENT =
    const OrderPaymentAvailabilityPurposeEnum._('FULL_ORDER_PAYMENT');
const OrderPaymentAvailabilityPurposeEnum
    _$orderPaymentAvailabilityPurposeEnum_NRPC_ASSURANCE_PAYMENT =
    const OrderPaymentAvailabilityPurposeEnum._('NRPC_ASSURANCE_PAYMENT');
const OrderPaymentAvailabilityPurposeEnum
    _$orderPaymentAvailabilityPurposeEnum_ORDER_BALANCE_PAYMENT =
    const OrderPaymentAvailabilityPurposeEnum._('ORDER_BALANCE_PAYMENT');

OrderPaymentAvailabilityPurposeEnum
    _$orderPaymentAvailabilityPurposeEnumValueOf(String name) {
  switch (name) {
    case 'FULL_ORDER_PAYMENT':
      return _$orderPaymentAvailabilityPurposeEnum_FULL_ORDER_PAYMENT;
    case 'NRPC_ASSURANCE_PAYMENT':
      return _$orderPaymentAvailabilityPurposeEnum_NRPC_ASSURANCE_PAYMENT;
    case 'ORDER_BALANCE_PAYMENT':
      return _$orderPaymentAvailabilityPurposeEnum_ORDER_BALANCE_PAYMENT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<OrderPaymentAvailabilityPurposeEnum>
    _$orderPaymentAvailabilityPurposeEnumValues = BuiltSet<
        OrderPaymentAvailabilityPurposeEnum>(const <OrderPaymentAvailabilityPurposeEnum>[
  _$orderPaymentAvailabilityPurposeEnum_FULL_ORDER_PAYMENT,
  _$orderPaymentAvailabilityPurposeEnum_NRPC_ASSURANCE_PAYMENT,
  _$orderPaymentAvailabilityPurposeEnum_ORDER_BALANCE_PAYMENT,
]);

const OrderPaymentAvailabilityEnvironmentEnum
    _$orderPaymentAvailabilityEnvironmentEnum_TEST =
    const OrderPaymentAvailabilityEnvironmentEnum._('TEST');

OrderPaymentAvailabilityEnvironmentEnum
    _$orderPaymentAvailabilityEnvironmentEnumValueOf(String name) {
  switch (name) {
    case 'TEST':
      return _$orderPaymentAvailabilityEnvironmentEnum_TEST;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<OrderPaymentAvailabilityEnvironmentEnum>
    _$orderPaymentAvailabilityEnvironmentEnumValues = BuiltSet<
        OrderPaymentAvailabilityEnvironmentEnum>(const <OrderPaymentAvailabilityEnvironmentEnum>[
  _$orderPaymentAvailabilityEnvironmentEnum_TEST,
]);

Serializer<OrderPaymentAvailabilityPurposeEnum>
    _$orderPaymentAvailabilityPurposeEnumSerializer =
    _$OrderPaymentAvailabilityPurposeEnumSerializer();
Serializer<OrderPaymentAvailabilityEnvironmentEnum>
    _$orderPaymentAvailabilityEnvironmentEnumSerializer =
    _$OrderPaymentAvailabilityEnvironmentEnumSerializer();

class _$OrderPaymentAvailabilityPurposeEnumSerializer
    implements PrimitiveSerializer<OrderPaymentAvailabilityPurposeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'FULL_ORDER_PAYMENT': 'FULL_ORDER_PAYMENT',
    'NRPC_ASSURANCE_PAYMENT': 'NRPC_ASSURANCE_PAYMENT',
    'ORDER_BALANCE_PAYMENT': 'ORDER_BALANCE_PAYMENT',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'FULL_ORDER_PAYMENT': 'FULL_ORDER_PAYMENT',
    'NRPC_ASSURANCE_PAYMENT': 'NRPC_ASSURANCE_PAYMENT',
    'ORDER_BALANCE_PAYMENT': 'ORDER_BALANCE_PAYMENT',
  };

  @override
  final Iterable<Type> types = const <Type>[
    OrderPaymentAvailabilityPurposeEnum
  ];
  @override
  final String wireName = 'OrderPaymentAvailabilityPurposeEnum';

  @override
  Object serialize(
          Serializers serializers, OrderPaymentAvailabilityPurposeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  OrderPaymentAvailabilityPurposeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      OrderPaymentAvailabilityPurposeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$OrderPaymentAvailabilityEnvironmentEnumSerializer
    implements PrimitiveSerializer<OrderPaymentAvailabilityEnvironmentEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'TEST': 'TEST',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'TEST': 'TEST',
  };

  @override
  final Iterable<Type> types = const <Type>[
    OrderPaymentAvailabilityEnvironmentEnum
  ];
  @override
  final String wireName = 'OrderPaymentAvailabilityEnvironmentEnum';

  @override
  Object serialize(Serializers serializers,
          OrderPaymentAvailabilityEnvironmentEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  OrderPaymentAvailabilityEnvironmentEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      OrderPaymentAvailabilityEnvironmentEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$OrderPaymentAvailability extends OrderPaymentAvailability {
  @override
  final bool available;
  @override
  final String? reason;
  @override
  final String? notice;
  @override
  final OrderPaymentAvailabilityPurposeEnum? purpose;
  @override
  final int? principalCentavos;
  @override
  final PaymentAttempt? latestAttempt;
  @override
  final PaymentAttempt? verifiedPayment;
  @override
  final BuiltList<PaymentAttempt>? attempts;
  @override
  final PhysicalPaymentSummary? physical;
  @override
  final OrderPaymentAvailabilityEnvironmentEnum? environment;

  factory _$OrderPaymentAvailability(
          [void Function(OrderPaymentAvailabilityBuilder)? updates]) =>
      (OrderPaymentAvailabilityBuilder()..update(updates))._build();

  _$OrderPaymentAvailability._(
      {required this.available,
      this.reason,
      this.notice,
      this.purpose,
      this.principalCentavos,
      this.latestAttempt,
      this.verifiedPayment,
      this.attempts,
      this.physical,
      this.environment})
      : super._();
  @override
  OrderPaymentAvailability rebuild(
          void Function(OrderPaymentAvailabilityBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OrderPaymentAvailabilityBuilder toBuilder() =>
      OrderPaymentAvailabilityBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OrderPaymentAvailability &&
        available == other.available &&
        reason == other.reason &&
        notice == other.notice &&
        purpose == other.purpose &&
        principalCentavos == other.principalCentavos &&
        latestAttempt == other.latestAttempt &&
        verifiedPayment == other.verifiedPayment &&
        attempts == other.attempts &&
        physical == other.physical &&
        environment == other.environment;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, available.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, notice.hashCode);
    _$hash = $jc(_$hash, purpose.hashCode);
    _$hash = $jc(_$hash, principalCentavos.hashCode);
    _$hash = $jc(_$hash, latestAttempt.hashCode);
    _$hash = $jc(_$hash, verifiedPayment.hashCode);
    _$hash = $jc(_$hash, attempts.hashCode);
    _$hash = $jc(_$hash, physical.hashCode);
    _$hash = $jc(_$hash, environment.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OrderPaymentAvailability')
          ..add('available', available)
          ..add('reason', reason)
          ..add('notice', notice)
          ..add('purpose', purpose)
          ..add('principalCentavos', principalCentavos)
          ..add('latestAttempt', latestAttempt)
          ..add('verifiedPayment', verifiedPayment)
          ..add('attempts', attempts)
          ..add('physical', physical)
          ..add('environment', environment))
        .toString();
  }
}

class OrderPaymentAvailabilityBuilder
    implements
        Builder<OrderPaymentAvailability, OrderPaymentAvailabilityBuilder> {
  _$OrderPaymentAvailability? _$v;

  bool? _available;
  bool? get available => _$this._available;
  set available(bool? available) => _$this._available = available;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  String? _notice;
  String? get notice => _$this._notice;
  set notice(String? notice) => _$this._notice = notice;

  OrderPaymentAvailabilityPurposeEnum? _purpose;
  OrderPaymentAvailabilityPurposeEnum? get purpose => _$this._purpose;
  set purpose(OrderPaymentAvailabilityPurposeEnum? purpose) =>
      _$this._purpose = purpose;

  int? _principalCentavos;
  int? get principalCentavos => _$this._principalCentavos;
  set principalCentavos(int? principalCentavos) =>
      _$this._principalCentavos = principalCentavos;

  PaymentAttemptBuilder? _latestAttempt;
  PaymentAttemptBuilder get latestAttempt =>
      _$this._latestAttempt ??= PaymentAttemptBuilder();
  set latestAttempt(PaymentAttemptBuilder? latestAttempt) =>
      _$this._latestAttempt = latestAttempt;

  PaymentAttemptBuilder? _verifiedPayment;
  PaymentAttemptBuilder get verifiedPayment =>
      _$this._verifiedPayment ??= PaymentAttemptBuilder();
  set verifiedPayment(PaymentAttemptBuilder? verifiedPayment) =>
      _$this._verifiedPayment = verifiedPayment;

  ListBuilder<PaymentAttempt>? _attempts;
  ListBuilder<PaymentAttempt> get attempts =>
      _$this._attempts ??= ListBuilder<PaymentAttempt>();
  set attempts(ListBuilder<PaymentAttempt>? attempts) =>
      _$this._attempts = attempts;

  PhysicalPaymentSummaryBuilder? _physical;
  PhysicalPaymentSummaryBuilder get physical =>
      _$this._physical ??= PhysicalPaymentSummaryBuilder();
  set physical(PhysicalPaymentSummaryBuilder? physical) =>
      _$this._physical = physical;

  OrderPaymentAvailabilityEnvironmentEnum? _environment;
  OrderPaymentAvailabilityEnvironmentEnum? get environment =>
      _$this._environment;
  set environment(OrderPaymentAvailabilityEnvironmentEnum? environment) =>
      _$this._environment = environment;

  OrderPaymentAvailabilityBuilder() {
    OrderPaymentAvailability._defaults(this);
  }

  OrderPaymentAvailabilityBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _available = $v.available;
      _reason = $v.reason;
      _notice = $v.notice;
      _purpose = $v.purpose;
      _principalCentavos = $v.principalCentavos;
      _latestAttempt = $v.latestAttempt?.toBuilder();
      _verifiedPayment = $v.verifiedPayment?.toBuilder();
      _attempts = $v.attempts?.toBuilder();
      _physical = $v.physical?.toBuilder();
      _environment = $v.environment;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OrderPaymentAvailability other) {
    _$v = other as _$OrderPaymentAvailability;
  }

  @override
  void update(void Function(OrderPaymentAvailabilityBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OrderPaymentAvailability build() => _build();

  _$OrderPaymentAvailability _build() {
    _$OrderPaymentAvailability _$result;
    try {
      _$result = _$v ??
          _$OrderPaymentAvailability._(
            available: BuiltValueNullFieldError.checkNotNull(
                available, r'OrderPaymentAvailability', 'available'),
            reason: reason,
            notice: notice,
            purpose: purpose,
            principalCentavos: principalCentavos,
            latestAttempt: _latestAttempt?.build(),
            verifiedPayment: _verifiedPayment?.build(),
            attempts: _attempts?.build(),
            physical: _physical?.build(),
            environment: environment,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'latestAttempt';
        _latestAttempt?.build();
        _$failedField = 'verifiedPayment';
        _verifiedPayment?.build();
        _$failedField = 'attempts';
        _attempts?.build();
        _$failedField = 'physical';
        _physical?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'OrderPaymentAvailability', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
