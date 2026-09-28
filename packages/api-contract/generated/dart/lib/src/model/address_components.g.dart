// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_components.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AddressComponents extends AddressComponents {
  @override
  final String? street;
  @override
  final String? barangay;
  @override
  final String? cityMunicipality;
  @override
  final String? province;
  @override
  final String? postalCode;

  factory _$AddressComponents(
          [void Function(AddressComponentsBuilder)? updates]) =>
      (AddressComponentsBuilder()..update(updates))._build();

  _$AddressComponents._(
      {this.street,
      this.barangay,
      this.cityMunicipality,
      this.province,
      this.postalCode})
      : super._();
  @override
  AddressComponents rebuild(void Function(AddressComponentsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AddressComponentsBuilder toBuilder() =>
      AddressComponentsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AddressComponents &&
        street == other.street &&
        barangay == other.barangay &&
        cityMunicipality == other.cityMunicipality &&
        province == other.province &&
        postalCode == other.postalCode;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, street.hashCode);
    _$hash = $jc(_$hash, barangay.hashCode);
    _$hash = $jc(_$hash, cityMunicipality.hashCode);
    _$hash = $jc(_$hash, province.hashCode);
    _$hash = $jc(_$hash, postalCode.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AddressComponents')
          ..add('street', street)
          ..add('barangay', barangay)
          ..add('cityMunicipality', cityMunicipality)
          ..add('province', province)
          ..add('postalCode', postalCode))
        .toString();
  }
}

class AddressComponentsBuilder
    implements Builder<AddressComponents, AddressComponentsBuilder> {
  _$AddressComponents? _$v;

  String? _street;
  String? get street => _$this._street;
  set street(String? street) => _$this._street = street;

  String? _barangay;
  String? get barangay => _$this._barangay;
  set barangay(String? barangay) => _$this._barangay = barangay;

  String? _cityMunicipality;
  String? get cityMunicipality => _$this._cityMunicipality;
  set cityMunicipality(String? cityMunicipality) =>
      _$this._cityMunicipality = cityMunicipality;

  String? _province;
  String? get province => _$this._province;
  set province(String? province) => _$this._province = province;

  String? _postalCode;
  String? get postalCode => _$this._postalCode;
  set postalCode(String? postalCode) => _$this._postalCode = postalCode;

  AddressComponentsBuilder() {
    AddressComponents._defaults(this);
  }

  AddressComponentsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _street = $v.street;
      _barangay = $v.barangay;
      _cityMunicipality = $v.cityMunicipality;
      _province = $v.province;
      _postalCode = $v.postalCode;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AddressComponents other) {
    _$v = other as _$AddressComponents;
  }

  @override
  void update(void Function(AddressComponentsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AddressComponents build() => _build();

  _$AddressComponents _build() {
    final _$result = _$v ??
        _$AddressComponents._(
          street: street,
          barangay: barangay,
          cityMunicipality: cityMunicipality,
          province: province,
          postalCode: postalCode,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
