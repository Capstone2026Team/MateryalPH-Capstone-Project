// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_analytics_segments.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ProductAnalyticsSegmentsStateEnum _$productAnalyticsSegmentsStateEnum_OK =
    const ProductAnalyticsSegmentsStateEnum._('OK');
const ProductAnalyticsSegmentsStateEnum
    _$productAnalyticsSegmentsStateEnum_INSUFFICIENT_DATA =
    const ProductAnalyticsSegmentsStateEnum._('INSUFFICIENT_DATA');

ProductAnalyticsSegmentsStateEnum _$productAnalyticsSegmentsStateEnumValueOf(
    String name) {
  switch (name) {
    case 'OK':
      return _$productAnalyticsSegmentsStateEnum_OK;
    case 'INSUFFICIENT_DATA':
      return _$productAnalyticsSegmentsStateEnum_INSUFFICIENT_DATA;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ProductAnalyticsSegmentsStateEnum>
    _$productAnalyticsSegmentsStateEnumValues = BuiltSet<
        ProductAnalyticsSegmentsStateEnum>(const <ProductAnalyticsSegmentsStateEnum>[
  _$productAnalyticsSegmentsStateEnum_OK,
  _$productAnalyticsSegmentsStateEnum_INSUFFICIENT_DATA,
]);

Serializer<ProductAnalyticsSegmentsStateEnum>
    _$productAnalyticsSegmentsStateEnumSerializer =
    _$ProductAnalyticsSegmentsStateEnumSerializer();

class _$ProductAnalyticsSegmentsStateEnumSerializer
    implements PrimitiveSerializer<ProductAnalyticsSegmentsStateEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'OK': 'OK',
    'INSUFFICIENT_DATA': 'INSUFFICIENT_DATA',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'OK': 'OK',
    'INSUFFICIENT_DATA': 'INSUFFICIENT_DATA',
  };

  @override
  final Iterable<Type> types = const <Type>[ProductAnalyticsSegmentsStateEnum];
  @override
  final String wireName = 'ProductAnalyticsSegmentsStateEnum';

  @override
  Object serialize(
          Serializers serializers, ProductAnalyticsSegmentsStateEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ProductAnalyticsSegmentsStateEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ProductAnalyticsSegmentsStateEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ProductAnalyticsSegments extends ProductAnalyticsSegments {
  @override
  final ProductAnalyticsSegmentsStateEnum state;
  @override
  final String? reason;
  @override
  final int? k;
  @override
  final num? silhouette;
  @override
  final BuiltList<String> features;
  @override
  final BuiltList<ProductAnalyticsSegmentsSegmentsInner> segments;
  @override
  final BuiltList<ProductAnalyticsSegmentsPointsInner> points;
  @override
  final num? meanConversionPercent;

  factory _$ProductAnalyticsSegments(
          [void Function(ProductAnalyticsSegmentsBuilder)? updates]) =>
      (ProductAnalyticsSegmentsBuilder()..update(updates))._build();

  _$ProductAnalyticsSegments._(
      {required this.state,
      this.reason,
      this.k,
      this.silhouette,
      required this.features,
      required this.segments,
      required this.points,
      this.meanConversionPercent})
      : super._();
  @override
  ProductAnalyticsSegments rebuild(
          void Function(ProductAnalyticsSegmentsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProductAnalyticsSegmentsBuilder toBuilder() =>
      ProductAnalyticsSegmentsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProductAnalyticsSegments &&
        state == other.state &&
        reason == other.reason &&
        k == other.k &&
        silhouette == other.silhouette &&
        features == other.features &&
        segments == other.segments &&
        points == other.points &&
        meanConversionPercent == other.meanConversionPercent;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, state.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, k.hashCode);
    _$hash = $jc(_$hash, silhouette.hashCode);
    _$hash = $jc(_$hash, features.hashCode);
    _$hash = $jc(_$hash, segments.hashCode);
    _$hash = $jc(_$hash, points.hashCode);
    _$hash = $jc(_$hash, meanConversionPercent.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProductAnalyticsSegments')
          ..add('state', state)
          ..add('reason', reason)
          ..add('k', k)
          ..add('silhouette', silhouette)
          ..add('features', features)
          ..add('segments', segments)
          ..add('points', points)
          ..add('meanConversionPercent', meanConversionPercent))
        .toString();
  }
}

class ProductAnalyticsSegmentsBuilder
    implements
        Builder<ProductAnalyticsSegments, ProductAnalyticsSegmentsBuilder> {
  _$ProductAnalyticsSegments? _$v;

  ProductAnalyticsSegmentsStateEnum? _state;
  ProductAnalyticsSegmentsStateEnum? get state => _$this._state;
  set state(ProductAnalyticsSegmentsStateEnum? state) => _$this._state = state;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  int? _k;
  int? get k => _$this._k;
  set k(int? k) => _$this._k = k;

  num? _silhouette;
  num? get silhouette => _$this._silhouette;
  set silhouette(num? silhouette) => _$this._silhouette = silhouette;

  ListBuilder<String>? _features;
  ListBuilder<String> get features =>
      _$this._features ??= ListBuilder<String>();
  set features(ListBuilder<String>? features) => _$this._features = features;

  ListBuilder<ProductAnalyticsSegmentsSegmentsInner>? _segments;
  ListBuilder<ProductAnalyticsSegmentsSegmentsInner> get segments =>
      _$this._segments ??= ListBuilder<ProductAnalyticsSegmentsSegmentsInner>();
  set segments(ListBuilder<ProductAnalyticsSegmentsSegmentsInner>? segments) =>
      _$this._segments = segments;

  ListBuilder<ProductAnalyticsSegmentsPointsInner>? _points;
  ListBuilder<ProductAnalyticsSegmentsPointsInner> get points =>
      _$this._points ??= ListBuilder<ProductAnalyticsSegmentsPointsInner>();
  set points(ListBuilder<ProductAnalyticsSegmentsPointsInner>? points) =>
      _$this._points = points;

  num? _meanConversionPercent;
  num? get meanConversionPercent => _$this._meanConversionPercent;
  set meanConversionPercent(num? meanConversionPercent) =>
      _$this._meanConversionPercent = meanConversionPercent;

  ProductAnalyticsSegmentsBuilder() {
    ProductAnalyticsSegments._defaults(this);
  }

  ProductAnalyticsSegmentsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _state = $v.state;
      _reason = $v.reason;
      _k = $v.k;
      _silhouette = $v.silhouette;
      _features = $v.features.toBuilder();
      _segments = $v.segments.toBuilder();
      _points = $v.points.toBuilder();
      _meanConversionPercent = $v.meanConversionPercent;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProductAnalyticsSegments other) {
    _$v = other as _$ProductAnalyticsSegments;
  }

  @override
  void update(void Function(ProductAnalyticsSegmentsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProductAnalyticsSegments build() => _build();

  _$ProductAnalyticsSegments _build() {
    _$ProductAnalyticsSegments _$result;
    try {
      _$result = _$v ??
          _$ProductAnalyticsSegments._(
            state: BuiltValueNullFieldError.checkNotNull(
                state, r'ProductAnalyticsSegments', 'state'),
            reason: reason,
            k: k,
            silhouette: silhouette,
            features: features.build(),
            segments: segments.build(),
            points: points.build(),
            meanConversionPercent: meanConversionPercent,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'features';
        features.build();
        _$failedField = 'segments';
        segments.build();
        _$failedField = 'points';
        points.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ProductAnalyticsSegments', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
