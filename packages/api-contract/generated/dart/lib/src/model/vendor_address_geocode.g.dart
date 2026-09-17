// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_address_geocode.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorAddressGeocode extends VendorAddressGeocode {
  @override
  final num latitude;
  @override
  final num longitude;

  factory _$VendorAddressGeocode(
          [void Function(VendorAddressGeocodeBuilder)? updates]) =>
      (VendorAddressGeocodeBuilder()..update(updates))._build();

  _$VendorAddressGeocode._({required this.latitude, required this.longitude})
      : super._();
  @override
  VendorAddressGeocode rebuild(
          void Function(VendorAddressGeocodeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorAddressGeocodeBuilder toBuilder() =>
      VendorAddressGeocodeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorAddressGeocode &&
        latitude == other.latitude &&
        longitude == other.longitude;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, latitude.hashCode);
    _$hash = $jc(_$hash, longitude.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorAddressGeocode')
          ..add('latitude', latitude)
          ..add('longitude', longitude))
        .toString();
  }
}

class VendorAddressGeocodeBuilder
    implements Builder<VendorAddressGeocode, VendorAddressGeocodeBuilder> {
  _$VendorAddressGeocode? _$v;

  num? _latitude;
  num? get latitude => _$this._latitude;
  set latitude(num? latitude) => _$this._latitude = latitude;

  num? _longitude;
  num? get longitude => _$this._longitude;
  set longitude(num? longitude) => _$this._longitude = longitude;

  VendorAddressGeocodeBuilder() {
    VendorAddressGeocode._defaults(this);
  }

  VendorAddressGeocodeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _latitude = $v.latitude;
      _longitude = $v.longitude;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorAddressGeocode other) {
    _$v = other as _$VendorAddressGeocode;
  }

  @override
  void update(void Function(VendorAddressGeocodeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorAddressGeocode build() => _build();

  _$VendorAddressGeocode _build() {
    final _$result = _$v ??
        _$VendorAddressGeocode._(
          latitude: BuiltValueNullFieldError.checkNotNull(
              latitude, r'VendorAddressGeocode', 'latitude'),
          longitude: BuiltValueNullFieldError.checkNotNull(
              longitude, r'VendorAddressGeocode', 'longitude'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
