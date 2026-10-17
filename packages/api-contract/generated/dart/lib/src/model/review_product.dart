//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'review_product.g.dart';

/// ReviewProduct
///
/// Properties:
/// * [listingId]
/// * [name] - Purchased product name preserved in the order line snapshot.
/// * [variantLabel]
@BuiltValue()
abstract class ReviewProduct implements Built<ReviewProduct, ReviewProductBuilder> {
  @BuiltValueField(wireName: r'listing_id')
  String get listingId;

  /// Purchased product name preserved in the order line snapshot.
  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'variant_label')
  String? get variantLabel;

  ReviewProduct._();

  factory ReviewProduct([void updates(ReviewProductBuilder b)]) = _$ReviewProduct;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ReviewProductBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ReviewProduct> get serializer => _$ReviewProductSerializer();
}

class _$ReviewProductSerializer implements PrimitiveSerializer<ReviewProduct> {
  @override
  final Iterable<Type> types = const [ReviewProduct, _$ReviewProduct];

  @override
  final String wireName = r'ReviewProduct';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ReviewProduct object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'listing_id';
    yield serializers.serialize(
      object.listingId,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'variant_label';
    yield object.variantLabel == null ? null : serializers.serialize(
      object.variantLabel,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ReviewProduct object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ReviewProductBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'listing_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.listingId = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'variant_label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.variantLabel = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ReviewProduct deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ReviewProductBuilder();
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


