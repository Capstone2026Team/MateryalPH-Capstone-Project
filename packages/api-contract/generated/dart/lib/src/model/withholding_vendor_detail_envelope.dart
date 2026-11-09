//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/withholding_vendor_detail_envelope_meta.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/api_error.dart';
import 'package:materyalph_api_client/src/model/withholding_vendor_detail.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'withholding_vendor_detail_envelope.g.dart';

/// WithholdingVendorDetailEnvelope
///
/// Properties:
/// * [data]
/// * [meta]
/// * [errors]
@BuiltValue()
abstract class WithholdingVendorDetailEnvelope implements Built<WithholdingVendorDetailEnvelope, WithholdingVendorDetailEnvelopeBuilder> {
  @BuiltValueField(wireName: r'data')
  WithholdingVendorDetail get data;

  @BuiltValueField(wireName: r'meta')
  WithholdingVendorDetailEnvelopeMeta get meta;

  @BuiltValueField(wireName: r'errors')
  BuiltList<ApiError> get errors;

  WithholdingVendorDetailEnvelope._();

  factory WithholdingVendorDetailEnvelope([void updates(WithholdingVendorDetailEnvelopeBuilder b)]) = _$WithholdingVendorDetailEnvelope;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(WithholdingVendorDetailEnvelopeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<WithholdingVendorDetailEnvelope> get serializer => _$WithholdingVendorDetailEnvelopeSerializer();
}

class _$WithholdingVendorDetailEnvelopeSerializer implements PrimitiveSerializer<WithholdingVendorDetailEnvelope> {
  @override
  final Iterable<Type> types = const [WithholdingVendorDetailEnvelope, _$WithholdingVendorDetailEnvelope];

  @override
  final String wireName = r'WithholdingVendorDetailEnvelope';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    WithholdingVendorDetailEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(WithholdingVendorDetail),
    );
    yield r'meta';
    yield serializers.serialize(
      object.meta,
      specifiedType: const FullType(WithholdingVendorDetailEnvelopeMeta),
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
    WithholdingVendorDetailEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required WithholdingVendorDetailEnvelopeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(WithholdingVendorDetail),
          ) as WithholdingVendorDetail;
          result.data.replace(valueDes);
          break;
        case r'meta':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(WithholdingVendorDetailEnvelopeMeta),
          ) as WithholdingVendorDetailEnvelopeMeta;
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
  WithholdingVendorDetailEnvelope deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = WithholdingVendorDetailEnvelopeBuilder();
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


