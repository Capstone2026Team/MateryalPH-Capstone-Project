// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geo_trend_point.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GeoTrendPoint extends GeoTrendPoint {
  @override
  final Date bucket;
  @override
  final int? grossGmvCentavos;
  @override
  final int? netGmvCentavos;
  @override
  final int? orderVolume;
  @override
  final bool suppressed;
  @override
  final String? reason;

  factory _$GeoTrendPoint([void Function(GeoTrendPointBuilder)? updates]) =>
      (GeoTrendPointBuilder()..update(updates))._build();

  _$GeoTrendPoint._(
      {required this.bucket,
      this.grossGmvCentavos,
      this.netGmvCentavos,
      this.orderVolume,
      required this.suppressed,
      this.reason})
      : super._();
  @override
  GeoTrendPoint rebuild(void Function(GeoTrendPointBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GeoTrendPointBuilder toBuilder() => GeoTrendPointBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GeoTrendPoint &&
        bucket == other.bucket &&
        grossGmvCentavos == other.grossGmvCentavos &&
        netGmvCentavos == other.netGmvCentavos &&
        orderVolume == other.orderVolume &&
        suppressed == other.suppressed &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, bucket.hashCode);
    _$hash = $jc(_$hash, grossGmvCentavos.hashCode);
    _$hash = $jc(_$hash, netGmvCentavos.hashCode);
    _$hash = $jc(_$hash, orderVolume.hashCode);
    _$hash = $jc(_$hash, suppressed.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GeoTrendPoint')
          ..add('bucket', bucket)
          ..add('grossGmvCentavos', grossGmvCentavos)
          ..add('netGmvCentavos', netGmvCentavos)
          ..add('orderVolume', orderVolume)
          ..add('suppressed', suppressed)
          ..add('reason', reason))
        .toString();
  }
}

class GeoTrendPointBuilder
    implements Builder<GeoTrendPoint, GeoTrendPointBuilder> {
  _$GeoTrendPoint? _$v;

  Date? _bucket;
  Date? get bucket => _$this._bucket;
  set bucket(Date? bucket) => _$this._bucket = bucket;

  int? _grossGmvCentavos;
  int? get grossGmvCentavos => _$this._grossGmvCentavos;
  set grossGmvCentavos(int? grossGmvCentavos) =>
      _$this._grossGmvCentavos = grossGmvCentavos;

  int? _netGmvCentavos;
  int? get netGmvCentavos => _$this._netGmvCentavos;
  set netGmvCentavos(int? netGmvCentavos) =>
      _$this._netGmvCentavos = netGmvCentavos;

  int? _orderVolume;
  int? get orderVolume => _$this._orderVolume;
  set orderVolume(int? orderVolume) => _$this._orderVolume = orderVolume;

  bool? _suppressed;
  bool? get suppressed => _$this._suppressed;
  set suppressed(bool? suppressed) => _$this._suppressed = suppressed;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  GeoTrendPointBuilder() {
    GeoTrendPoint._defaults(this);
  }

  GeoTrendPointBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _bucket = $v.bucket;
      _grossGmvCentavos = $v.grossGmvCentavos;
      _netGmvCentavos = $v.netGmvCentavos;
      _orderVolume = $v.orderVolume;
      _suppressed = $v.suppressed;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GeoTrendPoint other) {
    _$v = other as _$GeoTrendPoint;
  }

  @override
  void update(void Function(GeoTrendPointBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GeoTrendPoint build() => _build();

  _$GeoTrendPoint _build() {
    final _$result = _$v ??
        _$GeoTrendPoint._(
          bucket: BuiltValueNullFieldError.checkNotNull(
              bucket, r'GeoTrendPoint', 'bucket'),
          grossGmvCentavos: grossGmvCentavos,
          netGmvCentavos: netGmvCentavos,
          orderVolume: orderVolume,
          suppressed: BuiltValueNullFieldError.checkNotNull(
              suppressed, r'GeoTrendPoint', 'suppressed'),
          reason: reason,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
