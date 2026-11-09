// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'automated_response_settings.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AutomatedResponseSettings extends AutomatedResponseSettings {
  @override
  final bool enabled;
  @override
  final String welcomeMessage;
  @override
  final BuiltList<AutomatedResponseOption> options;
  @override
  final int lockVersion;

  factory _$AutomatedResponseSettings(
          [void Function(AutomatedResponseSettingsBuilder)? updates]) =>
      (AutomatedResponseSettingsBuilder()..update(updates))._build();

  _$AutomatedResponseSettings._(
      {required this.enabled,
      required this.welcomeMessage,
      required this.options,
      required this.lockVersion})
      : super._();
  @override
  AutomatedResponseSettings rebuild(
          void Function(AutomatedResponseSettingsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AutomatedResponseSettingsBuilder toBuilder() =>
      AutomatedResponseSettingsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AutomatedResponseSettings &&
        enabled == other.enabled &&
        welcomeMessage == other.welcomeMessage &&
        options == other.options &&
        lockVersion == other.lockVersion;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, enabled.hashCode);
    _$hash = $jc(_$hash, welcomeMessage.hashCode);
    _$hash = $jc(_$hash, options.hashCode);
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AutomatedResponseSettings')
          ..add('enabled', enabled)
          ..add('welcomeMessage', welcomeMessage)
          ..add('options', options)
          ..add('lockVersion', lockVersion))
        .toString();
  }
}

class AutomatedResponseSettingsBuilder
    implements
        Builder<AutomatedResponseSettings, AutomatedResponseSettingsBuilder> {
  _$AutomatedResponseSettings? _$v;

  bool? _enabled;
  bool? get enabled => _$this._enabled;
  set enabled(bool? enabled) => _$this._enabled = enabled;

  String? _welcomeMessage;
  String? get welcomeMessage => _$this._welcomeMessage;
  set welcomeMessage(String? welcomeMessage) =>
      _$this._welcomeMessage = welcomeMessage;

  ListBuilder<AutomatedResponseOption>? _options;
  ListBuilder<AutomatedResponseOption> get options =>
      _$this._options ??= ListBuilder<AutomatedResponseOption>();
  set options(ListBuilder<AutomatedResponseOption>? options) =>
      _$this._options = options;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  AutomatedResponseSettingsBuilder() {
    AutomatedResponseSettings._defaults(this);
  }

  AutomatedResponseSettingsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _enabled = $v.enabled;
      _welcomeMessage = $v.welcomeMessage;
      _options = $v.options.toBuilder();
      _lockVersion = $v.lockVersion;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AutomatedResponseSettings other) {
    _$v = other as _$AutomatedResponseSettings;
  }

  @override
  void update(void Function(AutomatedResponseSettingsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AutomatedResponseSettings build() => _build();

  _$AutomatedResponseSettings _build() {
    _$AutomatedResponseSettings _$result;
    try {
      _$result = _$v ??
          _$AutomatedResponseSettings._(
            enabled: BuiltValueNullFieldError.checkNotNull(
                enabled, r'AutomatedResponseSettings', 'enabled'),
            welcomeMessage: BuiltValueNullFieldError.checkNotNull(
                welcomeMessage, r'AutomatedResponseSettings', 'welcomeMessage'),
            options: options.build(),
            lockVersion: BuiltValueNullFieldError.checkNotNull(
                lockVersion, r'AutomatedResponseSettings', 'lockVersion'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'options';
        options.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AutomatedResponseSettings', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
