// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_estimate.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const RouteEstimateDurationBasisEnum
    _$routeEstimateDurationBasisEnum_TRAFFIC_AWARE =
    const RouteEstimateDurationBasisEnum._('TRAFFIC_AWARE');
const RouteEstimateDurationBasisEnum
    _$routeEstimateDurationBasisEnum_TRAFFIC_UNAWARE =
    const RouteEstimateDurationBasisEnum._('TRAFFIC_UNAWARE');

RouteEstimateDurationBasisEnum _$routeEstimateDurationBasisEnumValueOf(
    String name) {
  switch (name) {
    case 'TRAFFIC_AWARE':
      return _$routeEstimateDurationBasisEnum_TRAFFIC_AWARE;
    case 'TRAFFIC_UNAWARE':
      return _$routeEstimateDurationBasisEnum_TRAFFIC_UNAWARE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<RouteEstimateDurationBasisEnum>
    _$routeEstimateDurationBasisEnumValues = BuiltSet<
        RouteEstimateDurationBasisEnum>(const <RouteEstimateDurationBasisEnum>[
  _$routeEstimateDurationBasisEnum_TRAFFIC_AWARE,
  _$routeEstimateDurationBasisEnum_TRAFFIC_UNAWARE,
]);

Serializer<RouteEstimateDurationBasisEnum>
    _$routeEstimateDurationBasisEnumSerializer =
    _$RouteEstimateDurationBasisEnumSerializer();

class _$RouteEstimateDurationBasisEnumSerializer
    implements PrimitiveSerializer<RouteEstimateDurationBasisEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'TRAFFIC_AWARE': 'TRAFFIC_AWARE',
    'TRAFFIC_UNAWARE': 'TRAFFIC_UNAWARE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'TRAFFIC_AWARE': 'TRAFFIC_AWARE',
    'TRAFFIC_UNAWARE': 'TRAFFIC_UNAWARE',
  };

  @override
  final Iterable<Type> types = const <Type>[RouteEstimateDurationBasisEnum];
  @override
  final String wireName = 'RouteEstimateDurationBasisEnum';

  @override
  Object serialize(
          Serializers serializers, RouteEstimateDurationBasisEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  RouteEstimateDurationBasisEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      RouteEstimateDurationBasisEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$RouteEstimate extends RouteEstimate {
  @override
  final String requestVersion;
  @override
  final String originVersion;
  @override
  final SupplierTier tier;
  @override
  final String supplierId;
  @override
  final int straightLineMeters;
  @override
  final int distanceMeters;
  @override
  final int durationSeconds;
  @override
  final RouteEstimateDurationBasisEnum durationBasis;
  @override
  final String encodedPolyline;
  @override
  final DateTime computedAt;
  @override
  final bool cached;

  factory _$RouteEstimate([void Function(RouteEstimateBuilder)? updates]) =>
      (RouteEstimateBuilder()..update(updates))._build();

  _$RouteEstimate._(
      {required this.requestVersion,
      required this.originVersion,
      required this.tier,
      required this.supplierId,
      required this.straightLineMeters,
      required this.distanceMeters,
      required this.durationSeconds,
      required this.durationBasis,
      required this.encodedPolyline,
      required this.computedAt,
      required this.cached})
      : super._();
  @override
  RouteEstimate rebuild(void Function(RouteEstimateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RouteEstimateBuilder toBuilder() => RouteEstimateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RouteEstimate &&
        requestVersion == other.requestVersion &&
        originVersion == other.originVersion &&
        tier == other.tier &&
        supplierId == other.supplierId &&
        straightLineMeters == other.straightLineMeters &&
        distanceMeters == other.distanceMeters &&
        durationSeconds == other.durationSeconds &&
        durationBasis == other.durationBasis &&
        encodedPolyline == other.encodedPolyline &&
        computedAt == other.computedAt &&
        cached == other.cached;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, requestVersion.hashCode);
    _$hash = $jc(_$hash, originVersion.hashCode);
    _$hash = $jc(_$hash, tier.hashCode);
    _$hash = $jc(_$hash, supplierId.hashCode);
    _$hash = $jc(_$hash, straightLineMeters.hashCode);
    _$hash = $jc(_$hash, distanceMeters.hashCode);
    _$hash = $jc(_$hash, durationSeconds.hashCode);
    _$hash = $jc(_$hash, durationBasis.hashCode);
    _$hash = $jc(_$hash, encodedPolyline.hashCode);
    _$hash = $jc(_$hash, computedAt.hashCode);
    _$hash = $jc(_$hash, cached.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RouteEstimate')
          ..add('requestVersion', requestVersion)
          ..add('originVersion', originVersion)
          ..add('tier', tier)
          ..add('supplierId', supplierId)
          ..add('straightLineMeters', straightLineMeters)
          ..add('distanceMeters', distanceMeters)
          ..add('durationSeconds', durationSeconds)
          ..add('durationBasis', durationBasis)
          ..add('encodedPolyline', encodedPolyline)
          ..add('computedAt', computedAt)
          ..add('cached', cached))
        .toString();
  }
}

class RouteEstimateBuilder
    implements Builder<RouteEstimate, RouteEstimateBuilder> {
  _$RouteEstimate? _$v;

  String? _requestVersion;
  String? get requestVersion => _$this._requestVersion;
  set requestVersion(String? requestVersion) =>
      _$this._requestVersion = requestVersion;

  String? _originVersion;
  String? get originVersion => _$this._originVersion;
  set originVersion(String? originVersion) =>
      _$this._originVersion = originVersion;

  SupplierTier? _tier;
  SupplierTier? get tier => _$this._tier;
  set tier(SupplierTier? tier) => _$this._tier = tier;

  String? _supplierId;
  String? get supplierId => _$this._supplierId;
  set supplierId(String? supplierId) => _$this._supplierId = supplierId;

  int? _straightLineMeters;
  int? get straightLineMeters => _$this._straightLineMeters;
  set straightLineMeters(int? straightLineMeters) =>
      _$this._straightLineMeters = straightLineMeters;

  int? _distanceMeters;
  int? get distanceMeters => _$this._distanceMeters;
  set distanceMeters(int? distanceMeters) =>
      _$this._distanceMeters = distanceMeters;

  int? _durationSeconds;
  int? get durationSeconds => _$this._durationSeconds;
  set durationSeconds(int? durationSeconds) =>
      _$this._durationSeconds = durationSeconds;

  RouteEstimateDurationBasisEnum? _durationBasis;
  RouteEstimateDurationBasisEnum? get durationBasis => _$this._durationBasis;
  set durationBasis(RouteEstimateDurationBasisEnum? durationBasis) =>
      _$this._durationBasis = durationBasis;

  String? _encodedPolyline;
  String? get encodedPolyline => _$this._encodedPolyline;
  set encodedPolyline(String? encodedPolyline) =>
      _$this._encodedPolyline = encodedPolyline;

  DateTime? _computedAt;
  DateTime? get computedAt => _$this._computedAt;
  set computedAt(DateTime? computedAt) => _$this._computedAt = computedAt;

  bool? _cached;
  bool? get cached => _$this._cached;
  set cached(bool? cached) => _$this._cached = cached;

  RouteEstimateBuilder() {
    RouteEstimate._defaults(this);
  }

  RouteEstimateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _requestVersion = $v.requestVersion;
      _originVersion = $v.originVersion;
      _tier = $v.tier;
      _supplierId = $v.supplierId;
      _straightLineMeters = $v.straightLineMeters;
      _distanceMeters = $v.distanceMeters;
      _durationSeconds = $v.durationSeconds;
      _durationBasis = $v.durationBasis;
      _encodedPolyline = $v.encodedPolyline;
      _computedAt = $v.computedAt;
      _cached = $v.cached;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RouteEstimate other) {
    _$v = other as _$RouteEstimate;
  }

  @override
  void update(void Function(RouteEstimateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RouteEstimate build() => _build();

  _$RouteEstimate _build() {
    final _$result = _$v ??
        _$RouteEstimate._(
          requestVersion: BuiltValueNullFieldError.checkNotNull(
              requestVersion, r'RouteEstimate', 'requestVersion'),
          originVersion: BuiltValueNullFieldError.checkNotNull(
              originVersion, r'RouteEstimate', 'originVersion'),
          tier: BuiltValueNullFieldError.checkNotNull(
              tier, r'RouteEstimate', 'tier'),
          supplierId: BuiltValueNullFieldError.checkNotNull(
              supplierId, r'RouteEstimate', 'supplierId'),
          straightLineMeters: BuiltValueNullFieldError.checkNotNull(
              straightLineMeters, r'RouteEstimate', 'straightLineMeters'),
          distanceMeters: BuiltValueNullFieldError.checkNotNull(
              distanceMeters, r'RouteEstimate', 'distanceMeters'),
          durationSeconds: BuiltValueNullFieldError.checkNotNull(
              durationSeconds, r'RouteEstimate', 'durationSeconds'),
          durationBasis: BuiltValueNullFieldError.checkNotNull(
              durationBasis, r'RouteEstimate', 'durationBasis'),
          encodedPolyline: BuiltValueNullFieldError.checkNotNull(
              encodedPolyline, r'RouteEstimate', 'encodedPolyline'),
          computedAt: BuiltValueNullFieldError.checkNotNull(
              computedAt, r'RouteEstimate', 'computedAt'),
          cached: BuiltValueNullFieldError.checkNotNull(
              cached, r'RouteEstimate', 'cached'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
