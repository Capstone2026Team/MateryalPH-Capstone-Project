//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'notification_preference.g.dart';

/// MESSAGES is optional; its in_app and push channels default to enabled and email defaults to disabled. Mandatory security, payment, refund, dispute and legal notices remain enabled.
///
/// Properties:
/// * [category]
/// * [mandatory]
/// * [explanation]
/// * [inApp]
/// * [email]
/// * [push]
@BuiltValue()
abstract class NotificationPreference implements Built<NotificationPreference, NotificationPreferenceBuilder> {
  @BuiltValueField(wireName: r'category')
  String get category;

  @BuiltValueField(wireName: r'mandatory')
  bool get mandatory;

  @BuiltValueField(wireName: r'explanation')
  String get explanation;

  @BuiltValueField(wireName: r'in_app')
  bool get inApp;

  @BuiltValueField(wireName: r'email')
  bool get email;

  @BuiltValueField(wireName: r'push')
  bool get push;

  NotificationPreference._();

  factory NotificationPreference([void updates(NotificationPreferenceBuilder b)]) = _$NotificationPreference;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(NotificationPreferenceBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<NotificationPreference> get serializer => _$NotificationPreferenceSerializer();
}

class _$NotificationPreferenceSerializer implements PrimitiveSerializer<NotificationPreference> {
  @override
  final Iterable<Type> types = const [NotificationPreference, _$NotificationPreference];

  @override
  final String wireName = r'NotificationPreference';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    NotificationPreference object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'category';
    yield serializers.serialize(
      object.category,
      specifiedType: const FullType(String),
    );
    yield r'mandatory';
    yield serializers.serialize(
      object.mandatory,
      specifiedType: const FullType(bool),
    );
    yield r'explanation';
    yield serializers.serialize(
      object.explanation,
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
    NotificationPreference object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required NotificationPreferenceBuilder result,
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
        case r'mandatory':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.mandatory = valueDes;
          break;
        case r'explanation':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.explanation = valueDes;
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
  NotificationPreference deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = NotificationPreferenceBuilder();
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


