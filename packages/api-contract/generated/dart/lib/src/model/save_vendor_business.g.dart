// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'save_vendor_business.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SaveVendorBusiness extends SaveVendorBusiness {
  @override
  final int lockVersion;
  @override
  final bool submit;
  @override
  final VendorBusinessDraft business;

  factory _$SaveVendorBusiness(
          [void Function(SaveVendorBusinessBuilder)? updates]) =>
      (SaveVendorBusinessBuilder()..update(updates))._build();

  _$SaveVendorBusiness._(
      {required this.lockVersion, required this.submit, required this.business})
      : super._();
  @override
  SaveVendorBusiness rebuild(
          void Function(SaveVendorBusinessBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SaveVendorBusinessBuilder toBuilder() =>
      SaveVendorBusinessBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SaveVendorBusiness &&
        lockVersion == other.lockVersion &&
        submit == other.submit &&
        business == other.business;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, submit.hashCode);
    _$hash = $jc(_$hash, business.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SaveVendorBusiness')
          ..add('lockVersion', lockVersion)
          ..add('submit', submit)
          ..add('business', business))
        .toString();
  }
}

class SaveVendorBusinessBuilder
    implements Builder<SaveVendorBusiness, SaveVendorBusinessBuilder> {
  _$SaveVendorBusiness? _$v;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  bool? _submit;
  bool? get submit => _$this._submit;
  set submit(bool? submit) => _$this._submit = submit;

  VendorBusinessDraftBuilder? _business;
  VendorBusinessDraftBuilder get business =>
      _$this._business ??= VendorBusinessDraftBuilder();
  set business(VendorBusinessDraftBuilder? business) =>
      _$this._business = business;

  SaveVendorBusinessBuilder() {
    SaveVendorBusiness._defaults(this);
  }

  SaveVendorBusinessBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _lockVersion = $v.lockVersion;
      _submit = $v.submit;
      _business = $v.business.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SaveVendorBusiness other) {
    _$v = other as _$SaveVendorBusiness;
  }

  @override
  void update(void Function(SaveVendorBusinessBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SaveVendorBusiness build() => _build();

  _$SaveVendorBusiness _build() {
    _$SaveVendorBusiness _$result;
    try {
      _$result = _$v ??
          _$SaveVendorBusiness._(
            lockVersion: BuiltValueNullFieldError.checkNotNull(
                lockVersion, r'SaveVendorBusiness', 'lockVersion'),
            submit: BuiltValueNullFieldError.checkNotNull(
                submit, r'SaveVendorBusiness', 'submit'),
            business: business.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'business';
        business.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'SaveVendorBusiness', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
