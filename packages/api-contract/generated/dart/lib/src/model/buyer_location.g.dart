// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buyer_location.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BuyerLocation extends BuyerLocation {
  @override
  final String id;
  @override
  final String? label;
  @override
  final BuyerLocationKind locationKind;
  @override
  final bool isPrimary;
  @override
  final String formattedAddress;
  @override
  final double latitude;
  @override
  final double longitude;
  @override
  final String source_;
  @override
  final int addressVersion;
  @override
  final AddressComponents components;
  @override
  final PsgcResolution psgc;
  @override
  final String? contactName;
  @override
  final String? contactPhoneE164;
  @override
  final String? siteInstructions;
  @override
  final int lockVersion;
  @override
  final DateTime updatedAt;

  factory _$BuyerLocation([void Function(BuyerLocationBuilder)? updates]) =>
      (BuyerLocationBuilder()..update(updates))._build();

  _$BuyerLocation._(
      {required this.id,
      this.label,
      required this.locationKind,
      required this.isPrimary,
      required this.formattedAddress,
      required this.latitude,
      required this.longitude,
      required this.source_,
      required this.addressVersion,
      required this.components,
      required this.psgc,
      this.contactName,
      this.contactPhoneE164,
      this.siteInstructions,
      required this.lockVersion,
      required this.updatedAt})
      : super._();
  @override
  BuyerLocation rebuild(void Function(BuyerLocationBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuyerLocationBuilder toBuilder() => BuyerLocationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuyerLocation &&
        id == other.id &&
        label == other.label &&
        locationKind == other.locationKind &&
        isPrimary == other.isPrimary &&
        formattedAddress == other.formattedAddress &&
        latitude == other.latitude &&
        longitude == other.longitude &&
        source_ == other.source_ &&
        addressVersion == other.addressVersion &&
        components == other.components &&
        psgc == other.psgc &&
        contactName == other.contactName &&
        contactPhoneE164 == other.contactPhoneE164 &&
        siteInstructions == other.siteInstructions &&
        lockVersion == other.lockVersion &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, locationKind.hashCode);
    _$hash = $jc(_$hash, isPrimary.hashCode);
    _$hash = $jc(_$hash, formattedAddress.hashCode);
    _$hash = $jc(_$hash, latitude.hashCode);
    _$hash = $jc(_$hash, longitude.hashCode);
    _$hash = $jc(_$hash, source_.hashCode);
    _$hash = $jc(_$hash, addressVersion.hashCode);
    _$hash = $jc(_$hash, components.hashCode);
    _$hash = $jc(_$hash, psgc.hashCode);
    _$hash = $jc(_$hash, contactName.hashCode);
    _$hash = $jc(_$hash, contactPhoneE164.hashCode);
    _$hash = $jc(_$hash, siteInstructions.hashCode);
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BuyerLocation')
          ..add('id', id)
          ..add('label', label)
          ..add('locationKind', locationKind)
          ..add('isPrimary', isPrimary)
          ..add('formattedAddress', formattedAddress)
          ..add('latitude', latitude)
          ..add('longitude', longitude)
          ..add('source_', source_)
          ..add('addressVersion', addressVersion)
          ..add('components', components)
          ..add('psgc', psgc)
          ..add('contactName', contactName)
          ..add('contactPhoneE164', contactPhoneE164)
          ..add('siteInstructions', siteInstructions)
          ..add('lockVersion', lockVersion)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class BuyerLocationBuilder
    implements Builder<BuyerLocation, BuyerLocationBuilder> {
  _$BuyerLocation? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  BuyerLocationKind? _locationKind;
  BuyerLocationKind? get locationKind => _$this._locationKind;
  set locationKind(BuyerLocationKind? locationKind) =>
      _$this._locationKind = locationKind;

  bool? _isPrimary;
  bool? get isPrimary => _$this._isPrimary;
  set isPrimary(bool? isPrimary) => _$this._isPrimary = isPrimary;

  String? _formattedAddress;
  String? get formattedAddress => _$this._formattedAddress;
  set formattedAddress(String? formattedAddress) =>
      _$this._formattedAddress = formattedAddress;

  double? _latitude;
  double? get latitude => _$this._latitude;
  set latitude(double? latitude) => _$this._latitude = latitude;

  double? _longitude;
  double? get longitude => _$this._longitude;
  set longitude(double? longitude) => _$this._longitude = longitude;

  String? _source_;
  String? get source_ => _$this._source_;
  set source_(String? source_) => _$this._source_ = source_;

  int? _addressVersion;
  int? get addressVersion => _$this._addressVersion;
  set addressVersion(int? addressVersion) =>
      _$this._addressVersion = addressVersion;

  AddressComponentsBuilder? _components;
  AddressComponentsBuilder get components =>
      _$this._components ??= AddressComponentsBuilder();
  set components(AddressComponentsBuilder? components) =>
      _$this._components = components;

  PsgcResolutionBuilder? _psgc;
  PsgcResolutionBuilder get psgc => _$this._psgc ??= PsgcResolutionBuilder();
  set psgc(PsgcResolutionBuilder? psgc) => _$this._psgc = psgc;

  String? _contactName;
  String? get contactName => _$this._contactName;
  set contactName(String? contactName) => _$this._contactName = contactName;

  String? _contactPhoneE164;
  String? get contactPhoneE164 => _$this._contactPhoneE164;
  set contactPhoneE164(String? contactPhoneE164) =>
      _$this._contactPhoneE164 = contactPhoneE164;

  String? _siteInstructions;
  String? get siteInstructions => _$this._siteInstructions;
  set siteInstructions(String? siteInstructions) =>
      _$this._siteInstructions = siteInstructions;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  BuyerLocationBuilder() {
    BuyerLocation._defaults(this);
  }

  BuyerLocationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _label = $v.label;
      _locationKind = $v.locationKind;
      _isPrimary = $v.isPrimary;
      _formattedAddress = $v.formattedAddress;
      _latitude = $v.latitude;
      _longitude = $v.longitude;
      _source_ = $v.source_;
      _addressVersion = $v.addressVersion;
      _components = $v.components.toBuilder();
      _psgc = $v.psgc.toBuilder();
      _contactName = $v.contactName;
      _contactPhoneE164 = $v.contactPhoneE164;
      _siteInstructions = $v.siteInstructions;
      _lockVersion = $v.lockVersion;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BuyerLocation other) {
    _$v = other as _$BuyerLocation;
  }

  @override
  void update(void Function(BuyerLocationBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BuyerLocation build() => _build();

  _$BuyerLocation _build() {
    _$BuyerLocation _$result;
    try {
      _$result = _$v ??
          _$BuyerLocation._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'BuyerLocation', 'id'),
            label: label,
            locationKind: BuiltValueNullFieldError.checkNotNull(
                locationKind, r'BuyerLocation', 'locationKind'),
            isPrimary: BuiltValueNullFieldError.checkNotNull(
                isPrimary, r'BuyerLocation', 'isPrimary'),
            formattedAddress: BuiltValueNullFieldError.checkNotNull(
                formattedAddress, r'BuyerLocation', 'formattedAddress'),
            latitude: BuiltValueNullFieldError.checkNotNull(
                latitude, r'BuyerLocation', 'latitude'),
            longitude: BuiltValueNullFieldError.checkNotNull(
                longitude, r'BuyerLocation', 'longitude'),
            source_: BuiltValueNullFieldError.checkNotNull(
                source_, r'BuyerLocation', 'source_'),
            addressVersion: BuiltValueNullFieldError.checkNotNull(
                addressVersion, r'BuyerLocation', 'addressVersion'),
            components: components.build(),
            psgc: psgc.build(),
            contactName: contactName,
            contactPhoneE164: contactPhoneE164,
            siteInstructions: siteInstructions,
            lockVersion: BuiltValueNullFieldError.checkNotNull(
                lockVersion, r'BuyerLocation', 'lockVersion'),
            updatedAt: BuiltValueNullFieldError.checkNotNull(
                updatedAt, r'BuyerLocation', 'updatedAt'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'components';
        components.build();
        _$failedField = 'psgc';
        psgc.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'BuyerLocation', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
