// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_address_selection.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorAddressSelection extends VendorAddressSelection {
  @override
  final String? pinToken;
  @override
  final String provinceCode;
  @override
  final String cityCode;
  @override
  final String psgcCode;
  @override
  final String? street;
  @override
  final String? unit;
  @override
  final String? postalCode;

  factory _$VendorAddressSelection(
          [void Function(VendorAddressSelectionBuilder)? updates]) =>
      (VendorAddressSelectionBuilder()..update(updates))._build();

  _$VendorAddressSelection._(
      {this.pinToken,
      required this.provinceCode,
      required this.cityCode,
      required this.psgcCode,
      this.street,
      this.unit,
      this.postalCode})
      : super._();
  @override
  VendorAddressSelection rebuild(
          void Function(VendorAddressSelectionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorAddressSelectionBuilder toBuilder() =>
      VendorAddressSelectionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorAddressSelection &&
        pinToken == other.pinToken &&
        provinceCode == other.provinceCode &&
        cityCode == other.cityCode &&
        psgcCode == other.psgcCode &&
        street == other.street &&
        unit == other.unit &&
        postalCode == other.postalCode;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, pinToken.hashCode);
    _$hash = $jc(_$hash, provinceCode.hashCode);
    _$hash = $jc(_$hash, cityCode.hashCode);
    _$hash = $jc(_$hash, psgcCode.hashCode);
    _$hash = $jc(_$hash, street.hashCode);
    _$hash = $jc(_$hash, unit.hashCode);
    _$hash = $jc(_$hash, postalCode.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorAddressSelection')
          ..add('pinToken', pinToken)
          ..add('provinceCode', provinceCode)
          ..add('cityCode', cityCode)
          ..add('psgcCode', psgcCode)
          ..add('street', street)
          ..add('unit', unit)
          ..add('postalCode', postalCode))
        .toString();
  }
}

class VendorAddressSelectionBuilder
    implements Builder<VendorAddressSelection, VendorAddressSelectionBuilder> {
  _$VendorAddressSelection? _$v;

  String? _pinToken;
  String? get pinToken => _$this._pinToken;
  set pinToken(String? pinToken) => _$this._pinToken = pinToken;

  String? _provinceCode;
  String? get provinceCode => _$this._provinceCode;
  set provinceCode(String? provinceCode) => _$this._provinceCode = provinceCode;

  String? _cityCode;
  String? get cityCode => _$this._cityCode;
  set cityCode(String? cityCode) => _$this._cityCode = cityCode;

  String? _psgcCode;
  String? get psgcCode => _$this._psgcCode;
  set psgcCode(String? psgcCode) => _$this._psgcCode = psgcCode;

  String? _street;
  String? get street => _$this._street;
  set street(String? street) => _$this._street = street;

  String? _unit;
  String? get unit => _$this._unit;
  set unit(String? unit) => _$this._unit = unit;

  String? _postalCode;
  String? get postalCode => _$this._postalCode;
  set postalCode(String? postalCode) => _$this._postalCode = postalCode;

  VendorAddressSelectionBuilder() {
    VendorAddressSelection._defaults(this);
  }

  VendorAddressSelectionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _pinToken = $v.pinToken;
      _provinceCode = $v.provinceCode;
      _cityCode = $v.cityCode;
      _psgcCode = $v.psgcCode;
      _street = $v.street;
      _unit = $v.unit;
      _postalCode = $v.postalCode;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorAddressSelection other) {
    _$v = other as _$VendorAddressSelection;
  }

  @override
  void update(void Function(VendorAddressSelectionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorAddressSelection build() => _build();

  _$VendorAddressSelection _build() {
    final _$result = _$v ??
        _$VendorAddressSelection._(
          pinToken: pinToken,
          provinceCode: BuiltValueNullFieldError.checkNotNull(
              provinceCode, r'VendorAddressSelection', 'provinceCode'),
          cityCode: BuiltValueNullFieldError.checkNotNull(
              cityCode, r'VendorAddressSelection', 'cityCode'),
          psgcCode: BuiltValueNullFieldError.checkNotNull(
              psgcCode, r'VendorAddressSelection', 'psgcCode'),
          street: street,
          unit: unit,
          postalCode: postalCode,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
