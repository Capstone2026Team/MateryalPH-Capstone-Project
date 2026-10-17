// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_analytics_suggestion.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ProductAnalyticsSuggestionKindEnum
    _$productAnalyticsSuggestionKindEnum_RESTOCK_VIEWED =
    const ProductAnalyticsSuggestionKindEnum._('RESTOCK_VIEWED');
const ProductAnalyticsSuggestionKindEnum
    _$productAnalyticsSuggestionKindEnum_REORDER_SOON =
    const ProductAnalyticsSuggestionKindEnum._('REORDER_SOON');
const ProductAnalyticsSuggestionKindEnum
    _$productAnalyticsSuggestionKindEnum_LOW_CONVERSION =
    const ProductAnalyticsSuggestionKindEnum._('LOW_CONVERSION');
const ProductAnalyticsSuggestionKindEnum
    _$productAnalyticsSuggestionKindEnum_CONVERTS_WHEN_FOUND =
    const ProductAnalyticsSuggestionKindEnum._('CONVERTS_WHEN_FOUND');
const ProductAnalyticsSuggestionKindEnum
    _$productAnalyticsSuggestionKindEnum_BUNDLE =
    const ProductAnalyticsSuggestionKindEnum._('BUNDLE');
const ProductAnalyticsSuggestionKindEnum
    _$productAnalyticsSuggestionKindEnum_NOT_VIEWED =
    const ProductAnalyticsSuggestionKindEnum._('NOT_VIEWED');
const ProductAnalyticsSuggestionKindEnum
    _$productAnalyticsSuggestionKindEnum_VIEWS_RISING =
    const ProductAnalyticsSuggestionKindEnum._('VIEWS_RISING');
const ProductAnalyticsSuggestionKindEnum
    _$productAnalyticsSuggestionKindEnum_VIEWS_FALLING =
    const ProductAnalyticsSuggestionKindEnum._('VIEWS_FALLING');

ProductAnalyticsSuggestionKindEnum _$productAnalyticsSuggestionKindEnumValueOf(
    String name) {
  switch (name) {
    case 'RESTOCK_VIEWED':
      return _$productAnalyticsSuggestionKindEnum_RESTOCK_VIEWED;
    case 'REORDER_SOON':
      return _$productAnalyticsSuggestionKindEnum_REORDER_SOON;
    case 'LOW_CONVERSION':
      return _$productAnalyticsSuggestionKindEnum_LOW_CONVERSION;
    case 'CONVERTS_WHEN_FOUND':
      return _$productAnalyticsSuggestionKindEnum_CONVERTS_WHEN_FOUND;
    case 'BUNDLE':
      return _$productAnalyticsSuggestionKindEnum_BUNDLE;
    case 'NOT_VIEWED':
      return _$productAnalyticsSuggestionKindEnum_NOT_VIEWED;
    case 'VIEWS_RISING':
      return _$productAnalyticsSuggestionKindEnum_VIEWS_RISING;
    case 'VIEWS_FALLING':
      return _$productAnalyticsSuggestionKindEnum_VIEWS_FALLING;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ProductAnalyticsSuggestionKindEnum>
    _$productAnalyticsSuggestionKindEnumValues = BuiltSet<
        ProductAnalyticsSuggestionKindEnum>(const <ProductAnalyticsSuggestionKindEnum>[
  _$productAnalyticsSuggestionKindEnum_RESTOCK_VIEWED,
  _$productAnalyticsSuggestionKindEnum_REORDER_SOON,
  _$productAnalyticsSuggestionKindEnum_LOW_CONVERSION,
  _$productAnalyticsSuggestionKindEnum_CONVERTS_WHEN_FOUND,
  _$productAnalyticsSuggestionKindEnum_BUNDLE,
  _$productAnalyticsSuggestionKindEnum_NOT_VIEWED,
  _$productAnalyticsSuggestionKindEnum_VIEWS_RISING,
  _$productAnalyticsSuggestionKindEnum_VIEWS_FALLING,
]);

const ProductAnalyticsSuggestionPriorityEnum
    _$productAnalyticsSuggestionPriorityEnum_HIGH =
    const ProductAnalyticsSuggestionPriorityEnum._('HIGH');
const ProductAnalyticsSuggestionPriorityEnum
    _$productAnalyticsSuggestionPriorityEnum_MEDIUM =
    const ProductAnalyticsSuggestionPriorityEnum._('MEDIUM');
const ProductAnalyticsSuggestionPriorityEnum
    _$productAnalyticsSuggestionPriorityEnum_LOW =
    const ProductAnalyticsSuggestionPriorityEnum._('LOW');

ProductAnalyticsSuggestionPriorityEnum
    _$productAnalyticsSuggestionPriorityEnumValueOf(String name) {
  switch (name) {
    case 'HIGH':
      return _$productAnalyticsSuggestionPriorityEnum_HIGH;
    case 'MEDIUM':
      return _$productAnalyticsSuggestionPriorityEnum_MEDIUM;
    case 'LOW':
      return _$productAnalyticsSuggestionPriorityEnum_LOW;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ProductAnalyticsSuggestionPriorityEnum>
    _$productAnalyticsSuggestionPriorityEnumValues = BuiltSet<
        ProductAnalyticsSuggestionPriorityEnum>(const <ProductAnalyticsSuggestionPriorityEnum>[
  _$productAnalyticsSuggestionPriorityEnum_HIGH,
  _$productAnalyticsSuggestionPriorityEnum_MEDIUM,
  _$productAnalyticsSuggestionPriorityEnum_LOW,
]);

Serializer<ProductAnalyticsSuggestionKindEnum>
    _$productAnalyticsSuggestionKindEnumSerializer =
    _$ProductAnalyticsSuggestionKindEnumSerializer();
Serializer<ProductAnalyticsSuggestionPriorityEnum>
    _$productAnalyticsSuggestionPriorityEnumSerializer =
    _$ProductAnalyticsSuggestionPriorityEnumSerializer();

class _$ProductAnalyticsSuggestionKindEnumSerializer
    implements PrimitiveSerializer<ProductAnalyticsSuggestionKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'RESTOCK_VIEWED': 'RESTOCK_VIEWED',
    'REORDER_SOON': 'REORDER_SOON',
    'LOW_CONVERSION': 'LOW_CONVERSION',
    'CONVERTS_WHEN_FOUND': 'CONVERTS_WHEN_FOUND',
    'BUNDLE': 'BUNDLE',
    'NOT_VIEWED': 'NOT_VIEWED',
    'VIEWS_RISING': 'VIEWS_RISING',
    'VIEWS_FALLING': 'VIEWS_FALLING',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'RESTOCK_VIEWED': 'RESTOCK_VIEWED',
    'REORDER_SOON': 'REORDER_SOON',
    'LOW_CONVERSION': 'LOW_CONVERSION',
    'CONVERTS_WHEN_FOUND': 'CONVERTS_WHEN_FOUND',
    'BUNDLE': 'BUNDLE',
    'NOT_VIEWED': 'NOT_VIEWED',
    'VIEWS_RISING': 'VIEWS_RISING',
    'VIEWS_FALLING': 'VIEWS_FALLING',
  };

  @override
  final Iterable<Type> types = const <Type>[ProductAnalyticsSuggestionKindEnum];
  @override
  final String wireName = 'ProductAnalyticsSuggestionKindEnum';

  @override
  Object serialize(
          Serializers serializers, ProductAnalyticsSuggestionKindEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ProductAnalyticsSuggestionKindEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ProductAnalyticsSuggestionKindEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ProductAnalyticsSuggestionPriorityEnumSerializer
    implements PrimitiveSerializer<ProductAnalyticsSuggestionPriorityEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'HIGH': 'HIGH',
    'MEDIUM': 'MEDIUM',
    'LOW': 'LOW',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'HIGH': 'HIGH',
    'MEDIUM': 'MEDIUM',
    'LOW': 'LOW',
  };

  @override
  final Iterable<Type> types = const <Type>[
    ProductAnalyticsSuggestionPriorityEnum
  ];
  @override
  final String wireName = 'ProductAnalyticsSuggestionPriorityEnum';

  @override
  Object serialize(Serializers serializers,
          ProductAnalyticsSuggestionPriorityEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ProductAnalyticsSuggestionPriorityEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ProductAnalyticsSuggestionPriorityEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ProductAnalyticsSuggestion extends ProductAnalyticsSuggestion {
  @override
  final String key;
  @override
  final ProductAnalyticsSuggestionKindEnum kind;
  @override
  final ProductAnalyticsSuggestionPriorityEnum priority;
  @override
  final String title;
  @override
  final String detail;
  @override
  final String technique;
  @override
  final String href;
  @override
  final String? listingId;
  @override
  final String? product;

  factory _$ProductAnalyticsSuggestion(
          [void Function(ProductAnalyticsSuggestionBuilder)? updates]) =>
      (ProductAnalyticsSuggestionBuilder()..update(updates))._build();

  _$ProductAnalyticsSuggestion._(
      {required this.key,
      required this.kind,
      required this.priority,
      required this.title,
      required this.detail,
      required this.technique,
      required this.href,
      this.listingId,
      this.product})
      : super._();
  @override
  ProductAnalyticsSuggestion rebuild(
          void Function(ProductAnalyticsSuggestionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProductAnalyticsSuggestionBuilder toBuilder() =>
      ProductAnalyticsSuggestionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProductAnalyticsSuggestion &&
        key == other.key &&
        kind == other.kind &&
        priority == other.priority &&
        title == other.title &&
        detail == other.detail &&
        technique == other.technique &&
        href == other.href &&
        listingId == other.listingId &&
        product == other.product;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, key.hashCode);
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, priority.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, detail.hashCode);
    _$hash = $jc(_$hash, technique.hashCode);
    _$hash = $jc(_$hash, href.hashCode);
    _$hash = $jc(_$hash, listingId.hashCode);
    _$hash = $jc(_$hash, product.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProductAnalyticsSuggestion')
          ..add('key', key)
          ..add('kind', kind)
          ..add('priority', priority)
          ..add('title', title)
          ..add('detail', detail)
          ..add('technique', technique)
          ..add('href', href)
          ..add('listingId', listingId)
          ..add('product', product))
        .toString();
  }
}

class ProductAnalyticsSuggestionBuilder
    implements
        Builder<ProductAnalyticsSuggestion, ProductAnalyticsSuggestionBuilder> {
  _$ProductAnalyticsSuggestion? _$v;

  String? _key;
  String? get key => _$this._key;
  set key(String? key) => _$this._key = key;

  ProductAnalyticsSuggestionKindEnum? _kind;
  ProductAnalyticsSuggestionKindEnum? get kind => _$this._kind;
  set kind(ProductAnalyticsSuggestionKindEnum? kind) => _$this._kind = kind;

  ProductAnalyticsSuggestionPriorityEnum? _priority;
  ProductAnalyticsSuggestionPriorityEnum? get priority => _$this._priority;
  set priority(ProductAnalyticsSuggestionPriorityEnum? priority) =>
      _$this._priority = priority;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  String? _detail;
  String? get detail => _$this._detail;
  set detail(String? detail) => _$this._detail = detail;

  String? _technique;
  String? get technique => _$this._technique;
  set technique(String? technique) => _$this._technique = technique;

  String? _href;
  String? get href => _$this._href;
  set href(String? href) => _$this._href = href;

  String? _listingId;
  String? get listingId => _$this._listingId;
  set listingId(String? listingId) => _$this._listingId = listingId;

  String? _product;
  String? get product => _$this._product;
  set product(String? product) => _$this._product = product;

  ProductAnalyticsSuggestionBuilder() {
    ProductAnalyticsSuggestion._defaults(this);
  }

  ProductAnalyticsSuggestionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _key = $v.key;
      _kind = $v.kind;
      _priority = $v.priority;
      _title = $v.title;
      _detail = $v.detail;
      _technique = $v.technique;
      _href = $v.href;
      _listingId = $v.listingId;
      _product = $v.product;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProductAnalyticsSuggestion other) {
    _$v = other as _$ProductAnalyticsSuggestion;
  }

  @override
  void update(void Function(ProductAnalyticsSuggestionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProductAnalyticsSuggestion build() => _build();

  _$ProductAnalyticsSuggestion _build() {
    final _$result = _$v ??
        _$ProductAnalyticsSuggestion._(
          key: BuiltValueNullFieldError.checkNotNull(
              key, r'ProductAnalyticsSuggestion', 'key'),
          kind: BuiltValueNullFieldError.checkNotNull(
              kind, r'ProductAnalyticsSuggestion', 'kind'),
          priority: BuiltValueNullFieldError.checkNotNull(
              priority, r'ProductAnalyticsSuggestion', 'priority'),
          title: BuiltValueNullFieldError.checkNotNull(
              title, r'ProductAnalyticsSuggestion', 'title'),
          detail: BuiltValueNullFieldError.checkNotNull(
              detail, r'ProductAnalyticsSuggestion', 'detail'),
          technique: BuiltValueNullFieldError.checkNotNull(
              technique, r'ProductAnalyticsSuggestion', 'technique'),
          href: BuiltValueNullFieldError.checkNotNull(
              href, r'ProductAnalyticsSuggestion', 'href'),
          listingId: listingId,
          product: product,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
