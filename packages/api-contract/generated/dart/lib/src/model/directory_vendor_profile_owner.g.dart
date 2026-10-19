// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'directory_vendor_profile_owner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DirectoryVendorProfileOwner extends DirectoryVendorProfileOwner {
  @override
  final String name;
  @override
  final String email;
  @override
  final String? mobile;

  factory _$DirectoryVendorProfileOwner(
          [void Function(DirectoryVendorProfileOwnerBuilder)? updates]) =>
      (DirectoryVendorProfileOwnerBuilder()..update(updates))._build();

  _$DirectoryVendorProfileOwner._(
      {required this.name, required this.email, this.mobile})
      : super._();
  @override
  DirectoryVendorProfileOwner rebuild(
          void Function(DirectoryVendorProfileOwnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DirectoryVendorProfileOwnerBuilder toBuilder() =>
      DirectoryVendorProfileOwnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DirectoryVendorProfileOwner &&
        name == other.name &&
        email == other.email &&
        mobile == other.mobile;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, mobile.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DirectoryVendorProfileOwner')
          ..add('name', name)
          ..add('email', email)
          ..add('mobile', mobile))
        .toString();
  }
}

class DirectoryVendorProfileOwnerBuilder
    implements
        Builder<DirectoryVendorProfileOwner,
            DirectoryVendorProfileOwnerBuilder> {
  _$DirectoryVendorProfileOwner? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _mobile;
  String? get mobile => _$this._mobile;
  set mobile(String? mobile) => _$this._mobile = mobile;

  DirectoryVendorProfileOwnerBuilder() {
    DirectoryVendorProfileOwner._defaults(this);
  }

  DirectoryVendorProfileOwnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _email = $v.email;
      _mobile = $v.mobile;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DirectoryVendorProfileOwner other) {
    _$v = other as _$DirectoryVendorProfileOwner;
  }

  @override
  void update(void Function(DirectoryVendorProfileOwnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DirectoryVendorProfileOwner build() => _build();

  _$DirectoryVendorProfileOwner _build() {
    final _$result = _$v ??
        _$DirectoryVendorProfileOwner._(
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'DirectoryVendorProfileOwner', 'name'),
          email: BuiltValueNullFieldError.checkNotNull(
              email, r'DirectoryVendorProfileOwner', 'email'),
          mobile: mobile,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
