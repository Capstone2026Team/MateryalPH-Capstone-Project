// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_verification_draft_legal_identity.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorVerificationDraftLegalIdentity
    extends VendorVerificationDraftLegalIdentity {
  @override
  final bool? sameAsOwner;
  @override
  final String? surname;
  @override
  final String? firstName;
  @override
  final String? middleName;
  @override
  final String? suffix;
  @override
  final String? companyRegisteredName;
  @override
  final String? idType;
  @override
  final String? idNumber;

  factory _$VendorVerificationDraftLegalIdentity(
          [void Function(VendorVerificationDraftLegalIdentityBuilder)?
              updates]) =>
      (VendorVerificationDraftLegalIdentityBuilder()..update(updates))._build();

  _$VendorVerificationDraftLegalIdentity._(
      {this.sameAsOwner,
      this.surname,
      this.firstName,
      this.middleName,
      this.suffix,
      this.companyRegisteredName,
      this.idType,
      this.idNumber})
      : super._();
  @override
  VendorVerificationDraftLegalIdentity rebuild(
          void Function(VendorVerificationDraftLegalIdentityBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorVerificationDraftLegalIdentityBuilder toBuilder() =>
      VendorVerificationDraftLegalIdentityBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorVerificationDraftLegalIdentity &&
        sameAsOwner == other.sameAsOwner &&
        surname == other.surname &&
        firstName == other.firstName &&
        middleName == other.middleName &&
        suffix == other.suffix &&
        companyRegisteredName == other.companyRegisteredName &&
        idType == other.idType &&
        idNumber == other.idNumber;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, sameAsOwner.hashCode);
    _$hash = $jc(_$hash, surname.hashCode);
    _$hash = $jc(_$hash, firstName.hashCode);
    _$hash = $jc(_$hash, middleName.hashCode);
    _$hash = $jc(_$hash, suffix.hashCode);
    _$hash = $jc(_$hash, companyRegisteredName.hashCode);
    _$hash = $jc(_$hash, idType.hashCode);
    _$hash = $jc(_$hash, idNumber.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorVerificationDraftLegalIdentity')
          ..add('sameAsOwner', sameAsOwner)
          ..add('surname', surname)
          ..add('firstName', firstName)
          ..add('middleName', middleName)
          ..add('suffix', suffix)
          ..add('companyRegisteredName', companyRegisteredName)
          ..add('idType', idType)
          ..add('idNumber', idNumber))
        .toString();
  }
}

class VendorVerificationDraftLegalIdentityBuilder
    implements
        Builder<VendorVerificationDraftLegalIdentity,
            VendorVerificationDraftLegalIdentityBuilder> {
  _$VendorVerificationDraftLegalIdentity? _$v;

  bool? _sameAsOwner;
  bool? get sameAsOwner => _$this._sameAsOwner;
  set sameAsOwner(bool? sameAsOwner) => _$this._sameAsOwner = sameAsOwner;

  String? _surname;
  String? get surname => _$this._surname;
  set surname(String? surname) => _$this._surname = surname;

  String? _firstName;
  String? get firstName => _$this._firstName;
  set firstName(String? firstName) => _$this._firstName = firstName;

  String? _middleName;
  String? get middleName => _$this._middleName;
  set middleName(String? middleName) => _$this._middleName = middleName;

  String? _suffix;
  String? get suffix => _$this._suffix;
  set suffix(String? suffix) => _$this._suffix = suffix;

  String? _companyRegisteredName;
  String? get companyRegisteredName => _$this._companyRegisteredName;
  set companyRegisteredName(String? companyRegisteredName) =>
      _$this._companyRegisteredName = companyRegisteredName;

  String? _idType;
  String? get idType => _$this._idType;
  set idType(String? idType) => _$this._idType = idType;

  String? _idNumber;
  String? get idNumber => _$this._idNumber;
  set idNumber(String? idNumber) => _$this._idNumber = idNumber;

  VendorVerificationDraftLegalIdentityBuilder() {
    VendorVerificationDraftLegalIdentity._defaults(this);
  }

  VendorVerificationDraftLegalIdentityBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _sameAsOwner = $v.sameAsOwner;
      _surname = $v.surname;
      _firstName = $v.firstName;
      _middleName = $v.middleName;
      _suffix = $v.suffix;
      _companyRegisteredName = $v.companyRegisteredName;
      _idType = $v.idType;
      _idNumber = $v.idNumber;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorVerificationDraftLegalIdentity other) {
    _$v = other as _$VendorVerificationDraftLegalIdentity;
  }

  @override
  void update(
      void Function(VendorVerificationDraftLegalIdentityBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorVerificationDraftLegalIdentity build() => _build();

  _$VendorVerificationDraftLegalIdentity _build() {
    final _$result = _$v ??
        _$VendorVerificationDraftLegalIdentity._(
          sameAsOwner: sameAsOwner,
          surname: surname,
          firstName: firstName,
          middleName: middleName,
          suffix: suffix,
          companyRegisteredName: companyRegisteredName,
          idType: idType,
          idNumber: idNumber,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
