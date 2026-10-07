//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'notification_device_input.g.dart';

/// NotificationDeviceInput
///
/// Properties:
/// * [platform]
/// * [token]
@BuiltValue()
abstract class NotificationDeviceInput implements Built<NotificationDeviceInput, NotificationDeviceInputBuilder> {
  @BuiltValueField(wireName: r'platform')
  NotificationDeviceInputPlatformEnum get platform;
  // enum platformEnum {  ANDROID,  IOS,  WEB,  };

  @BuiltValueField(wireName: r'token')
  String get token;

  NotificationDeviceInput._();

  factory NotificationDeviceInput([void updates(NotificationDeviceInputBuilder b)]) = _$NotificationDeviceInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(NotificationDeviceInputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<NotificationDeviceInput> get serializer => _$NotificationDeviceInputSerializer();
}

class _$NotificationDeviceInputSerializer implements PrimitiveSerializer<NotificationDeviceInput> {
  @override
  final Iterable<Type> types = const [NotificationDeviceInput, _$NotificationDeviceInput];

  @override
  final String wireName = r'NotificationDeviceInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    NotificationDeviceInput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'platform';
    yield serializers.serialize(
      object.platform,
      specifiedType: const FullType(NotificationDeviceInputPlatformEnum),
    );
    yield r'token';
    yield serializers.serialize(
      object.token,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    NotificationDeviceInput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required NotificationDeviceInputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'platform':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(NotificationDeviceInputPlatformEnum),
          ) as NotificationDeviceInputPlatformEnum;
          result.platform = valueDes;
          break;
        case r'token':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.token = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  NotificationDeviceInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = NotificationDeviceInputBuilder();
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


class NotificationDeviceInputPlatformEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ANDROID')
  static const NotificationDeviceInputPlatformEnum ANDROID = _$notificationDeviceInputPlatformEnum_ANDROID;
  @BuiltValueEnumConst(wireName: r'IOS')
  static const NotificationDeviceInputPlatformEnum IOS = _$notificationDeviceInputPlatformEnum_IOS;
  @BuiltValueEnumConst(wireName: r'WEB')
  static const NotificationDeviceInputPlatformEnum WEB = _$notificationDeviceInputPlatformEnum_WEB;

  static Serializer<NotificationDeviceInputPlatformEnum> get serializer => _$notificationDeviceInputPlatformEnumSerializer;

  const NotificationDeviceInputPlatformEnum._(String name): super(name);

  static BuiltSet<NotificationDeviceInputPlatformEnum> get values => _$notificationDeviceInputPlatformEnumValues;
  static NotificationDeviceInputPlatformEnum valueOf(String name) => _$notificationDeviceInputPlatformEnumValueOf(name);
}

