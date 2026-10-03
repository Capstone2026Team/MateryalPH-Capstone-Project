// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_destination.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const OrderDestinationTypeEnum _$orderDestinationTypeEnum_DELIVERY =
    const OrderDestinationTypeEnum._('DELIVERY');
const OrderDestinationTypeEnum _$orderDestinationTypeEnum_PICKUP =
    const OrderDestinationTypeEnum._('PICKUP');

OrderDestinationTypeEnum _$orderDestinationTypeEnumValueOf(String name) {
  switch (name) {
    case 'DELIVERY':
      return _$orderDestinationTypeEnum_DELIVERY;
    case 'PICKUP':
      return _$orderDestinationTypeEnum_PICKUP;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<OrderDestinationTypeEnum> _$orderDestinationTypeEnumValues =
    BuiltSet<OrderDestinationTypeEnum>(const <OrderDestinationTypeEnum>[
  _$orderDestinationTypeEnum_DELIVERY,
  _$orderDestinationTypeEnum_PICKUP,
]);

const OrderDestinationHeavyVehicleRestrictionEnum
    _$orderDestinationHeavyVehicleRestrictionEnum_NO =
    const OrderDestinationHeavyVehicleRestrictionEnum._('NO');
const OrderDestinationHeavyVehicleRestrictionEnum
    _$orderDestinationHeavyVehicleRestrictionEnum_YES =
    const OrderDestinationHeavyVehicleRestrictionEnum._('YES');

OrderDestinationHeavyVehicleRestrictionEnum
    _$orderDestinationHeavyVehicleRestrictionEnumValueOf(String name) {
  switch (name) {
    case 'NO':
      return _$orderDestinationHeavyVehicleRestrictionEnum_NO;
    case 'YES':
      return _$orderDestinationHeavyVehicleRestrictionEnum_YES;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<OrderDestinationHeavyVehicleRestrictionEnum>
    _$orderDestinationHeavyVehicleRestrictionEnumValues = BuiltSet<
        OrderDestinationHeavyVehicleRestrictionEnum>(const <OrderDestinationHeavyVehicleRestrictionEnum>[
  _$orderDestinationHeavyVehicleRestrictionEnum_NO,
  _$orderDestinationHeavyVehicleRestrictionEnum_YES,
]);

const OrderDestinationVehicleEndpointEnum
    _$orderDestinationVehicleEndpointEnum_INTENDED_LOCATION =
    const OrderDestinationVehicleEndpointEnum._('INTENDED_LOCATION');
const OrderDestinationVehicleEndpointEnum
    _$orderDestinationVehicleEndpointEnum_ALTERNATE_DROP_OFF =
    const OrderDestinationVehicleEndpointEnum._('ALTERNATE_DROP_OFF');

OrderDestinationVehicleEndpointEnum
    _$orderDestinationVehicleEndpointEnumValueOf(String name) {
  switch (name) {
    case 'INTENDED_LOCATION':
      return _$orderDestinationVehicleEndpointEnum_INTENDED_LOCATION;
    case 'ALTERNATE_DROP_OFF':
      return _$orderDestinationVehicleEndpointEnum_ALTERNATE_DROP_OFF;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<OrderDestinationVehicleEndpointEnum>
    _$orderDestinationVehicleEndpointEnumValues = BuiltSet<
        OrderDestinationVehicleEndpointEnum>(const <OrderDestinationVehicleEndpointEnum>[
  _$orderDestinationVehicleEndpointEnum_INTENDED_LOCATION,
  _$orderDestinationVehicleEndpointEnum_ALTERNATE_DROP_OFF,
]);

Serializer<OrderDestinationTypeEnum> _$orderDestinationTypeEnumSerializer =
    _$OrderDestinationTypeEnumSerializer();
Serializer<OrderDestinationHeavyVehicleRestrictionEnum>
    _$orderDestinationHeavyVehicleRestrictionEnumSerializer =
    _$OrderDestinationHeavyVehicleRestrictionEnumSerializer();
Serializer<OrderDestinationVehicleEndpointEnum>
    _$orderDestinationVehicleEndpointEnumSerializer =
    _$OrderDestinationVehicleEndpointEnumSerializer();

class _$OrderDestinationTypeEnumSerializer
    implements PrimitiveSerializer<OrderDestinationTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'DELIVERY': 'DELIVERY',
    'PICKUP': 'PICKUP',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'DELIVERY': 'DELIVERY',
    'PICKUP': 'PICKUP',
  };

  @override
  final Iterable<Type> types = const <Type>[OrderDestinationTypeEnum];
  @override
  final String wireName = 'OrderDestinationTypeEnum';

  @override
  Object serialize(Serializers serializers, OrderDestinationTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  OrderDestinationTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      OrderDestinationTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$OrderDestinationHeavyVehicleRestrictionEnumSerializer
    implements
        PrimitiveSerializer<OrderDestinationHeavyVehicleRestrictionEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'NO': 'NO',
    'YES': 'YES',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'NO': 'NO',
    'YES': 'YES',
  };

  @override
  final Iterable<Type> types = const <Type>[
    OrderDestinationHeavyVehicleRestrictionEnum
  ];
  @override
  final String wireName = 'OrderDestinationHeavyVehicleRestrictionEnum';

  @override
  Object serialize(Serializers serializers,
          OrderDestinationHeavyVehicleRestrictionEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  OrderDestinationHeavyVehicleRestrictionEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      OrderDestinationHeavyVehicleRestrictionEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$OrderDestinationVehicleEndpointEnumSerializer
    implements PrimitiveSerializer<OrderDestinationVehicleEndpointEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'INTENDED_LOCATION': 'INTENDED_LOCATION',
    'ALTERNATE_DROP_OFF': 'ALTERNATE_DROP_OFF',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'INTENDED_LOCATION': 'INTENDED_LOCATION',
    'ALTERNATE_DROP_OFF': 'ALTERNATE_DROP_OFF',
  };

  @override
  final Iterable<Type> types = const <Type>[
    OrderDestinationVehicleEndpointEnum
  ];
  @override
  final String wireName = 'OrderDestinationVehicleEndpointEnum';

  @override
  Object serialize(
          Serializers serializers, OrderDestinationVehicleEndpointEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  OrderDestinationVehicleEndpointEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      OrderDestinationVehicleEndpointEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$OrderDestination extends OrderDestination {
  @override
  final OrderDestinationTypeEnum type;
  @override
  final String? storeAddress;
  @override
  final OrderPoint? intended;
  @override
  final OrderDestinationHeavyVehicleRestrictionEnum? heavyVehicleRestriction;
  @override
  final OrderPoint? alternateDropOff;
  @override
  final OrderDestinationVehicleEndpointEnum? vehicleEndpoint;
  @override
  final String? accessInstructions;

  factory _$OrderDestination(
          [void Function(OrderDestinationBuilder)? updates]) =>
      (OrderDestinationBuilder()..update(updates))._build();

  _$OrderDestination._(
      {required this.type,
      this.storeAddress,
      this.intended,
      this.heavyVehicleRestriction,
      this.alternateDropOff,
      this.vehicleEndpoint,
      this.accessInstructions})
      : super._();
  @override
  OrderDestination rebuild(void Function(OrderDestinationBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OrderDestinationBuilder toBuilder() =>
      OrderDestinationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OrderDestination &&
        type == other.type &&
        storeAddress == other.storeAddress &&
        intended == other.intended &&
        heavyVehicleRestriction == other.heavyVehicleRestriction &&
        alternateDropOff == other.alternateDropOff &&
        vehicleEndpoint == other.vehicleEndpoint &&
        accessInstructions == other.accessInstructions;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, storeAddress.hashCode);
    _$hash = $jc(_$hash, intended.hashCode);
    _$hash = $jc(_$hash, heavyVehicleRestriction.hashCode);
    _$hash = $jc(_$hash, alternateDropOff.hashCode);
    _$hash = $jc(_$hash, vehicleEndpoint.hashCode);
    _$hash = $jc(_$hash, accessInstructions.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OrderDestination')
          ..add('type', type)
          ..add('storeAddress', storeAddress)
          ..add('intended', intended)
          ..add('heavyVehicleRestriction', heavyVehicleRestriction)
          ..add('alternateDropOff', alternateDropOff)
          ..add('vehicleEndpoint', vehicleEndpoint)
          ..add('accessInstructions', accessInstructions))
        .toString();
  }
}

class OrderDestinationBuilder
    implements Builder<OrderDestination, OrderDestinationBuilder> {
  _$OrderDestination? _$v;

  OrderDestinationTypeEnum? _type;
  OrderDestinationTypeEnum? get type => _$this._type;
  set type(OrderDestinationTypeEnum? type) => _$this._type = type;

  String? _storeAddress;
  String? get storeAddress => _$this._storeAddress;
  set storeAddress(String? storeAddress) => _$this._storeAddress = storeAddress;

  OrderPointBuilder? _intended;
  OrderPointBuilder get intended => _$this._intended ??= OrderPointBuilder();
  set intended(OrderPointBuilder? intended) => _$this._intended = intended;

  OrderDestinationHeavyVehicleRestrictionEnum? _heavyVehicleRestriction;
  OrderDestinationHeavyVehicleRestrictionEnum? get heavyVehicleRestriction =>
      _$this._heavyVehicleRestriction;
  set heavyVehicleRestriction(
          OrderDestinationHeavyVehicleRestrictionEnum?
              heavyVehicleRestriction) =>
      _$this._heavyVehicleRestriction = heavyVehicleRestriction;

  OrderPointBuilder? _alternateDropOff;
  OrderPointBuilder get alternateDropOff =>
      _$this._alternateDropOff ??= OrderPointBuilder();
  set alternateDropOff(OrderPointBuilder? alternateDropOff) =>
      _$this._alternateDropOff = alternateDropOff;

  OrderDestinationVehicleEndpointEnum? _vehicleEndpoint;
  OrderDestinationVehicleEndpointEnum? get vehicleEndpoint =>
      _$this._vehicleEndpoint;
  set vehicleEndpoint(OrderDestinationVehicleEndpointEnum? vehicleEndpoint) =>
      _$this._vehicleEndpoint = vehicleEndpoint;

  String? _accessInstructions;
  String? get accessInstructions => _$this._accessInstructions;
  set accessInstructions(String? accessInstructions) =>
      _$this._accessInstructions = accessInstructions;

  OrderDestinationBuilder() {
    OrderDestination._defaults(this);
  }

  OrderDestinationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _type = $v.type;
      _storeAddress = $v.storeAddress;
      _intended = $v.intended?.toBuilder();
      _heavyVehicleRestriction = $v.heavyVehicleRestriction;
      _alternateDropOff = $v.alternateDropOff?.toBuilder();
      _vehicleEndpoint = $v.vehicleEndpoint;
      _accessInstructions = $v.accessInstructions;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OrderDestination other) {
    _$v = other as _$OrderDestination;
  }

  @override
  void update(void Function(OrderDestinationBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OrderDestination build() => _build();

  _$OrderDestination _build() {
    _$OrderDestination _$result;
    try {
      _$result = _$v ??
          _$OrderDestination._(
            type: BuiltValueNullFieldError.checkNotNull(
                type, r'OrderDestination', 'type'),
            storeAddress: storeAddress,
            intended: _intended?.build(),
            heavyVehicleRestriction: heavyVehicleRestriction,
            alternateDropOff: _alternateDropOff?.build(),
            vehicleEndpoint: vehicleEndpoint,
            accessInstructions: accessInstructions,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'intended';
        _intended?.build();

        _$failedField = 'alternateDropOff';
        _alternateDropOff?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'OrderDestination', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
