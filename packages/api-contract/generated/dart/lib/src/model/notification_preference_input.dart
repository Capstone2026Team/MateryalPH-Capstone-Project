//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'notification_preference_input.g.dart';

/// NotificationPreferenceInput
///
/// Properties:
/// * [category]
/// * [inApp]
/// * [email]
/// * [push]
@BuiltValue()
abstract class NotificationPreferenceInput implements Built<NotificationPreferenceInput, NotificationPreferenceInputBuilder> {
  @BuiltValueField(wireName: r'category')
  String get category;

  @BuiltValueField(wireName: r'in_app')
  bool get inApp;

  @BuiltValueField(wireName: r'email')
  bool get email;

  @BuiltValueField(wireName: r'push')
  bool get push;

  NotificationPreferenceInput._();

  factory NotificationPreferenceInput([void updates(NotificationPreferenceInputBuilder b)]) = _$NotificationPreferenceInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(NotificationPreferenceInputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<NotificationPreferenceInput> get serializer => _$NotificationPreferenceInputSerializer();
}

class _$NotificationPreferenceInputSerializer implements PrimitiveSerializer<NotificationPreferenceInput> {
  @override
  final Iterable<Type> types = const [NotificationPreferenceInput, _$NotificationPreferenceInput];

  @override
  final String wireName = r'NotificationPreferenceInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    NotificationPreferenceInput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'category';
    yield serializers.serialize(
      object.category,
      specifiedType: const FullType(String),
    );
    yield r'in_app';
    yield serializers.serialize(
      object.inApp,
      specifiedType: const FullType(bool),
    );
    yield r'email';
    yield serializers.serialize(
      object.email,
      specifiedType: const FullType(bool),
    );
    yield r'push';
    yield serializers.serialize(
      object.push,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    NotificationPreferenceInput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required NotificationPreferenceInputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.category = valueDes;
          break;
        case r'in_app':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.inApp = valueDes;
          break;
        case r'email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.email = valueDes;
          break;
        case r'push':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.push = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  NotificationPreferenceInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = NotificationPreferenceInputBuilder();
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


