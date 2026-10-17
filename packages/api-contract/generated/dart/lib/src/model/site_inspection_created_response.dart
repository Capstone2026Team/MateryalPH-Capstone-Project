//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/site_inspection_created_response_data.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/api_error.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'site_inspection_created_response.g.dart';

/// SiteInspectionCreatedResponse
///
/// Properties:
/// * [data]
/// * [meta]
/// * [errors]
@BuiltValue()
abstract class SiteInspectionCreatedResponse implements Built<SiteInspectionCreatedResponse, SiteInspectionCreatedResponseBuilder> {
  @BuiltValueField(wireName: r'data')
  SiteInspectionCreatedResponseData get data;

  @BuiltValueField(wireName: r'meta')
  BuiltMap<String, JsonObject?> get meta;

  @BuiltValueField(wireName: r'errors')
  BuiltList<ApiError> get errors;

  SiteInspectionCreatedResponse._();

  factory SiteInspectionCreatedResponse([void updates(SiteInspectionCreatedResponseBuilder b)]) = _$SiteInspectionCreatedResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SiteInspectionCreatedResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SiteInspectionCreatedResponse> get serializer => _$SiteInspectionCreatedResponseSerializer();
}

class _$SiteInspectionCreatedResponseSerializer implements PrimitiveSerializer<SiteInspectionCreatedResponse> {
  @override
  final Iterable<Type> types = const [SiteInspectionCreatedResponse, _$SiteInspectionCreatedResponse];

  @override
  final String wireName = r'SiteInspectionCreatedResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SiteInspectionCreatedResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(SiteInspectionCreatedResponseData),
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
    SiteInspectionCreatedResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SiteInspectionCreatedResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SiteInspectionCreatedResponseData),
          ) as SiteInspectionCreatedResponseData;
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
  SiteInspectionCreatedResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SiteInspectionCreatedResponseBuilder();
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


