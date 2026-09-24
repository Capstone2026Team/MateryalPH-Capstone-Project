// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_setup_complete.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorSetupComplete extends VendorSetupComplete {
  @override
  final int organizationLockVersion;

  factory _$VendorSetupComplete(
          [void Function(VendorSetupCompleteBuilder)? updates]) =>
      (VendorSetupCompleteBuilder()..update(updates))._build();

  _$VendorSetupComplete._({required this.organizationLockVersion}) : super._();
  @override
  VendorSetupComplete rebuild(
          void Function(VendorSetupCompleteBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorSetupCompleteBuilder toBuilder() =>
      VendorSetupCompleteBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorSetupComplete &&
        organizationLockVersion == other.organizationLockVersion;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, organizationLockVersion.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorSetupComplete')
          ..add('organizationLockVersion', organizationLockVersion))
        .toString();
  }
}

class VendorSetupCompleteBuilder
    implements Builder<VendorSetupComplete, VendorSetupCompleteBuilder> {
  _$VendorSetupComplete? _$v;

  int? _organizationLockVersion;
  int? get organizationLockVersion => _$this._organizationLockVersion;
  set organizationLockVersion(int? organizationLockVersion) =>
      _$this._organizationLockVersion = organizationLockVersion;

  VendorSetupCompleteBuilder() {
    VendorSetupComplete._defaults(this);
  }

  VendorSetupCompleteBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _organizationLockVersion = $v.organizationLockVersion;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorSetupComplete other) {
    _$v = other as _$VendorSetupComplete;
  }

  @override
  void update(void Function(VendorSetupCompleteBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorSetupComplete build() => _build();

  _$VendorSetupComplete _build() {
    final _$result = _$v ??
        _$VendorSetupComplete._(
          organizationLockVersion: BuiltValueNullFieldError.checkNotNull(
              organizationLockVersion,
              r'VendorSetupComplete',
              'organizationLockVersion'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
