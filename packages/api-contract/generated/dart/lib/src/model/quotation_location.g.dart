// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quotation_location.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$QuotationLocation extends QuotationLocation {
  @override
  final String id;
  @override
  final String formattedAddress;
  @override
  final double latitude;
  @override
  final double longitude;

  factory _$QuotationLocation(
          [void Function(QuotationLocationBuilder)? updates]) =>
      (QuotationLocationBuilder()..update(updates))._build();

  _$QuotationLocation._(
      {required this.id,
      required this.formattedAddress,
      required this.latitude,
      required this.longitude})
      : super._();
  @override
  QuotationLocation rebuild(void Function(QuotationLocationBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  QuotationLocationBuilder toBuilder() =>
      QuotationLocationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is QuotationLocation &&
        id == other.id &&
        formattedAddress == other.formattedAddress &&
        latitude == other.latitude &&
        longitude == other.longitude;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, formattedAddress.hashCode);
    _$hash = $jc(_$hash, latitude.hashCode);
    _$hash = $jc(_$hash, longitude.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'QuotationLocation')
          ..add('id', id)
          ..add('formattedAddress', formattedAddress)
          ..add('latitude', latitude)
          ..add('longitude', longitude))
        .toString();
  }
}

class QuotationLocationBuilder
    implements Builder<QuotationLocation, QuotationLocationBuilder> {
  _$QuotationLocation? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

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

  QuotationLocationBuilder() {
    QuotationLocation._defaults(this);
  }

  QuotationLocationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _formattedAddress = $v.formattedAddress;
      _latitude = $v.latitude;
      _longitude = $v.longitude;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(QuotationLocation other) {
    _$v = other as _$QuotationLocation;
  }

  @override
  void update(void Function(QuotationLocationBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  QuotationLocation build() => _build();

  _$QuotationLocation _build() {
    final _$result = _$v ??
        _$QuotationLocation._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'QuotationLocation', 'id'),
          formattedAddress: BuiltValueNullFieldError.checkNotNull(
              formattedAddress, r'QuotationLocation', 'formattedAddress'),
          latitude: BuiltValueNullFieldError.checkNotNull(
              latitude, r'QuotationLocation', 'latitude'),
          longitude: BuiltValueNullFieldError.checkNotNull(
              longitude, r'QuotationLocation', 'longitude'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
