// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'save_vendor_tax.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SaveVendorTax extends SaveVendorTax {
  @override
  final int lockVersion;
  @override
  final bool attest;
  @override
  final VendorTaxData profile;

  factory _$SaveVendorTax([void Function(SaveVendorTaxBuilder)? updates]) =>
      (SaveVendorTaxBuilder()..update(updates))._build();

  _$SaveVendorTax._(
      {required this.lockVersion, required this.attest, required this.profile})
      : super._();
  @override
  SaveVendorTax rebuild(void Function(SaveVendorTaxBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SaveVendorTaxBuilder toBuilder() => SaveVendorTaxBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SaveVendorTax &&
        lockVersion == other.lockVersion &&
        attest == other.attest &&
        profile == other.profile;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, attest.hashCode);
    _$hash = $jc(_$hash, profile.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SaveVendorTax')
          ..add('lockVersion', lockVersion)
          ..add('attest', attest)
          ..add('profile', profile))
        .toString();
  }
}

class SaveVendorTaxBuilder
    implements Builder<SaveVendorTax, SaveVendorTaxBuilder> {
  _$SaveVendorTax? _$v;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  bool? _attest;
  bool? get attest => _$this._attest;
  set attest(bool? attest) => _$this._attest = attest;

  VendorTaxDataBuilder? _profile;
  VendorTaxDataBuilder get profile =>
      _$this._profile ??= VendorTaxDataBuilder();
  set profile(VendorTaxDataBuilder? profile) => _$this._profile = profile;

  SaveVendorTaxBuilder() {
    SaveVendorTax._defaults(this);
  }

  SaveVendorTaxBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _lockVersion = $v.lockVersion;
      _attest = $v.attest;
      _profile = $v.profile.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SaveVendorTax other) {
    _$v = other as _$SaveVendorTax;
  }

  @override
  void update(void Function(SaveVendorTaxBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SaveVendorTax build() => _build();

  _$SaveVendorTax _build() {
    _$SaveVendorTax _$result;
    try {
      _$result = _$v ??
          _$SaveVendorTax._(
            lockVersion: BuiltValueNullFieldError.checkNotNull(
                lockVersion, r'SaveVendorTax', 'lockVersion'),
            attest: BuiltValueNullFieldError.checkNotNull(
                attest, r'SaveVendorTax', 'attest'),
            profile: profile.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'profile';
        profile.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'SaveVendorTax', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
