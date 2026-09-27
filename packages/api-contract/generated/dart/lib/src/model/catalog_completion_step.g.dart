// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_completion_step.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CatalogCompletionStepLevelEnum _$catalogCompletionStepLevelEnum_REQUIRED =
    const CatalogCompletionStepLevelEnum._('REQUIRED');
const CatalogCompletionStepLevelEnum
    _$catalogCompletionStepLevelEnum_CONDITIONALLY_REQUIRED =
    const CatalogCompletionStepLevelEnum._('CONDITIONALLY_REQUIRED');

CatalogCompletionStepLevelEnum _$catalogCompletionStepLevelEnumValueOf(
    String name) {
  switch (name) {
    case 'REQUIRED':
      return _$catalogCompletionStepLevelEnum_REQUIRED;
    case 'CONDITIONALLY_REQUIRED':
      return _$catalogCompletionStepLevelEnum_CONDITIONALLY_REQUIRED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CatalogCompletionStepLevelEnum>
    _$catalogCompletionStepLevelEnumValues = BuiltSet<
        CatalogCompletionStepLevelEnum>(const <CatalogCompletionStepLevelEnum>[
  _$catalogCompletionStepLevelEnum_REQUIRED,
  _$catalogCompletionStepLevelEnum_CONDITIONALLY_REQUIRED,
]);

Serializer<CatalogCompletionStepLevelEnum>
    _$catalogCompletionStepLevelEnumSerializer =
    _$CatalogCompletionStepLevelEnumSerializer();

class _$CatalogCompletionStepLevelEnumSerializer
    implements PrimitiveSerializer<CatalogCompletionStepLevelEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'REQUIRED': 'REQUIRED',
    'CONDITIONALLY_REQUIRED': 'CONDITIONALLY_REQUIRED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'REQUIRED': 'REQUIRED',
    'CONDITIONALLY_REQUIRED': 'CONDITIONALLY_REQUIRED',
  };

  @override
  final Iterable<Type> types = const <Type>[CatalogCompletionStepLevelEnum];
  @override
  final String wireName = 'CatalogCompletionStepLevelEnum';

  @override
  Object serialize(
          Serializers serializers, CatalogCompletionStepLevelEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CatalogCompletionStepLevelEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CatalogCompletionStepLevelEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CatalogCompletionStep extends CatalogCompletionStep {
  @override
  final String key;
  @override
  final String label;
  @override
  final CatalogCompletionStepLevelEnum level;
  @override
  final String status;
  @override
  final String? reason;

  factory _$CatalogCompletionStep(
          [void Function(CatalogCompletionStepBuilder)? updates]) =>
      (CatalogCompletionStepBuilder()..update(updates))._build();

  _$CatalogCompletionStep._(
      {required this.key,
      required this.label,
      required this.level,
      required this.status,
      this.reason})
      : super._();
  @override
  CatalogCompletionStep rebuild(
          void Function(CatalogCompletionStepBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CatalogCompletionStepBuilder toBuilder() =>
      CatalogCompletionStepBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CatalogCompletionStep &&
        key == other.key &&
        label == other.label &&
        level == other.level &&
        status == other.status &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, key.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, level.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CatalogCompletionStep')
          ..add('key', key)
          ..add('label', label)
          ..add('level', level)
          ..add('status', status)
          ..add('reason', reason))
        .toString();
  }
}

class CatalogCompletionStepBuilder
    implements Builder<CatalogCompletionStep, CatalogCompletionStepBuilder> {
  _$CatalogCompletionStep? _$v;

  String? _key;
  String? get key => _$this._key;
  set key(String? key) => _$this._key = key;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  CatalogCompletionStepLevelEnum? _level;
  CatalogCompletionStepLevelEnum? get level => _$this._level;
  set level(CatalogCompletionStepLevelEnum? level) => _$this._level = level;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  CatalogCompletionStepBuilder() {
    CatalogCompletionStep._defaults(this);
  }

  CatalogCompletionStepBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _key = $v.key;
      _label = $v.label;
      _level = $v.level;
      _status = $v.status;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CatalogCompletionStep other) {
    _$v = other as _$CatalogCompletionStep;
  }

  @override
  void update(void Function(CatalogCompletionStepBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CatalogCompletionStep build() => _build();

  _$CatalogCompletionStep _build() {
    final _$result = _$v ??
        _$CatalogCompletionStep._(
          key: BuiltValueNullFieldError.checkNotNull(
              key, r'CatalogCompletionStep', 'key'),
          label: BuiltValueNullFieldError.checkNotNull(
              label, r'CatalogCompletionStep', 'label'),
          level: BuiltValueNullFieldError.checkNotNull(
              level, r'CatalogCompletionStep', 'level'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'CatalogCompletionStep', 'status'),
          reason: reason,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
