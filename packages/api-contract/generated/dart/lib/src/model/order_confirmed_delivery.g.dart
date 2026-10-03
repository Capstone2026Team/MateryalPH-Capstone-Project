// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_confirmed_delivery.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const OrderConfirmedDeliveryBasisEnum
    _$orderConfirmedDeliveryBasisEnum_ADVISORY_CONFIRMED =
    const OrderConfirmedDeliveryBasisEnum._('ADVISORY_CONFIRMED');
const OrderConfirmedDeliveryBasisEnum
    _$orderConfirmedDeliveryBasisEnum_MANUAL_REVIEW =
    const OrderConfirmedDeliveryBasisEnum._('MANUAL_REVIEW');

OrderConfirmedDeliveryBasisEnum _$orderConfirmedDeliveryBasisEnumValueOf(
    String name) {
  switch (name) {
    case 'ADVISORY_CONFIRMED':
      return _$orderConfirmedDeliveryBasisEnum_ADVISORY_CONFIRMED;
    case 'MANUAL_REVIEW':
      return _$orderConfirmedDeliveryBasisEnum_MANUAL_REVIEW;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<OrderConfirmedDeliveryBasisEnum>
    _$orderConfirmedDeliveryBasisEnumValues = BuiltSet<
        OrderConfirmedDeliveryBasisEnum>(const <OrderConfirmedDeliveryBasisEnum>[
  _$orderConfirmedDeliveryBasisEnum_ADVISORY_CONFIRMED,
  _$orderConfirmedDeliveryBasisEnum_MANUAL_REVIEW,
]);

const OrderConfirmedDeliveryEndpointEnum
    _$orderConfirmedDeliveryEndpointEnum_INTENDED_LOCATION =
    const OrderConfirmedDeliveryEndpointEnum._('INTENDED_LOCATION');
const OrderConfirmedDeliveryEndpointEnum
    _$orderConfirmedDeliveryEndpointEnum_ALTERNATE_DROP_OFF =
    const OrderConfirmedDeliveryEndpointEnum._('ALTERNATE_DROP_OFF');

OrderConfirmedDeliveryEndpointEnum _$orderConfirmedDeliveryEndpointEnumValueOf(
    String name) {
  switch (name) {
    case 'INTENDED_LOCATION':
      return _$orderConfirmedDeliveryEndpointEnum_INTENDED_LOCATION;
    case 'ALTERNATE_DROP_OFF':
      return _$orderConfirmedDeliveryEndpointEnum_ALTERNATE_DROP_OFF;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<OrderConfirmedDeliveryEndpointEnum>
    _$orderConfirmedDeliveryEndpointEnumValues = BuiltSet<
        OrderConfirmedDeliveryEndpointEnum>(const <OrderConfirmedDeliveryEndpointEnum>[
  _$orderConfirmedDeliveryEndpointEnum_INTENDED_LOCATION,
  _$orderConfirmedDeliveryEndpointEnum_ALTERNATE_DROP_OFF,
]);

Serializer<OrderConfirmedDeliveryBasisEnum>
    _$orderConfirmedDeliveryBasisEnumSerializer =
    _$OrderConfirmedDeliveryBasisEnumSerializer();
Serializer<OrderConfirmedDeliveryEndpointEnum>
    _$orderConfirmedDeliveryEndpointEnumSerializer =
    _$OrderConfirmedDeliveryEndpointEnumSerializer();

class _$OrderConfirmedDeliveryBasisEnumSerializer
    implements PrimitiveSerializer<OrderConfirmedDeliveryBasisEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ADVISORY_CONFIRMED': 'ADVISORY_CONFIRMED',
    'MANUAL_REVIEW': 'MANUAL_REVIEW',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ADVISORY_CONFIRMED': 'ADVISORY_CONFIRMED',
    'MANUAL_REVIEW': 'MANUAL_REVIEW',
  };

  @override
  final Iterable<Type> types = const <Type>[OrderConfirmedDeliveryBasisEnum];
  @override
  final String wireName = 'OrderConfirmedDeliveryBasisEnum';

  @override
  Object serialize(
          Serializers serializers, OrderConfirmedDeliveryBasisEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  OrderConfirmedDeliveryBasisEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      OrderConfirmedDeliveryBasisEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$OrderConfirmedDeliveryEndpointEnumSerializer
    implements PrimitiveSerializer<OrderConfirmedDeliveryEndpointEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'INTENDED_LOCATION': 'INTENDED_LOCATION',
    'ALTERNATE_DROP_OFF': 'ALTERNATE_DROP_OFF',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'INTENDED_LOCATION': 'INTENDED_LOCATION',
    'ALTERNATE_DROP_OFF': 'ALTERNATE_DROP_OFF',
  };

  @override
  final Iterable<Type> types = const <Type>[OrderConfirmedDeliveryEndpointEnum];
  @override
  final String wireName = 'OrderConfirmedDeliveryEndpointEnum';

  @override
  Object serialize(
          Serializers serializers, OrderConfirmedDeliveryEndpointEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  OrderConfirmedDeliveryEndpointEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      OrderConfirmedDeliveryEndpointEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$OrderConfirmedDelivery extends OrderConfirmedDelivery {
  @override
  final BuiltList<OrderDeliveryVehicle> vehicles;
  @override
  final int distanceMeters;
  @override
  final String? routeSource;
  @override
  final OrderConfirmedDeliveryBasisEnum? basis;
  @override
  final OrderConfirmedDeliveryEndpointEnum? endpoint;
  @override
  final bool heavyVehicleRestriction;
  @override
  final OrderPoint? intended;
  @override
  final OrderPoint? alternateDropOff;
  @override
  final int finalFeeCentavos;
  @override
  final Date? fulfillmentDate;
  @override
  final String? arrangement;
  @override
  final String? calculationVersion;
  @override
  final String? confirmedByRole;
  @override
  final DateTime? confirmedAt;

  factory _$OrderConfirmedDelivery(
          [void Function(OrderConfirmedDeliveryBuilder)? updates]) =>
      (OrderConfirmedDeliveryBuilder()..update(updates))._build();

  _$OrderConfirmedDelivery._(
      {required this.vehicles,
      required this.distanceMeters,
      this.routeSource,
      this.basis,
      this.endpoint,
      required this.heavyVehicleRestriction,
      this.intended,
      this.alternateDropOff,
      required this.finalFeeCentavos,
      this.fulfillmentDate,
      this.arrangement,
      this.calculationVersion,
      this.confirmedByRole,
      this.confirmedAt})
      : super._();
  @override
  OrderConfirmedDelivery rebuild(
          void Function(OrderConfirmedDeliveryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OrderConfirmedDeliveryBuilder toBuilder() =>
      OrderConfirmedDeliveryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OrderConfirmedDelivery &&
        vehicles == other.vehicles &&
        distanceMeters == other.distanceMeters &&
        routeSource == other.routeSource &&
        basis == other.basis &&
        endpoint == other.endpoint &&
        heavyVehicleRestriction == other.heavyVehicleRestriction &&
        intended == other.intended &&
        alternateDropOff == other.alternateDropOff &&
        finalFeeCentavos == other.finalFeeCentavos &&
        fulfillmentDate == other.fulfillmentDate &&
        arrangement == other.arrangement &&
        calculationVersion == other.calculationVersion &&
        confirmedByRole == other.confirmedByRole &&
        confirmedAt == other.confirmedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, vehicles.hashCode);
    _$hash = $jc(_$hash, distanceMeters.hashCode);
    _$hash = $jc(_$hash, routeSource.hashCode);
    _$hash = $jc(_$hash, basis.hashCode);
    _$hash = $jc(_$hash, endpoint.hashCode);
    _$hash = $jc(_$hash, heavyVehicleRestriction.hashCode);
    _$hash = $jc(_$hash, intended.hashCode);
    _$hash = $jc(_$hash, alternateDropOff.hashCode);
    _$hash = $jc(_$hash, finalFeeCentavos.hashCode);
    _$hash = $jc(_$hash, fulfillmentDate.hashCode);
    _$hash = $jc(_$hash, arrangement.hashCode);
    _$hash = $jc(_$hash, calculationVersion.hashCode);
    _$hash = $jc(_$hash, confirmedByRole.hashCode);
    _$hash = $jc(_$hash, confirmedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OrderConfirmedDelivery')
          ..add('vehicles', vehicles)
          ..add('distanceMeters', distanceMeters)
          ..add('routeSource', routeSource)
          ..add('basis', basis)
          ..add('endpoint', endpoint)
          ..add('heavyVehicleRestriction', heavyVehicleRestriction)
          ..add('intended', intended)
          ..add('alternateDropOff', alternateDropOff)
          ..add('finalFeeCentavos', finalFeeCentavos)
          ..add('fulfillmentDate', fulfillmentDate)
          ..add('arrangement', arrangement)
          ..add('calculationVersion', calculationVersion)
          ..add('confirmedByRole', confirmedByRole)
          ..add('confirmedAt', confirmedAt))
        .toString();
  }
}

class OrderConfirmedDeliveryBuilder
    implements Builder<OrderConfirmedDelivery, OrderConfirmedDeliveryBuilder> {
  _$OrderConfirmedDelivery? _$v;

  ListBuilder<OrderDeliveryVehicle>? _vehicles;
  ListBuilder<OrderDeliveryVehicle> get vehicles =>
      _$this._vehicles ??= ListBuilder<OrderDeliveryVehicle>();
  set vehicles(ListBuilder<OrderDeliveryVehicle>? vehicles) =>
      _$this._vehicles = vehicles;

  int? _distanceMeters;
  int? get distanceMeters => _$this._distanceMeters;
  set distanceMeters(int? distanceMeters) =>
      _$this._distanceMeters = distanceMeters;

  String? _routeSource;
  String? get routeSource => _$this._routeSource;
  set routeSource(String? routeSource) => _$this._routeSource = routeSource;

  OrderConfirmedDeliveryBasisEnum? _basis;
  OrderConfirmedDeliveryBasisEnum? get basis => _$this._basis;
  set basis(OrderConfirmedDeliveryBasisEnum? basis) => _$this._basis = basis;

  OrderConfirmedDeliveryEndpointEnum? _endpoint;
  OrderConfirmedDeliveryEndpointEnum? get endpoint => _$this._endpoint;
  set endpoint(OrderConfirmedDeliveryEndpointEnum? endpoint) =>
      _$this._endpoint = endpoint;

  bool? _heavyVehicleRestriction;
  bool? get heavyVehicleRestriction => _$this._heavyVehicleRestriction;
  set heavyVehicleRestriction(bool? heavyVehicleRestriction) =>
      _$this._heavyVehicleRestriction = heavyVehicleRestriction;

  OrderPointBuilder? _intended;
  OrderPointBuilder get intended => _$this._intended ??= OrderPointBuilder();
  set intended(OrderPointBuilder? intended) => _$this._intended = intended;

  OrderPointBuilder? _alternateDropOff;
  OrderPointBuilder get alternateDropOff =>
      _$this._alternateDropOff ??= OrderPointBuilder();
  set alternateDropOff(OrderPointBuilder? alternateDropOff) =>
      _$this._alternateDropOff = alternateDropOff;

  int? _finalFeeCentavos;
  int? get finalFeeCentavos => _$this._finalFeeCentavos;
  set finalFeeCentavos(int? finalFeeCentavos) =>
      _$this._finalFeeCentavos = finalFeeCentavos;

  Date? _fulfillmentDate;
  Date? get fulfillmentDate => _$this._fulfillmentDate;
  set fulfillmentDate(Date? fulfillmentDate) =>
      _$this._fulfillmentDate = fulfillmentDate;

  String? _arrangement;
  String? get arrangement => _$this._arrangement;
  set arrangement(String? arrangement) => _$this._arrangement = arrangement;

  String? _calculationVersion;
  String? get calculationVersion => _$this._calculationVersion;
  set calculationVersion(String? calculationVersion) =>
      _$this._calculationVersion = calculationVersion;

  String? _confirmedByRole;
  String? get confirmedByRole => _$this._confirmedByRole;
  set confirmedByRole(String? confirmedByRole) =>
      _$this._confirmedByRole = confirmedByRole;

  DateTime? _confirmedAt;
  DateTime? get confirmedAt => _$this._confirmedAt;
  set confirmedAt(DateTime? confirmedAt) => _$this._confirmedAt = confirmedAt;

  OrderConfirmedDeliveryBuilder() {
    OrderConfirmedDelivery._defaults(this);
  }

  OrderConfirmedDeliveryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _vehicles = $v.vehicles.toBuilder();
      _distanceMeters = $v.distanceMeters;
      _routeSource = $v.routeSource;
      _basis = $v.basis;
      _endpoint = $v.endpoint;
      _heavyVehicleRestriction = $v.heavyVehicleRestriction;
      _intended = $v.intended?.toBuilder();
      _alternateDropOff = $v.alternateDropOff?.toBuilder();
      _finalFeeCentavos = $v.finalFeeCentavos;
      _fulfillmentDate = $v.fulfillmentDate;
      _arrangement = $v.arrangement;
      _calculationVersion = $v.calculationVersion;
      _confirmedByRole = $v.confirmedByRole;
      _confirmedAt = $v.confirmedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OrderConfirmedDelivery other) {
    _$v = other as _$OrderConfirmedDelivery;
  }

  @override
  void update(void Function(OrderConfirmedDeliveryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OrderConfirmedDelivery build() => _build();

  _$OrderConfirmedDelivery _build() {
    _$OrderConfirmedDelivery _$result;
    try {
      _$result = _$v ??
          _$OrderConfirmedDelivery._(
            vehicles: vehicles.build(),
            distanceMeters: BuiltValueNullFieldError.checkNotNull(
                distanceMeters, r'OrderConfirmedDelivery', 'distanceMeters'),
            routeSource: routeSource,
            basis: basis,
            endpoint: endpoint,
            heavyVehicleRestriction: BuiltValueNullFieldError.checkNotNull(
                heavyVehicleRestriction,
                r'OrderConfirmedDelivery',
                'heavyVehicleRestriction'),
            intended: _intended?.build(),
            alternateDropOff: _alternateDropOff?.build(),
            finalFeeCentavos: BuiltValueNullFieldError.checkNotNull(
                finalFeeCentavos,
                r'OrderConfirmedDelivery',
                'finalFeeCentavos'),
            fulfillmentDate: fulfillmentDate,
            arrangement: arrangement,
            calculationVersion: calculationVersion,
            confirmedByRole: confirmedByRole,
            confirmedAt: confirmedAt,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'vehicles';
        vehicles.build();

        _$failedField = 'intended';
        _intended?.build();
        _$failedField = 'alternateDropOff';
        _alternateDropOff?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'OrderConfirmedDelivery', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
