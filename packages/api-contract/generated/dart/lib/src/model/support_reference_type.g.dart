// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'support_reference_type.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const SupportReferenceType _$ORDER = const SupportReferenceType._('ORDER');
const SupportReferenceType _$PROJECT = const SupportReferenceType._('PROJECT');
const SupportReferenceType _$WORK_PACKAGE =
    const SupportReferenceType._('WORK_PACKAGE');
const SupportReferenceType _$TRANSACTION =
    const SupportReferenceType._('TRANSACTION');

SupportReferenceType _$valueOf(String name) {
  switch (name) {
    case 'ORDER':
      return _$ORDER;
    case 'PROJECT':
      return _$PROJECT;
    case 'WORK_PACKAGE':
      return _$WORK_PACKAGE;
    case 'TRANSACTION':
      return _$TRANSACTION;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<SupportReferenceType> _$values =
    BuiltSet<SupportReferenceType>(const <SupportReferenceType>[
  _$ORDER,
  _$PROJECT,
  _$WORK_PACKAGE,
  _$TRANSACTION,
]);

class _$SupportReferenceTypeMeta {
  const _$SupportReferenceTypeMeta();
  SupportReferenceType get ORDER => _$ORDER;
  SupportReferenceType get PROJECT => _$PROJECT;
  SupportReferenceType get WORK_PACKAGE => _$WORK_PACKAGE;
  SupportReferenceType get TRANSACTION => _$TRANSACTION;
  SupportReferenceType valueOf(String name) => _$valueOf(name);
  BuiltSet<SupportReferenceType> get values => _$values;
}

abstract class _$SupportReferenceTypeMixin {
  // ignore: non_constant_identifier_names
  _$SupportReferenceTypeMeta get SupportReferenceType =>
      const _$SupportReferenceTypeMeta();
}

Serializer<SupportReferenceType> _$supportReferenceTypeSerializer =
    _$SupportReferenceTypeSerializer();

class _$SupportReferenceTypeSerializer
    implements PrimitiveSerializer<SupportReferenceType> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ORDER': 'ORDER',
    'PROJECT': 'PROJECT',
    'WORK_PACKAGE': 'WORK_PACKAGE',
    'TRANSACTION': 'TRANSACTION',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ORDER': 'ORDER',
    'PROJECT': 'PROJECT',
    'WORK_PACKAGE': 'WORK_PACKAGE',
    'TRANSACTION': 'TRANSACTION',
  };

  @override
  final Iterable<Type> types = const <Type>[SupportReferenceType];
  @override
  final String wireName = 'SupportReferenceType';

  @override
  Object serialize(Serializers serializers, SupportReferenceType object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  SupportReferenceType deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      SupportReferenceType.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
