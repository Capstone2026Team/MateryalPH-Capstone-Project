//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/api_error.dart';
import 'package:materyalph_api_client/src/model/support_page_meta.dart';
import 'package:materyalph_api_client/src/model/support_handler.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'support_handler_list_response.g.dart';

/// SupportHandlerListResponse
///
/// Properties:
/// * [data]
/// * [meta]
/// * [errors]
@BuiltValue()
abstract class SupportHandlerListResponse implements Built<SupportHandlerListResponse, SupportHandlerListResponseBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<SupportHandler> get data;

  @BuiltValueField(wireName: r'meta')
  SupportPageMeta get meta;

  @BuiltValueField(wireName: r'errors')
  BuiltList<ApiError> get errors;

  SupportHandlerListResponse._();

  factory SupportHandlerListResponse([void updates(SupportHandlerListResponseBuilder b)]) = _$SupportHandlerListResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SupportHandlerListResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SupportHandlerListResponse> get serializer => _$SupportHandlerListResponseSerializer();
}

class _$SupportHandlerListResponseSerializer implements PrimitiveSerializer<SupportHandlerListResponse> {
  @override
  final Iterable<Type> types = const [SupportHandlerListResponse, _$SupportHandlerListResponse];

  @override
  final String wireName = r'SupportHandlerListResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SupportHandlerListResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(SupportHandler)]),
    );
    yield r'meta';
    yield serializers.serialize(
      object.meta,
      specifiedType: const FullType(SupportPageMeta),
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
    SupportHandlerListResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SupportHandlerListResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(SupportHandler)]),
          ) as BuiltList<SupportHandler>;
          result.data.replace(valueDes);
          break;
        case r'meta':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SupportPageMeta),
          ) as SupportPageMeta;
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
  SupportHandlerListResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SupportHandlerListResponseBuilder();
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


