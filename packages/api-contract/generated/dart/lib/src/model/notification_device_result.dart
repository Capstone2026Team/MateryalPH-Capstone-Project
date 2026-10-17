//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'notification_device_result.g.dart';

/// NotificationDeviceResult
///
/// Properties:
/// * [id]
@BuiltValue()
abstract class NotificationDeviceResult implements Built<NotificationDeviceResult, NotificationDeviceResultBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  NotificationDeviceResult._();

  factory NotificationDeviceResult([void updates(NotificationDeviceResultBuilder b)]) = _$NotificationDeviceResult;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(NotificationDeviceResultBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<NotificationDeviceResult> get serializer => _$NotificationDeviceResultSerializer();
}

class _$NotificationDeviceResultSerializer implements PrimitiveSerializer<NotificationDeviceResult> {
  @override
  final Iterable<Type> types = const [NotificationDeviceResult, _$NotificationDeviceResult];

  @override
  final String wireName = r'NotificationDeviceResult';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    NotificationDeviceResult object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    NotificationDeviceResult object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required NotificationDeviceResultBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  NotificationDeviceResult deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = NotificationDeviceResultBuilder();
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


