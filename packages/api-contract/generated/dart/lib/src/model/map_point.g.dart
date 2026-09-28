// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_point.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MapPoint extends MapPoint {
  @override
  final double latitude;
  @override
  final double longitude;

  factory _$MapPoint([void Function(MapPointBuilder)? updates]) =>
      (MapPointBuilder()..update(updates))._build();

  _$MapPoint._({required this.latitude, required this.longitude}) : super._();
  @override
  MapPoint rebuild(void Function(MapPointBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MapPointBuilder toBuilder() => MapPointBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MapPoint &&
        latitude == other.latitude &&
        longitude == other.longitude;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, latitude.hashCode);
    _$hash = $jc(_$hash, longitude.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MapPoint')
          ..add('latitude', latitude)
          ..add('longitude', longitude))
        .toString();
  }
}

class MapPointBuilder implements Builder<MapPoint, MapPointBuilder> {
  _$MapPoint? _$v;

  double? _latitude;
  double? get latitude => _$this._latitude;
  set latitude(double? latitude) => _$this._latitude = latitude;

  double? _longitude;
  double? get longitude => _$this._longitude;
  set longitude(double? longitude) => _$this._longitude = longitude;

  MapPointBuilder() {
    MapPoint._defaults(this);
  }

  MapPointBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _latitude = $v.latitude;
      _longitude = $v.longitude;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MapPoint other) {
    _$v = other as _$MapPoint;
  }

  @override
  void update(void Function(MapPointBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MapPoint build() => _build();

  _$MapPoint _build() {
    final _$result = _$v ??
        _$MapPoint._(
          latitude: BuiltValueNullFieldError.checkNotNull(
              latitude, r'MapPoint', 'latitude'),
          longitude: BuiltValueNullFieldError.checkNotNull(
              longitude, r'MapPoint', 'longitude'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
