// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_dashboard_orders_products_segments.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const VendorDashboardOrdersProductsSegmentsStateEnum
    _$vendorDashboardOrdersProductsSegmentsStateEnum_OK =
    const VendorDashboardOrdersProductsSegmentsStateEnum._('OK');
const VendorDashboardOrdersProductsSegmentsStateEnum
    _$vendorDashboardOrdersProductsSegmentsStateEnum_INSUFFICIENT_DATA =
    const VendorDashboardOrdersProductsSegmentsStateEnum._('INSUFFICIENT_DATA');

VendorDashboardOrdersProductsSegmentsStateEnum
    _$vendorDashboardOrdersProductsSegmentsStateEnumValueOf(String name) {
  switch (name) {
    case 'OK':
      return _$vendorDashboardOrdersProductsSegmentsStateEnum_OK;
    case 'INSUFFICIENT_DATA':
      return _$vendorDashboardOrdersProductsSegmentsStateEnum_INSUFFICIENT_DATA;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<VendorDashboardOrdersProductsSegmentsStateEnum>
    _$vendorDashboardOrdersProductsSegmentsStateEnumValues = BuiltSet<
        VendorDashboardOrdersProductsSegmentsStateEnum>(const <VendorDashboardOrdersProductsSegmentsStateEnum>[
  _$vendorDashboardOrdersProductsSegmentsStateEnum_OK,
  _$vendorDashboardOrdersProductsSegmentsStateEnum_INSUFFICIENT_DATA,
]);

Serializer<VendorDashboardOrdersProductsSegmentsStateEnum>
    _$vendorDashboardOrdersProductsSegmentsStateEnumSerializer =
    _$VendorDashboardOrdersProductsSegmentsStateEnumSerializer();

class _$VendorDashboardOrdersProductsSegmentsStateEnumSerializer
    implements
        PrimitiveSerializer<VendorDashboardOrdersProductsSegmentsStateEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'OK': 'OK',
    'INSUFFICIENT_DATA': 'INSUFFICIENT_DATA',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'OK': 'OK',
    'INSUFFICIENT_DATA': 'INSUFFICIENT_DATA',
  };

  @override
  final Iterable<Type> types = const <Type>[
    VendorDashboardOrdersProductsSegmentsStateEnum
  ];
  @override
  final String wireName = 'VendorDashboardOrdersProductsSegmentsStateEnum';

  @override
  Object serialize(Serializers serializers,
          VendorDashboardOrdersProductsSegmentsStateEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  VendorDashboardOrdersProductsSegmentsStateEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      VendorDashboardOrdersProductsSegmentsStateEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$VendorDashboardOrdersProductsSegments
    extends VendorDashboardOrdersProductsSegments {
  @override
  final VendorDashboardOrdersProductsSegmentsStateEnum state;
  @override
  final String? reason;
  @override
  final int? k;
  @override
  final num? silhouette;
  @override
  final BuiltList<String> features;
  @override
  final BuiltList<VendorDashboardSegment> segments;
  @override
  final BuiltList<VendorDashboardOrdersProductsSegmentsPointsInner> points;

  factory _$VendorDashboardOrdersProductsSegments(
          [void Function(VendorDashboardOrdersProductsSegmentsBuilder)?
              updates]) =>
      (VendorDashboardOrdersProductsSegmentsBuilder()..update(updates))
          ._build();

  _$VendorDashboardOrdersProductsSegments._(
      {required this.state,
      this.reason,
      this.k,
      this.silhouette,
      required this.features,
      required this.segments,
      required this.points})
      : super._();
  @override
  VendorDashboardOrdersProductsSegments rebuild(
          void Function(VendorDashboardOrdersProductsSegmentsBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorDashboardOrdersProductsSegmentsBuilder toBuilder() =>
      VendorDashboardOrdersProductsSegmentsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorDashboardOrdersProductsSegments &&
        state == other.state &&
        reason == other.reason &&
        k == other.k &&
        silhouette == other.silhouette &&
        features == other.features &&
        segments == other.segments &&
        points == other.points;
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
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'VendorDashboardOrdersProductsSegments')
          ..add('state', state)
          ..add('reason', reason)
          ..add('k', k)
          ..add('silhouette', silhouette)
          ..add('features', features)
          ..add('segments', segments)
          ..add('points', points))
        .toString();
  }
}

class VendorDashboardOrdersProductsSegmentsBuilder
    implements
        Builder<VendorDashboardOrdersProductsSegments,
            VendorDashboardOrdersProductsSegmentsBuilder> {
  _$VendorDashboardOrdersProductsSegments? _$v;

  VendorDashboardOrdersProductsSegmentsStateEnum? _state;
  VendorDashboardOrdersProductsSegmentsStateEnum? get state => _$this._state;
  set state(VendorDashboardOrdersProductsSegmentsStateEnum? state) =>
      _$this._state = state;

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

  ListBuilder<VendorDashboardSegment>? _segments;
  ListBuilder<VendorDashboardSegment> get segments =>
      _$this._segments ??= ListBuilder<VendorDashboardSegment>();
  set segments(ListBuilder<VendorDashboardSegment>? segments) =>
      _$this._segments = segments;

  ListBuilder<VendorDashboardOrdersProductsSegmentsPointsInner>? _points;
  ListBuilder<VendorDashboardOrdersProductsSegmentsPointsInner> get points =>
      _$this._points ??=
          ListBuilder<VendorDashboardOrdersProductsSegmentsPointsInner>();
  set points(
          ListBuilder<VendorDashboardOrdersProductsSegmentsPointsInner>?
              points) =>
      _$this._points = points;

  VendorDashboardOrdersProductsSegmentsBuilder() {
    VendorDashboardOrdersProductsSegments._defaults(this);
  }

  VendorDashboardOrdersProductsSegmentsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _state = $v.state;
      _reason = $v.reason;
      _k = $v.k;
      _silhouette = $v.silhouette;
      _features = $v.features.toBuilder();
      _segments = $v.segments.toBuilder();
      _points = $v.points.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorDashboardOrdersProductsSegments other) {
    _$v = other as _$VendorDashboardOrdersProductsSegments;
  }

  @override
  void update(
      void Function(VendorDashboardOrdersProductsSegmentsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorDashboardOrdersProductsSegments build() => _build();

  _$VendorDashboardOrdersProductsSegments _build() {
    _$VendorDashboardOrdersProductsSegments _$result;
    try {
      _$result = _$v ??
          _$VendorDashboardOrdersProductsSegments._(
            state: BuiltValueNullFieldError.checkNotNull(
                state, r'VendorDashboardOrdersProductsSegments', 'state'),
            reason: reason,
            k: k,
            silhouette: silhouette,
            features: features.build(),
            segments: segments.build(),
            points: points.build(),
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
            r'VendorDashboardOrdersProductsSegments',
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
