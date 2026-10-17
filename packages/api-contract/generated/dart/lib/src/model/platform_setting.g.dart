// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'platform_setting.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PlatformSetting extends PlatformSetting {
  @override
  final String key;
  @override
  final String group;
  @override
  final String label;
  @override
  final String description;
  @override
  final String validationRule;
  @override
  final String appliesTo;
  @override
  final JsonObject? value;
  @override
  final JsonObject? defaultValue;
  @override
  final int version;
  @override
  final JsonObject? previousValue;
  @override
  final String? lastReason;
  @override
  final DateTime? updatedAt;
  @override
  final String? updatedBy;
  @override
  final bool editable;

  factory _$PlatformSetting([void Function(PlatformSettingBuilder)? updates]) =>
      (PlatformSettingBuilder()..update(updates))._build();

  _$PlatformSetting._(
      {required this.key,
      required this.group,
      required this.label,
      required this.description,
      required this.validationRule,
      required this.appliesTo,
      this.value,
      this.defaultValue,
      required this.version,
      this.previousValue,
      this.lastReason,
      this.updatedAt,
      this.updatedBy,
      required this.editable})
      : super._();
  @override
  PlatformSetting rebuild(void Function(PlatformSettingBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PlatformSettingBuilder toBuilder() => PlatformSettingBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PlatformSetting &&
        key == other.key &&
        group == other.group &&
        label == other.label &&
        description == other.description &&
        validationRule == other.validationRule &&
        appliesTo == other.appliesTo &&
        value == other.value &&
        defaultValue == other.defaultValue &&
        version == other.version &&
        previousValue == other.previousValue &&
        lastReason == other.lastReason &&
        updatedAt == other.updatedAt &&
        updatedBy == other.updatedBy &&
        editable == other.editable;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, key.hashCode);
    _$hash = $jc(_$hash, group.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, validationRule.hashCode);
    _$hash = $jc(_$hash, appliesTo.hashCode);
    _$hash = $jc(_$hash, value.hashCode);
    _$hash = $jc(_$hash, defaultValue.hashCode);
    _$hash = $jc(_$hash, version.hashCode);
    _$hash = $jc(_$hash, previousValue.hashCode);
    _$hash = $jc(_$hash, lastReason.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jc(_$hash, updatedBy.hashCode);
    _$hash = $jc(_$hash, editable.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PlatformSetting')
          ..add('key', key)
          ..add('group', group)
          ..add('label', label)
          ..add('description', description)
          ..add('validationRule', validationRule)
          ..add('appliesTo', appliesTo)
          ..add('value', value)
          ..add('defaultValue', defaultValue)
          ..add('version', version)
          ..add('previousValue', previousValue)
          ..add('lastReason', lastReason)
          ..add('updatedAt', updatedAt)
          ..add('updatedBy', updatedBy)
          ..add('editable', editable))
        .toString();
  }
}

class PlatformSettingBuilder
    implements Builder<PlatformSetting, PlatformSettingBuilder> {
  _$PlatformSetting? _$v;

  String? _key;
  String? get key => _$this._key;
  set key(String? key) => _$this._key = key;

  String? _group;
  String? get group => _$this._group;
  set group(String? group) => _$this._group = group;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  String? _validationRule;
  String? get validationRule => _$this._validationRule;
  set validationRule(String? validationRule) =>
      _$this._validationRule = validationRule;

  String? _appliesTo;
  String? get appliesTo => _$this._appliesTo;
  set appliesTo(String? appliesTo) => _$this._appliesTo = appliesTo;

  JsonObject? _value;
  JsonObject? get value => _$this._value;
  set value(JsonObject? value) => _$this._value = value;

  JsonObject? _defaultValue;
  JsonObject? get defaultValue => _$this._defaultValue;
  set defaultValue(JsonObject? defaultValue) =>
      _$this._defaultValue = defaultValue;

  int? _version;
  int? get version => _$this._version;
  set version(int? version) => _$this._version = version;

  JsonObject? _previousValue;
  JsonObject? get previousValue => _$this._previousValue;
  set previousValue(JsonObject? previousValue) =>
      _$this._previousValue = previousValue;

  String? _lastReason;
  String? get lastReason => _$this._lastReason;
  set lastReason(String? lastReason) => _$this._lastReason = lastReason;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  String? _updatedBy;
  String? get updatedBy => _$this._updatedBy;
  set updatedBy(String? updatedBy) => _$this._updatedBy = updatedBy;

  bool? _editable;
  bool? get editable => _$this._editable;
  set editable(bool? editable) => _$this._editable = editable;

  PlatformSettingBuilder() {
    PlatformSetting._defaults(this);
  }

  PlatformSettingBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _key = $v.key;
      _group = $v.group;
      _label = $v.label;
      _description = $v.description;
      _validationRule = $v.validationRule;
      _appliesTo = $v.appliesTo;
      _value = $v.value;
      _defaultValue = $v.defaultValue;
      _version = $v.version;
      _previousValue = $v.previousValue;
      _lastReason = $v.lastReason;
      _updatedAt = $v.updatedAt;
      _updatedBy = $v.updatedBy;
      _editable = $v.editable;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PlatformSetting other) {
    _$v = other as _$PlatformSetting;
  }

  @override
  void update(void Function(PlatformSettingBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PlatformSetting build() => _build();

  _$PlatformSetting _build() {
    final _$result = _$v ??
        _$PlatformSetting._(
          key: BuiltValueNullFieldError.checkNotNull(
              key, r'PlatformSetting', 'key'),
          group: BuiltValueNullFieldError.checkNotNull(
              group, r'PlatformSetting', 'group'),
          label: BuiltValueNullFieldError.checkNotNull(
              label, r'PlatformSetting', 'label'),
          description: BuiltValueNullFieldError.checkNotNull(
              description, r'PlatformSetting', 'description'),
          validationRule: BuiltValueNullFieldError.checkNotNull(
              validationRule, r'PlatformSetting', 'validationRule'),
          appliesTo: BuiltValueNullFieldError.checkNotNull(
              appliesTo, r'PlatformSetting', 'appliesTo'),
          value: value,
          defaultValue: defaultValue,
          version: BuiltValueNullFieldError.checkNotNull(
              version, r'PlatformSetting', 'version'),
          previousValue: previousValue,
          lastReason: lastReason,
          updatedAt: updatedAt,
          updatedBy: updatedBy,
          editable: BuiltValueNullFieldError.checkNotNull(
              editable, r'PlatformSetting', 'editable'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
