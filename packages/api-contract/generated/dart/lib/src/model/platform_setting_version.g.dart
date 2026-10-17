// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'platform_setting_version.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PlatformSettingVersionSource_Enum
    _$platformSettingVersionSourceEnum_SEED =
    const PlatformSettingVersionSource_Enum._('SEED');
const PlatformSettingVersionSource_Enum
    _$platformSettingVersionSourceEnum_ADMIN =
    const PlatformSettingVersionSource_Enum._('ADMIN');

PlatformSettingVersionSource_Enum _$platformSettingVersionSourceEnumValueOf(
    String name) {
  switch (name) {
    case 'SEED':
      return _$platformSettingVersionSourceEnum_SEED;
    case 'ADMIN':
      return _$platformSettingVersionSourceEnum_ADMIN;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PlatformSettingVersionSource_Enum>
    _$platformSettingVersionSourceEnumValues = BuiltSet<
        PlatformSettingVersionSource_Enum>(const <PlatformSettingVersionSource_Enum>[
  _$platformSettingVersionSourceEnum_SEED,
  _$platformSettingVersionSourceEnum_ADMIN,
]);

Serializer<PlatformSettingVersionSource_Enum>
    _$platformSettingVersionSourceEnumSerializer =
    _$PlatformSettingVersionSource_EnumSerializer();

class _$PlatformSettingVersionSource_EnumSerializer
    implements PrimitiveSerializer<PlatformSettingVersionSource_Enum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'SEED': 'SEED',
    'ADMIN': 'ADMIN',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'SEED': 'SEED',
    'ADMIN': 'ADMIN',
  };

  @override
  final Iterable<Type> types = const <Type>[PlatformSettingVersionSource_Enum];
  @override
  final String wireName = 'PlatformSettingVersionSource_Enum';

  @override
  Object serialize(
          Serializers serializers, PlatformSettingVersionSource_Enum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PlatformSettingVersionSource_Enum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PlatformSettingVersionSource_Enum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PlatformSettingVersion extends PlatformSettingVersion {
  @override
  final int version;
  @override
  final JsonObject? value;
  @override
  final JsonObject? previousValue;
  @override
  final PlatformSettingVersionSource_Enum source_;
  @override
  final String reason;
  @override
  final String? changedBy;
  @override
  final String? changedRole;
  @override
  final String? correlationId;
  @override
  final DateTime effectiveFrom;

  factory _$PlatformSettingVersion(
          [void Function(PlatformSettingVersionBuilder)? updates]) =>
      (PlatformSettingVersionBuilder()..update(updates))._build();

  _$PlatformSettingVersion._(
      {required this.version,
      this.value,
      this.previousValue,
      required this.source_,
      required this.reason,
      this.changedBy,
      this.changedRole,
      this.correlationId,
      required this.effectiveFrom})
      : super._();
  @override
  PlatformSettingVersion rebuild(
          void Function(PlatformSettingVersionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PlatformSettingVersionBuilder toBuilder() =>
      PlatformSettingVersionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PlatformSettingVersion &&
        version == other.version &&
        value == other.value &&
        previousValue == other.previousValue &&
        source_ == other.source_ &&
        reason == other.reason &&
        changedBy == other.changedBy &&
        changedRole == other.changedRole &&
        correlationId == other.correlationId &&
        effectiveFrom == other.effectiveFrom;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, version.hashCode);
    _$hash = $jc(_$hash, value.hashCode);
    _$hash = $jc(_$hash, previousValue.hashCode);
    _$hash = $jc(_$hash, source_.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, changedBy.hashCode);
    _$hash = $jc(_$hash, changedRole.hashCode);
    _$hash = $jc(_$hash, correlationId.hashCode);
    _$hash = $jc(_$hash, effectiveFrom.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PlatformSettingVersion')
          ..add('version', version)
          ..add('value', value)
          ..add('previousValue', previousValue)
          ..add('source_', source_)
          ..add('reason', reason)
          ..add('changedBy', changedBy)
          ..add('changedRole', changedRole)
          ..add('correlationId', correlationId)
          ..add('effectiveFrom', effectiveFrom))
        .toString();
  }
}

class PlatformSettingVersionBuilder
    implements Builder<PlatformSettingVersion, PlatformSettingVersionBuilder> {
  _$PlatformSettingVersion? _$v;

  int? _version;
  int? get version => _$this._version;
  set version(int? version) => _$this._version = version;

  JsonObject? _value;
  JsonObject? get value => _$this._value;
  set value(JsonObject? value) => _$this._value = value;

  JsonObject? _previousValue;
  JsonObject? get previousValue => _$this._previousValue;
  set previousValue(JsonObject? previousValue) =>
      _$this._previousValue = previousValue;

  PlatformSettingVersionSource_Enum? _source_;
  PlatformSettingVersionSource_Enum? get source_ => _$this._source_;
  set source_(PlatformSettingVersionSource_Enum? source_) =>
      _$this._source_ = source_;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  String? _changedBy;
  String? get changedBy => _$this._changedBy;
  set changedBy(String? changedBy) => _$this._changedBy = changedBy;

  String? _changedRole;
  String? get changedRole => _$this._changedRole;
  set changedRole(String? changedRole) => _$this._changedRole = changedRole;

  String? _correlationId;
  String? get correlationId => _$this._correlationId;
  set correlationId(String? correlationId) =>
      _$this._correlationId = correlationId;

  DateTime? _effectiveFrom;
  DateTime? get effectiveFrom => _$this._effectiveFrom;
  set effectiveFrom(DateTime? effectiveFrom) =>
      _$this._effectiveFrom = effectiveFrom;

  PlatformSettingVersionBuilder() {
    PlatformSettingVersion._defaults(this);
  }

  PlatformSettingVersionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _version = $v.version;
      _value = $v.value;
      _previousValue = $v.previousValue;
      _source_ = $v.source_;
      _reason = $v.reason;
      _changedBy = $v.changedBy;
      _changedRole = $v.changedRole;
      _correlationId = $v.correlationId;
      _effectiveFrom = $v.effectiveFrom;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PlatformSettingVersion other) {
    _$v = other as _$PlatformSettingVersion;
  }

  @override
  void update(void Function(PlatformSettingVersionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PlatformSettingVersion build() => _build();

  _$PlatformSettingVersion _build() {
    final _$result = _$v ??
        _$PlatformSettingVersion._(
          version: BuiltValueNullFieldError.checkNotNull(
              version, r'PlatformSettingVersion', 'version'),
          value: value,
          previousValue: previousValue,
          source_: BuiltValueNullFieldError.checkNotNull(
              source_, r'PlatformSettingVersion', 'source_'),
          reason: BuiltValueNullFieldError.checkNotNull(
              reason, r'PlatformSettingVersion', 'reason'),
          changedBy: changedBy,
          changedRole: changedRole,
          correlationId: correlationId,
          effectiveFrom: BuiltValueNullFieldError.checkNotNull(
              effectiveFrom, r'PlatformSettingVersion', 'effectiveFrom'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
