// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_delivery_vehicle.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const OrderDeliveryVehicleMobilizationBasisEnum
    _$orderDeliveryVehicleMobilizationBasisEnum_PER_TRUCK =
    const OrderDeliveryVehicleMobilizationBasisEnum._('PER_TRUCK');
const OrderDeliveryVehicleMobilizationBasisEnum
    _$orderDeliveryVehicleMobilizationBasisEnum_PER_TRIP =
    const OrderDeliveryVehicleMobilizationBasisEnum._('PER_TRIP');

OrderDeliveryVehicleMobilizationBasisEnum
    _$orderDeliveryVehicleMobilizationBasisEnumValueOf(String name) {
  switch (name) {
    case 'PER_TRUCK':
      return _$orderDeliveryVehicleMobilizationBasisEnum_PER_TRUCK;
    case 'PER_TRIP':
      return _$orderDeliveryVehicleMobilizationBasisEnum_PER_TRIP;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<OrderDeliveryVehicleMobilizationBasisEnum>
    _$orderDeliveryVehicleMobilizationBasisEnumValues = BuiltSet<
        OrderDeliveryVehicleMobilizationBasisEnum>(const <OrderDeliveryVehicleMobilizationBasisEnum>[
  _$orderDeliveryVehicleMobilizationBasisEnum_PER_TRUCK,
  _$orderDeliveryVehicleMobilizationBasisEnum_PER_TRIP,
]);

Serializer<OrderDeliveryVehicleMobilizationBasisEnum>
    _$orderDeliveryVehicleMobilizationBasisEnumSerializer =
    _$OrderDeliveryVehicleMobilizationBasisEnumSerializer();

class _$OrderDeliveryVehicleMobilizationBasisEnumSerializer
    implements PrimitiveSerializer<OrderDeliveryVehicleMobilizationBasisEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PER_TRUCK': 'PER_TRUCK',
    'PER_TRIP': 'PER_TRIP',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PER_TRUCK': 'PER_TRUCK',
    'PER_TRIP': 'PER_TRIP',
  };

  @override
  final Iterable<Type> types = const <Type>[
    OrderDeliveryVehicleMobilizationBasisEnum
  ];
  @override
  final String wireName = 'OrderDeliveryVehicleMobilizationBasisEnum';

  @override
  Object serialize(Serializers serializers,
          OrderDeliveryVehicleMobilizationBasisEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  OrderDeliveryVehicleMobilizationBasisEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      OrderDeliveryVehicleMobilizationBasisEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$OrderDeliveryVehicle extends OrderDeliveryVehicle {
  @override
  final String? name;
  @override
  final String? vehicleCategory;
  @override
  final String? vehicleType;
  @override
  final String? customTypeName;
  @override
  final String? brand;
  @override
  final String? capacityKg;
  @override
  final String? heavyClassification;
  @override
  final int? configurationVersion;
  @override
  final int? rateVersion;
  @override
  final int numberOfVehicles;
  @override
  final int totalVehicleTrips;
  @override
  final int perTripCentavos;
  @override
  final int tripTotalCentavos;
  @override
  final OrderDeliveryVehicleMobilizationBasisEnum? mobilizationBasis;
  @override
  final int? mobilizationFeeCentavos;
  @override
  final int? mobilizationTotalCentavos;

  factory _$OrderDeliveryVehicle(
          [void Function(OrderDeliveryVehicleBuilder)? updates]) =>
      (OrderDeliveryVehicleBuilder()..update(updates))._build();

  _$OrderDeliveryVehicle._(
      {this.name,
      this.vehicleCategory,
      this.vehicleType,
      this.customTypeName,
      this.brand,
      this.capacityKg,
      this.heavyClassification,
      this.configurationVersion,
      this.rateVersion,
      required this.numberOfVehicles,
      required this.totalVehicleTrips,
      required this.perTripCentavos,
      required this.tripTotalCentavos,
      this.mobilizationBasis,
      this.mobilizationFeeCentavos,
      this.mobilizationTotalCentavos})
      : super._();
  @override
  OrderDeliveryVehicle rebuild(
          void Function(OrderDeliveryVehicleBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OrderDeliveryVehicleBuilder toBuilder() =>
      OrderDeliveryVehicleBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OrderDeliveryVehicle &&
        name == other.name &&
        vehicleCategory == other.vehicleCategory &&
        vehicleType == other.vehicleType &&
        customTypeName == other.customTypeName &&
        brand == other.brand &&
        capacityKg == other.capacityKg &&
        heavyClassification == other.heavyClassification &&
        configurationVersion == other.configurationVersion &&
        rateVersion == other.rateVersion &&
        numberOfVehicles == other.numberOfVehicles &&
        totalVehicleTrips == other.totalVehicleTrips &&
        perTripCentavos == other.perTripCentavos &&
        tripTotalCentavos == other.tripTotalCentavos &&
        mobilizationBasis == other.mobilizationBasis &&
        mobilizationFeeCentavos == other.mobilizationFeeCentavos &&
        mobilizationTotalCentavos == other.mobilizationTotalCentavos;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, vehicleCategory.hashCode);
    _$hash = $jc(_$hash, vehicleType.hashCode);
    _$hash = $jc(_$hash, customTypeName.hashCode);
    _$hash = $jc(_$hash, brand.hashCode);
    _$hash = $jc(_$hash, capacityKg.hashCode);
    _$hash = $jc(_$hash, heavyClassification.hashCode);
    _$hash = $jc(_$hash, configurationVersion.hashCode);
    _$hash = $jc(_$hash, rateVersion.hashCode);
    _$hash = $jc(_$hash, numberOfVehicles.hashCode);
    _$hash = $jc(_$hash, totalVehicleTrips.hashCode);
    _$hash = $jc(_$hash, perTripCentavos.hashCode);
    _$hash = $jc(_$hash, tripTotalCentavos.hashCode);
    _$hash = $jc(_$hash, mobilizationBasis.hashCode);
    _$hash = $jc(_$hash, mobilizationFeeCentavos.hashCode);
    _$hash = $jc(_$hash, mobilizationTotalCentavos.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OrderDeliveryVehicle')
          ..add('name', name)
          ..add('vehicleCategory', vehicleCategory)
          ..add('vehicleType', vehicleType)
          ..add('customTypeName', customTypeName)
          ..add('brand', brand)
          ..add('capacityKg', capacityKg)
          ..add('heavyClassification', heavyClassification)
          ..add('configurationVersion', configurationVersion)
          ..add('rateVersion', rateVersion)
          ..add('numberOfVehicles', numberOfVehicles)
          ..add('totalVehicleTrips', totalVehicleTrips)
          ..add('perTripCentavos', perTripCentavos)
          ..add('tripTotalCentavos', tripTotalCentavos)
          ..add('mobilizationBasis', mobilizationBasis)
          ..add('mobilizationFeeCentavos', mobilizationFeeCentavos)
          ..add('mobilizationTotalCentavos', mobilizationTotalCentavos))
        .toString();
  }
}

class OrderDeliveryVehicleBuilder
    implements Builder<OrderDeliveryVehicle, OrderDeliveryVehicleBuilder> {
  _$OrderDeliveryVehicle? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _vehicleCategory;
  String? get vehicleCategory => _$this._vehicleCategory;
  set vehicleCategory(String? vehicleCategory) =>
      _$this._vehicleCategory = vehicleCategory;

  String? _vehicleType;
  String? get vehicleType => _$this._vehicleType;
  set vehicleType(String? vehicleType) => _$this._vehicleType = vehicleType;

  String? _customTypeName;
  String? get customTypeName => _$this._customTypeName;
  set customTypeName(String? customTypeName) =>
      _$this._customTypeName = customTypeName;

  String? _brand;
  String? get brand => _$this._brand;
  set brand(String? brand) => _$this._brand = brand;

  String? _capacityKg;
  String? get capacityKg => _$this._capacityKg;
  set capacityKg(String? capacityKg) => _$this._capacityKg = capacityKg;

  String? _heavyClassification;
  String? get heavyClassification => _$this._heavyClassification;
  set heavyClassification(String? heavyClassification) =>
      _$this._heavyClassification = heavyClassification;

  int? _configurationVersion;
  int? get configurationVersion => _$this._configurationVersion;
  set configurationVersion(int? configurationVersion) =>
      _$this._configurationVersion = configurationVersion;

  int? _rateVersion;
  int? get rateVersion => _$this._rateVersion;
  set rateVersion(int? rateVersion) => _$this._rateVersion = rateVersion;

  int? _numberOfVehicles;
  int? get numberOfVehicles => _$this._numberOfVehicles;
  set numberOfVehicles(int? numberOfVehicles) =>
      _$this._numberOfVehicles = numberOfVehicles;

  int? _totalVehicleTrips;
  int? get totalVehicleTrips => _$this._totalVehicleTrips;
  set totalVehicleTrips(int? totalVehicleTrips) =>
      _$this._totalVehicleTrips = totalVehicleTrips;

  int? _perTripCentavos;
  int? get perTripCentavos => _$this._perTripCentavos;
  set perTripCentavos(int? perTripCentavos) =>
      _$this._perTripCentavos = perTripCentavos;

  int? _tripTotalCentavos;
  int? get tripTotalCentavos => _$this._tripTotalCentavos;
  set tripTotalCentavos(int? tripTotalCentavos) =>
      _$this._tripTotalCentavos = tripTotalCentavos;

  OrderDeliveryVehicleMobilizationBasisEnum? _mobilizationBasis;
  OrderDeliveryVehicleMobilizationBasisEnum? get mobilizationBasis =>
      _$this._mobilizationBasis;
  set mobilizationBasis(
          OrderDeliveryVehicleMobilizationBasisEnum? mobilizationBasis) =>
      _$this._mobilizationBasis = mobilizationBasis;

  int? _mobilizationFeeCentavos;
  int? get mobilizationFeeCentavos => _$this._mobilizationFeeCentavos;
  set mobilizationFeeCentavos(int? mobilizationFeeCentavos) =>
      _$this._mobilizationFeeCentavos = mobilizationFeeCentavos;

  int? _mobilizationTotalCentavos;
  int? get mobilizationTotalCentavos => _$this._mobilizationTotalCentavos;
  set mobilizationTotalCentavos(int? mobilizationTotalCentavos) =>
      _$this._mobilizationTotalCentavos = mobilizationTotalCentavos;

  OrderDeliveryVehicleBuilder() {
    OrderDeliveryVehicle._defaults(this);
  }

  OrderDeliveryVehicleBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _vehicleCategory = $v.vehicleCategory;
      _vehicleType = $v.vehicleType;
      _customTypeName = $v.customTypeName;
      _brand = $v.brand;
      _capacityKg = $v.capacityKg;
      _heavyClassification = $v.heavyClassification;
      _configurationVersion = $v.configurationVersion;
      _rateVersion = $v.rateVersion;
      _numberOfVehicles = $v.numberOfVehicles;
      _totalVehicleTrips = $v.totalVehicleTrips;
      _perTripCentavos = $v.perTripCentavos;
      _tripTotalCentavos = $v.tripTotalCentavos;
      _mobilizationBasis = $v.mobilizationBasis;
      _mobilizationFeeCentavos = $v.mobilizationFeeCentavos;
      _mobilizationTotalCentavos = $v.mobilizationTotalCentavos;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OrderDeliveryVehicle other) {
    _$v = other as _$OrderDeliveryVehicle;
  }

  @override
  void update(void Function(OrderDeliveryVehicleBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OrderDeliveryVehicle build() => _build();

  _$OrderDeliveryVehicle _build() {
    final _$result = _$v ??
        _$OrderDeliveryVehicle._(
          name: name,
          vehicleCategory: vehicleCategory,
          vehicleType: vehicleType,
          customTypeName: customTypeName,
          brand: brand,
          capacityKg: capacityKg,
          heavyClassification: heavyClassification,
          configurationVersion: configurationVersion,
          rateVersion: rateVersion,
          numberOfVehicles: BuiltValueNullFieldError.checkNotNull(
              numberOfVehicles, r'OrderDeliveryVehicle', 'numberOfVehicles'),
          totalVehicleTrips: BuiltValueNullFieldError.checkNotNull(
              totalVehicleTrips, r'OrderDeliveryVehicle', 'totalVehicleTrips'),
          perTripCentavos: BuiltValueNullFieldError.checkNotNull(
              perTripCentavos, r'OrderDeliveryVehicle', 'perTripCentavos'),
          tripTotalCentavos: BuiltValueNullFieldError.checkNotNull(
              tripTotalCentavos, r'OrderDeliveryVehicle', 'tripTotalCentavos'),
          mobilizationBasis: mobilizationBasis,
          mobilizationFeeCentavos: mobilizationFeeCentavos,
          mobilizationTotalCentavos: mobilizationTotalCentavos,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
