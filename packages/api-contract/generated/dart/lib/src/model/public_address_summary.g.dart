// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_address_summary.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PublicAddressSummary extends PublicAddressSummary {
  @override
  final String? formattedAddress;
  @override
  final String? cityMunicipality;
  @override
  final String? province;

  factory _$PublicAddressSummary(
          [void Function(PublicAddressSummaryBuilder)? updates]) =>
      (PublicAddressSummaryBuilder()..update(updates))._build();

  _$PublicAddressSummary._(
      {this.formattedAddress, this.cityMunicipality, this.province})
      : super._();
  @override
  PublicAddressSummary rebuild(
          void Function(PublicAddressSummaryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PublicAddressSummaryBuilder toBuilder() =>
      PublicAddressSummaryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PublicAddressSummary &&
        formattedAddress == other.formattedAddress &&
        cityMunicipality == other.cityMunicipality &&
        province == other.province;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, formattedAddress.hashCode);
    _$hash = $jc(_$hash, cityMunicipality.hashCode);
    _$hash = $jc(_$hash, province.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PublicAddressSummary')
          ..add('formattedAddress', formattedAddress)
          ..add('cityMunicipality', cityMunicipality)
          ..add('province', province))
        .toString();
  }
}

class PublicAddressSummaryBuilder
    implements Builder<PublicAddressSummary, PublicAddressSummaryBuilder> {
  _$PublicAddressSummary? _$v;

  String? _formattedAddress;
  String? get formattedAddress => _$this._formattedAddress;
  set formattedAddress(String? formattedAddress) =>
      _$this._formattedAddress = formattedAddress;

  String? _cityMunicipality;
  String? get cityMunicipality => _$this._cityMunicipality;
  set cityMunicipality(String? cityMunicipality) =>
      _$this._cityMunicipality = cityMunicipality;

  String? _province;
  String? get province => _$this._province;
  set province(String? province) => _$this._province = province;

  PublicAddressSummaryBuilder() {
    PublicAddressSummary._defaults(this);
  }

  PublicAddressSummaryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _formattedAddress = $v.formattedAddress;
      _cityMunicipality = $v.cityMunicipality;
      _province = $v.province;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PublicAddressSummary other) {
    _$v = other as _$PublicAddressSummary;
  }

  @override
  void update(void Function(PublicAddressSummaryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PublicAddressSummary build() => _build();

  _$PublicAddressSummary _build() {
    final _$result = _$v ??
        _$PublicAddressSummary._(
          formattedAddress: formattedAddress,
          cityMunicipality: cityMunicipality,
          province: province,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
