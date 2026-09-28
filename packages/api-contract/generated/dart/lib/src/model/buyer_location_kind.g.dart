// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buyer_location_kind.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const BuyerLocationKind _$DELIVERY = const BuyerLocationKind._('DELIVERY');
const BuyerLocationKind _$BUSINESS = const BuyerLocationKind._('BUSINESS');
const BuyerLocationKind _$PROJECT_SITE =
    const BuyerLocationKind._('PROJECT_SITE');
const BuyerLocationKind _$PICKUP_REFERENCE =
    const BuyerLocationKind._('PICKUP_REFERENCE');
const BuyerLocationKind _$OTHER = const BuyerLocationKind._('OTHER');

BuyerLocationKind _$valueOf(String name) {
  switch (name) {
    case 'DELIVERY':
      return _$DELIVERY;
    case 'BUSINESS':
      return _$BUSINESS;
    case 'PROJECT_SITE':
      return _$PROJECT_SITE;
    case 'PICKUP_REFERENCE':
      return _$PICKUP_REFERENCE;
    case 'OTHER':
      return _$OTHER;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<BuyerLocationKind> _$values =
    BuiltSet<BuyerLocationKind>(const <BuyerLocationKind>[
  _$DELIVERY,
  _$BUSINESS,
  _$PROJECT_SITE,
  _$PICKUP_REFERENCE,
  _$OTHER,
]);

class _$BuyerLocationKindMeta {
  const _$BuyerLocationKindMeta();
  BuyerLocationKind get DELIVERY => _$DELIVERY;
  BuyerLocationKind get BUSINESS => _$BUSINESS;
  BuyerLocationKind get PROJECT_SITE => _$PROJECT_SITE;
  BuyerLocationKind get PICKUP_REFERENCE => _$PICKUP_REFERENCE;
  BuyerLocationKind get OTHER => _$OTHER;
  BuyerLocationKind valueOf(String name) => _$valueOf(name);
  BuiltSet<BuyerLocationKind> get values => _$values;
}

abstract class _$BuyerLocationKindMixin {
  // ignore: non_constant_identifier_names
  _$BuyerLocationKindMeta get BuyerLocationKind =>
      const _$BuyerLocationKindMeta();
}

Serializer<BuyerLocationKind> _$buyerLocationKindSerializer =
    _$BuyerLocationKindSerializer();

class _$BuyerLocationKindSerializer
    implements PrimitiveSerializer<BuyerLocationKind> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'DELIVERY': 'DELIVERY',
    'BUSINESS': 'BUSINESS',
    'PROJECT_SITE': 'PROJECT_SITE',
    'PICKUP_REFERENCE': 'PICKUP_REFERENCE',
    'OTHER': 'OTHER',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'DELIVERY': 'DELIVERY',
    'BUSINESS': 'BUSINESS',
    'PROJECT_SITE': 'PROJECT_SITE',
    'PICKUP_REFERENCE': 'PICKUP_REFERENCE',
    'OTHER': 'OTHER',
  };

  @override
  final Iterable<Type> types = const <Type>[BuyerLocationKind];
  @override
  final String wireName = 'BuyerLocationKind';

  @override
  Object serialize(Serializers serializers, BuyerLocationKind object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  BuyerLocationKind deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      BuyerLocationKind.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
