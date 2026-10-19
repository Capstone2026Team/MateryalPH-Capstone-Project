// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'support_user_type.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const SupportUserType _$BUYER = const SupportUserType._('BUYER');
const SupportUserType _$VENDOR = const SupportUserType._('VENDOR');
const SupportUserType _$GUEST = const SupportUserType._('GUEST');

SupportUserType _$valueOf(String name) {
  switch (name) {
    case 'BUYER':
      return _$BUYER;
    case 'VENDOR':
      return _$VENDOR;
    case 'GUEST':
      return _$GUEST;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<SupportUserType> _$values =
    BuiltSet<SupportUserType>(const <SupportUserType>[
  _$BUYER,
  _$VENDOR,
  _$GUEST,
]);

class _$SupportUserTypeMeta {
  const _$SupportUserTypeMeta();
  SupportUserType get BUYER => _$BUYER;
  SupportUserType get VENDOR => _$VENDOR;
  SupportUserType get GUEST => _$GUEST;
  SupportUserType valueOf(String name) => _$valueOf(name);
  BuiltSet<SupportUserType> get values => _$values;
}

abstract class _$SupportUserTypeMixin {
  // ignore: non_constant_identifier_names
  _$SupportUserTypeMeta get SupportUserType => const _$SupportUserTypeMeta();
}

Serializer<SupportUserType> _$supportUserTypeSerializer =
    _$SupportUserTypeSerializer();

class _$SupportUserTypeSerializer
    implements PrimitiveSerializer<SupportUserType> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'BUYER': 'BUYER',
    'VENDOR': 'VENDOR',
    'GUEST': 'GUEST',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'BUYER': 'BUYER',
    'VENDOR': 'VENDOR',
    'GUEST': 'GUEST',
  };

  @override
  final Iterable<Type> types = const <Type>[SupportUserType];
  @override
  final String wireName = 'SupportUserType';

  @override
  Object serialize(Serializers serializers, SupportUserType object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  SupportUserType deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      SupportUserType.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
