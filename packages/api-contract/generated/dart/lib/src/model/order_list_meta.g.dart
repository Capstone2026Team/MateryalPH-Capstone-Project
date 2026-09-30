// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_list_meta.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$OrderListMeta extends OrderListMeta {
  @override
  final String group;
  @override
  final BuiltMap<String, int> counts;
  @override
  final int page;
  @override
  final int perPage;
  @override
  final int total;
  @override
  final bool hasMore;
  @override
  final DateTime currentAsOf;

  factory _$OrderListMeta([void Function(OrderListMetaBuilder)? updates]) =>
      (OrderListMetaBuilder()..update(updates))._build();

  _$OrderListMeta._(
      {required this.group,
      required this.counts,
      required this.page,
      required this.perPage,
      required this.total,
      required this.hasMore,
      required this.currentAsOf})
      : super._();
  @override
  OrderListMeta rebuild(void Function(OrderListMetaBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OrderListMetaBuilder toBuilder() => OrderListMetaBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OrderListMeta &&
        group == other.group &&
        counts == other.counts &&
        page == other.page &&
        perPage == other.perPage &&
        total == other.total &&
        hasMore == other.hasMore &&
        currentAsOf == other.currentAsOf;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, group.hashCode);
    _$hash = $jc(_$hash, counts.hashCode);
    _$hash = $jc(_$hash, page.hashCode);
    _$hash = $jc(_$hash, perPage.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jc(_$hash, hasMore.hashCode);
    _$hash = $jc(_$hash, currentAsOf.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OrderListMeta')
          ..add('group', group)
          ..add('counts', counts)
          ..add('page', page)
          ..add('perPage', perPage)
          ..add('total', total)
          ..add('hasMore', hasMore)
          ..add('currentAsOf', currentAsOf))
        .toString();
  }
}

class OrderListMetaBuilder
    implements Builder<OrderListMeta, OrderListMetaBuilder> {
  _$OrderListMeta? _$v;

  String? _group;
  String? get group => _$this._group;
  set group(String? group) => _$this._group = group;

  MapBuilder<String, int>? _counts;
  MapBuilder<String, int> get counts =>
      _$this._counts ??= MapBuilder<String, int>();
  set counts(MapBuilder<String, int>? counts) => _$this._counts = counts;

  int? _page;
  int? get page => _$this._page;
  set page(int? page) => _$this._page = page;

  int? _perPage;
  int? get perPage => _$this._perPage;
  set perPage(int? perPage) => _$this._perPage = perPage;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  bool? _hasMore;
  bool? get hasMore => _$this._hasMore;
  set hasMore(bool? hasMore) => _$this._hasMore = hasMore;

  DateTime? _currentAsOf;
  DateTime? get currentAsOf => _$this._currentAsOf;
  set currentAsOf(DateTime? currentAsOf) => _$this._currentAsOf = currentAsOf;

  OrderListMetaBuilder() {
    OrderListMeta._defaults(this);
  }

  OrderListMetaBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _group = $v.group;
      _counts = $v.counts.toBuilder();
      _page = $v.page;
      _perPage = $v.perPage;
      _total = $v.total;
      _hasMore = $v.hasMore;
      _currentAsOf = $v.currentAsOf;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OrderListMeta other) {
    _$v = other as _$OrderListMeta;
  }

  @override
  void update(void Function(OrderListMetaBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OrderListMeta build() => _build();

  _$OrderListMeta _build() {
    _$OrderListMeta _$result;
    try {
      _$result = _$v ??
          _$OrderListMeta._(
            group: BuiltValueNullFieldError.checkNotNull(
                group, r'OrderListMeta', 'group'),
            counts: counts.build(),
            page: BuiltValueNullFieldError.checkNotNull(
                page, r'OrderListMeta', 'page'),
            perPage: BuiltValueNullFieldError.checkNotNull(
                perPage, r'OrderListMeta', 'perPage'),
            total: BuiltValueNullFieldError.checkNotNull(
                total, r'OrderListMeta', 'total'),
            hasMore: BuiltValueNullFieldError.checkNotNull(
                hasMore, r'OrderListMeta', 'hasMore'),
            currentAsOf: BuiltValueNullFieldError.checkNotNull(
                currentAsOf, r'OrderListMeta', 'currentAsOf'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'counts';
        counts.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'OrderListMeta', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
