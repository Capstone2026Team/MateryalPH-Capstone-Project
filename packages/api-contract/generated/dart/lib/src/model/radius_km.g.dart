// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'radius_km.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const RadiusKm _$number5 = const RadiusKm._('number5');
const RadiusKm _$number10 = const RadiusKm._('number10');
const RadiusKm _$number20 = const RadiusKm._('number20');
const RadiusKm _$number30 = const RadiusKm._('number30');
const RadiusKm _$number40 = const RadiusKm._('number40');
const RadiusKm _$number50 = const RadiusKm._('number50');

RadiusKm _$valueOf(String name) {
  switch (name) {
    case 'number5':
      return _$number5;
    case 'number10':
      return _$number10;
    case 'number20':
      return _$number20;
    case 'number30':
      return _$number30;
    case 'number40':
      return _$number40;
    case 'number50':
      return _$number50;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<RadiusKm> _$values = BuiltSet<RadiusKm>(const <RadiusKm>[
  _$number5,
  _$number10,
  _$number20,
  _$number30,
  _$number40,
  _$number50,
]);

class _$RadiusKmMeta {
  const _$RadiusKmMeta();
  RadiusKm get number5 => _$number5;
  RadiusKm get number10 => _$number10;
  RadiusKm get number20 => _$number20;
  RadiusKm get number30 => _$number30;
  RadiusKm get number40 => _$number40;
  RadiusKm get number50 => _$number50;
  RadiusKm valueOf(String name) => _$valueOf(name);
  BuiltSet<RadiusKm> get values => _$values;
}

abstract class _$RadiusKmMixin {
  // ignore: non_constant_identifier_names
  _$RadiusKmMeta get RadiusKm => const _$RadiusKmMeta();
}

Serializer<RadiusKm> _$radiusKmSerializer = _$RadiusKmSerializer();

class _$RadiusKmSerializer implements PrimitiveSerializer<RadiusKm> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'number5': 5,
    'number10': 10,
    'number20': 20,
    'number30': 30,
    'number40': 40,
    'number50': 50,
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    5: 'number5',
    10: 'number10',
    20: 'number20',
    30: 'number30',
    40: 'number40',
    50: 'number50',
  };

  @override
  final Iterable<Type> types = const <Type>[RadiusKm];
  @override
  final String wireName = 'RadiusKm';

  @override
  Object serialize(Serializers serializers, RadiusKm object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  RadiusKm deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      RadiusKm.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
