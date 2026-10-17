//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'privacy_handler.g.dart';

/// PrivacyHandler
///
/// Properties:
/// * [userId]
/// * [name]
/// * [role]
@BuiltValue()
abstract class PrivacyHandler implements Built<PrivacyHandler, PrivacyHandlerBuilder> {
  @BuiltValueField(wireName: r'user_id')
  int get userId;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'role')
  String get role;

  PrivacyHandler._();

  factory PrivacyHandler([void updates(PrivacyHandlerBuilder b)]) = _$PrivacyHandler;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PrivacyHandlerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PrivacyHandler> get serializer => _$PrivacyHandlerSerializer();
}

class _$PrivacyHandlerSerializer implements PrimitiveSerializer<PrivacyHandler> {
  @override
  final Iterable<Type> types = const [PrivacyHandler, _$PrivacyHandler];

  @override
  final String wireName = r'PrivacyHandler';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PrivacyHandler object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'user_id';
    yield serializers.serialize(
      object.userId,
      specifiedType: const FullType(int),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'role';
    yield serializers.serialize(
      object.role,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PrivacyHandler object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PrivacyHandlerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'user_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.userId = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'role':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.role = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PrivacyHandler deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PrivacyHandlerBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}


