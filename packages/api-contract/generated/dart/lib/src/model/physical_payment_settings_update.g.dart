// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'physical_payment_settings_update.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PhysicalPaymentSettingsUpdate extends PhysicalPaymentSettingsUpdate {
  @override
  final int lockVersion;
  @override
  final bool codEnabled;
  @override
  final bool inStoreEnabled;

  factory _$PhysicalPaymentSettingsUpdate(
          [void Function(PhysicalPaymentSettingsUpdateBuilder)? updates]) =>
      (PhysicalPaymentSettingsUpdateBuilder()..update(updates))._build();

  _$PhysicalPaymentSettingsUpdate._(
      {required this.lockVersion,
      required this.codEnabled,
      required this.inStoreEnabled})
      : super._();
  @override
  PhysicalPaymentSettingsUpdate rebuild(
          void Function(PhysicalPaymentSettingsUpdateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PhysicalPaymentSettingsUpdateBuilder toBuilder() =>
      PhysicalPaymentSettingsUpdateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PhysicalPaymentSettingsUpdate &&
        lockVersion == other.lockVersion &&
        codEnabled == other.codEnabled &&
        inStoreEnabled == other.inStoreEnabled;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, codEnabled.hashCode);
    _$hash = $jc(_$hash, inStoreEnabled.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PhysicalPaymentSettingsUpdate')
          ..add('lockVersion', lockVersion)
          ..add('codEnabled', codEnabled)
          ..add('inStoreEnabled', inStoreEnabled))
        .toString();
  }
}

class PhysicalPaymentSettingsUpdateBuilder
    implements
        Builder<PhysicalPaymentSettingsUpdate,
            PhysicalPaymentSettingsUpdateBuilder> {
  _$PhysicalPaymentSettingsUpdate? _$v;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  bool? _codEnabled;
  bool? get codEnabled => _$this._codEnabled;
  set codEnabled(bool? codEnabled) => _$this._codEnabled = codEnabled;

  bool? _inStoreEnabled;
  bool? get inStoreEnabled => _$this._inStoreEnabled;
  set inStoreEnabled(bool? inStoreEnabled) =>
      _$this._inStoreEnabled = inStoreEnabled;

  PhysicalPaymentSettingsUpdateBuilder() {
    PhysicalPaymentSettingsUpdate._defaults(this);
  }

  PhysicalPaymentSettingsUpdateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _lockVersion = $v.lockVersion;
      _codEnabled = $v.codEnabled;
      _inStoreEnabled = $v.inStoreEnabled;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PhysicalPaymentSettingsUpdate other) {
    _$v = other as _$PhysicalPaymentSettingsUpdate;
  }

  @override
  void update(void Function(PhysicalPaymentSettingsUpdateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PhysicalPaymentSettingsUpdate build() => _build();

  _$PhysicalPaymentSettingsUpdate _build() {
    final _$result = _$v ??
        _$PhysicalPaymentSettingsUpdate._(
          lockVersion: BuiltValueNullFieldError.checkNotNull(
              lockVersion, r'PhysicalPaymentSettingsUpdate', 'lockVersion'),
          codEnabled: BuiltValueNullFieldError.checkNotNull(
              codEnabled, r'PhysicalPaymentSettingsUpdate', 'codEnabled'),
          inStoreEnabled: BuiltValueNullFieldError.checkNotNull(inStoreEnabled,
              r'PhysicalPaymentSettingsUpdate', 'inStoreEnabled'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
