//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/automated_response_settings.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/api_error.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'automated_response_settings_envelope.g.dart';

/// AutomatedResponseSettingsEnvelope
///
/// Properties:
/// * [data]
/// * [meta]
/// * [errors]
@BuiltValue()
abstract class AutomatedResponseSettingsEnvelope implements Built<AutomatedResponseSettingsEnvelope, AutomatedResponseSettingsEnvelopeBuilder> {
  @BuiltValueField(wireName: r'data')
  AutomatedResponseSettings get data;

  @BuiltValueField(wireName: r'meta')
  BuiltMap<String, JsonObject?>? get meta;

  @BuiltValueField(wireName: r'errors')
  BuiltList<ApiError>? get errors;

  AutomatedResponseSettingsEnvelope._();

  factory AutomatedResponseSettingsEnvelope([void updates(AutomatedResponseSettingsEnvelopeBuilder b)]) = _$AutomatedResponseSettingsEnvelope;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AutomatedResponseSettingsEnvelopeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AutomatedResponseSettingsEnvelope> get serializer => _$AutomatedResponseSettingsEnvelopeSerializer();
}

class _$AutomatedResponseSettingsEnvelopeSerializer implements PrimitiveSerializer<AutomatedResponseSettingsEnvelope> {
  @override
  final Iterable<Type> types = const [AutomatedResponseSettingsEnvelope, _$AutomatedResponseSettingsEnvelope];

  @override
  final String wireName = r'AutomatedResponseSettingsEnvelope';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AutomatedResponseSettingsEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(AutomatedResponseSettings),
    );
    if (object.meta != null) {
      yield r'meta';
      yield serializers.serialize(
        object.meta,
        specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
      );
    }
    if (object.errors != null) {
      yield r'errors';
      yield serializers.serialize(
        object.errors,
        specifiedType: const FullType(BuiltList, [FullType(ApiError)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    AutomatedResponseSettingsEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AutomatedResponseSettingsEnvelopeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AutomatedResponseSettings),
          ) as AutomatedResponseSettings;
          result.data.replace(valueDes);
          break;
        case r'meta':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>?;
          if (valueDes == null) continue;
          result.meta.replace(valueDes);
          break;
        case r'errors':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(ApiError)]),
          ) as BuiltList<ApiError>?;
          if (valueDes == null) continue;
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
  AutomatedResponseSettingsEnvelope deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AutomatedResponseSettingsEnvelopeBuilder();
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


