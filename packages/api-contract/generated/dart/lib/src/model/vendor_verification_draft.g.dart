// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_verification_draft.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const VendorVerificationDraftBusinessTypeEnum
    _$vendorVerificationDraftBusinessTypeEnum_SOLE_PROPRIETORSHIP =
    const VendorVerificationDraftBusinessTypeEnum._('SOLE_PROPRIETORSHIP');
const VendorVerificationDraftBusinessTypeEnum
    _$vendorVerificationDraftBusinessTypeEnum_PARTNERSHIP =
    const VendorVerificationDraftBusinessTypeEnum._('PARTNERSHIP');
const VendorVerificationDraftBusinessTypeEnum
    _$vendorVerificationDraftBusinessTypeEnum_CORPORATION =
    const VendorVerificationDraftBusinessTypeEnum._('CORPORATION');
const VendorVerificationDraftBusinessTypeEnum
    _$vendorVerificationDraftBusinessTypeEnum_ONE_PERSON_CORPORATION =
    const VendorVerificationDraftBusinessTypeEnum._('ONE_PERSON_CORPORATION');
const VendorVerificationDraftBusinessTypeEnum
    _$vendorVerificationDraftBusinessTypeEnum_COOPERATIVE =
    const VendorVerificationDraftBusinessTypeEnum._('COOPERATIVE');

VendorVerificationDraftBusinessTypeEnum
    _$vendorVerificationDraftBusinessTypeEnumValueOf(String name) {
  switch (name) {
    case 'SOLE_PROPRIETORSHIP':
      return _$vendorVerificationDraftBusinessTypeEnum_SOLE_PROPRIETORSHIP;
    case 'PARTNERSHIP':
      return _$vendorVerificationDraftBusinessTypeEnum_PARTNERSHIP;
    case 'CORPORATION':
      return _$vendorVerificationDraftBusinessTypeEnum_CORPORATION;
    case 'ONE_PERSON_CORPORATION':
      return _$vendorVerificationDraftBusinessTypeEnum_ONE_PERSON_CORPORATION;
    case 'COOPERATIVE':
      return _$vendorVerificationDraftBusinessTypeEnum_COOPERATIVE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<VendorVerificationDraftBusinessTypeEnum>
    _$vendorVerificationDraftBusinessTypeEnumValues = BuiltSet<
        VendorVerificationDraftBusinessTypeEnum>(const <VendorVerificationDraftBusinessTypeEnum>[
  _$vendorVerificationDraftBusinessTypeEnum_SOLE_PROPRIETORSHIP,
  _$vendorVerificationDraftBusinessTypeEnum_PARTNERSHIP,
  _$vendorVerificationDraftBusinessTypeEnum_CORPORATION,
  _$vendorVerificationDraftBusinessTypeEnum_ONE_PERSON_CORPORATION,
  _$vendorVerificationDraftBusinessTypeEnum_COOPERATIVE,
]);

Serializer<VendorVerificationDraftBusinessTypeEnum>
    _$vendorVerificationDraftBusinessTypeEnumSerializer =
    _$VendorVerificationDraftBusinessTypeEnumSerializer();

class _$VendorVerificationDraftBusinessTypeEnumSerializer
    implements PrimitiveSerializer<VendorVerificationDraftBusinessTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'SOLE_PROPRIETORSHIP': 'SOLE_PROPRIETORSHIP',
    'PARTNERSHIP': 'PARTNERSHIP',
    'CORPORATION': 'CORPORATION',
    'ONE_PERSON_CORPORATION': 'ONE_PERSON_CORPORATION',
    'COOPERATIVE': 'COOPERATIVE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'SOLE_PROPRIETORSHIP': 'SOLE_PROPRIETORSHIP',
    'PARTNERSHIP': 'PARTNERSHIP',
    'CORPORATION': 'CORPORATION',
    'ONE_PERSON_CORPORATION': 'ONE_PERSON_CORPORATION',
    'COOPERATIVE': 'COOPERATIVE',
  };

  @override
  final Iterable<Type> types = const <Type>[
    VendorVerificationDraftBusinessTypeEnum
  ];
  @override
  final String wireName = 'VendorVerificationDraftBusinessTypeEnum';

  @override
  Object serialize(Serializers serializers,
          VendorVerificationDraftBusinessTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  VendorVerificationDraftBusinessTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      VendorVerificationDraftBusinessTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$VendorVerificationDraft extends VendorVerificationDraft {
  @override
  final int lockVersion;
  @override
  final VendorVerificationDraftBusinessTypeEnum? businessType;
  @override
  final String? registeredName;
  @override
  final String? storeName;
  @override
  final Date? dateEstablished;
  @override
  final String? storeEmail;
  @override
  final String? storePhone;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>>? contacts;
  @override
  final BuiltMap<String, JsonObject?>? classification;
  @override
  final BuiltMap<String, JsonObject?>? address;
  @override
  final VendorVerificationDraftLegalIdentity? legalIdentity;
  @override
  final VendorVerificationDraftTaxProfile? taxProfile;

  factory _$VendorVerificationDraft(
          [void Function(VendorVerificationDraftBuilder)? updates]) =>
      (VendorVerificationDraftBuilder()..update(updates))._build();

  _$VendorVerificationDraft._(
      {required this.lockVersion,
      this.businessType,
      this.registeredName,
      this.storeName,
      this.dateEstablished,
      this.storeEmail,
      this.storePhone,
      this.contacts,
      this.classification,
      this.address,
      this.legalIdentity,
      this.taxProfile})
      : super._();
  @override
  VendorVerificationDraft rebuild(
          void Function(VendorVerificationDraftBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorVerificationDraftBuilder toBuilder() =>
      VendorVerificationDraftBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorVerificationDraft &&
        lockVersion == other.lockVersion &&
        businessType == other.businessType &&
        registeredName == other.registeredName &&
        storeName == other.storeName &&
        dateEstablished == other.dateEstablished &&
        storeEmail == other.storeEmail &&
        storePhone == other.storePhone &&
        contacts == other.contacts &&
        classification == other.classification &&
        address == other.address &&
        legalIdentity == other.legalIdentity &&
        taxProfile == other.taxProfile;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, businessType.hashCode);
    _$hash = $jc(_$hash, registeredName.hashCode);
    _$hash = $jc(_$hash, storeName.hashCode);
    _$hash = $jc(_$hash, dateEstablished.hashCode);
    _$hash = $jc(_$hash, storeEmail.hashCode);
    _$hash = $jc(_$hash, storePhone.hashCode);
    _$hash = $jc(_$hash, contacts.hashCode);
    _$hash = $jc(_$hash, classification.hashCode);
    _$hash = $jc(_$hash, address.hashCode);
    _$hash = $jc(_$hash, legalIdentity.hashCode);
    _$hash = $jc(_$hash, taxProfile.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorVerificationDraft')
          ..add('lockVersion', lockVersion)
          ..add('businessType', businessType)
          ..add('registeredName', registeredName)
          ..add('storeName', storeName)
          ..add('dateEstablished', dateEstablished)
          ..add('storeEmail', storeEmail)
          ..add('storePhone', storePhone)
          ..add('contacts', contacts)
          ..add('classification', classification)
          ..add('address', address)
          ..add('legalIdentity', legalIdentity)
          ..add('taxProfile', taxProfile))
        .toString();
  }
}

class VendorVerificationDraftBuilder
    implements
        Builder<VendorVerificationDraft, VendorVerificationDraftBuilder> {
  _$VendorVerificationDraft? _$v;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  VendorVerificationDraftBusinessTypeEnum? _businessType;
  VendorVerificationDraftBusinessTypeEnum? get businessType =>
      _$this._businessType;
  set businessType(VendorVerificationDraftBusinessTypeEnum? businessType) =>
      _$this._businessType = businessType;

  String? _registeredName;
  String? get registeredName => _$this._registeredName;
  set registeredName(String? registeredName) =>
      _$this._registeredName = registeredName;

  String? _storeName;
  String? get storeName => _$this._storeName;
  set storeName(String? storeName) => _$this._storeName = storeName;

  Date? _dateEstablished;
  Date? get dateEstablished => _$this._dateEstablished;
  set dateEstablished(Date? dateEstablished) =>
      _$this._dateEstablished = dateEstablished;

  String? _storeEmail;
  String? get storeEmail => _$this._storeEmail;
  set storeEmail(String? storeEmail) => _$this._storeEmail = storeEmail;

  String? _storePhone;
  String? get storePhone => _$this._storePhone;
  set storePhone(String? storePhone) => _$this._storePhone = storePhone;

  ListBuilder<BuiltMap<String, JsonObject?>>? _contacts;
  ListBuilder<BuiltMap<String, JsonObject?>> get contacts =>
      _$this._contacts ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set contacts(ListBuilder<BuiltMap<String, JsonObject?>>? contacts) =>
      _$this._contacts = contacts;

  MapBuilder<String, JsonObject?>? _classification;
  MapBuilder<String, JsonObject?> get classification =>
      _$this._classification ??= MapBuilder<String, JsonObject?>();
  set classification(MapBuilder<String, JsonObject?>? classification) =>
      _$this._classification = classification;

  MapBuilder<String, JsonObject?>? _address;
  MapBuilder<String, JsonObject?> get address =>
      _$this._address ??= MapBuilder<String, JsonObject?>();
  set address(MapBuilder<String, JsonObject?>? address) =>
      _$this._address = address;

  VendorVerificationDraftLegalIdentityBuilder? _legalIdentity;
  VendorVerificationDraftLegalIdentityBuilder get legalIdentity =>
      _$this._legalIdentity ??= VendorVerificationDraftLegalIdentityBuilder();
  set legalIdentity(
          VendorVerificationDraftLegalIdentityBuilder? legalIdentity) =>
      _$this._legalIdentity = legalIdentity;

  VendorVerificationDraftTaxProfileBuilder? _taxProfile;
  VendorVerificationDraftTaxProfileBuilder get taxProfile =>
      _$this._taxProfile ??= VendorVerificationDraftTaxProfileBuilder();
  set taxProfile(VendorVerificationDraftTaxProfileBuilder? taxProfile) =>
      _$this._taxProfile = taxProfile;

  VendorVerificationDraftBuilder() {
    VendorVerificationDraft._defaults(this);
  }

  VendorVerificationDraftBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _lockVersion = $v.lockVersion;
      _businessType = $v.businessType;
      _registeredName = $v.registeredName;
      _storeName = $v.storeName;
      _dateEstablished = $v.dateEstablished;
      _storeEmail = $v.storeEmail;
      _storePhone = $v.storePhone;
      _contacts = $v.contacts?.toBuilder();
      _classification = $v.classification?.toBuilder();
      _address = $v.address?.toBuilder();
      _legalIdentity = $v.legalIdentity?.toBuilder();
      _taxProfile = $v.taxProfile?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorVerificationDraft other) {
    _$v = other as _$VendorVerificationDraft;
  }

  @override
  void update(void Function(VendorVerificationDraftBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorVerificationDraft build() => _build();

  _$VendorVerificationDraft _build() {
    _$VendorVerificationDraft _$result;
    try {
      _$result = _$v ??
          _$VendorVerificationDraft._(
            lockVersion: BuiltValueNullFieldError.checkNotNull(
                lockVersion, r'VendorVerificationDraft', 'lockVersion'),
            businessType: businessType,
            registeredName: registeredName,
            storeName: storeName,
            dateEstablished: dateEstablished,
            storeEmail: storeEmail,
            storePhone: storePhone,
            contacts: _contacts?.build(),
            classification: _classification?.build(),
            address: _address?.build(),
            legalIdentity: _legalIdentity?.build(),
            taxProfile: _taxProfile?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'contacts';
        _contacts?.build();
        _$failedField = 'classification';
        _classification?.build();
        _$failedField = 'address';
        _address?.build();
        _$failedField = 'legalIdentity';
        _legalIdentity?.build();
        _$failedField = 'taxProfile';
        _taxProfile?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'VendorVerificationDraft', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
