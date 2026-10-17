// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_dashboard_insights_traffic.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorDashboardInsightsTraffic extends VendorDashboardInsightsTraffic {
  @override
  final VendorDashboardInsightsTrafficStoreVisits storeVisits;

  factory _$VendorDashboardInsightsTraffic(
          [void Function(VendorDashboardInsightsTrafficBuilder)? updates]) =>
      (VendorDashboardInsightsTrafficBuilder()..update(updates))._build();

  _$VendorDashboardInsightsTraffic._({required this.storeVisits}) : super._();
  @override
  VendorDashboardInsightsTraffic rebuild(
          void Function(VendorDashboardInsightsTrafficBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorDashboardInsightsTrafficBuilder toBuilder() =>
      VendorDashboardInsightsTrafficBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorDashboardInsightsTraffic &&
        storeVisits == other.storeVisits;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, storeVisits.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorDashboardInsightsTraffic')
          ..add('storeVisits', storeVisits))
        .toString();
  }
}

class VendorDashboardInsightsTrafficBuilder
    implements
        Builder<VendorDashboardInsightsTraffic,
            VendorDashboardInsightsTrafficBuilder> {
  _$VendorDashboardInsightsTraffic? _$v;

  VendorDashboardInsightsTrafficStoreVisitsBuilder? _storeVisits;
  VendorDashboardInsightsTrafficStoreVisitsBuilder get storeVisits =>
      _$this._storeVisits ??=
          VendorDashboardInsightsTrafficStoreVisitsBuilder();
  set storeVisits(
          VendorDashboardInsightsTrafficStoreVisitsBuilder? storeVisits) =>
      _$this._storeVisits = storeVisits;

  VendorDashboardInsightsTrafficBuilder() {
    VendorDashboardInsightsTraffic._defaults(this);
  }

  VendorDashboardInsightsTrafficBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _storeVisits = $v.storeVisits.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorDashboardInsightsTraffic other) {
    _$v = other as _$VendorDashboardInsightsTraffic;
  }

  @override
  void update(void Function(VendorDashboardInsightsTrafficBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorDashboardInsightsTraffic build() => _build();

  _$VendorDashboardInsightsTraffic _build() {
    _$VendorDashboardInsightsTraffic _$result;
    try {
      _$result = _$v ??
          _$VendorDashboardInsightsTraffic._(
            storeVisits: storeVisits.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'storeVisits';
        storeVisits.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'VendorDashboardInsightsTraffic', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
