// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quotation_location_search.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$QuotationLocationSearch extends QuotationLocationSearch {
  @override
  final String? query;
  @override
  final double? latitude;
  @override
  final double? longitude;
  @override
  final String? addressId;

  factory _$QuotationLocationSearch(
          [void Function(QuotationLocationSearchBuilder)? updates]) =>
      (QuotationLocationSearchBuilder()..update(updates))._build();

  _$QuotationLocationSearch._(
      {this.query, this.latitude, this.longitude, this.addressId})
      : super._();
  @override
  QuotationLocationSearch rebuild(
          void Function(QuotationLocationSearchBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  QuotationLocationSearchBuilder toBuilder() =>
      QuotationLocationSearchBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is QuotationLocationSearch &&
        query == other.query &&
        latitude == other.latitude &&
        longitude == other.longitude &&
        addressId == other.addressId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, query.hashCode);
    _$hash = $jc(_$hash, latitude.hashCode);
    _$hash = $jc(_$hash, longitude.hashCode);
    _$hash = $jc(_$hash, addressId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'QuotationLocationSearch')
          ..add('query', query)
          ..add('latitude', latitude)
          ..add('longitude', longitude)
          ..add('addressId', addressId))
        .toString();
  }
}

class QuotationLocationSearchBuilder
    implements
        Builder<QuotationLocationSearch, QuotationLocationSearchBuilder> {
  _$QuotationLocationSearch? _$v;

  String? _query;
  String? get query => _$this._query;
  set query(String? query) => _$this._query = query;

  double? _latitude;
  double? get latitude => _$this._latitude;
  set latitude(double? latitude) => _$this._latitude = latitude;

  double? _longitude;
  double? get longitude => _$this._longitude;
  set longitude(double? longitude) => _$this._longitude = longitude;

  String? _addressId;
  String? get addressId => _$this._addressId;
  set addressId(String? addressId) => _$this._addressId = addressId;

  QuotationLocationSearchBuilder() {
    QuotationLocationSearch._defaults(this);
  }

  QuotationLocationSearchBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _query = $v.query;
      _latitude = $v.latitude;
      _longitude = $v.longitude;
      _addressId = $v.addressId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(QuotationLocationSearch other) {
    _$v = other as _$QuotationLocationSearch;
  }

  @override
  void update(void Function(QuotationLocationSearchBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  QuotationLocationSearch build() => _build();

  _$QuotationLocationSearch _build() {
    final _$result = _$v ??
        _$QuotationLocationSearch._(
          query: query,
          latitude: latitude,
          longitude: longitude,
          addressId: addressId,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
