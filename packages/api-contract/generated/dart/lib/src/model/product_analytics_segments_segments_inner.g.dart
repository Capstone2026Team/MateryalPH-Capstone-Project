// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_analytics_segments_segments_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ProductAnalyticsSegmentsSegmentsInnerKindEnum
    _$productAnalyticsSegmentsSegmentsInnerKindEnum_POPULAR_CONVERTING =
    const ProductAnalyticsSegmentsSegmentsInnerKindEnum._('POPULAR_CONVERTING');
const ProductAnalyticsSegmentsSegmentsInnerKindEnum
    _$productAnalyticsSegmentsSegmentsInnerKindEnum_VIEWED_NOT_ORDERED =
    const ProductAnalyticsSegmentsSegmentsInnerKindEnum._('VIEWED_NOT_ORDERED');
const ProductAnalyticsSegmentsSegmentsInnerKindEnum
    _$productAnalyticsSegmentsSegmentsInnerKindEnum_CONVERTS_WHEN_FOUND =
    const ProductAnalyticsSegmentsSegmentsInnerKindEnum._(
        'CONVERTS_WHEN_FOUND');
const ProductAnalyticsSegmentsSegmentsInnerKindEnum
    _$productAnalyticsSegmentsSegmentsInnerKindEnum_LOW_VISIBILITY =
    const ProductAnalyticsSegmentsSegmentsInnerKindEnum._('LOW_VISIBILITY');

ProductAnalyticsSegmentsSegmentsInnerKindEnum
    _$productAnalyticsSegmentsSegmentsInnerKindEnumValueOf(String name) {
  switch (name) {
    case 'POPULAR_CONVERTING':
      return _$productAnalyticsSegmentsSegmentsInnerKindEnum_POPULAR_CONVERTING;
    case 'VIEWED_NOT_ORDERED':
      return _$productAnalyticsSegmentsSegmentsInnerKindEnum_VIEWED_NOT_ORDERED;
    case 'CONVERTS_WHEN_FOUND':
      return _$productAnalyticsSegmentsSegmentsInnerKindEnum_CONVERTS_WHEN_FOUND;
    case 'LOW_VISIBILITY':
      return _$productAnalyticsSegmentsSegmentsInnerKindEnum_LOW_VISIBILITY;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ProductAnalyticsSegmentsSegmentsInnerKindEnum>
    _$productAnalyticsSegmentsSegmentsInnerKindEnumValues = BuiltSet<
        ProductAnalyticsSegmentsSegmentsInnerKindEnum>(const <ProductAnalyticsSegmentsSegmentsInnerKindEnum>[
  _$productAnalyticsSegmentsSegmentsInnerKindEnum_POPULAR_CONVERTING,
  _$productAnalyticsSegmentsSegmentsInnerKindEnum_VIEWED_NOT_ORDERED,
  _$productAnalyticsSegmentsSegmentsInnerKindEnum_CONVERTS_WHEN_FOUND,
  _$productAnalyticsSegmentsSegmentsInnerKindEnum_LOW_VISIBILITY,
]);

Serializer<ProductAnalyticsSegmentsSegmentsInnerKindEnum>
    _$productAnalyticsSegmentsSegmentsInnerKindEnumSerializer =
    _$ProductAnalyticsSegmentsSegmentsInnerKindEnumSerializer();

class _$ProductAnalyticsSegmentsSegmentsInnerKindEnumSerializer
    implements
        PrimitiveSerializer<ProductAnalyticsSegmentsSegmentsInnerKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'POPULAR_CONVERTING': 'POPULAR_CONVERTING',
    'VIEWED_NOT_ORDERED': 'VIEWED_NOT_ORDERED',
    'CONVERTS_WHEN_FOUND': 'CONVERTS_WHEN_FOUND',
    'LOW_VISIBILITY': 'LOW_VISIBILITY',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'POPULAR_CONVERTING': 'POPULAR_CONVERTING',
    'VIEWED_NOT_ORDERED': 'VIEWED_NOT_ORDERED',
    'CONVERTS_WHEN_FOUND': 'CONVERTS_WHEN_FOUND',
    'LOW_VISIBILITY': 'LOW_VISIBILITY',
  };

  @override
  final Iterable<Type> types = const <Type>[
    ProductAnalyticsSegmentsSegmentsInnerKindEnum
  ];
  @override
  final String wireName = 'ProductAnalyticsSegmentsSegmentsInnerKindEnum';

  @override
  Object serialize(Serializers serializers,
          ProductAnalyticsSegmentsSegmentsInnerKindEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ProductAnalyticsSegmentsSegmentsInnerKindEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ProductAnalyticsSegmentsSegmentsInnerKindEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ProductAnalyticsSegmentsSegmentsInner
    extends ProductAnalyticsSegmentsSegmentsInner {
  @override
  final int id;
  @override
  final String label;
  @override
  final ProductAnalyticsSegmentsSegmentsInnerKindEnum kind;
  @override
  final int size;
  @override
  final num averageViews;
  @override
  final num averageConversionPercent;
  @override
  final num averageOrders;
  @override
  final BuiltList<String> examples;

  factory _$ProductAnalyticsSegmentsSegmentsInner(
          [void Function(ProductAnalyticsSegmentsSegmentsInnerBuilder)?
              updates]) =>
      (ProductAnalyticsSegmentsSegmentsInnerBuilder()..update(updates))
          ._build();

  _$ProductAnalyticsSegmentsSegmentsInner._(
      {required this.id,
      required this.label,
      required this.kind,
      required this.size,
      required this.averageViews,
      required this.averageConversionPercent,
      required this.averageOrders,
      required this.examples})
      : super._();
  @override
  ProductAnalyticsSegmentsSegmentsInner rebuild(
          void Function(ProductAnalyticsSegmentsSegmentsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProductAnalyticsSegmentsSegmentsInnerBuilder toBuilder() =>
      ProductAnalyticsSegmentsSegmentsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProductAnalyticsSegmentsSegmentsInner &&
        id == other.id &&
        label == other.label &&
        kind == other.kind &&
        size == other.size &&
        averageViews == other.averageViews &&
        averageConversionPercent == other.averageConversionPercent &&
        averageOrders == other.averageOrders &&
        examples == other.examples;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, size.hashCode);
    _$hash = $jc(_$hash, averageViews.hashCode);
    _$hash = $jc(_$hash, averageConversionPercent.hashCode);
    _$hash = $jc(_$hash, averageOrders.hashCode);
    _$hash = $jc(_$hash, examples.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'ProductAnalyticsSegmentsSegmentsInner')
          ..add('id', id)
          ..add('label', label)
          ..add('kind', kind)
          ..add('size', size)
          ..add('averageViews', averageViews)
          ..add('averageConversionPercent', averageConversionPercent)
          ..add('averageOrders', averageOrders)
          ..add('examples', examples))
        .toString();
  }
}

class ProductAnalyticsSegmentsSegmentsInnerBuilder
    implements
        Builder<ProductAnalyticsSegmentsSegmentsInner,
            ProductAnalyticsSegmentsSegmentsInnerBuilder> {
  _$ProductAnalyticsSegmentsSegmentsInner? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  ProductAnalyticsSegmentsSegmentsInnerKindEnum? _kind;
  ProductAnalyticsSegmentsSegmentsInnerKindEnum? get kind => _$this._kind;
  set kind(ProductAnalyticsSegmentsSegmentsInnerKindEnum? kind) =>
      _$this._kind = kind;

  int? _size;
  int? get size => _$this._size;
  set size(int? size) => _$this._size = size;

  num? _averageViews;
  num? get averageViews => _$this._averageViews;
  set averageViews(num? averageViews) => _$this._averageViews = averageViews;

  num? _averageConversionPercent;
  num? get averageConversionPercent => _$this._averageConversionPercent;
  set averageConversionPercent(num? averageConversionPercent) =>
      _$this._averageConversionPercent = averageConversionPercent;

  num? _averageOrders;
  num? get averageOrders => _$this._averageOrders;
  set averageOrders(num? averageOrders) =>
      _$this._averageOrders = averageOrders;

  ListBuilder<String>? _examples;
  ListBuilder<String> get examples =>
      _$this._examples ??= ListBuilder<String>();
  set examples(ListBuilder<String>? examples) => _$this._examples = examples;

  ProductAnalyticsSegmentsSegmentsInnerBuilder() {
    ProductAnalyticsSegmentsSegmentsInner._defaults(this);
  }

  ProductAnalyticsSegmentsSegmentsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _label = $v.label;
      _kind = $v.kind;
      _size = $v.size;
      _averageViews = $v.averageViews;
      _averageConversionPercent = $v.averageConversionPercent;
      _averageOrders = $v.averageOrders;
      _examples = $v.examples.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProductAnalyticsSegmentsSegmentsInner other) {
    _$v = other as _$ProductAnalyticsSegmentsSegmentsInner;
  }

  @override
  void update(
      void Function(ProductAnalyticsSegmentsSegmentsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProductAnalyticsSegmentsSegmentsInner build() => _build();

  _$ProductAnalyticsSegmentsSegmentsInner _build() {
    _$ProductAnalyticsSegmentsSegmentsInner _$result;
    try {
      _$result = _$v ??
          _$ProductAnalyticsSegmentsSegmentsInner._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'ProductAnalyticsSegmentsSegmentsInner', 'id'),
            label: BuiltValueNullFieldError.checkNotNull(
                label, r'ProductAnalyticsSegmentsSegmentsInner', 'label'),
            kind: BuiltValueNullFieldError.checkNotNull(
                kind, r'ProductAnalyticsSegmentsSegmentsInner', 'kind'),
            size: BuiltValueNullFieldError.checkNotNull(
                size, r'ProductAnalyticsSegmentsSegmentsInner', 'size'),
            averageViews: BuiltValueNullFieldError.checkNotNull(averageViews,
                r'ProductAnalyticsSegmentsSegmentsInner', 'averageViews'),
            averageConversionPercent: BuiltValueNullFieldError.checkNotNull(
                averageConversionPercent,
                r'ProductAnalyticsSegmentsSegmentsInner',
                'averageConversionPercent'),
            averageOrders: BuiltValueNullFieldError.checkNotNull(averageOrders,
                r'ProductAnalyticsSegmentsSegmentsInner', 'averageOrders'),
            examples: examples.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'examples';
        examples.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ProductAnalyticsSegmentsSegmentsInner',
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
