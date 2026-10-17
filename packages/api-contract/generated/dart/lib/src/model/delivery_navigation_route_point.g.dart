// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_navigation_route_point.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DeliveryNavigationRoutePoint extends DeliveryNavigationRoutePoint {
  @override
  final num latitude;
  @override
  final num longitude;
  @override
  final String label;

  factory _$DeliveryNavigationRoutePoint(
          [void Function(DeliveryNavigationRoutePointBuilder)? updates]) =>
      (DeliveryNavigationRoutePointBuilder()..update(updates))._build();

  _$DeliveryNavigationRoutePoint._(
      {required this.latitude, required this.longitude, required this.label})
      : super._();
  @override
  DeliveryNavigationRoutePoint rebuild(
          void Function(DeliveryNavigationRoutePointBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DeliveryNavigationRoutePointBuilder toBuilder() =>
      DeliveryNavigationRoutePointBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DeliveryNavigationRoutePoint &&
        latitude == other.latitude &&
        longitude == other.longitude &&
        label == other.label;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, latitude.hashCode);
    _$hash = $jc(_$hash, longitude.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DeliveryNavigationRoutePoint')
          ..add('latitude', latitude)
          ..add('longitude', longitude)
          ..add('label', label))
        .toString();
  }
}

class DeliveryNavigationRoutePointBuilder
    implements
        Builder<DeliveryNavigationRoutePoint,
            DeliveryNavigationRoutePointBuilder> {
  _$DeliveryNavigationRoutePoint? _$v;

  num? _latitude;
  num? get latitude => _$this._latitude;
  set latitude(num? latitude) => _$this._latitude = latitude;

  num? _longitude;
  num? get longitude => _$this._longitude;
  set longitude(num? longitude) => _$this._longitude = longitude;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  DeliveryNavigationRoutePointBuilder() {
    DeliveryNavigationRoutePoint._defaults(this);
  }

  DeliveryNavigationRoutePointBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _latitude = $v.latitude;
      _longitude = $v.longitude;
      _label = $v.label;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DeliveryNavigationRoutePoint other) {
    _$v = other as _$DeliveryNavigationRoutePoint;
  }

  @override
  void update(void Function(DeliveryNavigationRoutePointBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DeliveryNavigationRoutePoint build() => _build();

  _$DeliveryNavigationRoutePoint _build() {
    final _$result = _$v ??
        _$DeliveryNavigationRoutePoint._(
          latitude: BuiltValueNullFieldError.checkNotNull(
              latitude, r'DeliveryNavigationRoutePoint', 'latitude'),
          longitude: BuiltValueNullFieldError.checkNotNull(
              longitude, r'DeliveryNavigationRoutePoint', 'longitude'),
          label: BuiltValueNullFieldError.checkNotNull(
              label, r'DeliveryNavigationRoutePoint', 'label'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
