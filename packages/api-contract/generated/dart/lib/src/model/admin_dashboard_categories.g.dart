// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_dashboard_categories.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminDashboardCategories extends AdminDashboardCategories {
  @override
  final BuiltList<AdminDashboardCategoriesDemandInner> demand;
  @override
  final int suppressedCategories;
  @override
  final BuiltList<DashboardRule> rules;
  @override
  final int baskets;
  @override
  final int minimumBuyers;

  factory _$AdminDashboardCategories(
          [void Function(AdminDashboardCategoriesBuilder)? updates]) =>
      (AdminDashboardCategoriesBuilder()..update(updates))._build();

  _$AdminDashboardCategories._(
      {required this.demand,
      required this.suppressedCategories,
      required this.rules,
      required this.baskets,
      required this.minimumBuyers})
      : super._();
  @override
  AdminDashboardCategories rebuild(
          void Function(AdminDashboardCategoriesBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminDashboardCategoriesBuilder toBuilder() =>
      AdminDashboardCategoriesBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDashboardCategories &&
        demand == other.demand &&
        suppressedCategories == other.suppressedCategories &&
        rules == other.rules &&
        baskets == other.baskets &&
        minimumBuyers == other.minimumBuyers;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, demand.hashCode);
    _$hash = $jc(_$hash, suppressedCategories.hashCode);
    _$hash = $jc(_$hash, rules.hashCode);
    _$hash = $jc(_$hash, baskets.hashCode);
    _$hash = $jc(_$hash, minimumBuyers.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminDashboardCategories')
          ..add('demand', demand)
          ..add('suppressedCategories', suppressedCategories)
          ..add('rules', rules)
          ..add('baskets', baskets)
          ..add('minimumBuyers', minimumBuyers))
        .toString();
  }
}

class AdminDashboardCategoriesBuilder
    implements
        Builder<AdminDashboardCategories, AdminDashboardCategoriesBuilder> {
  _$AdminDashboardCategories? _$v;

  ListBuilder<AdminDashboardCategoriesDemandInner>? _demand;
  ListBuilder<AdminDashboardCategoriesDemandInner> get demand =>
      _$this._demand ??= ListBuilder<AdminDashboardCategoriesDemandInner>();
  set demand(ListBuilder<AdminDashboardCategoriesDemandInner>? demand) =>
      _$this._demand = demand;

  int? _suppressedCategories;
  int? get suppressedCategories => _$this._suppressedCategories;
  set suppressedCategories(int? suppressedCategories) =>
      _$this._suppressedCategories = suppressedCategories;

  ListBuilder<DashboardRule>? _rules;
  ListBuilder<DashboardRule> get rules =>
      _$this._rules ??= ListBuilder<DashboardRule>();
  set rules(ListBuilder<DashboardRule>? rules) => _$this._rules = rules;

  int? _baskets;
  int? get baskets => _$this._baskets;
  set baskets(int? baskets) => _$this._baskets = baskets;

  int? _minimumBuyers;
  int? get minimumBuyers => _$this._minimumBuyers;
  set minimumBuyers(int? minimumBuyers) =>
      _$this._minimumBuyers = minimumBuyers;

  AdminDashboardCategoriesBuilder() {
    AdminDashboardCategories._defaults(this);
  }

  AdminDashboardCategoriesBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _demand = $v.demand.toBuilder();
      _suppressedCategories = $v.suppressedCategories;
      _rules = $v.rules.toBuilder();
      _baskets = $v.baskets;
      _minimumBuyers = $v.minimumBuyers;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDashboardCategories other) {
    _$v = other as _$AdminDashboardCategories;
  }

  @override
  void update(void Function(AdminDashboardCategoriesBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminDashboardCategories build() => _build();

  _$AdminDashboardCategories _build() {
    _$AdminDashboardCategories _$result;
    try {
      _$result = _$v ??
          _$AdminDashboardCategories._(
            demand: demand.build(),
            suppressedCategories: BuiltValueNullFieldError.checkNotNull(
                suppressedCategories,
                r'AdminDashboardCategories',
                'suppressedCategories'),
            rules: rules.build(),
            baskets: BuiltValueNullFieldError.checkNotNull(
                baskets, r'AdminDashboardCategories', 'baskets'),
            minimumBuyers: BuiltValueNullFieldError.checkNotNull(
                minimumBuyers, r'AdminDashboardCategories', 'minimumBuyers'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'demand';
        demand.build();

        _$failedField = 'rules';
        rules.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AdminDashboardCategories', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
