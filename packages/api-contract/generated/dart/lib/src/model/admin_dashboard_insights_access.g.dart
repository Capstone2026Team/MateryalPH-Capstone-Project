// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_dashboard_insights_access.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminDashboardInsightsAccess extends AdminDashboardInsightsAccess {
  @override
  final bool marketplace;
  @override
  final bool vendorHealth;

  factory _$AdminDashboardInsightsAccess(
          [void Function(AdminDashboardInsightsAccessBuilder)? updates]) =>
      (AdminDashboardInsightsAccessBuilder()..update(updates))._build();

  _$AdminDashboardInsightsAccess._(
      {required this.marketplace, required this.vendorHealth})
      : super._();
  @override
  AdminDashboardInsightsAccess rebuild(
          void Function(AdminDashboardInsightsAccessBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminDashboardInsightsAccessBuilder toBuilder() =>
      AdminDashboardInsightsAccessBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDashboardInsightsAccess &&
        marketplace == other.marketplace &&
        vendorHealth == other.vendorHealth;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, marketplace.hashCode);
    _$hash = $jc(_$hash, vendorHealth.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminDashboardInsightsAccess')
          ..add('marketplace', marketplace)
          ..add('vendorHealth', vendorHealth))
        .toString();
  }
}

class AdminDashboardInsightsAccessBuilder
    implements
        Builder<AdminDashboardInsightsAccess,
            AdminDashboardInsightsAccessBuilder> {
  _$AdminDashboardInsightsAccess? _$v;

  bool? _marketplace;
  bool? get marketplace => _$this._marketplace;
  set marketplace(bool? marketplace) => _$this._marketplace = marketplace;

  bool? _vendorHealth;
  bool? get vendorHealth => _$this._vendorHealth;
  set vendorHealth(bool? vendorHealth) => _$this._vendorHealth = vendorHealth;

  AdminDashboardInsightsAccessBuilder() {
    AdminDashboardInsightsAccess._defaults(this);
  }

  AdminDashboardInsightsAccessBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _marketplace = $v.marketplace;
      _vendorHealth = $v.vendorHealth;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDashboardInsightsAccess other) {
    _$v = other as _$AdminDashboardInsightsAccess;
  }

  @override
  void update(void Function(AdminDashboardInsightsAccessBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminDashboardInsightsAccess build() => _build();

  _$AdminDashboardInsightsAccess _build() {
    final _$result = _$v ??
        _$AdminDashboardInsightsAccess._(
          marketplace: BuiltValueNullFieldError.checkNotNull(
              marketplace, r'AdminDashboardInsightsAccess', 'marketplace'),
          vendorHealth: BuiltValueNullFieldError.checkNotNull(
              vendorHealth, r'AdminDashboardInsightsAccess', 'vendorHealth'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
