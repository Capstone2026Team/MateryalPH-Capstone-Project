//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/notification_unread_count.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/api_error.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'get_notification_unread_count200_response.g.dart';

/// GetNotificationUnreadCount200Response
///
/// Properties:
/// * [data]
/// * [meta]
/// * [errors]
@BuiltValue()
abstract class GetNotificationUnreadCount200Response implements Built<GetNotificationUnreadCount200Response, GetNotificationUnreadCount200ResponseBuilder> {
  @BuiltValueField(wireName: r'data')
  NotificationUnreadCount get data;

  @BuiltValueField(wireName: r'meta')
  BuiltMap<String, JsonObject?> get meta;

  @BuiltValueField(wireName: r'errors')
  BuiltList<ApiError> get errors;

  GetNotificationUnreadCount200Response._();

  factory GetNotificationUnreadCount200Response([void updates(GetNotificationUnreadCount200ResponseBuilder b)]) = _$GetNotificationUnreadCount200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GetNotificationUnreadCount200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GetNotificationUnreadCount200Response> get serializer => _$GetNotificationUnreadCount200ResponseSerializer();
}

class _$GetNotificationUnreadCount200ResponseSerializer implements PrimitiveSerializer<GetNotificationUnreadCount200Response> {
  @override
  final Iterable<Type> types = const [GetNotificationUnreadCount200Response, _$GetNotificationUnreadCount200Response];

  @override
  final String wireName = r'GetNotificationUnreadCount200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GetNotificationUnreadCount200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(NotificationUnreadCount),
    );
    yield r'meta';
    yield serializers.serialize(
      object.meta,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
    yield r'errors';
    yield serializers.serialize(
      object.errors,
      specifiedType: const FullType(BuiltList, [FullType(ApiError)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    GetNotificationUnreadCount200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GetNotificationUnreadCount200ResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(NotificationUnreadCount),
          ) as NotificationUnreadCount;
          result.data.replace(valueDes);
          break;
        case r'meta':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.meta.replace(valueDes);
          break;
        case r'errors':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ApiError)]),
          ) as BuiltList<ApiError>;
          result.errors.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GetNotificationUnreadCount200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GetNotificationUnreadCount200ResponseBuilder();
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


