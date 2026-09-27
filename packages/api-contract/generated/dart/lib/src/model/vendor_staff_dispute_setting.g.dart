// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_staff_dispute_setting.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorStaffDisputeSetting extends VendorStaffDisputeSetting {
  @override
  final bool enabled;
  @override
  final int lockVersion;

  factory _$VendorStaffDisputeSetting(
          [void Function(VendorStaffDisputeSettingBuilder)? updates]) =>
      (VendorStaffDisputeSettingBuilder()..update(updates))._build();

  _$VendorStaffDisputeSetting._(
      {required this.enabled, required this.lockVersion})
      : super._();
  @override
  VendorStaffDisputeSetting rebuild(
          void Function(VendorStaffDisputeSettingBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorStaffDisputeSettingBuilder toBuilder() =>
      VendorStaffDisputeSettingBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorStaffDisputeSetting &&
        enabled == other.enabled &&
        lockVersion == other.lockVersion;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, enabled.hashCode);
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorStaffDisputeSetting')
          ..add('enabled', enabled)
          ..add('lockVersion', lockVersion))
        .toString();
  }
}

class VendorStaffDisputeSettingBuilder
    implements
        Builder<VendorStaffDisputeSetting, VendorStaffDisputeSettingBuilder> {
  _$VendorStaffDisputeSetting? _$v;

  bool? _enabled;
  bool? get enabled => _$this._enabled;
  set enabled(bool? enabled) => _$this._enabled = enabled;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  VendorStaffDisputeSettingBuilder() {
    VendorStaffDisputeSetting._defaults(this);
  }

  VendorStaffDisputeSettingBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _enabled = $v.enabled;
      _lockVersion = $v.lockVersion;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorStaffDisputeSetting other) {
    _$v = other as _$VendorStaffDisputeSetting;
  }

  @override
  void update(void Function(VendorStaffDisputeSettingBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorStaffDisputeSetting build() => _build();

  _$VendorStaffDisputeSetting _build() {
    final _$result = _$v ??
        _$VendorStaffDisputeSetting._(
          enabled: BuiltValueNullFieldError.checkNotNull(
              enabled, r'VendorStaffDisputeSetting', 'enabled'),
          lockVersion: BuiltValueNullFieldError.checkNotNull(
              lockVersion, r'VendorStaffDisputeSetting', 'lockVersion'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
