//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/api_error.dart';
import 'package:materyalph_api_client/src/model/vendor_review_list_meta.dart';
import 'package:materyalph_api_client/src/model/vendor_review_row.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_review_list_envelope.g.dart';

/// VendorReviewListEnvelope
///
/// Properties:
/// * [data]
/// * [meta]
/// * [errors]
@BuiltValue()
abstract class VendorReviewListEnvelope implements Built<VendorReviewListEnvelope, VendorReviewListEnvelopeBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<VendorReviewRow> get data;

  @BuiltValueField(wireName: r'meta')
  VendorReviewListMeta get meta;

  @BuiltValueField(wireName: r'errors')
  BuiltList<ApiError> get errors;

  VendorReviewListEnvelope._();

  factory VendorReviewListEnvelope([void updates(VendorReviewListEnvelopeBuilder b)]) = _$VendorReviewListEnvelope;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorReviewListEnvelopeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorReviewListEnvelope> get serializer => _$VendorReviewListEnvelopeSerializer();
}

class _$VendorReviewListEnvelopeSerializer implements PrimitiveSerializer<VendorReviewListEnvelope> {
  @override
  final Iterable<Type> types = const [VendorReviewListEnvelope, _$VendorReviewListEnvelope];

  @override
  final String wireName = r'VendorReviewListEnvelope';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorReviewListEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(VendorReviewRow)]),
    );
    yield r'meta';
    yield serializers.serialize(
      object.meta,
      specifiedType: const FullType(VendorReviewListMeta),
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
    VendorReviewListEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorReviewListEnvelopeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(VendorReviewRow)]),
          ) as BuiltList<VendorReviewRow>;
          result.data.replace(valueDes);
          break;
        case r'meta':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorReviewListMeta),
          ) as VendorReviewListMeta;
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
  VendorReviewListEnvelope deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorReviewListEnvelopeBuilder();
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


