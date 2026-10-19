// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'support_portal.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const SupportPortal _$buyers = const SupportPortal._('buyers');
const SupportPortal _$vendors = const SupportPortal._('vendors');
const SupportPortal _$admin = const SupportPortal._('admin');
const SupportPortal _$guest = const SupportPortal._('guest');

SupportPortal _$valueOf(String name) {
  switch (name) {
    case 'buyers':
      return _$buyers;
    case 'vendors':
      return _$vendors;
    case 'admin':
      return _$admin;
    case 'guest':
      return _$guest;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<SupportPortal> _$values =
    BuiltSet<SupportPortal>(const <SupportPortal>[
  _$buyers,
  _$vendors,
  _$admin,
  _$guest,
]);

class _$SupportPortalMeta {
  const _$SupportPortalMeta();
  SupportPortal get buyers => _$buyers;
  SupportPortal get vendors => _$vendors;
  SupportPortal get admin => _$admin;
  SupportPortal get guest => _$guest;
  SupportPortal valueOf(String name) => _$valueOf(name);
  BuiltSet<SupportPortal> get values => _$values;
}

abstract class _$SupportPortalMixin {
  // ignore: non_constant_identifier_names
  _$SupportPortalMeta get SupportPortal => const _$SupportPortalMeta();
}

Serializer<SupportPortal> _$supportPortalSerializer =
    _$SupportPortalSerializer();

class _$SupportPortalSerializer implements PrimitiveSerializer<SupportPortal> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'buyers': 'buyers',
    'vendors': 'vendors',
    'admin': 'admin',
    'guest': 'guest',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'buyers': 'buyers',
    'vendors': 'vendors',
    'admin': 'admin',
    'guest': 'guest',
  };

  @override
  final Iterable<Type> types = const <Type>[SupportPortal];
  @override
  final String wireName = 'SupportPortal';

  @override
  Object serialize(Serializers serializers, SupportPortal object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  SupportPortal deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      SupportPortal.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
