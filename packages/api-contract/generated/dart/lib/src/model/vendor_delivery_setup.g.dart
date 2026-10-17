// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_delivery_setup.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const VendorDeliverySetupFulfillmentMethodEnum
    _$vendorDeliverySetupFulfillmentMethodEnum_SELF_PICKUP =
    const VendorDeliverySetupFulfillmentMethodEnum._('SELF_PICKUP');
const VendorDeliverySetupFulfillmentMethodEnum
    _$vendorDeliverySetupFulfillmentMethodEnum_VENDOR_DELIVERY =
    const VendorDeliverySetupFulfillmentMethodEnum._('VENDOR_DELIVERY');
const VendorDeliverySetupFulfillmentMethodEnum
    _$vendorDeliverySetupFulfillmentMethodEnum_BOTH =
    const VendorDeliverySetupFulfillmentMethodEnum._('BOTH');

VendorDeliverySetupFulfillmentMethodEnum
    _$vendorDeliverySetupFulfillmentMethodEnumValueOf(String name) {
  switch (name) {
    case 'SELF_PICKUP':
      return _$vendorDeliverySetupFulfillmentMethodEnum_SELF_PICKUP;
    case 'VENDOR_DELIVERY':
      return _$vendorDeliverySetupFulfillmentMethodEnum_VENDOR_DELIVERY;
    case 'BOTH':
      return _$vendorDeliverySetupFulfillmentMethodEnum_BOTH;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<VendorDeliverySetupFulfillmentMethodEnum>
    _$vendorDeliverySetupFulfillmentMethodEnumValues = BuiltSet<
        VendorDeliverySetupFulfillmentMethodEnum>(const <VendorDeliverySetupFulfillmentMethodEnum>[
  _$vendorDeliverySetupFulfillmentMethodEnum_SELF_PICKUP,
  _$vendorDeliverySetupFulfillmentMethodEnum_VENDOR_DELIVERY,
  _$vendorDeliverySetupFulfillmentMethodEnum_BOTH,
]);

Serializer<VendorDeliverySetupFulfillmentMethodEnum>
    _$vendorDeliverySetupFulfillmentMethodEnumSerializer =
    _$VendorDeliverySetupFulfillmentMethodEnumSerializer();

class _$VendorDeliverySetupFulfillmentMethodEnumSerializer
    implements PrimitiveSerializer<VendorDeliverySetupFulfillmentMethodEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'SELF_PICKUP': 'SELF_PICKUP',
    'VENDOR_DELIVERY': 'VENDOR_DELIVERY',
    'BOTH': 'BOTH',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'SELF_PICKUP': 'SELF_PICKUP',
    'VENDOR_DELIVERY': 'VENDOR_DELIVERY',
    'BOTH': 'BOTH',
  };

  @override
  final Iterable<Type> types = const <Type>[
    VendorDeliverySetupFulfillmentMethodEnum
  ];
  @override
  final String wireName = 'VendorDeliverySetupFulfillmentMethodEnum';

  @override
  Object serialize(Serializers serializers,
          VendorDeliverySetupFulfillmentMethodEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  VendorDeliverySetupFulfillmentMethodEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      VendorDeliverySetupFulfillmentMethodEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$VendorDeliverySetup extends VendorDeliverySetup {
  @override
  final VendorDeliverySetupFulfillmentMethodEnum? fulfillmentMethod;
  @override
  final bool staffReady;
  @override
  final bool vehicleReady;
  @override
  final bool pickupLocationReady;
  @override
  final bool serviceSettingsReady;
  @override
  final bool ready;
  @override
  final bool enabled;
  @override
  final bool available;
  @override
  final int activeDeliveryObligations;

  factory _$VendorDeliverySetup(
          [void Function(VendorDeliverySetupBuilder)? updates]) =>
      (VendorDeliverySetupBuilder()..update(updates))._build();

  _$VendorDeliverySetup._(
      {this.fulfillmentMethod,
      required this.staffReady,
      required this.vehicleReady,
      required this.pickupLocationReady,
      required this.serviceSettingsReady,
      required this.ready,
      required this.enabled,
      required this.available,
      required this.activeDeliveryObligations})
      : super._();
  @override
  VendorDeliverySetup rebuild(
          void Function(VendorDeliverySetupBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorDeliverySetupBuilder toBuilder() =>
      VendorDeliverySetupBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorDeliverySetup &&
        fulfillmentMethod == other.fulfillmentMethod &&
        staffReady == other.staffReady &&
        vehicleReady == other.vehicleReady &&
        pickupLocationReady == other.pickupLocationReady &&
        serviceSettingsReady == other.serviceSettingsReady &&
        ready == other.ready &&
        enabled == other.enabled &&
        available == other.available &&
        activeDeliveryObligations == other.activeDeliveryObligations;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, fulfillmentMethod.hashCode);
    _$hash = $jc(_$hash, staffReady.hashCode);
    _$hash = $jc(_$hash, vehicleReady.hashCode);
    _$hash = $jc(_$hash, pickupLocationReady.hashCode);
    _$hash = $jc(_$hash, serviceSettingsReady.hashCode);
    _$hash = $jc(_$hash, ready.hashCode);
    _$hash = $jc(_$hash, enabled.hashCode);
    _$hash = $jc(_$hash, available.hashCode);
    _$hash = $jc(_$hash, activeDeliveryObligations.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorDeliverySetup')
          ..add('fulfillmentMethod', fulfillmentMethod)
          ..add('staffReady', staffReady)
          ..add('vehicleReady', vehicleReady)
          ..add('pickupLocationReady', pickupLocationReady)
          ..add('serviceSettingsReady', serviceSettingsReady)
          ..add('ready', ready)
          ..add('enabled', enabled)
          ..add('available', available)
          ..add('activeDeliveryObligations', activeDeliveryObligations))
        .toString();
  }
}

class VendorDeliverySetupBuilder
    implements Builder<VendorDeliverySetup, VendorDeliverySetupBuilder> {
  _$VendorDeliverySetup? _$v;

  VendorDeliverySetupFulfillmentMethodEnum? _fulfillmentMethod;
  VendorDeliverySetupFulfillmentMethodEnum? get fulfillmentMethod =>
      _$this._fulfillmentMethod;
  set fulfillmentMethod(
          VendorDeliverySetupFulfillmentMethodEnum? fulfillmentMethod) =>
      _$this._fulfillmentMethod = fulfillmentMethod;

  bool? _staffReady;
  bool? get staffReady => _$this._staffReady;
  set staffReady(bool? staffReady) => _$this._staffReady = staffReady;

  bool? _vehicleReady;
  bool? get vehicleReady => _$this._vehicleReady;
  set vehicleReady(bool? vehicleReady) => _$this._vehicleReady = vehicleReady;

  bool? _pickupLocationReady;
  bool? get pickupLocationReady => _$this._pickupLocationReady;
  set pickupLocationReady(bool? pickupLocationReady) =>
      _$this._pickupLocationReady = pickupLocationReady;

  bool? _serviceSettingsReady;
  bool? get serviceSettingsReady => _$this._serviceSettingsReady;
  set serviceSettingsReady(bool? serviceSettingsReady) =>
      _$this._serviceSettingsReady = serviceSettingsReady;

  bool? _ready;
  bool? get ready => _$this._ready;
  set ready(bool? ready) => _$this._ready = ready;

  bool? _enabled;
  bool? get enabled => _$this._enabled;
  set enabled(bool? enabled) => _$this._enabled = enabled;

  bool? _available;
  bool? get available => _$this._available;
  set available(bool? available) => _$this._available = available;

  int? _activeDeliveryObligations;
  int? get activeDeliveryObligations => _$this._activeDeliveryObligations;
  set activeDeliveryObligations(int? activeDeliveryObligations) =>
      _$this._activeDeliveryObligations = activeDeliveryObligations;

  VendorDeliverySetupBuilder() {
    VendorDeliverySetup._defaults(this);
  }

  VendorDeliverySetupBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _fulfillmentMethod = $v.fulfillmentMethod;
      _staffReady = $v.staffReady;
      _vehicleReady = $v.vehicleReady;
      _pickupLocationReady = $v.pickupLocationReady;
      _serviceSettingsReady = $v.serviceSettingsReady;
      _ready = $v.ready;
      _enabled = $v.enabled;
      _available = $v.available;
      _activeDeliveryObligations = $v.activeDeliveryObligations;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorDeliverySetup other) {
    _$v = other as _$VendorDeliverySetup;
  }

  @override
  void update(void Function(VendorDeliverySetupBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorDeliverySetup build() => _build();

  _$VendorDeliverySetup _build() {
    final _$result = _$v ??
        _$VendorDeliverySetup._(
          fulfillmentMethod: fulfillmentMethod,
          staffReady: BuiltValueNullFieldError.checkNotNull(
              staffReady, r'VendorDeliverySetup', 'staffReady'),
          vehicleReady: BuiltValueNullFieldError.checkNotNull(
              vehicleReady, r'VendorDeliverySetup', 'vehicleReady'),
          pickupLocationReady: BuiltValueNullFieldError.checkNotNull(
              pickupLocationReady,
              r'VendorDeliverySetup',
              'pickupLocationReady'),
          serviceSettingsReady: BuiltValueNullFieldError.checkNotNull(
              serviceSettingsReady,
              r'VendorDeliverySetup',
              'serviceSettingsReady'),
          ready: BuiltValueNullFieldError.checkNotNull(
              ready, r'VendorDeliverySetup', 'ready'),
          enabled: BuiltValueNullFieldError.checkNotNull(
              enabled, r'VendorDeliverySetup', 'enabled'),
          available: BuiltValueNullFieldError.checkNotNull(
              available, r'VendorDeliverySetup', 'available'),
          activeDeliveryObligations: BuiltValueNullFieldError.checkNotNull(
              activeDeliveryObligations,
              r'VendorDeliverySetup',
              'activeDeliveryObligations'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
