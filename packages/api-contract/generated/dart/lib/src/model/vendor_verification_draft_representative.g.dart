// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_verification_draft_representative.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const VendorVerificationDraftRepresentativeIdTypeEnum
    _$vendorVerificationDraftRepresentativeIdTypeEnum_NATIONAL_ID =
    const VendorVerificationDraftRepresentativeIdTypeEnum._('NATIONAL_ID');
const VendorVerificationDraftRepresentativeIdTypeEnum
    _$vendorVerificationDraftRepresentativeIdTypeEnum_DRIVERS_LICENSE =
    const VendorVerificationDraftRepresentativeIdTypeEnum._('DRIVERS_LICENSE');
const VendorVerificationDraftRepresentativeIdTypeEnum
    _$vendorVerificationDraftRepresentativeIdTypeEnum_PASSPORT =
    const VendorVerificationDraftRepresentativeIdTypeEnum._('PASSPORT');
const VendorVerificationDraftRepresentativeIdTypeEnum
    _$vendorVerificationDraftRepresentativeIdTypeEnum_UMID =
    const VendorVerificationDraftRepresentativeIdTypeEnum._('UMID');
const VendorVerificationDraftRepresentativeIdTypeEnum
    _$vendorVerificationDraftRepresentativeIdTypeEnum_OTHER =
    const VendorVerificationDraftRepresentativeIdTypeEnum._('OTHER');

VendorVerificationDraftRepresentativeIdTypeEnum
    _$vendorVerificationDraftRepresentativeIdTypeEnumValueOf(String name) {
  switch (name) {
    case 'NATIONAL_ID':
      return _$vendorVerificationDraftRepresentativeIdTypeEnum_NATIONAL_ID;
    case 'DRIVERS_LICENSE':
      return _$vendorVerificationDraftRepresentativeIdTypeEnum_DRIVERS_LICENSE;
    case 'PASSPORT':
      return _$vendorVerificationDraftRepresentativeIdTypeEnum_PASSPORT;
    case 'UMID':
      return _$vendorVerificationDraftRepresentativeIdTypeEnum_UMID;
    case 'OTHER':
      return _$vendorVerificationDraftRepresentativeIdTypeEnum_OTHER;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<VendorVerificationDraftRepresentativeIdTypeEnum>
    _$vendorVerificationDraftRepresentativeIdTypeEnumValues = BuiltSet<
        VendorVerificationDraftRepresentativeIdTypeEnum>(const <VendorVerificationDraftRepresentativeIdTypeEnum>[
  _$vendorVerificationDraftRepresentativeIdTypeEnum_NATIONAL_ID,
  _$vendorVerificationDraftRepresentativeIdTypeEnum_DRIVERS_LICENSE,
  _$vendorVerificationDraftRepresentativeIdTypeEnum_PASSPORT,
  _$vendorVerificationDraftRepresentativeIdTypeEnum_UMID,
  _$vendorVerificationDraftRepresentativeIdTypeEnum_OTHER,
]);

Serializer<VendorVerificationDraftRepresentativeIdTypeEnum>
    _$vendorVerificationDraftRepresentativeIdTypeEnumSerializer =
    _$VendorVerificationDraftRepresentativeIdTypeEnumSerializer();

class _$VendorVerificationDraftRepresentativeIdTypeEnumSerializer
    implements
        PrimitiveSerializer<VendorVerificationDraftRepresentativeIdTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'NATIONAL_ID': 'NATIONAL_ID',
    'DRIVERS_LICENSE': 'DRIVERS_LICENSE',
    'PASSPORT': 'PASSPORT',
    'UMID': 'UMID',
    'OTHER': 'OTHER',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'NATIONAL_ID': 'NATIONAL_ID',
    'DRIVERS_LICENSE': 'DRIVERS_LICENSE',
    'PASSPORT': 'PASSPORT',
    'UMID': 'UMID',
    'OTHER': 'OTHER',
  };

  @override
  final Iterable<Type> types = const <Type>[
    VendorVerificationDraftRepresentativeIdTypeEnum
  ];
  @override
  final String wireName = 'VendorVerificationDraftRepresentativeIdTypeEnum';

  @override
  Object serialize(Serializers serializers,
          VendorVerificationDraftRepresentativeIdTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  VendorVerificationDraftRepresentativeIdTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      VendorVerificationDraftRepresentativeIdTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$VendorVerificationDraftRepresentative
    extends VendorVerificationDraftRepresentative {
  @override
  final bool? sameAsOwner;
  @override
  final String fullName;
  @override
  final String? position;
  @override
  final String? email;
  @override
  final String? phone;
  @override
  final String? relationship;
  @override
  final VendorVerificationDraftRepresentativeIdTypeEnum? idType;
  @override
  final String? idNumber;

  factory _$VendorVerificationDraftRepresentative(
          [void Function(VendorVerificationDraftRepresentativeBuilder)?
              updates]) =>
      (VendorVerificationDraftRepresentativeBuilder()..update(updates))
          ._build();

  _$VendorVerificationDraftRepresentative._(
      {this.sameAsOwner,
      required this.fullName,
      this.position,
      this.email,
      this.phone,
      this.relationship,
      this.idType,
      this.idNumber})
      : super._();
  @override
  VendorVerificationDraftRepresentative rebuild(
          void Function(VendorVerificationDraftRepresentativeBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorVerificationDraftRepresentativeBuilder toBuilder() =>
      VendorVerificationDraftRepresentativeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorVerificationDraftRepresentative &&
        sameAsOwner == other.sameAsOwner &&
        fullName == other.fullName &&
        position == other.position &&
        email == other.email &&
        phone == other.phone &&
        relationship == other.relationship &&
        idType == other.idType &&
        idNumber == other.idNumber;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, sameAsOwner.hashCode);
    _$hash = $jc(_$hash, fullName.hashCode);
    _$hash = $jc(_$hash, position.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, phone.hashCode);
    _$hash = $jc(_$hash, relationship.hashCode);
    _$hash = $jc(_$hash, idType.hashCode);
    _$hash = $jc(_$hash, idNumber.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'VendorVerificationDraftRepresentative')
          ..add('sameAsOwner', sameAsOwner)
          ..add('fullName', fullName)
          ..add('position', position)
          ..add('email', email)
          ..add('phone', phone)
          ..add('relationship', relationship)
          ..add('idType', idType)
          ..add('idNumber', idNumber))
        .toString();
  }
}

class VendorVerificationDraftRepresentativeBuilder
    implements
        Builder<VendorVerificationDraftRepresentative,
            VendorVerificationDraftRepresentativeBuilder> {
  _$VendorVerificationDraftRepresentative? _$v;

  bool? _sameAsOwner;
  bool? get sameAsOwner => _$this._sameAsOwner;
  set sameAsOwner(bool? sameAsOwner) => _$this._sameAsOwner = sameAsOwner;

  String? _fullName;
  String? get fullName => _$this._fullName;
  set fullName(String? fullName) => _$this._fullName = fullName;

  String? _position;
  String? get position => _$this._position;
  set position(String? position) => _$this._position = position;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _phone;
  String? get phone => _$this._phone;
  set phone(String? phone) => _$this._phone = phone;

  String? _relationship;
  String? get relationship => _$this._relationship;
  set relationship(String? relationship) => _$this._relationship = relationship;

  VendorVerificationDraftRepresentativeIdTypeEnum? _idType;
  VendorVerificationDraftRepresentativeIdTypeEnum? get idType => _$this._idType;
  set idType(VendorVerificationDraftRepresentativeIdTypeEnum? idType) =>
      _$this._idType = idType;

  String? _idNumber;
  String? get idNumber => _$this._idNumber;
  set idNumber(String? idNumber) => _$this._idNumber = idNumber;

  VendorVerificationDraftRepresentativeBuilder() {
    VendorVerificationDraftRepresentative._defaults(this);
  }

  VendorVerificationDraftRepresentativeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _sameAsOwner = $v.sameAsOwner;
      _fullName = $v.fullName;
      _position = $v.position;
      _email = $v.email;
      _phone = $v.phone;
      _relationship = $v.relationship;
      _idType = $v.idType;
      _idNumber = $v.idNumber;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorVerificationDraftRepresentative other) {
    _$v = other as _$VendorVerificationDraftRepresentative;
  }

  @override
  void update(
      void Function(VendorVerificationDraftRepresentativeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorVerificationDraftRepresentative build() => _build();

  _$VendorVerificationDraftRepresentative _build() {
    final _$result = _$v ??
        _$VendorVerificationDraftRepresentative._(
          sameAsOwner: sameAsOwner,
          fullName: BuiltValueNullFieldError.checkNotNull(
              fullName, r'VendorVerificationDraftRepresentative', 'fullName'),
          position: position,
          email: email,
          phone: phone,
          relationship: relationship,
          idType: idType,
          idNumber: idNumber,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
