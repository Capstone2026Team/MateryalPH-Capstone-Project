// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_individual_registered_name.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorIndividualRegisteredName extends VendorIndividualRegisteredName {
  @override
  final String surname;
  @override
  final String firstName;
  @override
  final String? middleName;
  @override
  final String? suffix;
  @override
  final bool? sameAsOwner;

  factory _$VendorIndividualRegisteredName(
          [void Function(VendorIndividualRegisteredNameBuilder)? updates]) =>
      (VendorIndividualRegisteredNameBuilder()..update(updates))._build();

  _$VendorIndividualRegisteredName._(
      {required this.surname,
      required this.firstName,
      this.middleName,
      this.suffix,
      this.sameAsOwner})
      : super._();
  @override
  VendorIndividualRegisteredName rebuild(
          void Function(VendorIndividualRegisteredNameBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorIndividualRegisteredNameBuilder toBuilder() =>
      VendorIndividualRegisteredNameBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorIndividualRegisteredName &&
        surname == other.surname &&
        firstName == other.firstName &&
        middleName == other.middleName &&
        suffix == other.suffix &&
        sameAsOwner == other.sameAsOwner;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, surname.hashCode);
    _$hash = $jc(_$hash, firstName.hashCode);
    _$hash = $jc(_$hash, middleName.hashCode);
    _$hash = $jc(_$hash, suffix.hashCode);
    _$hash = $jc(_$hash, sameAsOwner.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorIndividualRegisteredName')
          ..add('surname', surname)
          ..add('firstName', firstName)
          ..add('middleName', middleName)
          ..add('suffix', suffix)
          ..add('sameAsOwner', sameAsOwner))
        .toString();
  }
}

class VendorIndividualRegisteredNameBuilder
    implements
        Builder<VendorIndividualRegisteredName,
            VendorIndividualRegisteredNameBuilder> {
  _$VendorIndividualRegisteredName? _$v;

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

  bool? _sameAsOwner;
  bool? get sameAsOwner => _$this._sameAsOwner;
  set sameAsOwner(bool? sameAsOwner) => _$this._sameAsOwner = sameAsOwner;

  VendorIndividualRegisteredNameBuilder() {
    VendorIndividualRegisteredName._defaults(this);
  }

  VendorIndividualRegisteredNameBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _surname = $v.surname;
      _firstName = $v.firstName;
      _middleName = $v.middleName;
      _suffix = $v.suffix;
      _sameAsOwner = $v.sameAsOwner;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorIndividualRegisteredName other) {
    _$v = other as _$VendorIndividualRegisteredName;
  }

  @override
  void update(void Function(VendorIndividualRegisteredNameBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorIndividualRegisteredName build() => _build();

  _$VendorIndividualRegisteredName _build() {
    final _$result = _$v ??
        _$VendorIndividualRegisteredName._(
          surname: BuiltValueNullFieldError.checkNotNull(
              surname, r'VendorIndividualRegisteredName', 'surname'),
          firstName: BuiltValueNullFieldError.checkNotNull(
              firstName, r'VendorIndividualRegisteredName', 'firstName'),
          middleName: middleName,
          suffix: suffix,
          sameAsOwner: sameAsOwner,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
