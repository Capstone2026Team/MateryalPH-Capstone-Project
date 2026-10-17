// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_dashboard_insights.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminDashboardInsights extends AdminDashboardInsights {
  @override
  final DateTime generatedAt;
  @override
  final AdminDashboardInsightsAccess access;
  @override
  final BuiltMap<String, String> definitions;
  @override
  final AdminDashboardMarketplace? marketplace;
  @override
  final String? marketplaceUnavailableReason;
  @override
  final AdminDashboardVendorHealth? vendorHealth;

  factory _$AdminDashboardInsights(
          [void Function(AdminDashboardInsightsBuilder)? updates]) =>
      (AdminDashboardInsightsBuilder()..update(updates))._build();

  _$AdminDashboardInsights._(
      {required this.generatedAt,
      required this.access,
      required this.definitions,
      this.marketplace,
      this.marketplaceUnavailableReason,
      this.vendorHealth})
      : super._();
  @override
  AdminDashboardInsights rebuild(
          void Function(AdminDashboardInsightsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminDashboardInsightsBuilder toBuilder() =>
      AdminDashboardInsightsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDashboardInsights &&
        generatedAt == other.generatedAt &&
        access == other.access &&
        definitions == other.definitions &&
        marketplace == other.marketplace &&
        marketplaceUnavailableReason == other.marketplaceUnavailableReason &&
        vendorHealth == other.vendorHealth;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, generatedAt.hashCode);
    _$hash = $jc(_$hash, access.hashCode);
    _$hash = $jc(_$hash, definitions.hashCode);
    _$hash = $jc(_$hash, marketplace.hashCode);
    _$hash = $jc(_$hash, marketplaceUnavailableReason.hashCode);
    _$hash = $jc(_$hash, vendorHealth.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminDashboardInsights')
          ..add('generatedAt', generatedAt)
          ..add('access', access)
          ..add('definitions', definitions)
          ..add('marketplace', marketplace)
          ..add('marketplaceUnavailableReason', marketplaceUnavailableReason)
          ..add('vendorHealth', vendorHealth))
        .toString();
  }
}

class AdminDashboardInsightsBuilder
    implements Builder<AdminDashboardInsights, AdminDashboardInsightsBuilder> {
  _$AdminDashboardInsights? _$v;

  DateTime? _generatedAt;
  DateTime? get generatedAt => _$this._generatedAt;
  set generatedAt(DateTime? generatedAt) => _$this._generatedAt = generatedAt;

  AdminDashboardInsightsAccessBuilder? _access;
  AdminDashboardInsightsAccessBuilder get access =>
      _$this._access ??= AdminDashboardInsightsAccessBuilder();
  set access(AdminDashboardInsightsAccessBuilder? access) =>
      _$this._access = access;

  MapBuilder<String, String>? _definitions;
  MapBuilder<String, String> get definitions =>
      _$this._definitions ??= MapBuilder<String, String>();
  set definitions(MapBuilder<String, String>? definitions) =>
      _$this._definitions = definitions;

  AdminDashboardMarketplaceBuilder? _marketplace;
  AdminDashboardMarketplaceBuilder get marketplace =>
      _$this._marketplace ??= AdminDashboardMarketplaceBuilder();
  set marketplace(AdminDashboardMarketplaceBuilder? marketplace) =>
      _$this._marketplace = marketplace;

  String? _marketplaceUnavailableReason;
  String? get marketplaceUnavailableReason =>
      _$this._marketplaceUnavailableReason;
  set marketplaceUnavailableReason(String? marketplaceUnavailableReason) =>
      _$this._marketplaceUnavailableReason = marketplaceUnavailableReason;

  AdminDashboardVendorHealthBuilder? _vendorHealth;
  AdminDashboardVendorHealthBuilder get vendorHealth =>
      _$this._vendorHealth ??= AdminDashboardVendorHealthBuilder();
  set vendorHealth(AdminDashboardVendorHealthBuilder? vendorHealth) =>
      _$this._vendorHealth = vendorHealth;

  AdminDashboardInsightsBuilder() {
    AdminDashboardInsights._defaults(this);
  }

  AdminDashboardInsightsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _generatedAt = $v.generatedAt;
      _access = $v.access.toBuilder();
      _definitions = $v.definitions.toBuilder();
      _marketplace = $v.marketplace?.toBuilder();
      _marketplaceUnavailableReason = $v.marketplaceUnavailableReason;
      _vendorHealth = $v.vendorHealth?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDashboardInsights other) {
    _$v = other as _$AdminDashboardInsights;
  }

  @override
  void update(void Function(AdminDashboardInsightsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminDashboardInsights build() => _build();

  _$AdminDashboardInsights _build() {
    _$AdminDashboardInsights _$result;
    try {
      _$result = _$v ??
          _$AdminDashboardInsights._(
            generatedAt: BuiltValueNullFieldError.checkNotNull(
                generatedAt, r'AdminDashboardInsights', 'generatedAt'),
            access: access.build(),
            definitions: definitions.build(),
            marketplace: _marketplace?.build(),
            marketplaceUnavailableReason: marketplaceUnavailableReason,
            vendorHealth: _vendorHealth?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'access';
        access.build();
        _$failedField = 'definitions';
        definitions.build();
        _$failedField = 'marketplace';
        _marketplace?.build();

        _$failedField = 'vendorHealth';
        _vendorHealth?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AdminDashboardInsights', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
