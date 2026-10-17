// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_dashboard_orders_products_basket_rules.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorDashboardOrdersProductsBasketRules
    extends VendorDashboardOrdersProductsBasketRules {
  @override
  final int baskets;
  @override
  final BuiltList<DashboardRule> rules;
  @override
  final int windowDays;

  factory _$VendorDashboardOrdersProductsBasketRules(
          [void Function(VendorDashboardOrdersProductsBasketRulesBuilder)?
              updates]) =>
      (VendorDashboardOrdersProductsBasketRulesBuilder()..update(updates))
          ._build();

  _$VendorDashboardOrdersProductsBasketRules._(
      {required this.baskets, required this.rules, required this.windowDays})
      : super._();
  @override
  VendorDashboardOrdersProductsBasketRules rebuild(
          void Function(VendorDashboardOrdersProductsBasketRulesBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorDashboardOrdersProductsBasketRulesBuilder toBuilder() =>
      VendorDashboardOrdersProductsBasketRulesBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorDashboardOrdersProductsBasketRules &&
        baskets == other.baskets &&
        rules == other.rules &&
        windowDays == other.windowDays;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, baskets.hashCode);
    _$hash = $jc(_$hash, rules.hashCode);
    _$hash = $jc(_$hash, windowDays.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'VendorDashboardOrdersProductsBasketRules')
          ..add('baskets', baskets)
          ..add('rules', rules)
          ..add('windowDays', windowDays))
        .toString();
  }
}

class VendorDashboardOrdersProductsBasketRulesBuilder
    implements
        Builder<VendorDashboardOrdersProductsBasketRules,
            VendorDashboardOrdersProductsBasketRulesBuilder> {
  _$VendorDashboardOrdersProductsBasketRules? _$v;

  int? _baskets;
  int? get baskets => _$this._baskets;
  set baskets(int? baskets) => _$this._baskets = baskets;

  ListBuilder<DashboardRule>? _rules;
  ListBuilder<DashboardRule> get rules =>
      _$this._rules ??= ListBuilder<DashboardRule>();
  set rules(ListBuilder<DashboardRule>? rules) => _$this._rules = rules;

  int? _windowDays;
  int? get windowDays => _$this._windowDays;
  set windowDays(int? windowDays) => _$this._windowDays = windowDays;

  VendorDashboardOrdersProductsBasketRulesBuilder() {
    VendorDashboardOrdersProductsBasketRules._defaults(this);
  }

  VendorDashboardOrdersProductsBasketRulesBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _baskets = $v.baskets;
      _rules = $v.rules.toBuilder();
      _windowDays = $v.windowDays;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorDashboardOrdersProductsBasketRules other) {
    _$v = other as _$VendorDashboardOrdersProductsBasketRules;
  }

  @override
  void update(
      void Function(VendorDashboardOrdersProductsBasketRulesBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorDashboardOrdersProductsBasketRules build() => _build();

  _$VendorDashboardOrdersProductsBasketRules _build() {
    _$VendorDashboardOrdersProductsBasketRules _$result;
    try {
      _$result = _$v ??
          _$VendorDashboardOrdersProductsBasketRules._(
            baskets: BuiltValueNullFieldError.checkNotNull(baskets,
                r'VendorDashboardOrdersProductsBasketRules', 'baskets'),
            rules: rules.build(),
            windowDays: BuiltValueNullFieldError.checkNotNull(windowDays,
                r'VendorDashboardOrdersProductsBasketRules', 'windowDays'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'rules';
        rules.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'VendorDashboardOrdersProductsBasketRules',
            _$failedField,
            e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
