// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_options.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PaymentOptionsPurposeEnum _$paymentOptionsPurposeEnum_FULL_ORDER_PAYMENT =
    const PaymentOptionsPurposeEnum._('FULL_ORDER_PAYMENT');
const PaymentOptionsPurposeEnum
    _$paymentOptionsPurposeEnum_NRPC_ASSURANCE_PAYMENT =
    const PaymentOptionsPurposeEnum._('NRPC_ASSURANCE_PAYMENT');
const PaymentOptionsPurposeEnum
    _$paymentOptionsPurposeEnum_ORDER_BALANCE_PAYMENT =
    const PaymentOptionsPurposeEnum._('ORDER_BALANCE_PAYMENT');
const PaymentOptionsPurposeEnum
    _$paymentOptionsPurposeEnum_PLATFORM_FEE_PAYMENT =
    const PaymentOptionsPurposeEnum._('PLATFORM_FEE_PAYMENT');

PaymentOptionsPurposeEnum _$paymentOptionsPurposeEnumValueOf(String name) {
  switch (name) {
    case 'FULL_ORDER_PAYMENT':
      return _$paymentOptionsPurposeEnum_FULL_ORDER_PAYMENT;
    case 'NRPC_ASSURANCE_PAYMENT':
      return _$paymentOptionsPurposeEnum_NRPC_ASSURANCE_PAYMENT;
    case 'ORDER_BALANCE_PAYMENT':
      return _$paymentOptionsPurposeEnum_ORDER_BALANCE_PAYMENT;
    case 'PLATFORM_FEE_PAYMENT':
      return _$paymentOptionsPurposeEnum_PLATFORM_FEE_PAYMENT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PaymentOptionsPurposeEnum> _$paymentOptionsPurposeEnumValues =
    BuiltSet<PaymentOptionsPurposeEnum>(const <PaymentOptionsPurposeEnum>[
  _$paymentOptionsPurposeEnum_FULL_ORDER_PAYMENT,
  _$paymentOptionsPurposeEnum_NRPC_ASSURANCE_PAYMENT,
  _$paymentOptionsPurposeEnum_ORDER_BALANCE_PAYMENT,
  _$paymentOptionsPurposeEnum_PLATFORM_FEE_PAYMENT,
]);

const PaymentOptionsEnvironmentEnum _$paymentOptionsEnvironmentEnum_TEST =
    const PaymentOptionsEnvironmentEnum._('TEST');

PaymentOptionsEnvironmentEnum _$paymentOptionsEnvironmentEnumValueOf(
    String name) {
  switch (name) {
    case 'TEST':
      return _$paymentOptionsEnvironmentEnum_TEST;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PaymentOptionsEnvironmentEnum>
    _$paymentOptionsEnvironmentEnumValues = BuiltSet<
        PaymentOptionsEnvironmentEnum>(const <PaymentOptionsEnvironmentEnum>[
  _$paymentOptionsEnvironmentEnum_TEST,
]);

const PaymentOptionsEvidenceOriginEnum
    _$paymentOptionsEvidenceOriginEnum_XENDIT_TEST =
    const PaymentOptionsEvidenceOriginEnum._('XENDIT_TEST');
const PaymentOptionsEvidenceOriginEnum
    _$paymentOptionsEvidenceOriginEnum_SIMULATED =
    const PaymentOptionsEvidenceOriginEnum._('SIMULATED');

PaymentOptionsEvidenceOriginEnum _$paymentOptionsEvidenceOriginEnumValueOf(
    String name) {
  switch (name) {
    case 'XENDIT_TEST':
      return _$paymentOptionsEvidenceOriginEnum_XENDIT_TEST;
    case 'SIMULATED':
      return _$paymentOptionsEvidenceOriginEnum_SIMULATED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PaymentOptionsEvidenceOriginEnum>
    _$paymentOptionsEvidenceOriginEnumValues = BuiltSet<
        PaymentOptionsEvidenceOriginEnum>(const <PaymentOptionsEvidenceOriginEnum>[
  _$paymentOptionsEvidenceOriginEnum_XENDIT_TEST,
  _$paymentOptionsEvidenceOriginEnum_SIMULATED,
]);

Serializer<PaymentOptionsPurposeEnum> _$paymentOptionsPurposeEnumSerializer =
    _$PaymentOptionsPurposeEnumSerializer();
Serializer<PaymentOptionsEnvironmentEnum>
    _$paymentOptionsEnvironmentEnumSerializer =
    _$PaymentOptionsEnvironmentEnumSerializer();
Serializer<PaymentOptionsEvidenceOriginEnum>
    _$paymentOptionsEvidenceOriginEnumSerializer =
    _$PaymentOptionsEvidenceOriginEnumSerializer();

class _$PaymentOptionsPurposeEnumSerializer
    implements PrimitiveSerializer<PaymentOptionsPurposeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'FULL_ORDER_PAYMENT': 'FULL_ORDER_PAYMENT',
    'NRPC_ASSURANCE_PAYMENT': 'NRPC_ASSURANCE_PAYMENT',
    'ORDER_BALANCE_PAYMENT': 'ORDER_BALANCE_PAYMENT',
    'PLATFORM_FEE_PAYMENT': 'PLATFORM_FEE_PAYMENT',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'FULL_ORDER_PAYMENT': 'FULL_ORDER_PAYMENT',
    'NRPC_ASSURANCE_PAYMENT': 'NRPC_ASSURANCE_PAYMENT',
    'ORDER_BALANCE_PAYMENT': 'ORDER_BALANCE_PAYMENT',
    'PLATFORM_FEE_PAYMENT': 'PLATFORM_FEE_PAYMENT',
  };

  @override
  final Iterable<Type> types = const <Type>[PaymentOptionsPurposeEnum];
  @override
  final String wireName = 'PaymentOptionsPurposeEnum';

  @override
  Object serialize(Serializers serializers, PaymentOptionsPurposeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PaymentOptionsPurposeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PaymentOptionsPurposeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PaymentOptionsEnvironmentEnumSerializer
    implements PrimitiveSerializer<PaymentOptionsEnvironmentEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'TEST': 'TEST',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'TEST': 'TEST',
  };

  @override
  final Iterable<Type> types = const <Type>[PaymentOptionsEnvironmentEnum];
  @override
  final String wireName = 'PaymentOptionsEnvironmentEnum';

  @override
  Object serialize(
          Serializers serializers, PaymentOptionsEnvironmentEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PaymentOptionsEnvironmentEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PaymentOptionsEnvironmentEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PaymentOptionsEvidenceOriginEnumSerializer
    implements PrimitiveSerializer<PaymentOptionsEvidenceOriginEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'XENDIT_TEST': 'XENDIT_TEST',
    'SIMULATED': 'SIMULATED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'XENDIT_TEST': 'XENDIT_TEST',
    'SIMULATED': 'SIMULATED',
  };

  @override
  final Iterable<Type> types = const <Type>[PaymentOptionsEvidenceOriginEnum];
  @override
  final String wireName = 'PaymentOptionsEvidenceOriginEnum';

  @override
  Object serialize(
          Serializers serializers, PaymentOptionsEvidenceOriginEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PaymentOptionsEvidenceOriginEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PaymentOptionsEvidenceOriginEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PaymentOptions extends PaymentOptions {
  @override
  final String orderId;
  @override
  final String orderReference;
  @override
  final bool paymentDue;
  @override
  final PaymentOptionsPurposeEnum? purpose;
  @override
  final int? principalCentavos;
  @override
  final BuiltMap<String, JsonObject?>? breakdown;
  @override
  final BuiltList<PaymentChannelOption> channels;
  @override
  final DateTime? payBy;
  @override
  final PaymentOptionsEnvironmentEnum environment;
  @override
  final PaymentOptionsEvidenceOriginEnum evidenceOrigin;
  @override
  final bool providerReady;
  @override
  final PaymentAttempt? latestAttempt;
  @override
  final String notice;

  factory _$PaymentOptions([void Function(PaymentOptionsBuilder)? updates]) =>
      (PaymentOptionsBuilder()..update(updates))._build();

  _$PaymentOptions._(
      {required this.orderId,
      required this.orderReference,
      required this.paymentDue,
      this.purpose,
      this.principalCentavos,
      this.breakdown,
      required this.channels,
      this.payBy,
      required this.environment,
      required this.evidenceOrigin,
      required this.providerReady,
      this.latestAttempt,
      required this.notice})
      : super._();
  @override
  PaymentOptions rebuild(void Function(PaymentOptionsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PaymentOptionsBuilder toBuilder() => PaymentOptionsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PaymentOptions &&
        orderId == other.orderId &&
        orderReference == other.orderReference &&
        paymentDue == other.paymentDue &&
        purpose == other.purpose &&
        principalCentavos == other.principalCentavos &&
        breakdown == other.breakdown &&
        channels == other.channels &&
        payBy == other.payBy &&
        environment == other.environment &&
        evidenceOrigin == other.evidenceOrigin &&
        providerReady == other.providerReady &&
        latestAttempt == other.latestAttempt &&
        notice == other.notice;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, orderId.hashCode);
    _$hash = $jc(_$hash, orderReference.hashCode);
    _$hash = $jc(_$hash, paymentDue.hashCode);
    _$hash = $jc(_$hash, purpose.hashCode);
    _$hash = $jc(_$hash, principalCentavos.hashCode);
    _$hash = $jc(_$hash, breakdown.hashCode);
    _$hash = $jc(_$hash, channels.hashCode);
    _$hash = $jc(_$hash, payBy.hashCode);
    _$hash = $jc(_$hash, environment.hashCode);
    _$hash = $jc(_$hash, evidenceOrigin.hashCode);
    _$hash = $jc(_$hash, providerReady.hashCode);
    _$hash = $jc(_$hash, latestAttempt.hashCode);
    _$hash = $jc(_$hash, notice.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PaymentOptions')
          ..add('orderId', orderId)
          ..add('orderReference', orderReference)
          ..add('paymentDue', paymentDue)
          ..add('purpose', purpose)
          ..add('principalCentavos', principalCentavos)
          ..add('breakdown', breakdown)
          ..add('channels', channels)
          ..add('payBy', payBy)
          ..add('environment', environment)
          ..add('evidenceOrigin', evidenceOrigin)
          ..add('providerReady', providerReady)
          ..add('latestAttempt', latestAttempt)
          ..add('notice', notice))
        .toString();
  }
}

class PaymentOptionsBuilder
    implements Builder<PaymentOptions, PaymentOptionsBuilder> {
  _$PaymentOptions? _$v;

  String? _orderId;
  String? get orderId => _$this._orderId;
  set orderId(String? orderId) => _$this._orderId = orderId;

  String? _orderReference;
  String? get orderReference => _$this._orderReference;
  set orderReference(String? orderReference) =>
      _$this._orderReference = orderReference;

  bool? _paymentDue;
  bool? get paymentDue => _$this._paymentDue;
  set paymentDue(bool? paymentDue) => _$this._paymentDue = paymentDue;

  PaymentOptionsPurposeEnum? _purpose;
  PaymentOptionsPurposeEnum? get purpose => _$this._purpose;
  set purpose(PaymentOptionsPurposeEnum? purpose) => _$this._purpose = purpose;

  int? _principalCentavos;
  int? get principalCentavos => _$this._principalCentavos;
  set principalCentavos(int? principalCentavos) =>
      _$this._principalCentavos = principalCentavos;

  MapBuilder<String, JsonObject?>? _breakdown;
  MapBuilder<String, JsonObject?> get breakdown =>
      _$this._breakdown ??= MapBuilder<String, JsonObject?>();
  set breakdown(MapBuilder<String, JsonObject?>? breakdown) =>
      _$this._breakdown = breakdown;

  ListBuilder<PaymentChannelOption>? _channels;
  ListBuilder<PaymentChannelOption> get channels =>
      _$this._channels ??= ListBuilder<PaymentChannelOption>();
  set channels(ListBuilder<PaymentChannelOption>? channels) =>
      _$this._channels = channels;

  DateTime? _payBy;
  DateTime? get payBy => _$this._payBy;
  set payBy(DateTime? payBy) => _$this._payBy = payBy;

  PaymentOptionsEnvironmentEnum? _environment;
  PaymentOptionsEnvironmentEnum? get environment => _$this._environment;
  set environment(PaymentOptionsEnvironmentEnum? environment) =>
      _$this._environment = environment;

  PaymentOptionsEvidenceOriginEnum? _evidenceOrigin;
  PaymentOptionsEvidenceOriginEnum? get evidenceOrigin =>
      _$this._evidenceOrigin;
  set evidenceOrigin(PaymentOptionsEvidenceOriginEnum? evidenceOrigin) =>
      _$this._evidenceOrigin = evidenceOrigin;

  bool? _providerReady;
  bool? get providerReady => _$this._providerReady;
  set providerReady(bool? providerReady) =>
      _$this._providerReady = providerReady;

  PaymentAttemptBuilder? _latestAttempt;
  PaymentAttemptBuilder get latestAttempt =>
      _$this._latestAttempt ??= PaymentAttemptBuilder();
  set latestAttempt(PaymentAttemptBuilder? latestAttempt) =>
      _$this._latestAttempt = latestAttempt;

  String? _notice;
  String? get notice => _$this._notice;
  set notice(String? notice) => _$this._notice = notice;

  PaymentOptionsBuilder() {
    PaymentOptions._defaults(this);
  }

  PaymentOptionsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _orderId = $v.orderId;
      _orderReference = $v.orderReference;
      _paymentDue = $v.paymentDue;
      _purpose = $v.purpose;
      _principalCentavos = $v.principalCentavos;
      _breakdown = $v.breakdown?.toBuilder();
      _channels = $v.channels.toBuilder();
      _payBy = $v.payBy;
      _environment = $v.environment;
      _evidenceOrigin = $v.evidenceOrigin;
      _providerReady = $v.providerReady;
      _latestAttempt = $v.latestAttempt?.toBuilder();
      _notice = $v.notice;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PaymentOptions other) {
    _$v = other as _$PaymentOptions;
  }

  @override
  void update(void Function(PaymentOptionsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PaymentOptions build() => _build();

  _$PaymentOptions _build() {
    _$PaymentOptions _$result;
    try {
      _$result = _$v ??
          _$PaymentOptions._(
            orderId: BuiltValueNullFieldError.checkNotNull(
                orderId, r'PaymentOptions', 'orderId'),
            orderReference: BuiltValueNullFieldError.checkNotNull(
                orderReference, r'PaymentOptions', 'orderReference'),
            paymentDue: BuiltValueNullFieldError.checkNotNull(
                paymentDue, r'PaymentOptions', 'paymentDue'),
            purpose: purpose,
            principalCentavos: principalCentavos,
            breakdown: _breakdown?.build(),
            channels: channels.build(),
            payBy: payBy,
            environment: BuiltValueNullFieldError.checkNotNull(
                environment, r'PaymentOptions', 'environment'),
            evidenceOrigin: BuiltValueNullFieldError.checkNotNull(
                evidenceOrigin, r'PaymentOptions', 'evidenceOrigin'),
            providerReady: BuiltValueNullFieldError.checkNotNull(
                providerReady, r'PaymentOptions', 'providerReady'),
            latestAttempt: _latestAttempt?.build(),
            notice: BuiltValueNullFieldError.checkNotNull(
                notice, r'PaymentOptions', 'notice'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'breakdown';
        _breakdown?.build();
        _$failedField = 'channels';
        channels.build();

        _$failedField = 'latestAttempt';
        _latestAttempt?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PaymentOptions', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
