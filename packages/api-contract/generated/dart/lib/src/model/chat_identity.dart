//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'chat_identity.g.dart';

/// ChatIdentity
///
/// Properties:
/// * [displayName]
/// * [role]
/// * [avatarPath]
@BuiltValue()
abstract class ChatIdentity implements Built<ChatIdentity, ChatIdentityBuilder> {
  @BuiltValueField(wireName: r'display_name')
  String get displayName;

  @BuiltValueField(wireName: r'role')
  String get role;

  @BuiltValueField(wireName: r'avatar_path')
  String? get avatarPath;

  ChatIdentity._();

  factory ChatIdentity([void updates(ChatIdentityBuilder b)]) = _$ChatIdentity;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ChatIdentityBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ChatIdentity> get serializer => _$ChatIdentitySerializer();
}

class _$ChatIdentitySerializer implements PrimitiveSerializer<ChatIdentity> {
  @override
  final Iterable<Type> types = const [ChatIdentity, _$ChatIdentity];

  @override
  final String wireName = r'ChatIdentity';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ChatIdentity object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'display_name';
    yield serializers.serialize(
      object.displayName,
      specifiedType: const FullType(String),
    );
    yield r'role';
    yield serializers.serialize(
      object.role,
      specifiedType: const FullType(String),
    );
    if (object.avatarPath != null) {
      yield r'avatar_path';
      yield serializers.serialize(
        object.avatarPath,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ChatIdentity object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ChatIdentityBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'display_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.displayName = valueDes;
          break;
        case r'role':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.role = valueDes;
          break;
        case r'avatar_path':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.avatarPath = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ChatIdentity deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ChatIdentityBuilder();
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


