// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_version_mutation.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorVersionMutation extends VendorVersionMutation {
  @override
  final int lockVersion;

  factory _$VendorVersionMutation(
          [void Function(VendorVersionMutationBuilder)? updates]) =>
      (VendorVersionMutationBuilder()..update(updates))._build();

  _$VendorVersionMutation._({required this.lockVersion}) : super._();
  @override
  VendorVersionMutation rebuild(
          void Function(VendorVersionMutationBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorVersionMutationBuilder toBuilder() =>
      VendorVersionMutationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorVersionMutation && lockVersion == other.lockVersion;
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
    return (newBuiltValueToStringHelper(r'VendorVersionMutation')
          ..add('lockVersion', lockVersion))
        .toString();
  }
}

class VendorVersionMutationBuilder
    implements Builder<VendorVersionMutation, VendorVersionMutationBuilder> {
  _$VendorVersionMutation? _$v;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  VendorVersionMutationBuilder() {
    VendorVersionMutation._defaults(this);
  }

  VendorVersionMutationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _lockVersion = $v.lockVersion;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorVersionMutation other) {
    _$v = other as _$VendorVersionMutation;
  }

  @override
  void update(void Function(VendorVersionMutationBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorVersionMutation build() => _build();

  _$VendorVersionMutation _build() {
    final _$result = _$v ??
        _$VendorVersionMutation._(
          lockVersion: BuiltValueNullFieldError.checkNotNull(
              lockVersion, r'VendorVersionMutation', 'lockVersion'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
