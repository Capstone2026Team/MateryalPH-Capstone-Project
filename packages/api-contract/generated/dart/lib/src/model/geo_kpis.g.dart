// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geo_kpis.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GeoKpis extends GeoKpis {
  @override
  final GeoCell vendorCount;
  @override
  final GeoCell registeredBuyers;
  @override
  final GeoCell grossGmvCentavos;
  @override
  final GeoCell netGmvCentavos;
  @override
  final GeoCell orderVolume;
  @override
  final GeoRate fulfillmentRate;
  @override
  final GeoRate cancellationRate;
  @override
  final GeoRate disputeRate;
  @override
  final GeoResponseTime responseTime;
  @override
  final GeoKpisActiveUsers activeUsers;

  factory _$GeoKpis([void Function(GeoKpisBuilder)? updates]) =>
      (GeoKpisBuilder()..update(updates))._build();

  _$GeoKpis._(
      {required this.vendorCount,
      required this.registeredBuyers,
      required this.grossGmvCentavos,
      required this.netGmvCentavos,
      required this.orderVolume,
      required this.fulfillmentRate,
      required this.cancellationRate,
      required this.disputeRate,
      required this.responseTime,
      required this.activeUsers})
      : super._();
  @override
  GeoKpis rebuild(void Function(GeoKpisBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GeoKpisBuilder toBuilder() => GeoKpisBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GeoKpis &&
        vendorCount == other.vendorCount &&
        registeredBuyers == other.registeredBuyers &&
        grossGmvCentavos == other.grossGmvCentavos &&
        netGmvCentavos == other.netGmvCentavos &&
        orderVolume == other.orderVolume &&
        fulfillmentRate == other.fulfillmentRate &&
        cancellationRate == other.cancellationRate &&
        disputeRate == other.disputeRate &&
        responseTime == other.responseTime &&
        activeUsers == other.activeUsers;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, vendorCount.hashCode);
    _$hash = $jc(_$hash, registeredBuyers.hashCode);
    _$hash = $jc(_$hash, grossGmvCentavos.hashCode);
    _$hash = $jc(_$hash, netGmvCentavos.hashCode);
    _$hash = $jc(_$hash, orderVolume.hashCode);
    _$hash = $jc(_$hash, fulfillmentRate.hashCode);
    _$hash = $jc(_$hash, cancellationRate.hashCode);
    _$hash = $jc(_$hash, disputeRate.hashCode);
    _$hash = $jc(_$hash, responseTime.hashCode);
    _$hash = $jc(_$hash, activeUsers.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GeoKpis')
          ..add('vendorCount', vendorCount)
          ..add('registeredBuyers', registeredBuyers)
          ..add('grossGmvCentavos', grossGmvCentavos)
          ..add('netGmvCentavos', netGmvCentavos)
          ..add('orderVolume', orderVolume)
          ..add('fulfillmentRate', fulfillmentRate)
          ..add('cancellationRate', cancellationRate)
          ..add('disputeRate', disputeRate)
          ..add('responseTime', responseTime)
          ..add('activeUsers', activeUsers))
        .toString();
  }
}

class GeoKpisBuilder implements Builder<GeoKpis, GeoKpisBuilder> {
  _$GeoKpis? _$v;

  GeoCellBuilder? _vendorCount;
  GeoCellBuilder get vendorCount => _$this._vendorCount ??= GeoCellBuilder();
  set vendorCount(GeoCellBuilder? vendorCount) =>
      _$this._vendorCount = vendorCount;

  GeoCellBuilder? _registeredBuyers;
  GeoCellBuilder get registeredBuyers =>
      _$this._registeredBuyers ??= GeoCellBuilder();
  set registeredBuyers(GeoCellBuilder? registeredBuyers) =>
      _$this._registeredBuyers = registeredBuyers;

  GeoCellBuilder? _grossGmvCentavos;
  GeoCellBuilder get grossGmvCentavos =>
      _$this._grossGmvCentavos ??= GeoCellBuilder();
  set grossGmvCentavos(GeoCellBuilder? grossGmvCentavos) =>
      _$this._grossGmvCentavos = grossGmvCentavos;

  GeoCellBuilder? _netGmvCentavos;
  GeoCellBuilder get netGmvCentavos =>
      _$this._netGmvCentavos ??= GeoCellBuilder();
  set netGmvCentavos(GeoCellBuilder? netGmvCentavos) =>
      _$this._netGmvCentavos = netGmvCentavos;

  GeoCellBuilder? _orderVolume;
  GeoCellBuilder get orderVolume => _$this._orderVolume ??= GeoCellBuilder();
  set orderVolume(GeoCellBuilder? orderVolume) =>
      _$this._orderVolume = orderVolume;

  GeoRateBuilder? _fulfillmentRate;
  GeoRateBuilder get fulfillmentRate =>
      _$this._fulfillmentRate ??= GeoRateBuilder();
  set fulfillmentRate(GeoRateBuilder? fulfillmentRate) =>
      _$this._fulfillmentRate = fulfillmentRate;

  GeoRateBuilder? _cancellationRate;
  GeoRateBuilder get cancellationRate =>
      _$this._cancellationRate ??= GeoRateBuilder();
  set cancellationRate(GeoRateBuilder? cancellationRate) =>
      _$this._cancellationRate = cancellationRate;

  GeoRateBuilder? _disputeRate;
  GeoRateBuilder get disputeRate => _$this._disputeRate ??= GeoRateBuilder();
  set disputeRate(GeoRateBuilder? disputeRate) =>
      _$this._disputeRate = disputeRate;

  GeoResponseTimeBuilder? _responseTime;
  GeoResponseTimeBuilder get responseTime =>
      _$this._responseTime ??= GeoResponseTimeBuilder();
  set responseTime(GeoResponseTimeBuilder? responseTime) =>
      _$this._responseTime = responseTime;

  GeoKpisActiveUsersBuilder? _activeUsers;
  GeoKpisActiveUsersBuilder get activeUsers =>
      _$this._activeUsers ??= GeoKpisActiveUsersBuilder();
  set activeUsers(GeoKpisActiveUsersBuilder? activeUsers) =>
      _$this._activeUsers = activeUsers;

  GeoKpisBuilder() {
    GeoKpis._defaults(this);
  }

  GeoKpisBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _vendorCount = $v.vendorCount.toBuilder();
      _registeredBuyers = $v.registeredBuyers.toBuilder();
      _grossGmvCentavos = $v.grossGmvCentavos.toBuilder();
      _netGmvCentavos = $v.netGmvCentavos.toBuilder();
      _orderVolume = $v.orderVolume.toBuilder();
      _fulfillmentRate = $v.fulfillmentRate.toBuilder();
      _cancellationRate = $v.cancellationRate.toBuilder();
      _disputeRate = $v.disputeRate.toBuilder();
      _responseTime = $v.responseTime.toBuilder();
      _activeUsers = $v.activeUsers.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GeoKpis other) {
    _$v = other as _$GeoKpis;
  }

  @override
  void update(void Function(GeoKpisBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GeoKpis build() => _build();

  _$GeoKpis _build() {
    _$GeoKpis _$result;
    try {
      _$result = _$v ??
          _$GeoKpis._(
            vendorCount: vendorCount.build(),
            registeredBuyers: registeredBuyers.build(),
            grossGmvCentavos: grossGmvCentavos.build(),
            netGmvCentavos: netGmvCentavos.build(),
            orderVolume: orderVolume.build(),
            fulfillmentRate: fulfillmentRate.build(),
            cancellationRate: cancellationRate.build(),
            disputeRate: disputeRate.build(),
            responseTime: responseTime.build(),
            activeUsers: activeUsers.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'vendorCount';
        vendorCount.build();
        _$failedField = 'registeredBuyers';
        registeredBuyers.build();
        _$failedField = 'grossGmvCentavos';
        grossGmvCentavos.build();
        _$failedField = 'netGmvCentavos';
        netGmvCentavos.build();
        _$failedField = 'orderVolume';
        orderVolume.build();
        _$failedField = 'fulfillmentRate';
        fulfillmentRate.build();
        _$failedField = 'cancellationRate';
        cancellationRate.build();
        _$failedField = 'disputeRate';
        disputeRate.build();
        _$failedField = 'responseTime';
        responseTime.build();
        _$failedField = 'activeUsers';
        activeUsers.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'GeoKpis', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
