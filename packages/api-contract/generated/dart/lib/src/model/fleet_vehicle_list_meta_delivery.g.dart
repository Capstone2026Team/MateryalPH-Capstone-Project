// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fleet_vehicle_list_meta_delivery.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FleetVehicleListMetaDelivery extends FleetVehicleListMetaDelivery {
  @override
  final String? fulfillmentMethod;
  @override
  final bool deliveryEnabled;
  @override
  final int? serviceRadiusKm;

  factory _$FleetVehicleListMetaDelivery(
          [void Function(FleetVehicleListMetaDeliveryBuilder)? updates]) =>
      (FleetVehicleListMetaDeliveryBuilder()..update(updates))._build();

  _$FleetVehicleListMetaDelivery._(
      {this.fulfillmentMethod,
      required this.deliveryEnabled,
      this.serviceRadiusKm})
      : super._();
  @override
  FleetVehicleListMetaDelivery rebuild(
          void Function(FleetVehicleListMetaDeliveryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FleetVehicleListMetaDeliveryBuilder toBuilder() =>
      FleetVehicleListMetaDeliveryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FleetVehicleListMetaDelivery &&
        fulfillmentMethod == other.fulfillmentMethod &&
        deliveryEnabled == other.deliveryEnabled &&
        serviceRadiusKm == other.serviceRadiusKm;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, fulfillmentMethod.hashCode);
    _$hash = $jc(_$hash, deliveryEnabled.hashCode);
    _$hash = $jc(_$hash, serviceRadiusKm.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FleetVehicleListMetaDelivery')
          ..add('fulfillmentMethod', fulfillmentMethod)
          ..add('deliveryEnabled', deliveryEnabled)
          ..add('serviceRadiusKm', serviceRadiusKm))
        .toString();
  }
}

class FleetVehicleListMetaDeliveryBuilder
    implements
        Builder<FleetVehicleListMetaDelivery,
            FleetVehicleListMetaDeliveryBuilder> {
  _$FleetVehicleListMetaDelivery? _$v;

  String? _fulfillmentMethod;
  String? get fulfillmentMethod => _$this._fulfillmentMethod;
  set fulfillmentMethod(String? fulfillmentMethod) =>
      _$this._fulfillmentMethod = fulfillmentMethod;

  bool? _deliveryEnabled;
  bool? get deliveryEnabled => _$this._deliveryEnabled;
  set deliveryEnabled(bool? deliveryEnabled) =>
      _$this._deliveryEnabled = deliveryEnabled;

  int? _serviceRadiusKm;
  int? get serviceRadiusKm => _$this._serviceRadiusKm;
  set serviceRadiusKm(int? serviceRadiusKm) =>
      _$this._serviceRadiusKm = serviceRadiusKm;

  FleetVehicleListMetaDeliveryBuilder() {
    FleetVehicleListMetaDelivery._defaults(this);
  }

  FleetVehicleListMetaDeliveryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _fulfillmentMethod = $v.fulfillmentMethod;
      _deliveryEnabled = $v.deliveryEnabled;
      _serviceRadiusKm = $v.serviceRadiusKm;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FleetVehicleListMetaDelivery other) {
    _$v = other as _$FleetVehicleListMetaDelivery;
  }

  @override
  void update(void Function(FleetVehicleListMetaDeliveryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FleetVehicleListMetaDelivery build() => _build();

  _$FleetVehicleListMetaDelivery _build() {
    final _$result = _$v ??
        _$FleetVehicleListMetaDelivery._(
          fulfillmentMethod: fulfillmentMethod,
          deliveryEnabled: BuiltValueNullFieldError.checkNotNull(
              deliveryEnabled,
              r'FleetVehicleListMetaDelivery',
              'deliveryEnabled'),
          serviceRadiusKm: serviceRadiusKm,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
