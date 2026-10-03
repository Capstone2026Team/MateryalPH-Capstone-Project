// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feature_availability.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const FeatureAvailabilityStatusEnum
    _$featureAvailabilityStatusEnum_NOT_YET_AVAILABLE =
    const FeatureAvailabilityStatusEnum._('NOT_YET_AVAILABLE');
const FeatureAvailabilityStatusEnum _$featureAvailabilityStatusEnum_AVAILABLE =
    const FeatureAvailabilityStatusEnum._('AVAILABLE');

FeatureAvailabilityStatusEnum _$featureAvailabilityStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'NOT_YET_AVAILABLE':
      return _$featureAvailabilityStatusEnum_NOT_YET_AVAILABLE;
    case 'AVAILABLE':
      return _$featureAvailabilityStatusEnum_AVAILABLE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<FeatureAvailabilityStatusEnum>
    _$featureAvailabilityStatusEnumValues = BuiltSet<
        FeatureAvailabilityStatusEnum>(const <FeatureAvailabilityStatusEnum>[
  _$featureAvailabilityStatusEnum_NOT_YET_AVAILABLE,
  _$featureAvailabilityStatusEnum_AVAILABLE,
]);

Serializer<FeatureAvailabilityStatusEnum>
    _$featureAvailabilityStatusEnumSerializer =
    _$FeatureAvailabilityStatusEnumSerializer();

class _$FeatureAvailabilityStatusEnumSerializer
    implements PrimitiveSerializer<FeatureAvailabilityStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'NOT_YET_AVAILABLE': 'NOT_YET_AVAILABLE',
    'AVAILABLE': 'AVAILABLE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'NOT_YET_AVAILABLE': 'NOT_YET_AVAILABLE',
    'AVAILABLE': 'AVAILABLE',
  };

  @override
  final Iterable<Type> types = const <Type>[FeatureAvailabilityStatusEnum];
  @override
  final String wireName = 'FeatureAvailabilityStatusEnum';

  @override
  Object serialize(
          Serializers serializers, FeatureAvailabilityStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  FeatureAvailabilityStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      FeatureAvailabilityStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$FeatureAvailability extends FeatureAvailability {
  @override
  final bool enabled;
  @override
  final FeatureAvailabilityStatusEnum status;
  @override
  final String message;

  factory _$FeatureAvailability(
          [void Function(FeatureAvailabilityBuilder)? updates]) =>
      (FeatureAvailabilityBuilder()..update(updates))._build();

  _$FeatureAvailability._(
      {required this.enabled, required this.status, required this.message})
      : super._();
  @override
  FeatureAvailability rebuild(
          void Function(FeatureAvailabilityBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FeatureAvailabilityBuilder toBuilder() =>
      FeatureAvailabilityBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FeatureAvailability &&
        enabled == other.enabled &&
        status == other.status &&
        message == other.message;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, enabled.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FeatureAvailability')
          ..add('enabled', enabled)
          ..add('status', status)
          ..add('message', message))
        .toString();
  }
}

class FeatureAvailabilityBuilder
    implements Builder<FeatureAvailability, FeatureAvailabilityBuilder> {
  _$FeatureAvailability? _$v;

  bool? _enabled;
  bool? get enabled => _$this._enabled;
  set enabled(bool? enabled) => _$this._enabled = enabled;

  FeatureAvailabilityStatusEnum? _status;
  FeatureAvailabilityStatusEnum? get status => _$this._status;
  set status(FeatureAvailabilityStatusEnum? status) => _$this._status = status;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  FeatureAvailabilityBuilder() {
    FeatureAvailability._defaults(this);
  }

  FeatureAvailabilityBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _enabled = $v.enabled;
      _status = $v.status;
      _message = $v.message;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FeatureAvailability other) {
    _$v = other as _$FeatureAvailability;
  }

  @override
  void update(void Function(FeatureAvailabilityBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FeatureAvailability build() => _build();

  _$FeatureAvailability _build() {
    final _$result = _$v ??
        _$FeatureAvailability._(
          enabled: BuiltValueNullFieldError.checkNotNull(
              enabled, r'FeatureAvailability', 'enabled'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'FeatureAvailability', 'status'),
          message: BuiltValueNullFieldError.checkNotNull(
              message, r'FeatureAvailability', 'message'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
