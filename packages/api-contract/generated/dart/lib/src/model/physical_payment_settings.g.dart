// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'physical_payment_settings.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PhysicalPaymentSettings extends PhysicalPaymentSettings {
  @override
  final bool codEnabled;
  @override
  final bool inStoreEnabled;
  @override
  final int lockVersion;
  @override
  final String? updatedAt;

  factory _$PhysicalPaymentSettings(
          [void Function(PhysicalPaymentSettingsBuilder)? updates]) =>
      (PhysicalPaymentSettingsBuilder()..update(updates))._build();

  _$PhysicalPaymentSettings._(
      {required this.codEnabled,
      required this.inStoreEnabled,
      required this.lockVersion,
      this.updatedAt})
      : super._();
  @override
  PhysicalPaymentSettings rebuild(
          void Function(PhysicalPaymentSettingsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PhysicalPaymentSettingsBuilder toBuilder() =>
      PhysicalPaymentSettingsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PhysicalPaymentSettings &&
        codEnabled == other.codEnabled &&
        inStoreEnabled == other.inStoreEnabled &&
        lockVersion == other.lockVersion &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, codEnabled.hashCode);
    _$hash = $jc(_$hash, inStoreEnabled.hashCode);
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PhysicalPaymentSettings')
          ..add('codEnabled', codEnabled)
          ..add('inStoreEnabled', inStoreEnabled)
          ..add('lockVersion', lockVersion)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class PhysicalPaymentSettingsBuilder
    implements
        Builder<PhysicalPaymentSettings, PhysicalPaymentSettingsBuilder> {
  _$PhysicalPaymentSettings? _$v;

  bool? _codEnabled;
  bool? get codEnabled => _$this._codEnabled;
  set codEnabled(bool? codEnabled) => _$this._codEnabled = codEnabled;

  bool? _inStoreEnabled;
  bool? get inStoreEnabled => _$this._inStoreEnabled;
  set inStoreEnabled(bool? inStoreEnabled) =>
      _$this._inStoreEnabled = inStoreEnabled;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  String? _updatedAt;
  String? get updatedAt => _$this._updatedAt;
  set updatedAt(String? updatedAt) => _$this._updatedAt = updatedAt;

  PhysicalPaymentSettingsBuilder() {
    PhysicalPaymentSettings._defaults(this);
  }

  PhysicalPaymentSettingsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _codEnabled = $v.codEnabled;
      _inStoreEnabled = $v.inStoreEnabled;
      _lockVersion = $v.lockVersion;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PhysicalPaymentSettings other) {
    _$v = other as _$PhysicalPaymentSettings;
  }

  @override
  void update(void Function(PhysicalPaymentSettingsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PhysicalPaymentSettings build() => _build();

  _$PhysicalPaymentSettings _build() {
    final _$result = _$v ??
        _$PhysicalPaymentSettings._(
          codEnabled: BuiltValueNullFieldError.checkNotNull(
              codEnabled, r'PhysicalPaymentSettings', 'codEnabled'),
          inStoreEnabled: BuiltValueNullFieldError.checkNotNull(
              inStoreEnabled, r'PhysicalPaymentSettings', 'inStoreEnabled'),
          lockVersion: BuiltValueNullFieldError.checkNotNull(
              lockVersion, r'PhysicalPaymentSettings', 'lockVersion'),
          updatedAt: updatedAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
