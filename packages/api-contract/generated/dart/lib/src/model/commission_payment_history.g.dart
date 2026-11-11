// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'commission_payment_history.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CommissionPaymentHistoryPerPageEnum
    _$commissionPaymentHistoryPerPageEnum_number10 =
    const CommissionPaymentHistoryPerPageEnum._('number10');

CommissionPaymentHistoryPerPageEnum
    _$commissionPaymentHistoryPerPageEnumValueOf(String name) {
  switch (name) {
    case 'number10':
      return _$commissionPaymentHistoryPerPageEnum_number10;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CommissionPaymentHistoryPerPageEnum>
    _$commissionPaymentHistoryPerPageEnumValues = BuiltSet<
        CommissionPaymentHistoryPerPageEnum>(const <CommissionPaymentHistoryPerPageEnum>[
  _$commissionPaymentHistoryPerPageEnum_number10,
]);

Serializer<CommissionPaymentHistoryPerPageEnum>
    _$commissionPaymentHistoryPerPageEnumSerializer =
    _$CommissionPaymentHistoryPerPageEnumSerializer();

class _$CommissionPaymentHistoryPerPageEnumSerializer
    implements PrimitiveSerializer<CommissionPaymentHistoryPerPageEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'number10': 10,
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    10: 'number10',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CommissionPaymentHistoryPerPageEnum
  ];
  @override
  final String wireName = 'CommissionPaymentHistoryPerPageEnum';

  @override
  Object serialize(
          Serializers serializers, CommissionPaymentHistoryPerPageEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CommissionPaymentHistoryPerPageEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CommissionPaymentHistoryPerPageEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CommissionPaymentHistory extends CommissionPaymentHistory {
  @override
  final BuiltList<CommissionPaymentPeriod> items;
  @override
  final int page;
  @override
  final CommissionPaymentHistoryPerPageEnum perPage;
  @override
  final int total;
  @override
  final bool hasMore;

  factory _$CommissionPaymentHistory(
          [void Function(CommissionPaymentHistoryBuilder)? updates]) =>
      (CommissionPaymentHistoryBuilder()..update(updates))._build();

  _$CommissionPaymentHistory._(
      {required this.items,
      required this.page,
      required this.perPage,
      required this.total,
      required this.hasMore})
      : super._();
  @override
  CommissionPaymentHistory rebuild(
          void Function(CommissionPaymentHistoryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CommissionPaymentHistoryBuilder toBuilder() =>
      CommissionPaymentHistoryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CommissionPaymentHistory &&
        items == other.items &&
        page == other.page &&
        perPage == other.perPage &&
        total == other.total &&
        hasMore == other.hasMore;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jc(_$hash, page.hashCode);
    _$hash = $jc(_$hash, perPage.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jc(_$hash, hasMore.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CommissionPaymentHistory')
          ..add('items', items)
          ..add('page', page)
          ..add('perPage', perPage)
          ..add('total', total)
          ..add('hasMore', hasMore))
        .toString();
  }
}

class CommissionPaymentHistoryBuilder
    implements
        Builder<CommissionPaymentHistory, CommissionPaymentHistoryBuilder> {
  _$CommissionPaymentHistory? _$v;

  ListBuilder<CommissionPaymentPeriod>? _items;
  ListBuilder<CommissionPaymentPeriod> get items =>
      _$this._items ??= ListBuilder<CommissionPaymentPeriod>();
  set items(ListBuilder<CommissionPaymentPeriod>? items) =>
      _$this._items = items;

  int? _page;
  int? get page => _$this._page;
  set page(int? page) => _$this._page = page;

  CommissionPaymentHistoryPerPageEnum? _perPage;
  CommissionPaymentHistoryPerPageEnum? get perPage => _$this._perPage;
  set perPage(CommissionPaymentHistoryPerPageEnum? perPage) =>
      _$this._perPage = perPage;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  bool? _hasMore;
  bool? get hasMore => _$this._hasMore;
  set hasMore(bool? hasMore) => _$this._hasMore = hasMore;

  CommissionPaymentHistoryBuilder() {
    CommissionPaymentHistory._defaults(this);
  }

  CommissionPaymentHistoryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _page = $v.page;
      _perPage = $v.perPage;
      _total = $v.total;
      _hasMore = $v.hasMore;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CommissionPaymentHistory other) {
    _$v = other as _$CommissionPaymentHistory;
  }

  @override
  void update(void Function(CommissionPaymentHistoryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CommissionPaymentHistory build() => _build();

  _$CommissionPaymentHistory _build() {
    _$CommissionPaymentHistory _$result;
    try {
      _$result = _$v ??
          _$CommissionPaymentHistory._(
            items: items.build(),
            page: BuiltValueNullFieldError.checkNotNull(
                page, r'CommissionPaymentHistory', 'page'),
            perPage: BuiltValueNullFieldError.checkNotNull(
                perPage, r'CommissionPaymentHistory', 'perPage'),
            total: BuiltValueNullFieldError.checkNotNull(
                total, r'CommissionPaymentHistory', 'total'),
            hasMore: BuiltValueNullFieldError.checkNotNull(
                hasMore, r'CommissionPaymentHistory', 'hasMore'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CommissionPaymentHistory', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
