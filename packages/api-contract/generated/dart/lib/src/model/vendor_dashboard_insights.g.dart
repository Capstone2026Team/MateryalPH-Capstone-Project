// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_dashboard_insights.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorDashboardInsights extends VendorDashboardInsights {
  @override
  final DateTime generatedAt;
  @override
  final VendorDashboardInsightsPeriod period;
  @override
  final VendorDashboardInsightsAccess access;
  @override
  final BuiltMap<String, String> definitions;
  @override
  final VendorDashboardOrders? orders;
  @override
  final VendorDashboardPerformance? performance;
  @override
  final VendorDashboardStock? stock;
  @override
  final VendorDashboardDisputes? disputes;
  @override
  final BuiltList<DashboardAction> actions;
  @override
  final VendorDashboardInsightsTraffic traffic;

  factory _$VendorDashboardInsights(
          [void Function(VendorDashboardInsightsBuilder)? updates]) =>
      (VendorDashboardInsightsBuilder()..update(updates))._build();

  _$VendorDashboardInsights._(
      {required this.generatedAt,
      required this.period,
      required this.access,
      required this.definitions,
      this.orders,
      this.performance,
      this.stock,
      this.disputes,
      required this.actions,
      required this.traffic})
      : super._();
  @override
  VendorDashboardInsights rebuild(
          void Function(VendorDashboardInsightsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorDashboardInsightsBuilder toBuilder() =>
      VendorDashboardInsightsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorDashboardInsights &&
        generatedAt == other.generatedAt &&
        period == other.period &&
        access == other.access &&
        definitions == other.definitions &&
        orders == other.orders &&
        performance == other.performance &&
        stock == other.stock &&
        disputes == other.disputes &&
        actions == other.actions &&
        traffic == other.traffic;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, generatedAt.hashCode);
    _$hash = $jc(_$hash, period.hashCode);
    _$hash = $jc(_$hash, access.hashCode);
    _$hash = $jc(_$hash, definitions.hashCode);
    _$hash = $jc(_$hash, orders.hashCode);
    _$hash = $jc(_$hash, performance.hashCode);
    _$hash = $jc(_$hash, stock.hashCode);
    _$hash = $jc(_$hash, disputes.hashCode);
    _$hash = $jc(_$hash, actions.hashCode);
    _$hash = $jc(_$hash, traffic.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorDashboardInsights')
          ..add('generatedAt', generatedAt)
          ..add('period', period)
          ..add('access', access)
          ..add('definitions', definitions)
          ..add('orders', orders)
          ..add('performance', performance)
          ..add('stock', stock)
          ..add('disputes', disputes)
          ..add('actions', actions)
          ..add('traffic', traffic))
        .toString();
  }
}

class VendorDashboardInsightsBuilder
    implements
        Builder<VendorDashboardInsights, VendorDashboardInsightsBuilder> {
  _$VendorDashboardInsights? _$v;

  DateTime? _generatedAt;
  DateTime? get generatedAt => _$this._generatedAt;
  set generatedAt(DateTime? generatedAt) => _$this._generatedAt = generatedAt;

  VendorDashboardInsightsPeriodBuilder? _period;
  VendorDashboardInsightsPeriodBuilder get period =>
      _$this._period ??= VendorDashboardInsightsPeriodBuilder();
  set period(VendorDashboardInsightsPeriodBuilder? period) =>
      _$this._period = period;

  VendorDashboardInsightsAccessBuilder? _access;
  VendorDashboardInsightsAccessBuilder get access =>
      _$this._access ??= VendorDashboardInsightsAccessBuilder();
  set access(VendorDashboardInsightsAccessBuilder? access) =>
      _$this._access = access;

  MapBuilder<String, String>? _definitions;
  MapBuilder<String, String> get definitions =>
      _$this._definitions ??= MapBuilder<String, String>();
  set definitions(MapBuilder<String, String>? definitions) =>
      _$this._definitions = definitions;

  VendorDashboardOrdersBuilder? _orders;
  VendorDashboardOrdersBuilder get orders =>
      _$this._orders ??= VendorDashboardOrdersBuilder();
  set orders(VendorDashboardOrdersBuilder? orders) => _$this._orders = orders;

  VendorDashboardPerformanceBuilder? _performance;
  VendorDashboardPerformanceBuilder get performance =>
      _$this._performance ??= VendorDashboardPerformanceBuilder();
  set performance(VendorDashboardPerformanceBuilder? performance) =>
      _$this._performance = performance;

  VendorDashboardStockBuilder? _stock;
  VendorDashboardStockBuilder get stock =>
      _$this._stock ??= VendorDashboardStockBuilder();
  set stock(VendorDashboardStockBuilder? stock) => _$this._stock = stock;

  VendorDashboardDisputesBuilder? _disputes;
  VendorDashboardDisputesBuilder get disputes =>
      _$this._disputes ??= VendorDashboardDisputesBuilder();
  set disputes(VendorDashboardDisputesBuilder? disputes) =>
      _$this._disputes = disputes;

  ListBuilder<DashboardAction>? _actions;
  ListBuilder<DashboardAction> get actions =>
      _$this._actions ??= ListBuilder<DashboardAction>();
  set actions(ListBuilder<DashboardAction>? actions) =>
      _$this._actions = actions;

  VendorDashboardInsightsTrafficBuilder? _traffic;
  VendorDashboardInsightsTrafficBuilder get traffic =>
      _$this._traffic ??= VendorDashboardInsightsTrafficBuilder();
  set traffic(VendorDashboardInsightsTrafficBuilder? traffic) =>
      _$this._traffic = traffic;

  VendorDashboardInsightsBuilder() {
    VendorDashboardInsights._defaults(this);
  }

  VendorDashboardInsightsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _generatedAt = $v.generatedAt;
      _period = $v.period.toBuilder();
      _access = $v.access.toBuilder();
      _definitions = $v.definitions.toBuilder();
      _orders = $v.orders?.toBuilder();
      _performance = $v.performance?.toBuilder();
      _stock = $v.stock?.toBuilder();
      _disputes = $v.disputes?.toBuilder();
      _actions = $v.actions.toBuilder();
      _traffic = $v.traffic.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorDashboardInsights other) {
    _$v = other as _$VendorDashboardInsights;
  }

  @override
  void update(void Function(VendorDashboardInsightsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorDashboardInsights build() => _build();

  _$VendorDashboardInsights _build() {
    _$VendorDashboardInsights _$result;
    try {
      _$result = _$v ??
          _$VendorDashboardInsights._(
            generatedAt: BuiltValueNullFieldError.checkNotNull(
                generatedAt, r'VendorDashboardInsights', 'generatedAt'),
            period: period.build(),
            access: access.build(),
            definitions: definitions.build(),
            orders: _orders?.build(),
            performance: _performance?.build(),
            stock: _stock?.build(),
            disputes: _disputes?.build(),
            actions: actions.build(),
            traffic: traffic.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'period';
        period.build();
        _$failedField = 'access';
        access.build();
        _$failedField = 'definitions';
        definitions.build();
        _$failedField = 'orders';
        _orders?.build();
        _$failedField = 'performance';
        _performance?.build();
        _$failedField = 'stock';
        _stock?.build();
        _$failedField = 'disputes';
        _disputes?.build();
        _$failedField = 'actions';
        actions.build();
        _$failedField = 'traffic';
        traffic.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'VendorDashboardInsights', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
