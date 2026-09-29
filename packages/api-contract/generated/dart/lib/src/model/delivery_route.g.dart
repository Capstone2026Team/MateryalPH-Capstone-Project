// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_route.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const DeliveryRouteBasisEnum
    _$deliveryRouteBasisEnum_ROAD_ROUTE_STORE_TO_VEHICLE_DROP_OFF =
    const DeliveryRouteBasisEnum._('ROAD_ROUTE_STORE_TO_VEHICLE_DROP_OFF');

DeliveryRouteBasisEnum _$deliveryRouteBasisEnumValueOf(String name) {
  switch (name) {
    case 'ROAD_ROUTE_STORE_TO_VEHICLE_DROP_OFF':
      return _$deliveryRouteBasisEnum_ROAD_ROUTE_STORE_TO_VEHICLE_DROP_OFF;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DeliveryRouteBasisEnum> _$deliveryRouteBasisEnumValues =
    BuiltSet<DeliveryRouteBasisEnum>(const <DeliveryRouteBasisEnum>[
  _$deliveryRouteBasisEnum_ROAD_ROUTE_STORE_TO_VEHICLE_DROP_OFF,
]);

const DeliveryRouteSource_Enum _$deliveryRouteSourceEnum_GOOGLE_ROUTES =
    const DeliveryRouteSource_Enum._('GOOGLE_ROUTES');

DeliveryRouteSource_Enum _$deliveryRouteSourceEnumValueOf(String name) {
  switch (name) {
    case 'GOOGLE_ROUTES':
      return _$deliveryRouteSourceEnum_GOOGLE_ROUTES;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DeliveryRouteSource_Enum> _$deliveryRouteSourceEnumValues =
    BuiltSet<DeliveryRouteSource_Enum>(const <DeliveryRouteSource_Enum>[
  _$deliveryRouteSourceEnum_GOOGLE_ROUTES,
]);

Serializer<DeliveryRouteBasisEnum> _$deliveryRouteBasisEnumSerializer =
    _$DeliveryRouteBasisEnumSerializer();
Serializer<DeliveryRouteSource_Enum> _$deliveryRouteSourceEnumSerializer =
    _$DeliveryRouteSource_EnumSerializer();

class _$DeliveryRouteBasisEnumSerializer
    implements PrimitiveSerializer<DeliveryRouteBasisEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ROAD_ROUTE_STORE_TO_VEHICLE_DROP_OFF':
        'ROAD_ROUTE_STORE_TO_VEHICLE_DROP_OFF',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ROAD_ROUTE_STORE_TO_VEHICLE_DROP_OFF':
        'ROAD_ROUTE_STORE_TO_VEHICLE_DROP_OFF',
  };

  @override
  final Iterable<Type> types = const <Type>[DeliveryRouteBasisEnum];
  @override
  final String wireName = 'DeliveryRouteBasisEnum';

  @override
  Object serialize(Serializers serializers, DeliveryRouteBasisEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DeliveryRouteBasisEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DeliveryRouteBasisEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DeliveryRouteSource_EnumSerializer
    implements PrimitiveSerializer<DeliveryRouteSource_Enum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'GOOGLE_ROUTES': 'GOOGLE_ROUTES',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'GOOGLE_ROUTES': 'GOOGLE_ROUTES',
  };

  @override
  final Iterable<Type> types = const <Type>[DeliveryRouteSource_Enum];
  @override
  final String wireName = 'DeliveryRouteSource_Enum';

  @override
  Object serialize(Serializers serializers, DeliveryRouteSource_Enum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DeliveryRouteSource_Enum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DeliveryRouteSource_Enum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DeliveryRoute extends DeliveryRoute {
  @override
  final int distanceMeters;
  @override
  final int durationSeconds;
  @override
  final DeliveryRouteBasisEnum basis;
  @override
  final DeliveryRouteSource_Enum source_;
  @override
  final DateTime computedAt;
  @override
  final bool cached;

  factory _$DeliveryRoute([void Function(DeliveryRouteBuilder)? updates]) =>
      (DeliveryRouteBuilder()..update(updates))._build();

  _$DeliveryRoute._(
      {required this.distanceMeters,
      required this.durationSeconds,
      required this.basis,
      required this.source_,
      required this.computedAt,
      required this.cached})
      : super._();
  @override
  DeliveryRoute rebuild(void Function(DeliveryRouteBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DeliveryRouteBuilder toBuilder() => DeliveryRouteBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DeliveryRoute &&
        distanceMeters == other.distanceMeters &&
        durationSeconds == other.durationSeconds &&
        basis == other.basis &&
        source_ == other.source_ &&
        computedAt == other.computedAt &&
        cached == other.cached;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, distanceMeters.hashCode);
    _$hash = $jc(_$hash, durationSeconds.hashCode);
    _$hash = $jc(_$hash, basis.hashCode);
    _$hash = $jc(_$hash, source_.hashCode);
    _$hash = $jc(_$hash, computedAt.hashCode);
    _$hash = $jc(_$hash, cached.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DeliveryRoute')
          ..add('distanceMeters', distanceMeters)
          ..add('durationSeconds', durationSeconds)
          ..add('basis', basis)
          ..add('source_', source_)
          ..add('computedAt', computedAt)
          ..add('cached', cached))
        .toString();
  }
}

class DeliveryRouteBuilder
    implements Builder<DeliveryRoute, DeliveryRouteBuilder> {
  _$DeliveryRoute? _$v;

  int? _distanceMeters;
  int? get distanceMeters => _$this._distanceMeters;
  set distanceMeters(int? distanceMeters) =>
      _$this._distanceMeters = distanceMeters;

  int? _durationSeconds;
  int? get durationSeconds => _$this._durationSeconds;
  set durationSeconds(int? durationSeconds) =>
      _$this._durationSeconds = durationSeconds;

  DeliveryRouteBasisEnum? _basis;
  DeliveryRouteBasisEnum? get basis => _$this._basis;
  set basis(DeliveryRouteBasisEnum? basis) => _$this._basis = basis;

  DeliveryRouteSource_Enum? _source_;
  DeliveryRouteSource_Enum? get source_ => _$this._source_;
  set source_(DeliveryRouteSource_Enum? source_) => _$this._source_ = source_;

  DateTime? _computedAt;
  DateTime? get computedAt => _$this._computedAt;
  set computedAt(DateTime? computedAt) => _$this._computedAt = computedAt;

  bool? _cached;
  bool? get cached => _$this._cached;
  set cached(bool? cached) => _$this._cached = cached;

  DeliveryRouteBuilder() {
    DeliveryRoute._defaults(this);
  }

  DeliveryRouteBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _distanceMeters = $v.distanceMeters;
      _durationSeconds = $v.durationSeconds;
      _basis = $v.basis;
      _source_ = $v.source_;
      _computedAt = $v.computedAt;
      _cached = $v.cached;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DeliveryRoute other) {
    _$v = other as _$DeliveryRoute;
  }

  @override
  void update(void Function(DeliveryRouteBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DeliveryRoute build() => _build();

  _$DeliveryRoute _build() {
    final _$result = _$v ??
        _$DeliveryRoute._(
          distanceMeters: BuiltValueNullFieldError.checkNotNull(
              distanceMeters, r'DeliveryRoute', 'distanceMeters'),
          durationSeconds: BuiltValueNullFieldError.checkNotNull(
              durationSeconds, r'DeliveryRoute', 'durationSeconds'),
          basis: BuiltValueNullFieldError.checkNotNull(
              basis, r'DeliveryRoute', 'basis'),
          source_: BuiltValueNullFieldError.checkNotNull(
              source_, r'DeliveryRoute', 'source_'),
          computedAt: BuiltValueNullFieldError.checkNotNull(
              computedAt, r'DeliveryRoute', 'computedAt'),
          cached: BuiltValueNullFieldError.checkNotNull(
              cached, r'DeliveryRoute', 'cached'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
