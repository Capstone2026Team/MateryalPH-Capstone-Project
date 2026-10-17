//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/document_export.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'request_document_export202_response.g.dart';

/// RequestDocumentExport202Response
///
/// Properties:
/// * [data]
/// * [meta]
/// * [errors]
@BuiltValue()
abstract class RequestDocumentExport202Response implements Built<RequestDocumentExport202Response, RequestDocumentExport202ResponseBuilder> {
  @BuiltValueField(wireName: r'data')
  DocumentExport get data;

  @BuiltValueField(wireName: r'meta')
  BuiltMap<String, JsonObject?> get meta;

  @BuiltValueField(wireName: r'errors')
  BuiltList<BuiltMap<String, JsonObject?>> get errors;

  RequestDocumentExport202Response._();

  factory RequestDocumentExport202Response([void updates(RequestDocumentExport202ResponseBuilder b)]) = _$RequestDocumentExport202Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RequestDocumentExport202ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RequestDocumentExport202Response> get serializer => _$RequestDocumentExport202ResponseSerializer();
}

class _$RequestDocumentExport202ResponseSerializer implements PrimitiveSerializer<RequestDocumentExport202Response> {
  @override
  final Iterable<Type> types = const [RequestDocumentExport202Response, _$RequestDocumentExport202Response];

  @override
  final String wireName = r'RequestDocumentExport202Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RequestDocumentExport202Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(DocumentExport),
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
    RequestDocumentExport202Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RequestDocumentExport202ResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DocumentExport),
          ) as DocumentExport;
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
  RequestDocumentExport202Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RequestDocumentExport202ResponseBuilder();
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


