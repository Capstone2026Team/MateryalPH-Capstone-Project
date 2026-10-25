// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'web_password_recovery_portal.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const WebPasswordRecoveryPortal _$VENDOR =
    const WebPasswordRecoveryPortal._('VENDOR');
const WebPasswordRecoveryPortal _$ADMIN =
    const WebPasswordRecoveryPortal._('ADMIN');

WebPasswordRecoveryPortal _$valueOf(String name) {
  switch (name) {
    case 'VENDOR':
      return _$VENDOR;
    case 'ADMIN':
      return _$ADMIN;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<WebPasswordRecoveryPortal> _$values =
    BuiltSet<WebPasswordRecoveryPortal>(const <WebPasswordRecoveryPortal>[
  _$VENDOR,
  _$ADMIN,
]);

class _$WebPasswordRecoveryPortalMeta {
  const _$WebPasswordRecoveryPortalMeta();
  WebPasswordRecoveryPortal get VENDOR => _$VENDOR;
  WebPasswordRecoveryPortal get ADMIN => _$ADMIN;
  WebPasswordRecoveryPortal valueOf(String name) => _$valueOf(name);
  BuiltSet<WebPasswordRecoveryPortal> get values => _$values;
}

abstract class _$WebPasswordRecoveryPortalMixin {
  // ignore: non_constant_identifier_names
  _$WebPasswordRecoveryPortalMeta get WebPasswordRecoveryPortal =>
      const _$WebPasswordRecoveryPortalMeta();
}

Serializer<WebPasswordRecoveryPortal> _$webPasswordRecoveryPortalSerializer =
    _$WebPasswordRecoveryPortalSerializer();

class _$WebPasswordRecoveryPortalSerializer
    implements PrimitiveSerializer<WebPasswordRecoveryPortal> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'VENDOR': 'VENDOR',
    'ADMIN': 'ADMIN',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'VENDOR': 'VENDOR',
    'ADMIN': 'ADMIN',
  };

  @override
  final Iterable<Type> types = const <Type>[WebPasswordRecoveryPortal];
  @override
  final String wireName = 'WebPasswordRecoveryPortal';

  @override
  Object serialize(Serializers serializers, WebPasswordRecoveryPortal object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  WebPasswordRecoveryPortal deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      WebPasswordRecoveryPortal.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
