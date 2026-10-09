//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'platform_setting_update_request.g.dart';

/// Needs platform_settings.manage and recent re-authentication. 409 SETTING_VERSION_CONFLICT for a stale version; 422 SETTING_INVALID with field errors.
///
/// Properties:
/// * [value] - The new value in the setting's shape.
/// * [expectedVersion]
/// * [reason]
@BuiltValue()
abstract class PlatformSettingUpdateRequest implements Built<PlatformSettingUpdateRequest, PlatformSettingUpdateRequestBuilder> {
  /// The new value in the setting's shape.
  @BuiltValueField(wireName: r'value')
  JsonObject? get value;

  @BuiltValueField(wireName: r'expected_version')
  int get expectedVersion;

  @BuiltValueField(wireName: r'reason')
  String get reason;

  PlatformSettingUpdateRequest._();

  factory PlatformSettingUpdateRequest([void updates(PlatformSettingUpdateRequestBuilder b)]) = _$PlatformSettingUpdateRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PlatformSettingUpdateRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PlatformSettingUpdateRequest> get serializer => _$PlatformSettingUpdateRequestSerializer();
}

class _$PlatformSettingUpdateRequestSerializer implements PrimitiveSerializer<PlatformSettingUpdateRequest> {
  @override
  final Iterable<Type> types = const [PlatformSettingUpdateRequest, _$PlatformSettingUpdateRequest];

  @override
  final String wireName = r'PlatformSettingUpdateRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PlatformSettingUpdateRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'value';
    yield object.value == null ? null : serializers.serialize(
      object.value,
      specifiedType: const FullType.nullable(JsonObject),
    );
    yield r'expected_version';
    yield serializers.serialize(
      object.expectedVersion,
      specifiedType: const FullType(int),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PlatformSettingUpdateRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PlatformSettingUpdateRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'value':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(JsonObject),
          ) as JsonObject?;
          if (valueDes == null) continue;
          result.value = valueDes;
          break;
        case r'expected_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.expectedVersion = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PlatformSettingUpdateRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PlatformSettingUpdateRequestBuilder();
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


