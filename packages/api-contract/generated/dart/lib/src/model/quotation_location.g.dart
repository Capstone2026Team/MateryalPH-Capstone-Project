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

  factory _$QuotationLocation(
          [void Function(QuotationLocationBuilder)? updates]) =>
      (QuotationLocationBuilder()..update(updates))._build();

  _$QuotationLocation._({required this.id, required this.formattedAddress})
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
        formattedAddress == other.formattedAddress;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, formattedAddress.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'QuotationLocation')
          ..add('id', id)
          ..add('formattedAddress', formattedAddress))
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

  QuotationLocationBuilder() {
    QuotationLocation._defaults(this);
  }

  QuotationLocationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _formattedAddress = $v.formattedAddress;
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
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
