// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'explore_counts.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ExploreCounts extends ExploreCounts {
  @override
  final int verifiedVendors;
  @override
  final int vendorListings;

  factory _$ExploreCounts([void Function(ExploreCountsBuilder)? updates]) =>
      (ExploreCountsBuilder()..update(updates))._build();

  _$ExploreCounts._(
      {required this.verifiedVendors, required this.vendorListings})
      : super._();
  @override
  ExploreCounts rebuild(void Function(ExploreCountsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ExploreCountsBuilder toBuilder() => ExploreCountsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ExploreCounts &&
        verifiedVendors == other.verifiedVendors &&
        vendorListings == other.vendorListings;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, verifiedVendors.hashCode);
    _$hash = $jc(_$hash, vendorListings.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ExploreCounts')
          ..add('verifiedVendors', verifiedVendors)
          ..add('vendorListings', vendorListings))
        .toString();
  }
}

class ExploreCountsBuilder
    implements Builder<ExploreCounts, ExploreCountsBuilder> {
  _$ExploreCounts? _$v;

  int? _verifiedVendors;
  int? get verifiedVendors => _$this._verifiedVendors;
  set verifiedVendors(int? verifiedVendors) =>
      _$this._verifiedVendors = verifiedVendors;

  int? _vendorListings;
  int? get vendorListings => _$this._vendorListings;
  set vendorListings(int? vendorListings) =>
      _$this._vendorListings = vendorListings;

  ExploreCountsBuilder() {
    ExploreCounts._defaults(this);
  }

  ExploreCountsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _verifiedVendors = $v.verifiedVendors;
      _vendorListings = $v.vendorListings;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ExploreCounts other) {
    _$v = other as _$ExploreCounts;
  }

  @override
  void update(void Function(ExploreCountsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ExploreCounts build() => _build();

  _$ExploreCounts _build() {
    final _$result = _$v ??
        _$ExploreCounts._(
          verifiedVendors: BuiltValueNullFieldError.checkNotNull(
              verifiedVendors, r'ExploreCounts', 'verifiedVendors'),
          vendorListings: BuiltValueNullFieldError.checkNotNull(
              vendorListings, r'ExploreCounts', 'vendorListings'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
