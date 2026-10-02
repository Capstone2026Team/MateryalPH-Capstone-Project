//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/finance_review_item.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/api_error.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'finance_review_item_list_envelope.g.dart';

/// FinanceReviewItemListEnvelope
///
/// Properties:
/// * [data]
/// * [meta]
/// * [errors]
@BuiltValue()
abstract class FinanceReviewItemListEnvelope implements Built<FinanceReviewItemListEnvelope, FinanceReviewItemListEnvelopeBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<FinanceReviewItem> get data;

  @BuiltValueField(wireName: r'meta')
  BuiltMap<String, JsonObject?> get meta;

  @BuiltValueField(wireName: r'errors')
  BuiltList<ApiError> get errors;

  FinanceReviewItemListEnvelope._();

  factory FinanceReviewItemListEnvelope([void updates(FinanceReviewItemListEnvelopeBuilder b)]) = _$FinanceReviewItemListEnvelope;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FinanceReviewItemListEnvelopeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FinanceReviewItemListEnvelope> get serializer => _$FinanceReviewItemListEnvelopeSerializer();
}

class _$FinanceReviewItemListEnvelopeSerializer implements PrimitiveSerializer<FinanceReviewItemListEnvelope> {
  @override
  final Iterable<Type> types = const [FinanceReviewItemListEnvelope, _$FinanceReviewItemListEnvelope];

  @override
  final String wireName = r'FinanceReviewItemListEnvelope';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FinanceReviewItemListEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(FinanceReviewItem)]),
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
    FinanceReviewItemListEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FinanceReviewItemListEnvelopeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(FinanceReviewItem)]),
          ) as BuiltList<FinanceReviewItem>;
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
  FinanceReviewItemListEnvelope deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FinanceReviewItemListEnvelopeBuilder();
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


