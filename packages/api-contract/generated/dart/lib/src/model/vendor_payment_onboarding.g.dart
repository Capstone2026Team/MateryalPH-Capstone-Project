// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_payment_onboarding.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const VendorPaymentOnboardingStatusEnum
    _$vendorPaymentOnboardingStatusEnum_NOT_CONNECTED =
    const VendorPaymentOnboardingStatusEnum._('NOT_CONNECTED');
const VendorPaymentOnboardingStatusEnum
    _$vendorPaymentOnboardingStatusEnum_CONNECTING =
    const VendorPaymentOnboardingStatusEnum._('CONNECTING');
const VendorPaymentOnboardingStatusEnum
    _$vendorPaymentOnboardingStatusEnum_PENDING =
    const VendorPaymentOnboardingStatusEnum._('PENDING');
const VendorPaymentOnboardingStatusEnum
    _$vendorPaymentOnboardingStatusEnum_CONNECTED_TEST =
    const VendorPaymentOnboardingStatusEnum._('CONNECTED_TEST');
const VendorPaymentOnboardingStatusEnum
    _$vendorPaymentOnboardingStatusEnum_CONNECTION_FAILED =
    const VendorPaymentOnboardingStatusEnum._('CONNECTION_FAILED');

VendorPaymentOnboardingStatusEnum _$vendorPaymentOnboardingStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'NOT_CONNECTED':
      return _$vendorPaymentOnboardingStatusEnum_NOT_CONNECTED;
    case 'CONNECTING':
      return _$vendorPaymentOnboardingStatusEnum_CONNECTING;
    case 'PENDING':
      return _$vendorPaymentOnboardingStatusEnum_PENDING;
    case 'CONNECTED_TEST':
      return _$vendorPaymentOnboardingStatusEnum_CONNECTED_TEST;
    case 'CONNECTION_FAILED':
      return _$vendorPaymentOnboardingStatusEnum_CONNECTION_FAILED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<VendorPaymentOnboardingStatusEnum>
    _$vendorPaymentOnboardingStatusEnumValues = BuiltSet<
        VendorPaymentOnboardingStatusEnum>(const <VendorPaymentOnboardingStatusEnum>[
  _$vendorPaymentOnboardingStatusEnum_NOT_CONNECTED,
  _$vendorPaymentOnboardingStatusEnum_CONNECTING,
  _$vendorPaymentOnboardingStatusEnum_PENDING,
  _$vendorPaymentOnboardingStatusEnum_CONNECTED_TEST,
  _$vendorPaymentOnboardingStatusEnum_CONNECTION_FAILED,
]);

const VendorPaymentOnboardingEnvironmentEnum
    _$vendorPaymentOnboardingEnvironmentEnum_TEST =
    const VendorPaymentOnboardingEnvironmentEnum._('TEST');

VendorPaymentOnboardingEnvironmentEnum
    _$vendorPaymentOnboardingEnvironmentEnumValueOf(String name) {
  switch (name) {
    case 'TEST':
      return _$vendorPaymentOnboardingEnvironmentEnum_TEST;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<VendorPaymentOnboardingEnvironmentEnum>
    _$vendorPaymentOnboardingEnvironmentEnumValues = BuiltSet<
        VendorPaymentOnboardingEnvironmentEnum>(const <VendorPaymentOnboardingEnvironmentEnum>[
  _$vendorPaymentOnboardingEnvironmentEnum_TEST,
]);

Serializer<VendorPaymentOnboardingStatusEnum>
    _$vendorPaymentOnboardingStatusEnumSerializer =
    _$VendorPaymentOnboardingStatusEnumSerializer();
Serializer<VendorPaymentOnboardingEnvironmentEnum>
    _$vendorPaymentOnboardingEnvironmentEnumSerializer =
    _$VendorPaymentOnboardingEnvironmentEnumSerializer();

class _$VendorPaymentOnboardingStatusEnumSerializer
    implements PrimitiveSerializer<VendorPaymentOnboardingStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'NOT_CONNECTED': 'NOT_CONNECTED',
    'CONNECTING': 'CONNECTING',
    'PENDING': 'PENDING',
    'CONNECTED_TEST': 'CONNECTED_TEST',
    'CONNECTION_FAILED': 'CONNECTION_FAILED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'NOT_CONNECTED': 'NOT_CONNECTED',
    'CONNECTING': 'CONNECTING',
    'PENDING': 'PENDING',
    'CONNECTED_TEST': 'CONNECTED_TEST',
    'CONNECTION_FAILED': 'CONNECTION_FAILED',
  };

  @override
  final Iterable<Type> types = const <Type>[VendorPaymentOnboardingStatusEnum];
  @override
  final String wireName = 'VendorPaymentOnboardingStatusEnum';

  @override
  Object serialize(
          Serializers serializers, VendorPaymentOnboardingStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  VendorPaymentOnboardingStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      VendorPaymentOnboardingStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$VendorPaymentOnboardingEnvironmentEnumSerializer
    implements PrimitiveSerializer<VendorPaymentOnboardingEnvironmentEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'TEST': 'TEST',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'TEST': 'TEST',
  };

  @override
  final Iterable<Type> types = const <Type>[
    VendorPaymentOnboardingEnvironmentEnum
  ];
  @override
  final String wireName = 'VendorPaymentOnboardingEnvironmentEnum';

  @override
  Object serialize(Serializers serializers,
          VendorPaymentOnboardingEnvironmentEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  VendorPaymentOnboardingEnvironmentEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      VendorPaymentOnboardingEnvironmentEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$VendorPaymentOnboarding extends VendorPaymentOnboarding {
  @override
  final VendorPaymentOnboardingStatusEnum status;
  @override
  final VendorPaymentOnboardingEnvironmentEnum environment;

  factory _$VendorPaymentOnboarding(
          [void Function(VendorPaymentOnboardingBuilder)? updates]) =>
      (VendorPaymentOnboardingBuilder()..update(updates))._build();

  _$VendorPaymentOnboarding._({required this.status, required this.environment})
      : super._();
  @override
  VendorPaymentOnboarding rebuild(
          void Function(VendorPaymentOnboardingBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorPaymentOnboardingBuilder toBuilder() =>
      VendorPaymentOnboardingBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorPaymentOnboarding &&
        status == other.status &&
        environment == other.environment;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, environment.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorPaymentOnboarding')
          ..add('status', status)
          ..add('environment', environment))
        .toString();
  }
}

class VendorPaymentOnboardingBuilder
    implements
        Builder<VendorPaymentOnboarding, VendorPaymentOnboardingBuilder> {
  _$VendorPaymentOnboarding? _$v;

  VendorPaymentOnboardingStatusEnum? _status;
  VendorPaymentOnboardingStatusEnum? get status => _$this._status;
  set status(VendorPaymentOnboardingStatusEnum? status) =>
      _$this._status = status;

  VendorPaymentOnboardingEnvironmentEnum? _environment;
  VendorPaymentOnboardingEnvironmentEnum? get environment =>
      _$this._environment;
  set environment(VendorPaymentOnboardingEnvironmentEnum? environment) =>
      _$this._environment = environment;

  VendorPaymentOnboardingBuilder() {
    VendorPaymentOnboarding._defaults(this);
  }

  VendorPaymentOnboardingBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _environment = $v.environment;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorPaymentOnboarding other) {
    _$v = other as _$VendorPaymentOnboarding;
  }

  @override
  void update(void Function(VendorPaymentOnboardingBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorPaymentOnboarding build() => _build();

  _$VendorPaymentOnboarding _build() {
    final _$result = _$v ??
        _$VendorPaymentOnboarding._(
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'VendorPaymentOnboarding', 'status'),
          environment: BuiltValueNullFieldError.checkNotNull(
              environment, r'VendorPaymentOnboarding', 'environment'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
