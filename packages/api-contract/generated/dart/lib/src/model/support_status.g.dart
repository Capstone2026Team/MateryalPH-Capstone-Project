// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'support_status.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const SupportStatus _$OPEN = const SupportStatus._('OPEN');
const SupportStatus _$IN_PROGRESS = const SupportStatus._('IN_PROGRESS');
const SupportStatus _$WAITING_FOR_USER =
    const SupportStatus._('WAITING_FOR_USER');
const SupportStatus _$RESOLVED = const SupportStatus._('RESOLVED');
const SupportStatus _$CLOSED = const SupportStatus._('CLOSED');

SupportStatus _$valueOf(String name) {
  switch (name) {
    case 'OPEN':
      return _$OPEN;
    case 'IN_PROGRESS':
      return _$IN_PROGRESS;
    case 'WAITING_FOR_USER':
      return _$WAITING_FOR_USER;
    case 'RESOLVED':
      return _$RESOLVED;
    case 'CLOSED':
      return _$CLOSED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<SupportStatus> _$values =
    BuiltSet<SupportStatus>(const <SupportStatus>[
  _$OPEN,
  _$IN_PROGRESS,
  _$WAITING_FOR_USER,
  _$RESOLVED,
  _$CLOSED,
]);

class _$SupportStatusMeta {
  const _$SupportStatusMeta();
  SupportStatus get OPEN => _$OPEN;
  SupportStatus get IN_PROGRESS => _$IN_PROGRESS;
  SupportStatus get WAITING_FOR_USER => _$WAITING_FOR_USER;
  SupportStatus get RESOLVED => _$RESOLVED;
  SupportStatus get CLOSED => _$CLOSED;
  SupportStatus valueOf(String name) => _$valueOf(name);
  BuiltSet<SupportStatus> get values => _$values;
}

abstract class _$SupportStatusMixin {
  // ignore: non_constant_identifier_names
  _$SupportStatusMeta get SupportStatus => const _$SupportStatusMeta();
}

Serializer<SupportStatus> _$supportStatusSerializer =
    _$SupportStatusSerializer();

class _$SupportStatusSerializer implements PrimitiveSerializer<SupportStatus> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'OPEN': 'OPEN',
    'IN_PROGRESS': 'IN_PROGRESS',
    'WAITING_FOR_USER': 'WAITING_FOR_USER',
    'RESOLVED': 'RESOLVED',
    'CLOSED': 'CLOSED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'OPEN': 'OPEN',
    'IN_PROGRESS': 'IN_PROGRESS',
    'WAITING_FOR_USER': 'WAITING_FOR_USER',
    'RESOLVED': 'RESOLVED',
    'CLOSED': 'CLOSED',
  };

  @override
  final Iterable<Type> types = const <Type>[SupportStatus];
  @override
  final String wireName = 'SupportStatus';

  @override
  Object serialize(Serializers serializers, SupportStatus object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  SupportStatus deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      SupportStatus.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
