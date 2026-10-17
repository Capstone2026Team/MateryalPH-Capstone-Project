// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_dashboard_categories_demand_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminDashboardCategoriesDemandInner
    extends AdminDashboardCategoriesDemandInner {
  @override
  final String category;
  @override
  final int orders;

  factory _$AdminDashboardCategoriesDemandInner(
          [void Function(AdminDashboardCategoriesDemandInnerBuilder)?
              updates]) =>
      (AdminDashboardCategoriesDemandInnerBuilder()..update(updates))._build();

  _$AdminDashboardCategoriesDemandInner._(
      {required this.category, required this.orders})
      : super._();
  @override
  AdminDashboardCategoriesDemandInner rebuild(
          void Function(AdminDashboardCategoriesDemandInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminDashboardCategoriesDemandInnerBuilder toBuilder() =>
      AdminDashboardCategoriesDemandInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDashboardCategoriesDemandInner &&
        category == other.category &&
        orders == other.orders;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jc(_$hash, orders.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminDashboardCategoriesDemandInner')
          ..add('category', category)
          ..add('orders', orders))
        .toString();
  }
}

class AdminDashboardCategoriesDemandInnerBuilder
    implements
        Builder<AdminDashboardCategoriesDemandInner,
            AdminDashboardCategoriesDemandInnerBuilder> {
  _$AdminDashboardCategoriesDemandInner? _$v;

  String? _category;
  String? get category => _$this._category;
  set category(String? category) => _$this._category = category;

  int? _orders;
  int? get orders => _$this._orders;
  set orders(int? orders) => _$this._orders = orders;

  AdminDashboardCategoriesDemandInnerBuilder() {
    AdminDashboardCategoriesDemandInner._defaults(this);
  }

  AdminDashboardCategoriesDemandInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _category = $v.category;
      _orders = $v.orders;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDashboardCategoriesDemandInner other) {
    _$v = other as _$AdminDashboardCategoriesDemandInner;
  }

  @override
  void update(
      void Function(AdminDashboardCategoriesDemandInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminDashboardCategoriesDemandInner build() => _build();

  _$AdminDashboardCategoriesDemandInner _build() {
    final _$result = _$v ??
        _$AdminDashboardCategoriesDemandInner._(
          category: BuiltValueNullFieldError.checkNotNull(
              category, r'AdminDashboardCategoriesDemandInner', 'category'),
          orders: BuiltValueNullFieldError.checkNotNull(
              orders, r'AdminDashboardCategoriesDemandInner', 'orders'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
