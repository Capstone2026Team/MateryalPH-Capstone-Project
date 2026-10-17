// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_product_analytics_products_meta.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const VendorProductAnalyticsProductsMetaSortEnum
    _$vendorProductAnalyticsProductsMetaSortEnum_views =
    const VendorProductAnalyticsProductsMetaSortEnum._('views');
const VendorProductAnalyticsProductsMetaSortEnum
    _$vendorProductAnalyticsProductsMetaSortEnum_orders =
    const VendorProductAnalyticsProductsMetaSortEnum._('orders');
const VendorProductAnalyticsProductsMetaSortEnum
    _$vendorProductAnalyticsProductsMetaSortEnum_conversion =
    const VendorProductAnalyticsProductsMetaSortEnum._('conversion');
const VendorProductAnalyticsProductsMetaSortEnum
    _$vendorProductAnalyticsProductsMetaSortEnum_value =
    const VendorProductAnalyticsProductsMetaSortEnum._('value');

VendorProductAnalyticsProductsMetaSortEnum
    _$vendorProductAnalyticsProductsMetaSortEnumValueOf(String name) {
  switch (name) {
    case 'views':
      return _$vendorProductAnalyticsProductsMetaSortEnum_views;
    case 'orders':
      return _$vendorProductAnalyticsProductsMetaSortEnum_orders;
    case 'conversion':
      return _$vendorProductAnalyticsProductsMetaSortEnum_conversion;
    case 'value':
      return _$vendorProductAnalyticsProductsMetaSortEnum_value;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<VendorProductAnalyticsProductsMetaSortEnum>
    _$vendorProductAnalyticsProductsMetaSortEnumValues = BuiltSet<
        VendorProductAnalyticsProductsMetaSortEnum>(const <VendorProductAnalyticsProductsMetaSortEnum>[
  _$vendorProductAnalyticsProductsMetaSortEnum_views,
  _$vendorProductAnalyticsProductsMetaSortEnum_orders,
  _$vendorProductAnalyticsProductsMetaSortEnum_conversion,
  _$vendorProductAnalyticsProductsMetaSortEnum_value,
]);

Serializer<VendorProductAnalyticsProductsMetaSortEnum>
    _$vendorProductAnalyticsProductsMetaSortEnumSerializer =
    _$VendorProductAnalyticsProductsMetaSortEnumSerializer();

class _$VendorProductAnalyticsProductsMetaSortEnumSerializer
    implements PrimitiveSerializer<VendorProductAnalyticsProductsMetaSortEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'views': 'views',
    'orders': 'orders',
    'conversion': 'conversion',
    'value': 'value',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'views': 'views',
    'orders': 'orders',
    'conversion': 'conversion',
    'value': 'value',
  };

  @override
  final Iterable<Type> types = const <Type>[
    VendorProductAnalyticsProductsMetaSortEnum
  ];
  @override
  final String wireName = 'VendorProductAnalyticsProductsMetaSortEnum';

  @override
  Object serialize(Serializers serializers,
          VendorProductAnalyticsProductsMetaSortEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  VendorProductAnalyticsProductsMetaSortEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      VendorProductAnalyticsProductsMetaSortEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$VendorProductAnalyticsProductsMeta
    extends VendorProductAnalyticsProductsMeta {
  @override
  final int page;
  @override
  final int perPage;
  @override
  final int total;
  @override
  final int lastPage;
  @override
  final VendorProductAnalyticsProductsMetaSortEnum sort;

  factory _$VendorProductAnalyticsProductsMeta(
          [void Function(VendorProductAnalyticsProductsMetaBuilder)?
              updates]) =>
      (VendorProductAnalyticsProductsMetaBuilder()..update(updates))._build();

  _$VendorProductAnalyticsProductsMeta._(
      {required this.page,
      required this.perPage,
      required this.total,
      required this.lastPage,
      required this.sort})
      : super._();
  @override
  VendorProductAnalyticsProductsMeta rebuild(
          void Function(VendorProductAnalyticsProductsMetaBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorProductAnalyticsProductsMetaBuilder toBuilder() =>
      VendorProductAnalyticsProductsMetaBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorProductAnalyticsProductsMeta &&
        page == other.page &&
        perPage == other.perPage &&
        total == other.total &&
        lastPage == other.lastPage &&
        sort == other.sort;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, page.hashCode);
    _$hash = $jc(_$hash, perPage.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jc(_$hash, lastPage.hashCode);
    _$hash = $jc(_$hash, sort.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorProductAnalyticsProductsMeta')
          ..add('page', page)
          ..add('perPage', perPage)
          ..add('total', total)
          ..add('lastPage', lastPage)
          ..add('sort', sort))
        .toString();
  }
}

class VendorProductAnalyticsProductsMetaBuilder
    implements
        Builder<VendorProductAnalyticsProductsMeta,
            VendorProductAnalyticsProductsMetaBuilder> {
  _$VendorProductAnalyticsProductsMeta? _$v;

  int? _page;
  int? get page => _$this._page;
  set page(int? page) => _$this._page = page;

  int? _perPage;
  int? get perPage => _$this._perPage;
  set perPage(int? perPage) => _$this._perPage = perPage;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  int? _lastPage;
  int? get lastPage => _$this._lastPage;
  set lastPage(int? lastPage) => _$this._lastPage = lastPage;

  VendorProductAnalyticsProductsMetaSortEnum? _sort;
  VendorProductAnalyticsProductsMetaSortEnum? get sort => _$this._sort;
  set sort(VendorProductAnalyticsProductsMetaSortEnum? sort) =>
      _$this._sort = sort;

  VendorProductAnalyticsProductsMetaBuilder() {
    VendorProductAnalyticsProductsMeta._defaults(this);
  }

  VendorProductAnalyticsProductsMetaBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _page = $v.page;
      _perPage = $v.perPage;
      _total = $v.total;
      _lastPage = $v.lastPage;
      _sort = $v.sort;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorProductAnalyticsProductsMeta other) {
    _$v = other as _$VendorProductAnalyticsProductsMeta;
  }

  @override
  void update(
      void Function(VendorProductAnalyticsProductsMetaBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorProductAnalyticsProductsMeta build() => _build();

  _$VendorProductAnalyticsProductsMeta _build() {
    final _$result = _$v ??
        _$VendorProductAnalyticsProductsMeta._(
          page: BuiltValueNullFieldError.checkNotNull(
              page, r'VendorProductAnalyticsProductsMeta', 'page'),
          perPage: BuiltValueNullFieldError.checkNotNull(
              perPage, r'VendorProductAnalyticsProductsMeta', 'perPage'),
          total: BuiltValueNullFieldError.checkNotNull(
              total, r'VendorProductAnalyticsProductsMeta', 'total'),
          lastPage: BuiltValueNullFieldError.checkNotNull(
              lastPage, r'VendorProductAnalyticsProductsMeta', 'lastPage'),
          sort: BuiltValueNullFieldError.checkNotNull(
              sort, r'VendorProductAnalyticsProductsMeta', 'sort'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
