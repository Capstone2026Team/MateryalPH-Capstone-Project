// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_team_deletion.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorTeamDeletion extends VendorTeamDeletion {
  @override
  final int lockVersion;

  factory _$VendorTeamDeletion(
          [void Function(VendorTeamDeletionBuilder)? updates]) =>
      (VendorTeamDeletionBuilder()..update(updates))._build();

  _$VendorTeamDeletion._({required this.lockVersion}) : super._();
  @override
  VendorTeamDeletion rebuild(
          void Function(VendorTeamDeletionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorTeamDeletionBuilder toBuilder() =>
      VendorTeamDeletionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorTeamDeletion && lockVersion == other.lockVersion;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorTeamDeletion')
          ..add('lockVersion', lockVersion))
        .toString();
  }
}

class VendorTeamDeletionBuilder
    implements Builder<VendorTeamDeletion, VendorTeamDeletionBuilder> {
  _$VendorTeamDeletion? _$v;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  VendorTeamDeletionBuilder() {
    VendorTeamDeletion._defaults(this);
  }

  VendorTeamDeletionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _lockVersion = $v.lockVersion;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorTeamDeletion other) {
    _$v = other as _$VendorTeamDeletion;
  }

  @override
  void update(void Function(VendorTeamDeletionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorTeamDeletion build() => _build();

  _$VendorTeamDeletion _build() {
    final _$result = _$v ??
        _$VendorTeamDeletion._(
          lockVersion: BuiltValueNullFieldError.checkNotNull(
              lockVersion, r'VendorTeamDeletion', 'lockVersion'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
