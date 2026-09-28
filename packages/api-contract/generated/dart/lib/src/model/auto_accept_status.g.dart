// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auto_accept_status.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AutoAcceptStatus _$DISABLED = const AutoAcceptStatus._('DISABLED');
const AutoAcceptStatus _$ACTIVE = const AutoAcceptStatus._('ACTIVE');
const AutoAcceptStatus _$PAUSED = const AutoAcceptStatus._('PAUSED');

AutoAcceptStatus _$valueOf(String name) {
  switch (name) {
    case 'DISABLED':
      return _$DISABLED;
    case 'ACTIVE':
      return _$ACTIVE;
    case 'PAUSED':
      return _$PAUSED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AutoAcceptStatus> _$values =
    BuiltSet<AutoAcceptStatus>(const <AutoAcceptStatus>[
  _$DISABLED,
  _$ACTIVE,
  _$PAUSED,
]);

class _$AutoAcceptStatusMeta {
  const _$AutoAcceptStatusMeta();
  AutoAcceptStatus get DISABLED => _$DISABLED;
  AutoAcceptStatus get ACTIVE => _$ACTIVE;
  AutoAcceptStatus get PAUSED => _$PAUSED;
  AutoAcceptStatus valueOf(String name) => _$valueOf(name);
  BuiltSet<AutoAcceptStatus> get values => _$values;
}

abstract class _$AutoAcceptStatusMixin {
  // ignore: non_constant_identifier_names
  _$AutoAcceptStatusMeta get AutoAcceptStatus => const _$AutoAcceptStatusMeta();
}

Serializer<AutoAcceptStatus> _$autoAcceptStatusSerializer =
    _$AutoAcceptStatusSerializer();

class _$AutoAcceptStatusSerializer
    implements PrimitiveSerializer<AutoAcceptStatus> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'DISABLED': 'DISABLED',
    'ACTIVE': 'ACTIVE',
    'PAUSED': 'PAUSED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'DISABLED': 'DISABLED',
    'ACTIVE': 'ACTIVE',
    'PAUSED': 'PAUSED',
  };

  @override
  final Iterable<Type> types = const <Type>[AutoAcceptStatus];
  @override
  final String wireName = 'AutoAcceptStatus';

  @override
  Object serialize(Serializers serializers, AutoAcceptStatus object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AutoAcceptStatus deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AutoAcceptStatus.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
