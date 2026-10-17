// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_navigation_route.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DeliveryNavigationRoute extends DeliveryNavigationRoute {
  @override
  final DeliveryNavigationRoutePoint origin;
  @override
  final DeliveryNavigationRoutePoint destination;
  @override
  final int distanceMeters;
  @override
  final int durationSeconds;
  @override
  final String encodedPolyline;
  @override
  final String durationBasis;
  @override
  final DateTime computedAt;

  factory _$DeliveryNavigationRoute(
          [void Function(DeliveryNavigationRouteBuilder)? updates]) =>
      (DeliveryNavigationRouteBuilder()..update(updates))._build();

  _$DeliveryNavigationRoute._(
      {required this.origin,
      required this.destination,
      required this.distanceMeters,
      required this.durationSeconds,
      required this.encodedPolyline,
      required this.durationBasis,
      required this.computedAt})
      : super._();
  @override
  DeliveryNavigationRoute rebuild(
          void Function(DeliveryNavigationRouteBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DeliveryNavigationRouteBuilder toBuilder() =>
      DeliveryNavigationRouteBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DeliveryNavigationRoute &&
        origin == other.origin &&
        destination == other.destination &&
        distanceMeters == other.distanceMeters &&
        durationSeconds == other.durationSeconds &&
        encodedPolyline == other.encodedPolyline &&
        durationBasis == other.durationBasis &&
        computedAt == other.computedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, origin.hashCode);
    _$hash = $jc(_$hash, destination.hashCode);
    _$hash = $jc(_$hash, distanceMeters.hashCode);
    _$hash = $jc(_$hash, durationSeconds.hashCode);
    _$hash = $jc(_$hash, encodedPolyline.hashCode);
    _$hash = $jc(_$hash, durationBasis.hashCode);
    _$hash = $jc(_$hash, computedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DeliveryNavigationRoute')
          ..add('origin', origin)
          ..add('destination', destination)
          ..add('distanceMeters', distanceMeters)
          ..add('durationSeconds', durationSeconds)
          ..add('encodedPolyline', encodedPolyline)
          ..add('durationBasis', durationBasis)
          ..add('computedAt', computedAt))
        .toString();
  }
}

class DeliveryNavigationRouteBuilder
    implements
        Builder<DeliveryNavigationRoute, DeliveryNavigationRouteBuilder> {
  _$DeliveryNavigationRoute? _$v;

  DeliveryNavigationRoutePointBuilder? _origin;
  DeliveryNavigationRoutePointBuilder get origin =>
      _$this._origin ??= DeliveryNavigationRoutePointBuilder();
  set origin(DeliveryNavigationRoutePointBuilder? origin) =>
      _$this._origin = origin;

  DeliveryNavigationRoutePointBuilder? _destination;
  DeliveryNavigationRoutePointBuilder get destination =>
      _$this._destination ??= DeliveryNavigationRoutePointBuilder();
  set destination(DeliveryNavigationRoutePointBuilder? destination) =>
      _$this._destination = destination;

  int? _distanceMeters;
  int? get distanceMeters => _$this._distanceMeters;
  set distanceMeters(int? distanceMeters) =>
      _$this._distanceMeters = distanceMeters;

  int? _durationSeconds;
  int? get durationSeconds => _$this._durationSeconds;
  set durationSeconds(int? durationSeconds) =>
      _$this._durationSeconds = durationSeconds;

  String? _encodedPolyline;
  String? get encodedPolyline => _$this._encodedPolyline;
  set encodedPolyline(String? encodedPolyline) =>
      _$this._encodedPolyline = encodedPolyline;

  String? _durationBasis;
  String? get durationBasis => _$this._durationBasis;
  set durationBasis(String? durationBasis) =>
      _$this._durationBasis = durationBasis;

  DateTime? _computedAt;
  DateTime? get computedAt => _$this._computedAt;
  set computedAt(DateTime? computedAt) => _$this._computedAt = computedAt;

  DeliveryNavigationRouteBuilder() {
    DeliveryNavigationRoute._defaults(this);
  }

  DeliveryNavigationRouteBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _origin = $v.origin.toBuilder();
      _destination = $v.destination.toBuilder();
      _distanceMeters = $v.distanceMeters;
      _durationSeconds = $v.durationSeconds;
      _encodedPolyline = $v.encodedPolyline;
      _durationBasis = $v.durationBasis;
      _computedAt = $v.computedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DeliveryNavigationRoute other) {
    _$v = other as _$DeliveryNavigationRoute;
  }

  @override
  void update(void Function(DeliveryNavigationRouteBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DeliveryNavigationRoute build() => _build();

  _$DeliveryNavigationRoute _build() {
    _$DeliveryNavigationRoute _$result;
    try {
      _$result = _$v ??
          _$DeliveryNavigationRoute._(
            origin: origin.build(),
            destination: destination.build(),
            distanceMeters: BuiltValueNullFieldError.checkNotNull(
                distanceMeters, r'DeliveryNavigationRoute', 'distanceMeters'),
            durationSeconds: BuiltValueNullFieldError.checkNotNull(
                durationSeconds, r'DeliveryNavigationRoute', 'durationSeconds'),
            encodedPolyline: BuiltValueNullFieldError.checkNotNull(
                encodedPolyline, r'DeliveryNavigationRoute', 'encodedPolyline'),
            durationBasis: BuiltValueNullFieldError.checkNotNull(
                durationBasis, r'DeliveryNavigationRoute', 'durationBasis'),
            computedAt: BuiltValueNullFieldError.checkNotNull(
                computedAt, r'DeliveryNavigationRoute', 'computedAt'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'origin';
        origin.build();
        _$failedField = 'destination';
        destination.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'DeliveryNavigationRoute', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
