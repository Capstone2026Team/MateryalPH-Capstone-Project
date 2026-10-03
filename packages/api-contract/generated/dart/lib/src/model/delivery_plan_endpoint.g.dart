// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_plan_endpoint.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const DeliveryPlanEndpointKindEnum
    _$deliveryPlanEndpointKindEnum_INTENDED_LOCATION =
    const DeliveryPlanEndpointKindEnum._('INTENDED_LOCATION');
const DeliveryPlanEndpointKindEnum
    _$deliveryPlanEndpointKindEnum_ALTERNATE_DROP_OFF =
    const DeliveryPlanEndpointKindEnum._('ALTERNATE_DROP_OFF');

DeliveryPlanEndpointKindEnum _$deliveryPlanEndpointKindEnumValueOf(
    String name) {
  switch (name) {
    case 'INTENDED_LOCATION':
      return _$deliveryPlanEndpointKindEnum_INTENDED_LOCATION;
    case 'ALTERNATE_DROP_OFF':
      return _$deliveryPlanEndpointKindEnum_ALTERNATE_DROP_OFF;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DeliveryPlanEndpointKindEnum>
    _$deliveryPlanEndpointKindEnumValues =
    BuiltSet<DeliveryPlanEndpointKindEnum>(const <DeliveryPlanEndpointKindEnum>[
  _$deliveryPlanEndpointKindEnum_INTENDED_LOCATION,
  _$deliveryPlanEndpointKindEnum_ALTERNATE_DROP_OFF,
]);

const DeliveryPlanEndpointHeavyVehicleRestrictionEnum
    _$deliveryPlanEndpointHeavyVehicleRestrictionEnum_NO =
    const DeliveryPlanEndpointHeavyVehicleRestrictionEnum._('NO');
const DeliveryPlanEndpointHeavyVehicleRestrictionEnum
    _$deliveryPlanEndpointHeavyVehicleRestrictionEnum_YES =
    const DeliveryPlanEndpointHeavyVehicleRestrictionEnum._('YES');

DeliveryPlanEndpointHeavyVehicleRestrictionEnum
    _$deliveryPlanEndpointHeavyVehicleRestrictionEnumValueOf(String name) {
  switch (name) {
    case 'NO':
      return _$deliveryPlanEndpointHeavyVehicleRestrictionEnum_NO;
    case 'YES':
      return _$deliveryPlanEndpointHeavyVehicleRestrictionEnum_YES;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DeliveryPlanEndpointHeavyVehicleRestrictionEnum>
    _$deliveryPlanEndpointHeavyVehicleRestrictionEnumValues = BuiltSet<
        DeliveryPlanEndpointHeavyVehicleRestrictionEnum>(const <DeliveryPlanEndpointHeavyVehicleRestrictionEnum>[
  _$deliveryPlanEndpointHeavyVehicleRestrictionEnum_NO,
  _$deliveryPlanEndpointHeavyVehicleRestrictionEnum_YES,
]);

Serializer<DeliveryPlanEndpointKindEnum>
    _$deliveryPlanEndpointKindEnumSerializer =
    _$DeliveryPlanEndpointKindEnumSerializer();
Serializer<DeliveryPlanEndpointHeavyVehicleRestrictionEnum>
    _$deliveryPlanEndpointHeavyVehicleRestrictionEnumSerializer =
    _$DeliveryPlanEndpointHeavyVehicleRestrictionEnumSerializer();

class _$DeliveryPlanEndpointKindEnumSerializer
    implements PrimitiveSerializer<DeliveryPlanEndpointKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'INTENDED_LOCATION': 'INTENDED_LOCATION',
    'ALTERNATE_DROP_OFF': 'ALTERNATE_DROP_OFF',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'INTENDED_LOCATION': 'INTENDED_LOCATION',
    'ALTERNATE_DROP_OFF': 'ALTERNATE_DROP_OFF',
  };

  @override
  final Iterable<Type> types = const <Type>[DeliveryPlanEndpointKindEnum];
  @override
  final String wireName = 'DeliveryPlanEndpointKindEnum';

  @override
  Object serialize(Serializers serializers, DeliveryPlanEndpointKindEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DeliveryPlanEndpointKindEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DeliveryPlanEndpointKindEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DeliveryPlanEndpointHeavyVehicleRestrictionEnumSerializer
    implements
        PrimitiveSerializer<DeliveryPlanEndpointHeavyVehicleRestrictionEnum> {
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
    DeliveryPlanEndpointHeavyVehicleRestrictionEnum
  ];
  @override
  final String wireName = 'DeliveryPlanEndpointHeavyVehicleRestrictionEnum';

  @override
  Object serialize(Serializers serializers,
          DeliveryPlanEndpointHeavyVehicleRestrictionEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DeliveryPlanEndpointHeavyVehicleRestrictionEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DeliveryPlanEndpointHeavyVehicleRestrictionEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DeliveryPlanEndpoint extends DeliveryPlanEndpoint {
  @override
  final DeliveryPlanEndpointKindEnum? kind;
  @override
  final DeliveryPlanEndpointHeavyVehicleRestrictionEnum?
      heavyVehicleRestriction;
  @override
  final OrderPoint? intended;
  @override
  final OrderPoint? alternateDropOff;

  factory _$DeliveryPlanEndpoint(
          [void Function(DeliveryPlanEndpointBuilder)? updates]) =>
      (DeliveryPlanEndpointBuilder()..update(updates))._build();

  _$DeliveryPlanEndpoint._(
      {this.kind,
      this.heavyVehicleRestriction,
      this.intended,
      this.alternateDropOff})
      : super._();
  @override
  DeliveryPlanEndpoint rebuild(
          void Function(DeliveryPlanEndpointBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DeliveryPlanEndpointBuilder toBuilder() =>
      DeliveryPlanEndpointBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DeliveryPlanEndpoint &&
        kind == other.kind &&
        heavyVehicleRestriction == other.heavyVehicleRestriction &&
        intended == other.intended &&
        alternateDropOff == other.alternateDropOff;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, heavyVehicleRestriction.hashCode);
    _$hash = $jc(_$hash, intended.hashCode);
    _$hash = $jc(_$hash, alternateDropOff.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DeliveryPlanEndpoint')
          ..add('kind', kind)
          ..add('heavyVehicleRestriction', heavyVehicleRestriction)
          ..add('intended', intended)
          ..add('alternateDropOff', alternateDropOff))
        .toString();
  }
}

class DeliveryPlanEndpointBuilder
    implements Builder<DeliveryPlanEndpoint, DeliveryPlanEndpointBuilder> {
  _$DeliveryPlanEndpoint? _$v;

  DeliveryPlanEndpointKindEnum? _kind;
  DeliveryPlanEndpointKindEnum? get kind => _$this._kind;
  set kind(DeliveryPlanEndpointKindEnum? kind) => _$this._kind = kind;

  DeliveryPlanEndpointHeavyVehicleRestrictionEnum? _heavyVehicleRestriction;
  DeliveryPlanEndpointHeavyVehicleRestrictionEnum?
      get heavyVehicleRestriction => _$this._heavyVehicleRestriction;
  set heavyVehicleRestriction(
          DeliveryPlanEndpointHeavyVehicleRestrictionEnum?
              heavyVehicleRestriction) =>
      _$this._heavyVehicleRestriction = heavyVehicleRestriction;

  OrderPointBuilder? _intended;
  OrderPointBuilder get intended => _$this._intended ??= OrderPointBuilder();
  set intended(OrderPointBuilder? intended) => _$this._intended = intended;

  OrderPointBuilder? _alternateDropOff;
  OrderPointBuilder get alternateDropOff =>
      _$this._alternateDropOff ??= OrderPointBuilder();
  set alternateDropOff(OrderPointBuilder? alternateDropOff) =>
      _$this._alternateDropOff = alternateDropOff;

  DeliveryPlanEndpointBuilder() {
    DeliveryPlanEndpoint._defaults(this);
  }

  DeliveryPlanEndpointBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _kind = $v.kind;
      _heavyVehicleRestriction = $v.heavyVehicleRestriction;
      _intended = $v.intended?.toBuilder();
      _alternateDropOff = $v.alternateDropOff?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DeliveryPlanEndpoint other) {
    _$v = other as _$DeliveryPlanEndpoint;
  }

  @override
  void update(void Function(DeliveryPlanEndpointBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DeliveryPlanEndpoint build() => _build();

  _$DeliveryPlanEndpoint _build() {
    _$DeliveryPlanEndpoint _$result;
    try {
      _$result = _$v ??
          _$DeliveryPlanEndpoint._(
            kind: kind,
            heavyVehicleRestriction: heavyVehicleRestriction,
            intended: _intended?.build(),
            alternateDropOff: _alternateDropOff?.build(),
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
            r'DeliveryPlanEndpoint', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
