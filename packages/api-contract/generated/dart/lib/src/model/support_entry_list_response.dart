//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/api_error.dart';
import 'package:materyalph_api_client/src/model/support_entry.dart';
import 'package:materyalph_api_client/src/model/support_page_meta.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'support_entry_list_response.g.dart';

/// SupportEntryListResponse
///
/// Properties:
/// * [data]
/// * [meta]
/// * [errors]
@BuiltValue()
abstract class SupportEntryListResponse implements Built<SupportEntryListResponse, SupportEntryListResponseBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<SupportEntry> get data;

  @BuiltValueField(wireName: r'meta')
  SupportPageMeta get meta;

  @BuiltValueField(wireName: r'errors')
  BuiltList<ApiError> get errors;

  SupportEntryListResponse._();

  factory SupportEntryListResponse([void updates(SupportEntryListResponseBuilder b)]) = _$SupportEntryListResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SupportEntryListResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SupportEntryListResponse> get serializer => _$SupportEntryListResponseSerializer();
}

class _$SupportEntryListResponseSerializer implements PrimitiveSerializer<SupportEntryListResponse> {
  @override
  final Iterable<Type> types = const [SupportEntryListResponse, _$SupportEntryListResponse];

  @override
  final String wireName = r'SupportEntryListResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SupportEntryListResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(SupportEntry)]),
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
    SupportEntryListResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SupportEntryListResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(SupportEntry)]),
          ) as BuiltList<SupportEntry>;
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
  SupportEntryListResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SupportEntryListResponseBuilder();
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


