// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_business_contact.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorBusinessContact extends VendorBusinessContact {
  @override
  final String fullName;
  @override
  final String position;
  @override
  final String email;
  @override
  final String telephoneE164;
  @override
  final bool authorizedRepresentative;
  @override
  final bool isPrimary;
  @override
  final bool verificationCommunication;
  @override
  final bool accountAdministrationCommunication;
  @override
  final bool generalAdministrationCommunication;

  factory _$VendorBusinessContact(
          [void Function(VendorBusinessContactBuilder)? updates]) =>
      (VendorBusinessContactBuilder()..update(updates))._build();

  _$VendorBusinessContact._(
      {required this.fullName,
      required this.position,
      required this.email,
      required this.telephoneE164,
      required this.authorizedRepresentative,
      required this.isPrimary,
      required this.verificationCommunication,
      required this.accountAdministrationCommunication,
      required this.generalAdministrationCommunication})
      : super._();
  @override
  VendorBusinessContact rebuild(
          void Function(VendorBusinessContactBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorBusinessContactBuilder toBuilder() =>
      VendorBusinessContactBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorBusinessContact &&
        fullName == other.fullName &&
        position == other.position &&
        email == other.email &&
        telephoneE164 == other.telephoneE164 &&
        authorizedRepresentative == other.authorizedRepresentative &&
        isPrimary == other.isPrimary &&
        verificationCommunication == other.verificationCommunication &&
        accountAdministrationCommunication ==
            other.accountAdministrationCommunication &&
        generalAdministrationCommunication ==
            other.generalAdministrationCommunication;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, fullName.hashCode);
    _$hash = $jc(_$hash, position.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, telephoneE164.hashCode);
    _$hash = $jc(_$hash, authorizedRepresentative.hashCode);
    _$hash = $jc(_$hash, isPrimary.hashCode);
    _$hash = $jc(_$hash, verificationCommunication.hashCode);
    _$hash = $jc(_$hash, accountAdministrationCommunication.hashCode);
    _$hash = $jc(_$hash, generalAdministrationCommunication.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorBusinessContact')
          ..add('fullName', fullName)
          ..add('position', position)
          ..add('email', email)
          ..add('telephoneE164', telephoneE164)
          ..add('authorizedRepresentative', authorizedRepresentative)
          ..add('isPrimary', isPrimary)
          ..add('verificationCommunication', verificationCommunication)
          ..add('accountAdministrationCommunication',
              accountAdministrationCommunication)
          ..add('generalAdministrationCommunication',
              generalAdministrationCommunication))
        .toString();
  }
}

class VendorBusinessContactBuilder
    implements Builder<VendorBusinessContact, VendorBusinessContactBuilder> {
  _$VendorBusinessContact? _$v;

  String? _fullName;
  String? get fullName => _$this._fullName;
  set fullName(String? fullName) => _$this._fullName = fullName;

  String? _position;
  String? get position => _$this._position;
  set position(String? position) => _$this._position = position;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _telephoneE164;
  String? get telephoneE164 => _$this._telephoneE164;
  set telephoneE164(String? telephoneE164) =>
      _$this._telephoneE164 = telephoneE164;

  bool? _authorizedRepresentative;
  bool? get authorizedRepresentative => _$this._authorizedRepresentative;
  set authorizedRepresentative(bool? authorizedRepresentative) =>
      _$this._authorizedRepresentative = authorizedRepresentative;

  bool? _isPrimary;
  bool? get isPrimary => _$this._isPrimary;
  set isPrimary(bool? isPrimary) => _$this._isPrimary = isPrimary;

  bool? _verificationCommunication;
  bool? get verificationCommunication => _$this._verificationCommunication;
  set verificationCommunication(bool? verificationCommunication) =>
      _$this._verificationCommunication = verificationCommunication;

  bool? _accountAdministrationCommunication;
  bool? get accountAdministrationCommunication =>
      _$this._accountAdministrationCommunication;
  set accountAdministrationCommunication(
          bool? accountAdministrationCommunication) =>
      _$this._accountAdministrationCommunication =
          accountAdministrationCommunication;

  bool? _generalAdministrationCommunication;
  bool? get generalAdministrationCommunication =>
      _$this._generalAdministrationCommunication;
  set generalAdministrationCommunication(
          bool? generalAdministrationCommunication) =>
      _$this._generalAdministrationCommunication =
          generalAdministrationCommunication;

  VendorBusinessContactBuilder() {
    VendorBusinessContact._defaults(this);
  }

  VendorBusinessContactBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _fullName = $v.fullName;
      _position = $v.position;
      _email = $v.email;
      _telephoneE164 = $v.telephoneE164;
      _authorizedRepresentative = $v.authorizedRepresentative;
      _isPrimary = $v.isPrimary;
      _verificationCommunication = $v.verificationCommunication;
      _accountAdministrationCommunication =
          $v.accountAdministrationCommunication;
      _generalAdministrationCommunication =
          $v.generalAdministrationCommunication;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorBusinessContact other) {
    _$v = other as _$VendorBusinessContact;
  }

  @override
  void update(void Function(VendorBusinessContactBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorBusinessContact build() => _build();

  _$VendorBusinessContact _build() {
    final _$result = _$v ??
        _$VendorBusinessContact._(
          fullName: BuiltValueNullFieldError.checkNotNull(
              fullName, r'VendorBusinessContact', 'fullName'),
          position: BuiltValueNullFieldError.checkNotNull(
              position, r'VendorBusinessContact', 'position'),
          email: BuiltValueNullFieldError.checkNotNull(
              email, r'VendorBusinessContact', 'email'),
          telephoneE164: BuiltValueNullFieldError.checkNotNull(
              telephoneE164, r'VendorBusinessContact', 'telephoneE164'),
          authorizedRepresentative: BuiltValueNullFieldError.checkNotNull(
              authorizedRepresentative,
              r'VendorBusinessContact',
              'authorizedRepresentative'),
          isPrimary: BuiltValueNullFieldError.checkNotNull(
              isPrimary, r'VendorBusinessContact', 'isPrimary'),
          verificationCommunication: BuiltValueNullFieldError.checkNotNull(
              verificationCommunication,
              r'VendorBusinessContact',
              'verificationCommunication'),
          accountAdministrationCommunication:
              BuiltValueNullFieldError.checkNotNull(
                  accountAdministrationCommunication,
                  r'VendorBusinessContact',
                  'accountAdministrationCommunication'),
          generalAdministrationCommunication:
              BuiltValueNullFieldError.checkNotNull(
                  generalAdministrationCommunication,
                  r'VendorBusinessContact',
                  'generalAdministrationCommunication'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
