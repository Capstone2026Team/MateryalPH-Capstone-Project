// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_destination.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CartDestinationHeavyVehicleRestrictionEnum
    _$cartDestinationHeavyVehicleRestrictionEnum_UNANSWERED =
    const CartDestinationHeavyVehicleRestrictionEnum._('UNANSWERED');
const CartDestinationHeavyVehicleRestrictionEnum
    _$cartDestinationHeavyVehicleRestrictionEnum_NO =
    const CartDestinationHeavyVehicleRestrictionEnum._('NO');
const CartDestinationHeavyVehicleRestrictionEnum
    _$cartDestinationHeavyVehicleRestrictionEnum_YES =
    const CartDestinationHeavyVehicleRestrictionEnum._('YES');

CartDestinationHeavyVehicleRestrictionEnum
    _$cartDestinationHeavyVehicleRestrictionEnumValueOf(String name) {
  switch (name) {
    case 'UNANSWERED':
      return _$cartDestinationHeavyVehicleRestrictionEnum_UNANSWERED;
    case 'NO':
      return _$cartDestinationHeavyVehicleRestrictionEnum_NO;
    case 'YES':
      return _$cartDestinationHeavyVehicleRestrictionEnum_YES;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CartDestinationHeavyVehicleRestrictionEnum>
    _$cartDestinationHeavyVehicleRestrictionEnumValues = BuiltSet<
        CartDestinationHeavyVehicleRestrictionEnum>(const <CartDestinationHeavyVehicleRestrictionEnum>[
  _$cartDestinationHeavyVehicleRestrictionEnum_UNANSWERED,
  _$cartDestinationHeavyVehicleRestrictionEnum_NO,
  _$cartDestinationHeavyVehicleRestrictionEnum_YES,
]);

const CartDestinationVehicleEndpointEnum
    _$cartDestinationVehicleEndpointEnum_INTENDED_LOCATION =
    const CartDestinationVehicleEndpointEnum._('INTENDED_LOCATION');
const CartDestinationVehicleEndpointEnum
    _$cartDestinationVehicleEndpointEnum_ALTERNATE_DROP_OFF =
    const CartDestinationVehicleEndpointEnum._('ALTERNATE_DROP_OFF');

CartDestinationVehicleEndpointEnum _$cartDestinationVehicleEndpointEnumValueOf(
    String name) {
  switch (name) {
    case 'INTENDED_LOCATION':
      return _$cartDestinationVehicleEndpointEnum_INTENDED_LOCATION;
    case 'ALTERNATE_DROP_OFF':
      return _$cartDestinationVehicleEndpointEnum_ALTERNATE_DROP_OFF;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CartDestinationVehicleEndpointEnum>
    _$cartDestinationVehicleEndpointEnumValues = BuiltSet<
        CartDestinationVehicleEndpointEnum>(const <CartDestinationVehicleEndpointEnum>[
  _$cartDestinationVehicleEndpointEnum_INTENDED_LOCATION,
  _$cartDestinationVehicleEndpointEnum_ALTERNATE_DROP_OFF,
]);

Serializer<CartDestinationHeavyVehicleRestrictionEnum>
    _$cartDestinationHeavyVehicleRestrictionEnumSerializer =
    _$CartDestinationHeavyVehicleRestrictionEnumSerializer();
Serializer<CartDestinationVehicleEndpointEnum>
    _$cartDestinationVehicleEndpointEnumSerializer =
    _$CartDestinationVehicleEndpointEnumSerializer();

class _$CartDestinationHeavyVehicleRestrictionEnumSerializer
    implements PrimitiveSerializer<CartDestinationHeavyVehicleRestrictionEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'UNANSWERED': 'UNANSWERED',
    'NO': 'NO',
    'YES': 'YES',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'UNANSWERED': 'UNANSWERED',
    'NO': 'NO',
    'YES': 'YES',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CartDestinationHeavyVehicleRestrictionEnum
  ];
  @override
  final String wireName = 'CartDestinationHeavyVehicleRestrictionEnum';

  @override
  Object serialize(Serializers serializers,
          CartDestinationHeavyVehicleRestrictionEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CartDestinationHeavyVehicleRestrictionEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CartDestinationHeavyVehicleRestrictionEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CartDestinationVehicleEndpointEnumSerializer
    implements PrimitiveSerializer<CartDestinationVehicleEndpointEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'INTENDED_LOCATION': 'INTENDED_LOCATION',
    'ALTERNATE_DROP_OFF': 'ALTERNATE_DROP_OFF',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'INTENDED_LOCATION': 'INTENDED_LOCATION',
    'ALTERNATE_DROP_OFF': 'ALTERNATE_DROP_OFF',
  };

  @override
  final Iterable<Type> types = const <Type>[CartDestinationVehicleEndpointEnum];
  @override
  final String wireName = 'CartDestinationVehicleEndpointEnum';

  @override
  Object serialize(
          Serializers serializers, CartDestinationVehicleEndpointEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CartDestinationVehicleEndpointEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CartDestinationVehicleEndpointEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CartDestination extends CartDestination {
  @override
  final CartLocationRef? intended;
  @override
  final CartDestinationHeavyVehicleRestrictionEnum heavyVehicleRestriction;
  @override
  final CartLocationRef? alternateDropOff;
  @override
  final CartDestinationVehicleEndpointEnum? vehicleEndpoint;
  @override
  final String? accessInstructions;
  @override
  final CartDestinationLabels labels;

  factory _$CartDestination([void Function(CartDestinationBuilder)? updates]) =>
      (CartDestinationBuilder()..update(updates))._build();

  _$CartDestination._(
      {this.intended,
      required this.heavyVehicleRestriction,
      this.alternateDropOff,
      this.vehicleEndpoint,
      this.accessInstructions,
      required this.labels})
      : super._();
  @override
  CartDestination rebuild(void Function(CartDestinationBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CartDestinationBuilder toBuilder() => CartDestinationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CartDestination &&
        intended == other.intended &&
        heavyVehicleRestriction == other.heavyVehicleRestriction &&
        alternateDropOff == other.alternateDropOff &&
        vehicleEndpoint == other.vehicleEndpoint &&
        accessInstructions == other.accessInstructions &&
        labels == other.labels;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, intended.hashCode);
    _$hash = $jc(_$hash, heavyVehicleRestriction.hashCode);
    _$hash = $jc(_$hash, alternateDropOff.hashCode);
    _$hash = $jc(_$hash, vehicleEndpoint.hashCode);
    _$hash = $jc(_$hash, accessInstructions.hashCode);
    _$hash = $jc(_$hash, labels.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CartDestination')
          ..add('intended', intended)
          ..add('heavyVehicleRestriction', heavyVehicleRestriction)
          ..add('alternateDropOff', alternateDropOff)
          ..add('vehicleEndpoint', vehicleEndpoint)
          ..add('accessInstructions', accessInstructions)
          ..add('labels', labels))
        .toString();
  }
}

class CartDestinationBuilder
    implements Builder<CartDestination, CartDestinationBuilder> {
  _$CartDestination? _$v;

  CartLocationRefBuilder? _intended;
  CartLocationRefBuilder get intended =>
      _$this._intended ??= CartLocationRefBuilder();
  set intended(CartLocationRefBuilder? intended) => _$this._intended = intended;

  CartDestinationHeavyVehicleRestrictionEnum? _heavyVehicleRestriction;
  CartDestinationHeavyVehicleRestrictionEnum? get heavyVehicleRestriction =>
      _$this._heavyVehicleRestriction;
  set heavyVehicleRestriction(
          CartDestinationHeavyVehicleRestrictionEnum?
              heavyVehicleRestriction) =>
      _$this._heavyVehicleRestriction = heavyVehicleRestriction;

  CartLocationRefBuilder? _alternateDropOff;
  CartLocationRefBuilder get alternateDropOff =>
      _$this._alternateDropOff ??= CartLocationRefBuilder();
  set alternateDropOff(CartLocationRefBuilder? alternateDropOff) =>
      _$this._alternateDropOff = alternateDropOff;

  CartDestinationVehicleEndpointEnum? _vehicleEndpoint;
  CartDestinationVehicleEndpointEnum? get vehicleEndpoint =>
      _$this._vehicleEndpoint;
  set vehicleEndpoint(CartDestinationVehicleEndpointEnum? vehicleEndpoint) =>
      _$this._vehicleEndpoint = vehicleEndpoint;

  String? _accessInstructions;
  String? get accessInstructions => _$this._accessInstructions;
  set accessInstructions(String? accessInstructions) =>
      _$this._accessInstructions = accessInstructions;

  CartDestinationLabelsBuilder? _labels;
  CartDestinationLabelsBuilder get labels =>
      _$this._labels ??= CartDestinationLabelsBuilder();
  set labels(CartDestinationLabelsBuilder? labels) => _$this._labels = labels;

  CartDestinationBuilder() {
    CartDestination._defaults(this);
  }

  CartDestinationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _intended = $v.intended?.toBuilder();
      _heavyVehicleRestriction = $v.heavyVehicleRestriction;
      _alternateDropOff = $v.alternateDropOff?.toBuilder();
      _vehicleEndpoint = $v.vehicleEndpoint;
      _accessInstructions = $v.accessInstructions;
      _labels = $v.labels.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CartDestination other) {
    _$v = other as _$CartDestination;
  }

  @override
  void update(void Function(CartDestinationBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CartDestination build() => _build();

  _$CartDestination _build() {
    _$CartDestination _$result;
    try {
      _$result = _$v ??
          _$CartDestination._(
            intended: _intended?.build(),
            heavyVehicleRestriction: BuiltValueNullFieldError.checkNotNull(
                heavyVehicleRestriction,
                r'CartDestination',
                'heavyVehicleRestriction'),
            alternateDropOff: _alternateDropOff?.build(),
            vehicleEndpoint: vehicleEndpoint,
            accessInstructions: accessInstructions,
            labels: labels.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'intended';
        _intended?.build();

        _$failedField = 'alternateDropOff';
        _alternateDropOff?.build();

        _$failedField = 'labels';
        labels.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CartDestination', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
