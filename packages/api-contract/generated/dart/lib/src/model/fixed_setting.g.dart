// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fixed_setting.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FixedSetting extends FixedSetting {
  @override
  final String key;
  @override
  final String label;
  @override
  final JsonObject? value;
  @override
  final String reason;

  factory _$FixedSetting([void Function(FixedSettingBuilder)? updates]) =>
      (FixedSettingBuilder()..update(updates))._build();

  _$FixedSetting._(
      {required this.key,
      required this.label,
      this.value,
      required this.reason})
      : super._();
  @override
  FixedSetting rebuild(void Function(FixedSettingBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FixedSettingBuilder toBuilder() => FixedSettingBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FixedSetting &&
        key == other.key &&
        label == other.label &&
        value == other.value &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, key.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, value.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FixedSetting')
          ..add('key', key)
          ..add('label', label)
          ..add('value', value)
          ..add('reason', reason))
        .toString();
  }
}

class FixedSettingBuilder
    implements Builder<FixedSetting, FixedSettingBuilder> {
  _$FixedSetting? _$v;

  String? _key;
  String? get key => _$this._key;
  set key(String? key) => _$this._key = key;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  JsonObject? _value;
  JsonObject? get value => _$this._value;
  set value(JsonObject? value) => _$this._value = value;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  FixedSettingBuilder() {
    FixedSetting._defaults(this);
  }

  FixedSettingBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _key = $v.key;
      _label = $v.label;
      _value = $v.value;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FixedSetting other) {
    _$v = other as _$FixedSetting;
  }

  @override
  void update(void Function(FixedSettingBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FixedSetting build() => _build();

  _$FixedSetting _build() {
    final _$result = _$v ??
        _$FixedSetting._(
          key: BuiltValueNullFieldError.checkNotNull(
              key, r'FixedSetting', 'key'),
          label: BuiltValueNullFieldError.checkNotNull(
              label, r'FixedSetting', 'label'),
          value: value,
          reason: BuiltValueNullFieldError.checkNotNull(
              reason, r'FixedSetting', 'reason'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
