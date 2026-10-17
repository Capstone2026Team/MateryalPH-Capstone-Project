// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_product_analytics_basket_rules.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorProductAnalyticsBasketRules
    extends VendorProductAnalyticsBasketRules {
  @override
  final int baskets;
  @override
  final BuiltList<DashboardRule> rules;
  @override
  final int windowDays;

  factory _$VendorProductAnalyticsBasketRules(
          [void Function(VendorProductAnalyticsBasketRulesBuilder)? updates]) =>
      (VendorProductAnalyticsBasketRulesBuilder()..update(updates))._build();

  _$VendorProductAnalyticsBasketRules._(
      {required this.baskets, required this.rules, required this.windowDays})
      : super._();
  @override
  VendorProductAnalyticsBasketRules rebuild(
          void Function(VendorProductAnalyticsBasketRulesBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorProductAnalyticsBasketRulesBuilder toBuilder() =>
      VendorProductAnalyticsBasketRulesBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorProductAnalyticsBasketRules &&
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
    return (newBuiltValueToStringHelper(r'VendorProductAnalyticsBasketRules')
          ..add('baskets', baskets)
          ..add('rules', rules)
          ..add('windowDays', windowDays))
        .toString();
  }
}

class VendorProductAnalyticsBasketRulesBuilder
    implements
        Builder<VendorProductAnalyticsBasketRules,
            VendorProductAnalyticsBasketRulesBuilder> {
  _$VendorProductAnalyticsBasketRules? _$v;

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

  VendorProductAnalyticsBasketRulesBuilder() {
    VendorProductAnalyticsBasketRules._defaults(this);
  }

  VendorProductAnalyticsBasketRulesBuilder get _$this {
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
  void replace(VendorProductAnalyticsBasketRules other) {
    _$v = other as _$VendorProductAnalyticsBasketRules;
  }

  @override
  void update(
      void Function(VendorProductAnalyticsBasketRulesBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorProductAnalyticsBasketRules build() => _build();

  _$VendorProductAnalyticsBasketRules _build() {
    _$VendorProductAnalyticsBasketRules _$result;
    try {
      _$result = _$v ??
          _$VendorProductAnalyticsBasketRules._(
            baskets: BuiltValueNullFieldError.checkNotNull(
                baskets, r'VendorProductAnalyticsBasketRules', 'baskets'),
            rules: rules.build(),
            windowDays: BuiltValueNullFieldError.checkNotNull(
                windowDays, r'VendorProductAnalyticsBasketRules', 'windowDays'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'rules';
        rules.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'VendorProductAnalyticsBasketRules', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
