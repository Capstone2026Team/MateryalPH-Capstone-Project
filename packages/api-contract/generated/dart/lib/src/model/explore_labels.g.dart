// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'explore_labels.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ExploreLabels extends ExploreLabels {
  @override
  final String verifiedVendors;
  @override
  final String vendorListings;
  @override
  final String vendorListingsUnit;

  factory _$ExploreLabels([void Function(ExploreLabelsBuilder)? updates]) =>
      (ExploreLabelsBuilder()..update(updates))._build();

  _$ExploreLabels._(
      {required this.verifiedVendors,
      required this.vendorListings,
      required this.vendorListingsUnit})
      : super._();
  @override
  ExploreLabels rebuild(void Function(ExploreLabelsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ExploreLabelsBuilder toBuilder() => ExploreLabelsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ExploreLabels &&
        verifiedVendors == other.verifiedVendors &&
        vendorListings == other.vendorListings &&
        vendorListingsUnit == other.vendorListingsUnit;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, verifiedVendors.hashCode);
    _$hash = $jc(_$hash, vendorListings.hashCode);
    _$hash = $jc(_$hash, vendorListingsUnit.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ExploreLabels')
          ..add('verifiedVendors', verifiedVendors)
          ..add('vendorListings', vendorListings)
          ..add('vendorListingsUnit', vendorListingsUnit))
        .toString();
  }
}

class ExploreLabelsBuilder
    implements Builder<ExploreLabels, ExploreLabelsBuilder> {
  _$ExploreLabels? _$v;

  String? _verifiedVendors;
  String? get verifiedVendors => _$this._verifiedVendors;
  set verifiedVendors(String? verifiedVendors) =>
      _$this._verifiedVendors = verifiedVendors;

  String? _vendorListings;
  String? get vendorListings => _$this._vendorListings;
  set vendorListings(String? vendorListings) =>
      _$this._vendorListings = vendorListings;

  String? _vendorListingsUnit;
  String? get vendorListingsUnit => _$this._vendorListingsUnit;
  set vendorListingsUnit(String? vendorListingsUnit) =>
      _$this._vendorListingsUnit = vendorListingsUnit;

  ExploreLabelsBuilder() {
    ExploreLabels._defaults(this);
  }

  ExploreLabelsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _verifiedVendors = $v.verifiedVendors;
      _vendorListings = $v.vendorListings;
      _vendorListingsUnit = $v.vendorListingsUnit;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ExploreLabels other) {
    _$v = other as _$ExploreLabels;
  }

  @override
  void update(void Function(ExploreLabelsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ExploreLabels build() => _build();

  _$ExploreLabels _build() {
    final _$result = _$v ??
        _$ExploreLabels._(
          verifiedVendors: BuiltValueNullFieldError.checkNotNull(
              verifiedVendors, r'ExploreLabels', 'verifiedVendors'),
          vendorListings: BuiltValueNullFieldError.checkNotNull(
              vendorListings, r'ExploreLabels', 'vendorListings'),
          vendorListingsUnit: BuiltValueNullFieldError.checkNotNull(
              vendorListingsUnit, r'ExploreLabels', 'vendorListingsUnit'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
