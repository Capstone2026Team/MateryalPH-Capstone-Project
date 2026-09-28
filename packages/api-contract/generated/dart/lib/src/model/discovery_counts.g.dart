// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discovery_counts.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DiscoveryCounts extends DiscoveryCounts {
  @override
  final int verifiedVendors;
  @override
  final int directorySuppliers;
  @override
  final int favoriteSuppliers;

  factory _$DiscoveryCounts([void Function(DiscoveryCountsBuilder)? updates]) =>
      (DiscoveryCountsBuilder()..update(updates))._build();

  _$DiscoveryCounts._(
      {required this.verifiedVendors,
      required this.directorySuppliers,
      required this.favoriteSuppliers})
      : super._();
  @override
  DiscoveryCounts rebuild(void Function(DiscoveryCountsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DiscoveryCountsBuilder toBuilder() => DiscoveryCountsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DiscoveryCounts &&
        verifiedVendors == other.verifiedVendors &&
        directorySuppliers == other.directorySuppliers &&
        favoriteSuppliers == other.favoriteSuppliers;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, verifiedVendors.hashCode);
    _$hash = $jc(_$hash, directorySuppliers.hashCode);
    _$hash = $jc(_$hash, favoriteSuppliers.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DiscoveryCounts')
          ..add('verifiedVendors', verifiedVendors)
          ..add('directorySuppliers', directorySuppliers)
          ..add('favoriteSuppliers', favoriteSuppliers))
        .toString();
  }
}

class DiscoveryCountsBuilder
    implements Builder<DiscoveryCounts, DiscoveryCountsBuilder> {
  _$DiscoveryCounts? _$v;

  int? _verifiedVendors;
  int? get verifiedVendors => _$this._verifiedVendors;
  set verifiedVendors(int? verifiedVendors) =>
      _$this._verifiedVendors = verifiedVendors;

  int? _directorySuppliers;
  int? get directorySuppliers => _$this._directorySuppliers;
  set directorySuppliers(int? directorySuppliers) =>
      _$this._directorySuppliers = directorySuppliers;

  int? _favoriteSuppliers;
  int? get favoriteSuppliers => _$this._favoriteSuppliers;
  set favoriteSuppliers(int? favoriteSuppliers) =>
      _$this._favoriteSuppliers = favoriteSuppliers;

  DiscoveryCountsBuilder() {
    DiscoveryCounts._defaults(this);
  }

  DiscoveryCountsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _verifiedVendors = $v.verifiedVendors;
      _directorySuppliers = $v.directorySuppliers;
      _favoriteSuppliers = $v.favoriteSuppliers;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DiscoveryCounts other) {
    _$v = other as _$DiscoveryCounts;
  }

  @override
  void update(void Function(DiscoveryCountsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DiscoveryCounts build() => _build();

  _$DiscoveryCounts _build() {
    final _$result = _$v ??
        _$DiscoveryCounts._(
          verifiedVendors: BuiltValueNullFieldError.checkNotNull(
              verifiedVendors, r'DiscoveryCounts', 'verifiedVendors'),
          directorySuppliers: BuiltValueNullFieldError.checkNotNull(
              directorySuppliers, r'DiscoveryCounts', 'directorySuppliers'),
          favoriteSuppliers: BuiltValueNullFieldError.checkNotNull(
              favoriteSuppliers, r'DiscoveryCounts', 'favoriteSuppliers'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
