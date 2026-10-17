// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_dashboard_insights_traffic_store_visits.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorDashboardInsightsTrafficStoreVisits
    extends VendorDashboardInsightsTrafficStoreVisits {
  @override
  final bool tracked;
  @override
  final String reason;

  factory _$VendorDashboardInsightsTrafficStoreVisits(
          [void Function(VendorDashboardInsightsTrafficStoreVisitsBuilder)?
              updates]) =>
      (VendorDashboardInsightsTrafficStoreVisitsBuilder()..update(updates))
          ._build();

  _$VendorDashboardInsightsTrafficStoreVisits._(
      {required this.tracked, required this.reason})
      : super._();
  @override
  VendorDashboardInsightsTrafficStoreVisits rebuild(
          void Function(VendorDashboardInsightsTrafficStoreVisitsBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorDashboardInsightsTrafficStoreVisitsBuilder toBuilder() =>
      VendorDashboardInsightsTrafficStoreVisitsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorDashboardInsightsTrafficStoreVisits &&
        tracked == other.tracked &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, tracked.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'VendorDashboardInsightsTrafficStoreVisits')
          ..add('tracked', tracked)
          ..add('reason', reason))
        .toString();
  }
}

class VendorDashboardInsightsTrafficStoreVisitsBuilder
    implements
        Builder<VendorDashboardInsightsTrafficStoreVisits,
            VendorDashboardInsightsTrafficStoreVisitsBuilder> {
  _$VendorDashboardInsightsTrafficStoreVisits? _$v;

  bool? _tracked;
  bool? get tracked => _$this._tracked;
  set tracked(bool? tracked) => _$this._tracked = tracked;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  VendorDashboardInsightsTrafficStoreVisitsBuilder() {
    VendorDashboardInsightsTrafficStoreVisits._defaults(this);
  }

  VendorDashboardInsightsTrafficStoreVisitsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _tracked = $v.tracked;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorDashboardInsightsTrafficStoreVisits other) {
    _$v = other as _$VendorDashboardInsightsTrafficStoreVisits;
  }

  @override
  void update(
      void Function(VendorDashboardInsightsTrafficStoreVisitsBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorDashboardInsightsTrafficStoreVisits build() => _build();

  _$VendorDashboardInsightsTrafficStoreVisits _build() {
    final _$result = _$v ??
        _$VendorDashboardInsightsTrafficStoreVisits._(
          tracked: BuiltValueNullFieldError.checkNotNull(
              tracked, r'VendorDashboardInsightsTrafficStoreVisits', 'tracked'),
          reason: BuiltValueNullFieldError.checkNotNull(
              reason, r'VendorDashboardInsightsTrafficStoreVisits', 'reason'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
