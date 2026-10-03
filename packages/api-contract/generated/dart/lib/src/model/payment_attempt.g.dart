// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_attempt.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PaymentAttemptPurposeEnum _$paymentAttemptPurposeEnum_FULL_ORDER_PAYMENT =
    const PaymentAttemptPurposeEnum._('FULL_ORDER_PAYMENT');
const PaymentAttemptPurposeEnum
    _$paymentAttemptPurposeEnum_NRPC_ASSURANCE_PAYMENT =
    const PaymentAttemptPurposeEnum._('NRPC_ASSURANCE_PAYMENT');
const PaymentAttemptPurposeEnum
    _$paymentAttemptPurposeEnum_ORDER_BALANCE_PAYMENT =
    const PaymentAttemptPurposeEnum._('ORDER_BALANCE_PAYMENT');
const PaymentAttemptPurposeEnum
    _$paymentAttemptPurposeEnum_PLATFORM_FEE_PAYMENT =
    const PaymentAttemptPurposeEnum._('PLATFORM_FEE_PAYMENT');

PaymentAttemptPurposeEnum _$paymentAttemptPurposeEnumValueOf(String name) {
  switch (name) {
    case 'FULL_ORDER_PAYMENT':
      return _$paymentAttemptPurposeEnum_FULL_ORDER_PAYMENT;
    case 'NRPC_ASSURANCE_PAYMENT':
      return _$paymentAttemptPurposeEnum_NRPC_ASSURANCE_PAYMENT;
    case 'ORDER_BALANCE_PAYMENT':
      return _$paymentAttemptPurposeEnum_ORDER_BALANCE_PAYMENT;
    case 'PLATFORM_FEE_PAYMENT':
      return _$paymentAttemptPurposeEnum_PLATFORM_FEE_PAYMENT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PaymentAttemptPurposeEnum> _$paymentAttemptPurposeEnumValues =
    BuiltSet<PaymentAttemptPurposeEnum>(const <PaymentAttemptPurposeEnum>[
  _$paymentAttemptPurposeEnum_FULL_ORDER_PAYMENT,
  _$paymentAttemptPurposeEnum_NRPC_ASSURANCE_PAYMENT,
  _$paymentAttemptPurposeEnum_ORDER_BALANCE_PAYMENT,
  _$paymentAttemptPurposeEnum_PLATFORM_FEE_PAYMENT,
]);

const PaymentAttemptStatusEnum _$paymentAttemptStatusEnum_PENDING =
    const PaymentAttemptStatusEnum._('PENDING');
const PaymentAttemptStatusEnum _$paymentAttemptStatusEnum_PAID =
    const PaymentAttemptStatusEnum._('PAID');
const PaymentAttemptStatusEnum _$paymentAttemptStatusEnum_FAILED =
    const PaymentAttemptStatusEnum._('FAILED');
const PaymentAttemptStatusEnum _$paymentAttemptStatusEnum_EXPIRED =
    const PaymentAttemptStatusEnum._('EXPIRED');
const PaymentAttemptStatusEnum
    _$paymentAttemptStatusEnum_CAPTURED_LATE_REFUND_PENDING =
    const PaymentAttemptStatusEnum._('CAPTURED_LATE_REFUND_PENDING');

PaymentAttemptStatusEnum _$paymentAttemptStatusEnumValueOf(String name) {
  switch (name) {
    case 'PENDING':
      return _$paymentAttemptStatusEnum_PENDING;
    case 'PAID':
      return _$paymentAttemptStatusEnum_PAID;
    case 'FAILED':
      return _$paymentAttemptStatusEnum_FAILED;
    case 'EXPIRED':
      return _$paymentAttemptStatusEnum_EXPIRED;
    case 'CAPTURED_LATE_REFUND_PENDING':
      return _$paymentAttemptStatusEnum_CAPTURED_LATE_REFUND_PENDING;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PaymentAttemptStatusEnum> _$paymentAttemptStatusEnumValues =
    BuiltSet<PaymentAttemptStatusEnum>(const <PaymentAttemptStatusEnum>[
  _$paymentAttemptStatusEnum_PENDING,
  _$paymentAttemptStatusEnum_PAID,
  _$paymentAttemptStatusEnum_FAILED,
  _$paymentAttemptStatusEnum_EXPIRED,
  _$paymentAttemptStatusEnum_CAPTURED_LATE_REFUND_PENDING,
]);

const PaymentAttemptFeeBearerEnum _$paymentAttemptFeeBearerEnum_BUYER =
    const PaymentAttemptFeeBearerEnum._('BUYER');
const PaymentAttemptFeeBearerEnum _$paymentAttemptFeeBearerEnum_PLATFORM =
    const PaymentAttemptFeeBearerEnum._('PLATFORM');

PaymentAttemptFeeBearerEnum _$paymentAttemptFeeBearerEnumValueOf(String name) {
  switch (name) {
    case 'BUYER':
      return _$paymentAttemptFeeBearerEnum_BUYER;
    case 'PLATFORM':
      return _$paymentAttemptFeeBearerEnum_PLATFORM;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PaymentAttemptFeeBearerEnum>
    _$paymentAttemptFeeBearerEnumValues =
    BuiltSet<PaymentAttemptFeeBearerEnum>(const <PaymentAttemptFeeBearerEnum>[
  _$paymentAttemptFeeBearerEnum_BUYER,
  _$paymentAttemptFeeBearerEnum_PLATFORM,
]);

const PaymentAttemptEnvironmentEnum _$paymentAttemptEnvironmentEnum_TEST =
    const PaymentAttemptEnvironmentEnum._('TEST');

PaymentAttemptEnvironmentEnum _$paymentAttemptEnvironmentEnumValueOf(
    String name) {
  switch (name) {
    case 'TEST':
      return _$paymentAttemptEnvironmentEnum_TEST;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PaymentAttemptEnvironmentEnum>
    _$paymentAttemptEnvironmentEnumValues = BuiltSet<
        PaymentAttemptEnvironmentEnum>(const <PaymentAttemptEnvironmentEnum>[
  _$paymentAttemptEnvironmentEnum_TEST,
]);

const PaymentAttemptEvidenceOriginEnum
    _$paymentAttemptEvidenceOriginEnum_XENDIT_TEST =
    const PaymentAttemptEvidenceOriginEnum._('XENDIT_TEST');
const PaymentAttemptEvidenceOriginEnum
    _$paymentAttemptEvidenceOriginEnum_SIMULATED =
    const PaymentAttemptEvidenceOriginEnum._('SIMULATED');

PaymentAttemptEvidenceOriginEnum _$paymentAttemptEvidenceOriginEnumValueOf(
    String name) {
  switch (name) {
    case 'XENDIT_TEST':
      return _$paymentAttemptEvidenceOriginEnum_XENDIT_TEST;
    case 'SIMULATED':
      return _$paymentAttemptEvidenceOriginEnum_SIMULATED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PaymentAttemptEvidenceOriginEnum>
    _$paymentAttemptEvidenceOriginEnumValues = BuiltSet<
        PaymentAttemptEvidenceOriginEnum>(const <PaymentAttemptEvidenceOriginEnum>[
  _$paymentAttemptEvidenceOriginEnum_XENDIT_TEST,
  _$paymentAttemptEvidenceOriginEnum_SIMULATED,
]);

Serializer<PaymentAttemptPurposeEnum> _$paymentAttemptPurposeEnumSerializer =
    _$PaymentAttemptPurposeEnumSerializer();
Serializer<PaymentAttemptStatusEnum> _$paymentAttemptStatusEnumSerializer =
    _$PaymentAttemptStatusEnumSerializer();
Serializer<PaymentAttemptFeeBearerEnum>
    _$paymentAttemptFeeBearerEnumSerializer =
    _$PaymentAttemptFeeBearerEnumSerializer();
Serializer<PaymentAttemptEnvironmentEnum>
    _$paymentAttemptEnvironmentEnumSerializer =
    _$PaymentAttemptEnvironmentEnumSerializer();
Serializer<PaymentAttemptEvidenceOriginEnum>
    _$paymentAttemptEvidenceOriginEnumSerializer =
    _$PaymentAttemptEvidenceOriginEnumSerializer();

class _$PaymentAttemptPurposeEnumSerializer
    implements PrimitiveSerializer<PaymentAttemptPurposeEnum> {
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
  final Iterable<Type> types = const <Type>[PaymentAttemptPurposeEnum];
  @override
  final String wireName = 'PaymentAttemptPurposeEnum';

  @override
  Object serialize(Serializers serializers, PaymentAttemptPurposeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PaymentAttemptPurposeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PaymentAttemptPurposeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PaymentAttemptStatusEnumSerializer
    implements PrimitiveSerializer<PaymentAttemptStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PENDING': 'PENDING',
    'PAID': 'PAID',
    'FAILED': 'FAILED',
    'EXPIRED': 'EXPIRED',
    'CAPTURED_LATE_REFUND_PENDING': 'CAPTURED_LATE_REFUND_PENDING',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PENDING': 'PENDING',
    'PAID': 'PAID',
    'FAILED': 'FAILED',
    'EXPIRED': 'EXPIRED',
    'CAPTURED_LATE_REFUND_PENDING': 'CAPTURED_LATE_REFUND_PENDING',
  };

  @override
  final Iterable<Type> types = const <Type>[PaymentAttemptStatusEnum];
  @override
  final String wireName = 'PaymentAttemptStatusEnum';

  @override
  Object serialize(Serializers serializers, PaymentAttemptStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PaymentAttemptStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PaymentAttemptStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PaymentAttemptFeeBearerEnumSerializer
    implements PrimitiveSerializer<PaymentAttemptFeeBearerEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'BUYER': 'BUYER',
    'PLATFORM': 'PLATFORM',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'BUYER': 'BUYER',
    'PLATFORM': 'PLATFORM',
  };

  @override
  final Iterable<Type> types = const <Type>[PaymentAttemptFeeBearerEnum];
  @override
  final String wireName = 'PaymentAttemptFeeBearerEnum';

  @override
  Object serialize(Serializers serializers, PaymentAttemptFeeBearerEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PaymentAttemptFeeBearerEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PaymentAttemptFeeBearerEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PaymentAttemptEnvironmentEnumSerializer
    implements PrimitiveSerializer<PaymentAttemptEnvironmentEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'TEST': 'TEST',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'TEST': 'TEST',
  };

  @override
  final Iterable<Type> types = const <Type>[PaymentAttemptEnvironmentEnum];
  @override
  final String wireName = 'PaymentAttemptEnvironmentEnum';

  @override
  Object serialize(
          Serializers serializers, PaymentAttemptEnvironmentEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PaymentAttemptEnvironmentEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PaymentAttemptEnvironmentEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PaymentAttemptEvidenceOriginEnumSerializer
    implements PrimitiveSerializer<PaymentAttemptEvidenceOriginEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'XENDIT_TEST': 'XENDIT_TEST',
    'SIMULATED': 'SIMULATED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'XENDIT_TEST': 'XENDIT_TEST',
    'SIMULATED': 'SIMULATED',
  };

  @override
  final Iterable<Type> types = const <Type>[PaymentAttemptEvidenceOriginEnum];
  @override
  final String wireName = 'PaymentAttemptEvidenceOriginEnum';

  @override
  Object serialize(
          Serializers serializers, PaymentAttemptEvidenceOriginEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PaymentAttemptEvidenceOriginEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PaymentAttemptEvidenceOriginEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PaymentAttempt extends PaymentAttempt {
  @override
  final String id;
  @override
  final PaymentAttemptPurposeEnum purpose;
  @override
  final PaymentAttemptStatusEnum status;
  @override
  final int attemptNumber;
  @override
  final String? orderId;
  @override
  final String? statementId;
  @override
  final String? channelCode;
  @override
  final String? channelName;
  @override
  final int principalCentavos;
  @override
  final int processingFeeCentavos;
  @override
  final int totalCentavos;
  @override
  final PaymentAttemptFeeBearerEnum feeBearer;
  @override
  final DateTime? expiresAt;
  @override
  final DateTime? paidAt;
  @override
  final DateTime? createdAt;
  @override
  final PaymentAttemptEnvironmentEnum environment;
  @override
  final PaymentAttemptEvidenceOriginEnum evidenceOrigin;
  @override
  final String? checkoutUrl;
  @override
  final bool canCheckStatus;
  @override
  final String message;

  factory _$PaymentAttempt([void Function(PaymentAttemptBuilder)? updates]) =>
      (PaymentAttemptBuilder()..update(updates))._build();

  _$PaymentAttempt._(
      {required this.id,
      required this.purpose,
      required this.status,
      required this.attemptNumber,
      this.orderId,
      this.statementId,
      this.channelCode,
      this.channelName,
      required this.principalCentavos,
      required this.processingFeeCentavos,
      required this.totalCentavos,
      required this.feeBearer,
      this.expiresAt,
      this.paidAt,
      this.createdAt,
      required this.environment,
      required this.evidenceOrigin,
      this.checkoutUrl,
      required this.canCheckStatus,
      required this.message})
      : super._();
  @override
  PaymentAttempt rebuild(void Function(PaymentAttemptBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PaymentAttemptBuilder toBuilder() => PaymentAttemptBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PaymentAttempt &&
        id == other.id &&
        purpose == other.purpose &&
        status == other.status &&
        attemptNumber == other.attemptNumber &&
        orderId == other.orderId &&
        statementId == other.statementId &&
        channelCode == other.channelCode &&
        channelName == other.channelName &&
        principalCentavos == other.principalCentavos &&
        processingFeeCentavos == other.processingFeeCentavos &&
        totalCentavos == other.totalCentavos &&
        feeBearer == other.feeBearer &&
        expiresAt == other.expiresAt &&
        paidAt == other.paidAt &&
        createdAt == other.createdAt &&
        environment == other.environment &&
        evidenceOrigin == other.evidenceOrigin &&
        checkoutUrl == other.checkoutUrl &&
        canCheckStatus == other.canCheckStatus &&
        message == other.message;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, purpose.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, attemptNumber.hashCode);
    _$hash = $jc(_$hash, orderId.hashCode);
    _$hash = $jc(_$hash, statementId.hashCode);
    _$hash = $jc(_$hash, channelCode.hashCode);
    _$hash = $jc(_$hash, channelName.hashCode);
    _$hash = $jc(_$hash, principalCentavos.hashCode);
    _$hash = $jc(_$hash, processingFeeCentavos.hashCode);
    _$hash = $jc(_$hash, totalCentavos.hashCode);
    _$hash = $jc(_$hash, feeBearer.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jc(_$hash, paidAt.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, environment.hashCode);
    _$hash = $jc(_$hash, evidenceOrigin.hashCode);
    _$hash = $jc(_$hash, checkoutUrl.hashCode);
    _$hash = $jc(_$hash, canCheckStatus.hashCode);
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PaymentAttempt')
          ..add('id', id)
          ..add('purpose', purpose)
          ..add('status', status)
          ..add('attemptNumber', attemptNumber)
          ..add('orderId', orderId)
          ..add('statementId', statementId)
          ..add('channelCode', channelCode)
          ..add('channelName', channelName)
          ..add('principalCentavos', principalCentavos)
          ..add('processingFeeCentavos', processingFeeCentavos)
          ..add('totalCentavos', totalCentavos)
          ..add('feeBearer', feeBearer)
          ..add('expiresAt', expiresAt)
          ..add('paidAt', paidAt)
          ..add('createdAt', createdAt)
          ..add('environment', environment)
          ..add('evidenceOrigin', evidenceOrigin)
          ..add('checkoutUrl', checkoutUrl)
          ..add('canCheckStatus', canCheckStatus)
          ..add('message', message))
        .toString();
  }
}

class PaymentAttemptBuilder
    implements Builder<PaymentAttempt, PaymentAttemptBuilder> {
  _$PaymentAttempt? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  PaymentAttemptPurposeEnum? _purpose;
  PaymentAttemptPurposeEnum? get purpose => _$this._purpose;
  set purpose(PaymentAttemptPurposeEnum? purpose) => _$this._purpose = purpose;

  PaymentAttemptStatusEnum? _status;
  PaymentAttemptStatusEnum? get status => _$this._status;
  set status(PaymentAttemptStatusEnum? status) => _$this._status = status;

  int? _attemptNumber;
  int? get attemptNumber => _$this._attemptNumber;
  set attemptNumber(int? attemptNumber) =>
      _$this._attemptNumber = attemptNumber;

  String? _orderId;
  String? get orderId => _$this._orderId;
  set orderId(String? orderId) => _$this._orderId = orderId;

  String? _statementId;
  String? get statementId => _$this._statementId;
  set statementId(String? statementId) => _$this._statementId = statementId;

  String? _channelCode;
  String? get channelCode => _$this._channelCode;
  set channelCode(String? channelCode) => _$this._channelCode = channelCode;

  String? _channelName;
  String? get channelName => _$this._channelName;
  set channelName(String? channelName) => _$this._channelName = channelName;

  int? _principalCentavos;
  int? get principalCentavos => _$this._principalCentavos;
  set principalCentavos(int? principalCentavos) =>
      _$this._principalCentavos = principalCentavos;

  int? _processingFeeCentavos;
  int? get processingFeeCentavos => _$this._processingFeeCentavos;
  set processingFeeCentavos(int? processingFeeCentavos) =>
      _$this._processingFeeCentavos = processingFeeCentavos;

  int? _totalCentavos;
  int? get totalCentavos => _$this._totalCentavos;
  set totalCentavos(int? totalCentavos) =>
      _$this._totalCentavos = totalCentavos;

  PaymentAttemptFeeBearerEnum? _feeBearer;
  PaymentAttemptFeeBearerEnum? get feeBearer => _$this._feeBearer;
  set feeBearer(PaymentAttemptFeeBearerEnum? feeBearer) =>
      _$this._feeBearer = feeBearer;

  DateTime? _expiresAt;
  DateTime? get expiresAt => _$this._expiresAt;
  set expiresAt(DateTime? expiresAt) => _$this._expiresAt = expiresAt;

  DateTime? _paidAt;
  DateTime? get paidAt => _$this._paidAt;
  set paidAt(DateTime? paidAt) => _$this._paidAt = paidAt;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  PaymentAttemptEnvironmentEnum? _environment;
  PaymentAttemptEnvironmentEnum? get environment => _$this._environment;
  set environment(PaymentAttemptEnvironmentEnum? environment) =>
      _$this._environment = environment;

  PaymentAttemptEvidenceOriginEnum? _evidenceOrigin;
  PaymentAttemptEvidenceOriginEnum? get evidenceOrigin =>
      _$this._evidenceOrigin;
  set evidenceOrigin(PaymentAttemptEvidenceOriginEnum? evidenceOrigin) =>
      _$this._evidenceOrigin = evidenceOrigin;

  String? _checkoutUrl;
  String? get checkoutUrl => _$this._checkoutUrl;
  set checkoutUrl(String? checkoutUrl) => _$this._checkoutUrl = checkoutUrl;

  bool? _canCheckStatus;
  bool? get canCheckStatus => _$this._canCheckStatus;
  set canCheckStatus(bool? canCheckStatus) =>
      _$this._canCheckStatus = canCheckStatus;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  PaymentAttemptBuilder() {
    PaymentAttempt._defaults(this);
  }

  PaymentAttemptBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _purpose = $v.purpose;
      _status = $v.status;
      _attemptNumber = $v.attemptNumber;
      _orderId = $v.orderId;
      _statementId = $v.statementId;
      _channelCode = $v.channelCode;
      _channelName = $v.channelName;
      _principalCentavos = $v.principalCentavos;
      _processingFeeCentavos = $v.processingFeeCentavos;
      _totalCentavos = $v.totalCentavos;
      _feeBearer = $v.feeBearer;
      _expiresAt = $v.expiresAt;
      _paidAt = $v.paidAt;
      _createdAt = $v.createdAt;
      _environment = $v.environment;
      _evidenceOrigin = $v.evidenceOrigin;
      _checkoutUrl = $v.checkoutUrl;
      _canCheckStatus = $v.canCheckStatus;
      _message = $v.message;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PaymentAttempt other) {
    _$v = other as _$PaymentAttempt;
  }

  @override
  void update(void Function(PaymentAttemptBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PaymentAttempt build() => _build();

  _$PaymentAttempt _build() {
    final _$result = _$v ??
        _$PaymentAttempt._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'PaymentAttempt', 'id'),
          purpose: BuiltValueNullFieldError.checkNotNull(
              purpose, r'PaymentAttempt', 'purpose'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'PaymentAttempt', 'status'),
          attemptNumber: BuiltValueNullFieldError.checkNotNull(
              attemptNumber, r'PaymentAttempt', 'attemptNumber'),
          orderId: orderId,
          statementId: statementId,
          channelCode: channelCode,
          channelName: channelName,
          principalCentavos: BuiltValueNullFieldError.checkNotNull(
              principalCentavos, r'PaymentAttempt', 'principalCentavos'),
          processingFeeCentavos: BuiltValueNullFieldError.checkNotNull(
              processingFeeCentavos,
              r'PaymentAttempt',
              'processingFeeCentavos'),
          totalCentavos: BuiltValueNullFieldError.checkNotNull(
              totalCentavos, r'PaymentAttempt', 'totalCentavos'),
          feeBearer: BuiltValueNullFieldError.checkNotNull(
              feeBearer, r'PaymentAttempt', 'feeBearer'),
          expiresAt: expiresAt,
          paidAt: paidAt,
          createdAt: createdAt,
          environment: BuiltValueNullFieldError.checkNotNull(
              environment, r'PaymentAttempt', 'environment'),
          evidenceOrigin: BuiltValueNullFieldError.checkNotNull(
              evidenceOrigin, r'PaymentAttempt', 'evidenceOrigin'),
          checkoutUrl: checkoutUrl,
          canCheckStatus: BuiltValueNullFieldError.checkNotNull(
              canCheckStatus, r'PaymentAttempt', 'canCheckStatus'),
          message: BuiltValueNullFieldError.checkNotNull(
              message, r'PaymentAttempt', 'message'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
