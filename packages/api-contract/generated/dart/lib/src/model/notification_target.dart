//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'notification_target.g.dart';

/// NotificationTarget
///
/// Properties:
/// * [path]
@BuiltValue()
abstract class NotificationTarget implements Built<NotificationTarget, NotificationTargetBuilder> {
  @BuiltValueField(wireName: r'path')
  String get path;

  NotificationTarget._();

  factory NotificationTarget([void updates(NotificationTargetBuilder b)]) = _$NotificationTarget;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(NotificationTargetBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<NotificationTarget> get serializer => _$NotificationTargetSerializer();
}

class _$NotificationTargetSerializer implements PrimitiveSerializer<NotificationTarget> {
  @override
  final Iterable<Type> types = const [NotificationTarget, _$NotificationTarget];

  @override
  final String wireName = r'NotificationTarget';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    NotificationTarget object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'path';
    yield serializers.serialize(
      object.path,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    NotificationTarget object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required NotificationTargetBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'path':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.path = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  NotificationTarget deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = NotificationTargetBuilder();
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


