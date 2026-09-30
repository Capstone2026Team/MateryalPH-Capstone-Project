// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_plan_route.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const DeliveryPlanRouteBasisEnum
    _$deliveryPlanRouteBasisEnum_ROAD_ROUTE_STORE_TO_VEHICLE_DROP_OFF =
    const DeliveryPlanRouteBasisEnum._('ROAD_ROUTE_STORE_TO_VEHICLE_DROP_OFF');

DeliveryPlanRouteBasisEnum _$deliveryPlanRouteBasisEnumValueOf(String name) {
  switch (name) {
    case 'ROAD_ROUTE_STORE_TO_VEHICLE_DROP_OFF':
      return _$deliveryPlanRouteBasisEnum_ROAD_ROUTE_STORE_TO_VEHICLE_DROP_OFF;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DeliveryPlanRouteBasisEnum> _$deliveryPlanRouteBasisEnumValues =
    BuiltSet<DeliveryPlanRouteBasisEnum>(const <DeliveryPlanRouteBasisEnum>[
  _$deliveryPlanRouteBasisEnum_ROAD_ROUTE_STORE_TO_VEHICLE_DROP_OFF,
]);

Serializer<DeliveryPlanRouteBasisEnum> _$deliveryPlanRouteBasisEnumSerializer =
    _$DeliveryPlanRouteBasisEnumSerializer();

class _$DeliveryPlanRouteBasisEnumSerializer
    implements PrimitiveSerializer<DeliveryPlanRouteBasisEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ROAD_ROUTE_STORE_TO_VEHICLE_DROP_OFF':
        'ROAD_ROUTE_STORE_TO_VEHICLE_DROP_OFF',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ROAD_ROUTE_STORE_TO_VEHICLE_DROP_OFF':
        'ROAD_ROUTE_STORE_TO_VEHICLE_DROP_OFF',
  };

  @override
  final Iterable<Type> types = const <Type>[DeliveryPlanRouteBasisEnum];
  @override
  final String wireName = 'DeliveryPlanRouteBasisEnum';

  @override
  Object serialize(Serializers serializers, DeliveryPlanRouteBasisEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DeliveryPlanRouteBasisEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DeliveryPlanRouteBasisEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DeliveryPlanRoute extends DeliveryPlanRoute {
  @override
  final int distanceMeters;
  @override
  final int durationSeconds;
  @override
  final DeliveryPlanRouteBasisEnum basis;
  @override
  final String source_;

  factory _$DeliveryPlanRoute(
          [void Function(DeliveryPlanRouteBuilder)? updates]) =>
      (DeliveryPlanRouteBuilder()..update(updates))._build();

  _$DeliveryPlanRoute._(
      {required this.distanceMeters,
      required this.durationSeconds,
      required this.basis,
      required this.source_})
      : super._();
  @override
  DeliveryPlanRoute rebuild(void Function(DeliveryPlanRouteBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DeliveryPlanRouteBuilder toBuilder() =>
      DeliveryPlanRouteBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DeliveryPlanRoute &&
        distanceMeters == other.distanceMeters &&
        durationSeconds == other.durationSeconds &&
        basis == other.basis &&
        source_ == other.source_;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, distanceMeters.hashCode);
    _$hash = $jc(_$hash, durationSeconds.hashCode);
    _$hash = $jc(_$hash, basis.hashCode);
    _$hash = $jc(_$hash, source_.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DeliveryPlanRoute')
          ..add('distanceMeters', distanceMeters)
          ..add('durationSeconds', durationSeconds)
          ..add('basis', basis)
          ..add('source_', source_))
        .toString();
  }
}

class DeliveryPlanRouteBuilder
    implements Builder<DeliveryPlanRoute, DeliveryPlanRouteBuilder> {
  _$DeliveryPlanRoute? _$v;

  int? _distanceMeters;
  int? get distanceMeters => _$this._distanceMeters;
  set distanceMeters(int? distanceMeters) =>
      _$this._distanceMeters = distanceMeters;

  int? _durationSeconds;
  int? get durationSeconds => _$this._durationSeconds;
  set durationSeconds(int? durationSeconds) =>
      _$this._durationSeconds = durationSeconds;

  DeliveryPlanRouteBasisEnum? _basis;
  DeliveryPlanRouteBasisEnum? get basis => _$this._basis;
  set basis(DeliveryPlanRouteBasisEnum? basis) => _$this._basis = basis;

  String? _source_;
  String? get source_ => _$this._source_;
  set source_(String? source_) => _$this._source_ = source_;

  DeliveryPlanRouteBuilder() {
    DeliveryPlanRoute._defaults(this);
  }

  DeliveryPlanRouteBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _distanceMeters = $v.distanceMeters;
      _durationSeconds = $v.durationSeconds;
      _basis = $v.basis;
      _source_ = $v.source_;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DeliveryPlanRoute other) {
    _$v = other as _$DeliveryPlanRoute;
  }

  @override
  void update(void Function(DeliveryPlanRouteBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DeliveryPlanRoute build() => _build();

  _$DeliveryPlanRoute _build() {
    final _$result = _$v ??
        _$DeliveryPlanRoute._(
          distanceMeters: BuiltValueNullFieldError.checkNotNull(
              distanceMeters, r'DeliveryPlanRoute', 'distanceMeters'),
          durationSeconds: BuiltValueNullFieldError.checkNotNull(
              durationSeconds, r'DeliveryPlanRoute', 'durationSeconds'),
          basis: BuiltValueNullFieldError.checkNotNull(
              basis, r'DeliveryPlanRoute', 'basis'),
          source_: BuiltValueNullFieldError.checkNotNull(
              source_, r'DeliveryPlanRoute', 'source_'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
