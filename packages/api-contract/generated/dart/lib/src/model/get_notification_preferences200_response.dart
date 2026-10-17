//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/notification_preference.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'get_notification_preferences200_response.g.dart';

/// GetNotificationPreferences200Response
///
/// Properties:
/// * [data]
/// * [meta]
/// * [errors]
@BuiltValue()
abstract class GetNotificationPreferences200Response implements Built<GetNotificationPreferences200Response, GetNotificationPreferences200ResponseBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<NotificationPreference> get data;

  @BuiltValueField(wireName: r'meta')
  BuiltMap<String, JsonObject?> get meta;

  @BuiltValueField(wireName: r'errors')
  BuiltList<BuiltMap<String, JsonObject?>> get errors;

  GetNotificationPreferences200Response._();

  factory GetNotificationPreferences200Response([void updates(GetNotificationPreferences200ResponseBuilder b)]) = _$GetNotificationPreferences200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GetNotificationPreferences200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GetNotificationPreferences200Response> get serializer => _$GetNotificationPreferences200ResponseSerializer();
}

class _$GetNotificationPreferences200ResponseSerializer implements PrimitiveSerializer<GetNotificationPreferences200Response> {
  @override
  final Iterable<Type> types = const [GetNotificationPreferences200Response, _$GetNotificationPreferences200Response];

  @override
  final String wireName = r'GetNotificationPreferences200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GetNotificationPreferences200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(NotificationPreference)]),
    );
    yield r'meta';
    yield serializers.serialize(
      object.meta,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
    yield r'errors';
    yield serializers.serialize(
      object.errors,
      specifiedType: const FullType(BuiltList, [FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)])]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    GetNotificationPreferences200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GetNotificationPreferences200ResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(NotificationPreference)]),
          ) as BuiltList<NotificationPreference>;
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
            specifiedType: const FullType(BuiltList, [FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)])]),
          ) as BuiltList<BuiltMap<String, JsonObject?>>;
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
  GetNotificationPreferences200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GetNotificationPreferences200ResponseBuilder();
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


