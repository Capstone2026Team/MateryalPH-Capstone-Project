// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_estimate_option.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const DeliveryEstimateOptionMobilizationBasisEnum
    _$deliveryEstimateOptionMobilizationBasisEnum_PER_TRUCK =
    const DeliveryEstimateOptionMobilizationBasisEnum._('PER_TRUCK');
const DeliveryEstimateOptionMobilizationBasisEnum
    _$deliveryEstimateOptionMobilizationBasisEnum_PER_TRIP =
    const DeliveryEstimateOptionMobilizationBasisEnum._('PER_TRIP');

DeliveryEstimateOptionMobilizationBasisEnum
    _$deliveryEstimateOptionMobilizationBasisEnumValueOf(String name) {
  switch (name) {
    case 'PER_TRUCK':
      return _$deliveryEstimateOptionMobilizationBasisEnum_PER_TRUCK;
    case 'PER_TRIP':
      return _$deliveryEstimateOptionMobilizationBasisEnum_PER_TRIP;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DeliveryEstimateOptionMobilizationBasisEnum>
    _$deliveryEstimateOptionMobilizationBasisEnumValues = BuiltSet<
        DeliveryEstimateOptionMobilizationBasisEnum>(const <DeliveryEstimateOptionMobilizationBasisEnum>[
  _$deliveryEstimateOptionMobilizationBasisEnum_PER_TRUCK,
  _$deliveryEstimateOptionMobilizationBasisEnum_PER_TRIP,
]);

Serializer<DeliveryEstimateOptionMobilizationBasisEnum>
    _$deliveryEstimateOptionMobilizationBasisEnumSerializer =
    _$DeliveryEstimateOptionMobilizationBasisEnumSerializer();

class _$DeliveryEstimateOptionMobilizationBasisEnumSerializer
    implements
        PrimitiveSerializer<DeliveryEstimateOptionMobilizationBasisEnum> {
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
    DeliveryEstimateOptionMobilizationBasisEnum
  ];
  @override
  final String wireName = 'DeliveryEstimateOptionMobilizationBasisEnum';

  @override
  Object serialize(Serializers serializers,
          DeliveryEstimateOptionMobilizationBasisEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DeliveryEstimateOptionMobilizationBasisEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DeliveryEstimateOptionMobilizationBasisEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DeliveryEstimateOption extends DeliveryEstimateOption {
  @override
  final String? vehicleId;
  @override
  final String loadKey;
  @override
  final String vehicleName;
  @override
  final String vehicleType;
  @override
  final int vehicles;
  @override
  final int trips;
  @override
  final int feeCentavos;
  @override
  final int feePerTripCentavos;
  @override
  final DeliveryEstimateOptionMobilizationBasisEnum? mobilizationBasis;
  @override
  final int? mobilizationFeeCentavos;
  @override
  final int? mobilizationTotalCentavos;
  @override
  final MixerVolumePlan? volumePlan;

  factory _$DeliveryEstimateOption(
          [void Function(DeliveryEstimateOptionBuilder)? updates]) =>
      (DeliveryEstimateOptionBuilder()..update(updates))._build();

  _$DeliveryEstimateOption._(
      {this.vehicleId,
      required this.loadKey,
      required this.vehicleName,
      required this.vehicleType,
      required this.vehicles,
      required this.trips,
      required this.feeCentavos,
      required this.feePerTripCentavos,
      this.mobilizationBasis,
      this.mobilizationFeeCentavos,
      this.mobilizationTotalCentavos,
      this.volumePlan})
      : super._();
  @override
  DeliveryEstimateOption rebuild(
          void Function(DeliveryEstimateOptionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DeliveryEstimateOptionBuilder toBuilder() =>
      DeliveryEstimateOptionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DeliveryEstimateOption &&
        vehicleId == other.vehicleId &&
        loadKey == other.loadKey &&
        vehicleName == other.vehicleName &&
        vehicleType == other.vehicleType &&
        vehicles == other.vehicles &&
        trips == other.trips &&
        feeCentavos == other.feeCentavos &&
        feePerTripCentavos == other.feePerTripCentavos &&
        mobilizationBasis == other.mobilizationBasis &&
        mobilizationFeeCentavos == other.mobilizationFeeCentavos &&
        mobilizationTotalCentavos == other.mobilizationTotalCentavos &&
        volumePlan == other.volumePlan;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, vehicleId.hashCode);
    _$hash = $jc(_$hash, loadKey.hashCode);
    _$hash = $jc(_$hash, vehicleName.hashCode);
    _$hash = $jc(_$hash, vehicleType.hashCode);
    _$hash = $jc(_$hash, vehicles.hashCode);
    _$hash = $jc(_$hash, trips.hashCode);
    _$hash = $jc(_$hash, feeCentavos.hashCode);
    _$hash = $jc(_$hash, feePerTripCentavos.hashCode);
    _$hash = $jc(_$hash, mobilizationBasis.hashCode);
    _$hash = $jc(_$hash, mobilizationFeeCentavos.hashCode);
    _$hash = $jc(_$hash, mobilizationTotalCentavos.hashCode);
    _$hash = $jc(_$hash, volumePlan.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DeliveryEstimateOption')
          ..add('vehicleId', vehicleId)
          ..add('loadKey', loadKey)
          ..add('vehicleName', vehicleName)
          ..add('vehicleType', vehicleType)
          ..add('vehicles', vehicles)
          ..add('trips', trips)
          ..add('feeCentavos', feeCentavos)
          ..add('feePerTripCentavos', feePerTripCentavos)
          ..add('mobilizationBasis', mobilizationBasis)
          ..add('mobilizationFeeCentavos', mobilizationFeeCentavos)
          ..add('mobilizationTotalCentavos', mobilizationTotalCentavos)
          ..add('volumePlan', volumePlan))
        .toString();
  }
}

class DeliveryEstimateOptionBuilder
    implements Builder<DeliveryEstimateOption, DeliveryEstimateOptionBuilder> {
  _$DeliveryEstimateOption? _$v;

  String? _vehicleId;
  String? get vehicleId => _$this._vehicleId;
  set vehicleId(String? vehicleId) => _$this._vehicleId = vehicleId;

  String? _loadKey;
  String? get loadKey => _$this._loadKey;
  set loadKey(String? loadKey) => _$this._loadKey = loadKey;

  String? _vehicleName;
  String? get vehicleName => _$this._vehicleName;
  set vehicleName(String? vehicleName) => _$this._vehicleName = vehicleName;

  String? _vehicleType;
  String? get vehicleType => _$this._vehicleType;
  set vehicleType(String? vehicleType) => _$this._vehicleType = vehicleType;

  int? _vehicles;
  int? get vehicles => _$this._vehicles;
  set vehicles(int? vehicles) => _$this._vehicles = vehicles;

  int? _trips;
  int? get trips => _$this._trips;
  set trips(int? trips) => _$this._trips = trips;

  int? _feeCentavos;
  int? get feeCentavos => _$this._feeCentavos;
  set feeCentavos(int? feeCentavos) => _$this._feeCentavos = feeCentavos;

  int? _feePerTripCentavos;
  int? get feePerTripCentavos => _$this._feePerTripCentavos;
  set feePerTripCentavos(int? feePerTripCentavos) =>
      _$this._feePerTripCentavos = feePerTripCentavos;

  DeliveryEstimateOptionMobilizationBasisEnum? _mobilizationBasis;
  DeliveryEstimateOptionMobilizationBasisEnum? get mobilizationBasis =>
      _$this._mobilizationBasis;
  set mobilizationBasis(
          DeliveryEstimateOptionMobilizationBasisEnum? mobilizationBasis) =>
      _$this._mobilizationBasis = mobilizationBasis;

  int? _mobilizationFeeCentavos;
  int? get mobilizationFeeCentavos => _$this._mobilizationFeeCentavos;
  set mobilizationFeeCentavos(int? mobilizationFeeCentavos) =>
      _$this._mobilizationFeeCentavos = mobilizationFeeCentavos;

  int? _mobilizationTotalCentavos;
  int? get mobilizationTotalCentavos => _$this._mobilizationTotalCentavos;
  set mobilizationTotalCentavos(int? mobilizationTotalCentavos) =>
      _$this._mobilizationTotalCentavos = mobilizationTotalCentavos;

  MixerVolumePlanBuilder? _volumePlan;
  MixerVolumePlanBuilder get volumePlan =>
      _$this._volumePlan ??= MixerVolumePlanBuilder();
  set volumePlan(MixerVolumePlanBuilder? volumePlan) =>
      _$this._volumePlan = volumePlan;

  DeliveryEstimateOptionBuilder() {
    DeliveryEstimateOption._defaults(this);
  }

  DeliveryEstimateOptionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _vehicleId = $v.vehicleId;
      _loadKey = $v.loadKey;
      _vehicleName = $v.vehicleName;
      _vehicleType = $v.vehicleType;
      _vehicles = $v.vehicles;
      _trips = $v.trips;
      _feeCentavos = $v.feeCentavos;
      _feePerTripCentavos = $v.feePerTripCentavos;
      _mobilizationBasis = $v.mobilizationBasis;
      _mobilizationFeeCentavos = $v.mobilizationFeeCentavos;
      _mobilizationTotalCentavos = $v.mobilizationTotalCentavos;
      _volumePlan = $v.volumePlan?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DeliveryEstimateOption other) {
    _$v = other as _$DeliveryEstimateOption;
  }

  @override
  void update(void Function(DeliveryEstimateOptionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DeliveryEstimateOption build() => _build();

  _$DeliveryEstimateOption _build() {
    _$DeliveryEstimateOption _$result;
    try {
      _$result = _$v ??
          _$DeliveryEstimateOption._(
            vehicleId: vehicleId,
            loadKey: BuiltValueNullFieldError.checkNotNull(
                loadKey, r'DeliveryEstimateOption', 'loadKey'),
            vehicleName: BuiltValueNullFieldError.checkNotNull(
                vehicleName, r'DeliveryEstimateOption', 'vehicleName'),
            vehicleType: BuiltValueNullFieldError.checkNotNull(
                vehicleType, r'DeliveryEstimateOption', 'vehicleType'),
            vehicles: BuiltValueNullFieldError.checkNotNull(
                vehicles, r'DeliveryEstimateOption', 'vehicles'),
            trips: BuiltValueNullFieldError.checkNotNull(
                trips, r'DeliveryEstimateOption', 'trips'),
            feeCentavos: BuiltValueNullFieldError.checkNotNull(
                feeCentavos, r'DeliveryEstimateOption', 'feeCentavos'),
            feePerTripCentavos: BuiltValueNullFieldError.checkNotNull(
                feePerTripCentavos,
                r'DeliveryEstimateOption',
                'feePerTripCentavos'),
            mobilizationBasis: mobilizationBasis,
            mobilizationFeeCentavos: mobilizationFeeCentavos,
            mobilizationTotalCentavos: mobilizationTotalCentavos,
            volumePlan: _volumePlan?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'volumePlan';
        _volumePlan?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'DeliveryEstimateOption', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
