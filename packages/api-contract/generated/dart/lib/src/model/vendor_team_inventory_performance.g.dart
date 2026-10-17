// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_team_inventory_performance.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorTeamInventoryPerformance extends VendorTeamInventoryPerformance {
  @override
  final int stockUpdates;
  @override
  final int stockConfirmations;
  @override
  final int listingsCreated;
  @override
  final int listingUpdates;
  @override
  final int complianceSubmissions;
  @override
  final int allotmentUpdates;
  @override
  final int unsuccessful;

  factory _$VendorTeamInventoryPerformance(
          [void Function(VendorTeamInventoryPerformanceBuilder)? updates]) =>
      (VendorTeamInventoryPerformanceBuilder()..update(updates))._build();

  _$VendorTeamInventoryPerformance._(
      {required this.stockUpdates,
      required this.stockConfirmations,
      required this.listingsCreated,
      required this.listingUpdates,
      required this.complianceSubmissions,
      required this.allotmentUpdates,
      required this.unsuccessful})
      : super._();
  @override
  VendorTeamInventoryPerformance rebuild(
          void Function(VendorTeamInventoryPerformanceBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorTeamInventoryPerformanceBuilder toBuilder() =>
      VendorTeamInventoryPerformanceBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorTeamInventoryPerformance &&
        stockUpdates == other.stockUpdates &&
        stockConfirmations == other.stockConfirmations &&
        listingsCreated == other.listingsCreated &&
        listingUpdates == other.listingUpdates &&
        complianceSubmissions == other.complianceSubmissions &&
        allotmentUpdates == other.allotmentUpdates &&
        unsuccessful == other.unsuccessful;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, stockUpdates.hashCode);
    _$hash = $jc(_$hash, stockConfirmations.hashCode);
    _$hash = $jc(_$hash, listingsCreated.hashCode);
    _$hash = $jc(_$hash, listingUpdates.hashCode);
    _$hash = $jc(_$hash, complianceSubmissions.hashCode);
    _$hash = $jc(_$hash, allotmentUpdates.hashCode);
    _$hash = $jc(_$hash, unsuccessful.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorTeamInventoryPerformance')
          ..add('stockUpdates', stockUpdates)
          ..add('stockConfirmations', stockConfirmations)
          ..add('listingsCreated', listingsCreated)
          ..add('listingUpdates', listingUpdates)
          ..add('complianceSubmissions', complianceSubmissions)
          ..add('allotmentUpdates', allotmentUpdates)
          ..add('unsuccessful', unsuccessful))
        .toString();
  }
}

class VendorTeamInventoryPerformanceBuilder
    implements
        Builder<VendorTeamInventoryPerformance,
            VendorTeamInventoryPerformanceBuilder> {
  _$VendorTeamInventoryPerformance? _$v;

  int? _stockUpdates;
  int? get stockUpdates => _$this._stockUpdates;
  set stockUpdates(int? stockUpdates) => _$this._stockUpdates = stockUpdates;

  int? _stockConfirmations;
  int? get stockConfirmations => _$this._stockConfirmations;
  set stockConfirmations(int? stockConfirmations) =>
      _$this._stockConfirmations = stockConfirmations;

  int? _listingsCreated;
  int? get listingsCreated => _$this._listingsCreated;
  set listingsCreated(int? listingsCreated) =>
      _$this._listingsCreated = listingsCreated;

  int? _listingUpdates;
  int? get listingUpdates => _$this._listingUpdates;
  set listingUpdates(int? listingUpdates) =>
      _$this._listingUpdates = listingUpdates;

  int? _complianceSubmissions;
  int? get complianceSubmissions => _$this._complianceSubmissions;
  set complianceSubmissions(int? complianceSubmissions) =>
      _$this._complianceSubmissions = complianceSubmissions;

  int? _allotmentUpdates;
  int? get allotmentUpdates => _$this._allotmentUpdates;
  set allotmentUpdates(int? allotmentUpdates) =>
      _$this._allotmentUpdates = allotmentUpdates;

  int? _unsuccessful;
  int? get unsuccessful => _$this._unsuccessful;
  set unsuccessful(int? unsuccessful) => _$this._unsuccessful = unsuccessful;

  VendorTeamInventoryPerformanceBuilder() {
    VendorTeamInventoryPerformance._defaults(this);
  }

  VendorTeamInventoryPerformanceBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _stockUpdates = $v.stockUpdates;
      _stockConfirmations = $v.stockConfirmations;
      _listingsCreated = $v.listingsCreated;
      _listingUpdates = $v.listingUpdates;
      _complianceSubmissions = $v.complianceSubmissions;
      _allotmentUpdates = $v.allotmentUpdates;
      _unsuccessful = $v.unsuccessful;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorTeamInventoryPerformance other) {
    _$v = other as _$VendorTeamInventoryPerformance;
  }

  @override
  void update(void Function(VendorTeamInventoryPerformanceBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorTeamInventoryPerformance build() => _build();

  _$VendorTeamInventoryPerformance _build() {
    final _$result = _$v ??
        _$VendorTeamInventoryPerformance._(
          stockUpdates: BuiltValueNullFieldError.checkNotNull(
              stockUpdates, r'VendorTeamInventoryPerformance', 'stockUpdates'),
          stockConfirmations: BuiltValueNullFieldError.checkNotNull(
              stockConfirmations,
              r'VendorTeamInventoryPerformance',
              'stockConfirmations'),
          listingsCreated: BuiltValueNullFieldError.checkNotNull(
              listingsCreated,
              r'VendorTeamInventoryPerformance',
              'listingsCreated'),
          listingUpdates: BuiltValueNullFieldError.checkNotNull(listingUpdates,
              r'VendorTeamInventoryPerformance', 'listingUpdates'),
          complianceSubmissions: BuiltValueNullFieldError.checkNotNull(
              complianceSubmissions,
              r'VendorTeamInventoryPerformance',
              'complianceSubmissions'),
          allotmentUpdates: BuiltValueNullFieldError.checkNotNull(
              allotmentUpdates,
              r'VendorTeamInventoryPerformance',
              'allotmentUpdates'),
          unsuccessful: BuiltValueNullFieldError.checkNotNull(
              unsuccessful, r'VendorTeamInventoryPerformance', 'unsuccessful'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
