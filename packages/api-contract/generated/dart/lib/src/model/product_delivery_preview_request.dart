//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'product_delivery_preview_request.g.dart';

/// ProductDeliveryPreviewRequest
///
/// Properties:
/// * [listingVariantId]
/// * [quantity] - Positive quantity up to 1000000
@BuiltValue()
abstract class ProductDeliveryPreviewRequest implements Built<ProductDeliveryPreviewRequest, ProductDeliveryPreviewRequestBuilder> {
  @BuiltValueField(wireName: r'listing_variant_id')
  String get listingVariantId;

  /// Positive quantity up to 1000000
  @BuiltValueField(wireName: r'quantity')
  String get quantity;

  ProductDeliveryPreviewRequest._();

  factory ProductDeliveryPreviewRequest([void updates(ProductDeliveryPreviewRequestBuilder b)]) = _$ProductDeliveryPreviewRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProductDeliveryPreviewRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProductDeliveryPreviewRequest> get serializer => _$ProductDeliveryPreviewRequestSerializer();
}

class _$ProductDeliveryPreviewRequestSerializer implements PrimitiveSerializer<ProductDeliveryPreviewRequest> {
  @override
  final Iterable<Type> types = const [ProductDeliveryPreviewRequest, _$ProductDeliveryPreviewRequest];

  @override
  final String wireName = r'ProductDeliveryPreviewRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProductDeliveryPreviewRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'listing_variant_id';
    yield serializers.serialize(
      object.listingVariantId,
      specifiedType: const FullType(String),
    );
    yield r'quantity';
    yield serializers.serialize(
      object.quantity,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ProductDeliveryPreviewRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProductDeliveryPreviewRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'listing_variant_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.listingVariantId = valueDes;
          break;
        case r'quantity':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.quantity = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProductDeliveryPreviewRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProductDeliveryPreviewRequestBuilder();
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


