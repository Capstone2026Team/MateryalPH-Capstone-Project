// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_business_address.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorBusinessAddress extends VendorBusinessAddress {
  @override
  final String street;
  @override
  final String barangay;
  @override
  final String city;
  @override
  final String province;
  @override
  final String postalCode;
  @override
  final num? latitude;
  @override
  final num? longitude;

  factory _$VendorBusinessAddress(
          [void Function(VendorBusinessAddressBuilder)? updates]) =>
      (VendorBusinessAddressBuilder()..update(updates))._build();

  _$VendorBusinessAddress._(
      {required this.street,
      required this.barangay,
      required this.city,
      required this.province,
      required this.postalCode,
      this.latitude,
      this.longitude})
      : super._();
  @override
  VendorBusinessAddress rebuild(
          void Function(VendorBusinessAddressBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorBusinessAddressBuilder toBuilder() =>
      VendorBusinessAddressBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorBusinessAddress &&
        street == other.street &&
        barangay == other.barangay &&
        city == other.city &&
        province == other.province &&
        postalCode == other.postalCode &&
        latitude == other.latitude &&
        longitude == other.longitude;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, street.hashCode);
    _$hash = $jc(_$hash, barangay.hashCode);
    _$hash = $jc(_$hash, city.hashCode);
    _$hash = $jc(_$hash, province.hashCode);
    _$hash = $jc(_$hash, postalCode.hashCode);
    _$hash = $jc(_$hash, latitude.hashCode);
    _$hash = $jc(_$hash, longitude.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorBusinessAddress')
          ..add('street', street)
          ..add('barangay', barangay)
          ..add('city', city)
          ..add('province', province)
          ..add('postalCode', postalCode)
          ..add('latitude', latitude)
          ..add('longitude', longitude))
        .toString();
  }
}

class VendorBusinessAddressBuilder
    implements Builder<VendorBusinessAddress, VendorBusinessAddressBuilder> {
  _$VendorBusinessAddress? _$v;

  String? _street;
  String? get street => _$this._street;
  set street(String? street) => _$this._street = street;

  String? _barangay;
  String? get barangay => _$this._barangay;
  set barangay(String? barangay) => _$this._barangay = barangay;

  String? _city;
  String? get city => _$this._city;
  set city(String? city) => _$this._city = city;

  String? _province;
  String? get province => _$this._province;
  set province(String? province) => _$this._province = province;

  String? _postalCode;
  String? get postalCode => _$this._postalCode;
  set postalCode(String? postalCode) => _$this._postalCode = postalCode;

  num? _latitude;
  num? get latitude => _$this._latitude;
  set latitude(num? latitude) => _$this._latitude = latitude;

  num? _longitude;
  num? get longitude => _$this._longitude;
  set longitude(num? longitude) => _$this._longitude = longitude;

  VendorBusinessAddressBuilder() {
    VendorBusinessAddress._defaults(this);
  }

  VendorBusinessAddressBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _street = $v.street;
      _barangay = $v.barangay;
      _city = $v.city;
      _province = $v.province;
      _postalCode = $v.postalCode;
      _latitude = $v.latitude;
      _longitude = $v.longitude;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorBusinessAddress other) {
    _$v = other as _$VendorBusinessAddress;
  }

  @override
  void update(void Function(VendorBusinessAddressBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorBusinessAddress build() => _build();

  _$VendorBusinessAddress _build() {
    final _$result = _$v ??
        _$VendorBusinessAddress._(
          street: BuiltValueNullFieldError.checkNotNull(
              street, r'VendorBusinessAddress', 'street'),
          barangay: BuiltValueNullFieldError.checkNotNull(
              barangay, r'VendorBusinessAddress', 'barangay'),
          city: BuiltValueNullFieldError.checkNotNull(
              city, r'VendorBusinessAddress', 'city'),
          province: BuiltValueNullFieldError.checkNotNull(
              province, r'VendorBusinessAddress', 'province'),
          postalCode: BuiltValueNullFieldError.checkNotNull(
              postalCode, r'VendorBusinessAddress', 'postalCode'),
          latitude: latitude,
          longitude: longitude,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
