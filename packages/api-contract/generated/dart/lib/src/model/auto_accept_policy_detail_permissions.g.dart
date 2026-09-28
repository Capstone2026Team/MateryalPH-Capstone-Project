// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auto_accept_policy_detail_permissions.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AutoAcceptPolicyDetailPermissions
    extends AutoAcceptPolicyDetailPermissions {
  @override
  final bool canConfigure;
  @override
  final bool canUpdateAllotment;

  factory _$AutoAcceptPolicyDetailPermissions(
          [void Function(AutoAcceptPolicyDetailPermissionsBuilder)? updates]) =>
      (AutoAcceptPolicyDetailPermissionsBuilder()..update(updates))._build();

  _$AutoAcceptPolicyDetailPermissions._(
      {required this.canConfigure, required this.canUpdateAllotment})
      : super._();
  @override
  AutoAcceptPolicyDetailPermissions rebuild(
          void Function(AutoAcceptPolicyDetailPermissionsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AutoAcceptPolicyDetailPermissionsBuilder toBuilder() =>
      AutoAcceptPolicyDetailPermissionsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AutoAcceptPolicyDetailPermissions &&
        canConfigure == other.canConfigure &&
        canUpdateAllotment == other.canUpdateAllotment;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, canConfigure.hashCode);
    _$hash = $jc(_$hash, canUpdateAllotment.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AutoAcceptPolicyDetailPermissions')
          ..add('canConfigure', canConfigure)
          ..add('canUpdateAllotment', canUpdateAllotment))
        .toString();
  }
}

class AutoAcceptPolicyDetailPermissionsBuilder
    implements
        Builder<AutoAcceptPolicyDetailPermissions,
            AutoAcceptPolicyDetailPermissionsBuilder> {
  _$AutoAcceptPolicyDetailPermissions? _$v;

  bool? _canConfigure;
  bool? get canConfigure => _$this._canConfigure;
  set canConfigure(bool? canConfigure) => _$this._canConfigure = canConfigure;

  bool? _canUpdateAllotment;
  bool? get canUpdateAllotment => _$this._canUpdateAllotment;
  set canUpdateAllotment(bool? canUpdateAllotment) =>
      _$this._canUpdateAllotment = canUpdateAllotment;

  AutoAcceptPolicyDetailPermissionsBuilder() {
    AutoAcceptPolicyDetailPermissions._defaults(this);
  }

  AutoAcceptPolicyDetailPermissionsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _canConfigure = $v.canConfigure;
      _canUpdateAllotment = $v.canUpdateAllotment;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AutoAcceptPolicyDetailPermissions other) {
    _$v = other as _$AutoAcceptPolicyDetailPermissions;
  }

  @override
  void update(
      void Function(AutoAcceptPolicyDetailPermissionsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AutoAcceptPolicyDetailPermissions build() => _build();

  _$AutoAcceptPolicyDetailPermissions _build() {
    final _$result = _$v ??
        _$AutoAcceptPolicyDetailPermissions._(
          canConfigure: BuiltValueNullFieldError.checkNotNull(canConfigure,
              r'AutoAcceptPolicyDetailPermissions', 'canConfigure'),
          canUpdateAllotment: BuiltValueNullFieldError.checkNotNull(
              canUpdateAllotment,
              r'AutoAcceptPolicyDetailPermissions',
              'canUpdateAllotment'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
