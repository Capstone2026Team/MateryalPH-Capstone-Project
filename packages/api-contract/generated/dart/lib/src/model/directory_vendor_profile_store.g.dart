// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'directory_vendor_profile_store.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DirectoryVendorProfileStore extends DirectoryVendorProfileStore {
  @override
  final String? legalName;
  @override
  final String? registeredName;
  @override
  final String? businessType;
  @override
  final String? description;
  @override
  final String? logoUrl;
  @override
  final String? bannerUrl;
  @override
  final String? contactEmail;
  @override
  final String? contactPhone;
  @override
  final String? address;
  @override
  final String? location;
  @override
  final String verificationStatus;
  @override
  final String setupStatus;
  @override
  final String activationStatus;
  @override
  final String discoverabilityStatus;
  @override
  final String accountStatus;
  @override
  final String? activationHoldCode;
  @override
  final bool vacationMode;
  @override
  final bool bulkCapability;
  @override
  final DateTime joinedAt;

  factory _$DirectoryVendorProfileStore(
          [void Function(DirectoryVendorProfileStoreBuilder)? updates]) =>
      (DirectoryVendorProfileStoreBuilder()..update(updates))._build();

  _$DirectoryVendorProfileStore._(
      {this.legalName,
      this.registeredName,
      this.businessType,
      this.description,
      this.logoUrl,
      this.bannerUrl,
      this.contactEmail,
      this.contactPhone,
      this.address,
      this.location,
      required this.verificationStatus,
      required this.setupStatus,
      required this.activationStatus,
      required this.discoverabilityStatus,
      required this.accountStatus,
      this.activationHoldCode,
      required this.vacationMode,
      required this.bulkCapability,
      required this.joinedAt})
      : super._();
  @override
  DirectoryVendorProfileStore rebuild(
          void Function(DirectoryVendorProfileStoreBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DirectoryVendorProfileStoreBuilder toBuilder() =>
      DirectoryVendorProfileStoreBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DirectoryVendorProfileStore &&
        legalName == other.legalName &&
        registeredName == other.registeredName &&
        businessType == other.businessType &&
        description == other.description &&
        logoUrl == other.logoUrl &&
        bannerUrl == other.bannerUrl &&
        contactEmail == other.contactEmail &&
        contactPhone == other.contactPhone &&
        address == other.address &&
        location == other.location &&
        verificationStatus == other.verificationStatus &&
        setupStatus == other.setupStatus &&
        activationStatus == other.activationStatus &&
        discoverabilityStatus == other.discoverabilityStatus &&
        accountStatus == other.accountStatus &&
        activationHoldCode == other.activationHoldCode &&
        vacationMode == other.vacationMode &&
        bulkCapability == other.bulkCapability &&
        joinedAt == other.joinedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, legalName.hashCode);
    _$hash = $jc(_$hash, registeredName.hashCode);
    _$hash = $jc(_$hash, businessType.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, logoUrl.hashCode);
    _$hash = $jc(_$hash, bannerUrl.hashCode);
    _$hash = $jc(_$hash, contactEmail.hashCode);
    _$hash = $jc(_$hash, contactPhone.hashCode);
    _$hash = $jc(_$hash, address.hashCode);
    _$hash = $jc(_$hash, location.hashCode);
    _$hash = $jc(_$hash, verificationStatus.hashCode);
    _$hash = $jc(_$hash, setupStatus.hashCode);
    _$hash = $jc(_$hash, activationStatus.hashCode);
    _$hash = $jc(_$hash, discoverabilityStatus.hashCode);
    _$hash = $jc(_$hash, accountStatus.hashCode);
    _$hash = $jc(_$hash, activationHoldCode.hashCode);
    _$hash = $jc(_$hash, vacationMode.hashCode);
    _$hash = $jc(_$hash, bulkCapability.hashCode);
    _$hash = $jc(_$hash, joinedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DirectoryVendorProfileStore')
          ..add('legalName', legalName)
          ..add('registeredName', registeredName)
          ..add('businessType', businessType)
          ..add('description', description)
          ..add('logoUrl', logoUrl)
          ..add('bannerUrl', bannerUrl)
          ..add('contactEmail', contactEmail)
          ..add('contactPhone', contactPhone)
          ..add('address', address)
          ..add('location', location)
          ..add('verificationStatus', verificationStatus)
          ..add('setupStatus', setupStatus)
          ..add('activationStatus', activationStatus)
          ..add('discoverabilityStatus', discoverabilityStatus)
          ..add('accountStatus', accountStatus)
          ..add('activationHoldCode', activationHoldCode)
          ..add('vacationMode', vacationMode)
          ..add('bulkCapability', bulkCapability)
          ..add('joinedAt', joinedAt))
        .toString();
  }
}

class DirectoryVendorProfileStoreBuilder
    implements
        Builder<DirectoryVendorProfileStore,
            DirectoryVendorProfileStoreBuilder> {
  _$DirectoryVendorProfileStore? _$v;

  String? _legalName;
  String? get legalName => _$this._legalName;
  set legalName(String? legalName) => _$this._legalName = legalName;

  String? _registeredName;
  String? get registeredName => _$this._registeredName;
  set registeredName(String? registeredName) =>
      _$this._registeredName = registeredName;

  String? _businessType;
  String? get businessType => _$this._businessType;
  set businessType(String? businessType) => _$this._businessType = businessType;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  String? _logoUrl;
  String? get logoUrl => _$this._logoUrl;
  set logoUrl(String? logoUrl) => _$this._logoUrl = logoUrl;

  String? _bannerUrl;
  String? get bannerUrl => _$this._bannerUrl;
  set bannerUrl(String? bannerUrl) => _$this._bannerUrl = bannerUrl;

  String? _contactEmail;
  String? get contactEmail => _$this._contactEmail;
  set contactEmail(String? contactEmail) => _$this._contactEmail = contactEmail;

  String? _contactPhone;
  String? get contactPhone => _$this._contactPhone;
  set contactPhone(String? contactPhone) => _$this._contactPhone = contactPhone;

  String? _address;
  String? get address => _$this._address;
  set address(String? address) => _$this._address = address;

  String? _location;
  String? get location => _$this._location;
  set location(String? location) => _$this._location = location;

  String? _verificationStatus;
  String? get verificationStatus => _$this._verificationStatus;
  set verificationStatus(String? verificationStatus) =>
      _$this._verificationStatus = verificationStatus;

  String? _setupStatus;
  String? get setupStatus => _$this._setupStatus;
  set setupStatus(String? setupStatus) => _$this._setupStatus = setupStatus;

  String? _activationStatus;
  String? get activationStatus => _$this._activationStatus;
  set activationStatus(String? activationStatus) =>
      _$this._activationStatus = activationStatus;

  String? _discoverabilityStatus;
  String? get discoverabilityStatus => _$this._discoverabilityStatus;
  set discoverabilityStatus(String? discoverabilityStatus) =>
      _$this._discoverabilityStatus = discoverabilityStatus;

  String? _accountStatus;
  String? get accountStatus => _$this._accountStatus;
  set accountStatus(String? accountStatus) =>
      _$this._accountStatus = accountStatus;

  String? _activationHoldCode;
  String? get activationHoldCode => _$this._activationHoldCode;
  set activationHoldCode(String? activationHoldCode) =>
      _$this._activationHoldCode = activationHoldCode;

  bool? _vacationMode;
  bool? get vacationMode => _$this._vacationMode;
  set vacationMode(bool? vacationMode) => _$this._vacationMode = vacationMode;

  bool? _bulkCapability;
  bool? get bulkCapability => _$this._bulkCapability;
  set bulkCapability(bool? bulkCapability) =>
      _$this._bulkCapability = bulkCapability;

  DateTime? _joinedAt;
  DateTime? get joinedAt => _$this._joinedAt;
  set joinedAt(DateTime? joinedAt) => _$this._joinedAt = joinedAt;

  DirectoryVendorProfileStoreBuilder() {
    DirectoryVendorProfileStore._defaults(this);
  }

  DirectoryVendorProfileStoreBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _legalName = $v.legalName;
      _registeredName = $v.registeredName;
      _businessType = $v.businessType;
      _description = $v.description;
      _logoUrl = $v.logoUrl;
      _bannerUrl = $v.bannerUrl;
      _contactEmail = $v.contactEmail;
      _contactPhone = $v.contactPhone;
      _address = $v.address;
      _location = $v.location;
      _verificationStatus = $v.verificationStatus;
      _setupStatus = $v.setupStatus;
      _activationStatus = $v.activationStatus;
      _discoverabilityStatus = $v.discoverabilityStatus;
      _accountStatus = $v.accountStatus;
      _activationHoldCode = $v.activationHoldCode;
      _vacationMode = $v.vacationMode;
      _bulkCapability = $v.bulkCapability;
      _joinedAt = $v.joinedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DirectoryVendorProfileStore other) {
    _$v = other as _$DirectoryVendorProfileStore;
  }

  @override
  void update(void Function(DirectoryVendorProfileStoreBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DirectoryVendorProfileStore build() => _build();

  _$DirectoryVendorProfileStore _build() {
    final _$result = _$v ??
        _$DirectoryVendorProfileStore._(
          legalName: legalName,
          registeredName: registeredName,
          businessType: businessType,
          description: description,
          logoUrl: logoUrl,
          bannerUrl: bannerUrl,
          contactEmail: contactEmail,
          contactPhone: contactPhone,
          address: address,
          location: location,
          verificationStatus: BuiltValueNullFieldError.checkNotNull(
              verificationStatus,
              r'DirectoryVendorProfileStore',
              'verificationStatus'),
          setupStatus: BuiltValueNullFieldError.checkNotNull(
              setupStatus, r'DirectoryVendorProfileStore', 'setupStatus'),
          activationStatus: BuiltValueNullFieldError.checkNotNull(
              activationStatus,
              r'DirectoryVendorProfileStore',
              'activationStatus'),
          discoverabilityStatus: BuiltValueNullFieldError.checkNotNull(
              discoverabilityStatus,
              r'DirectoryVendorProfileStore',
              'discoverabilityStatus'),
          accountStatus: BuiltValueNullFieldError.checkNotNull(
              accountStatus, r'DirectoryVendorProfileStore', 'accountStatus'),
          activationHoldCode: activationHoldCode,
          vacationMode: BuiltValueNullFieldError.checkNotNull(
              vacationMode, r'DirectoryVendorProfileStore', 'vacationMode'),
          bulkCapability: BuiltValueNullFieldError.checkNotNull(
              bulkCapability, r'DirectoryVendorProfileStore', 'bulkCapability'),
          joinedAt: BuiltValueNullFieldError.checkNotNull(
              joinedAt, r'DirectoryVendorProfileStore', 'joinedAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
