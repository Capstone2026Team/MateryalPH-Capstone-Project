//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_own_offer.g.dart';

/// Your own current comparable price; never part of the competitor average.
///
/// Properties:
/// * [listingId]
/// * [variantId]
/// * [displayName]
/// * [variantLabel]
/// * [priceCentavos]
/// * [normalizedPhp]
/// * [taxLabel]
/// * [priceAsOf]
@BuiltValue()
abstract class VendorOwnOffer implements Built<VendorOwnOffer, VendorOwnOfferBuilder> {
  @BuiltValueField(wireName: r'listing_id')
  String get listingId;

  @BuiltValueField(wireName: r'variant_id')
  String get variantId;

  @BuiltValueField(wireName: r'display_name')
  String get displayName;

  @BuiltValueField(wireName: r'variant_label')
  String? get variantLabel;

  @BuiltValueField(wireName: r'price_centavos')
  int get priceCentavos;

  @BuiltValueField(wireName: r'normalized_php')
  String get normalizedPhp;

  @BuiltValueField(wireName: r'tax_label')
  String get taxLabel;

  @BuiltValueField(wireName: r'price_as_of')
  DateTime get priceAsOf;

  VendorOwnOffer._();

  factory VendorOwnOffer([void updates(VendorOwnOfferBuilder b)]) = _$VendorOwnOffer;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorOwnOfferBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorOwnOffer> get serializer => _$VendorOwnOfferSerializer();
}

class _$VendorOwnOfferSerializer implements PrimitiveSerializer<VendorOwnOffer> {
  @override
  final Iterable<Type> types = const [VendorOwnOffer, _$VendorOwnOffer];

  @override
  final String wireName = r'VendorOwnOffer';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorOwnOffer object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'listing_id';
    yield serializers.serialize(
      object.listingId,
      specifiedType: const FullType(String),
    );
    yield r'variant_id';
    yield serializers.serialize(
      object.variantId,
      specifiedType: const FullType(String),
    );
    yield r'display_name';
    yield serializers.serialize(
      object.displayName,
      specifiedType: const FullType(String),
    );
    if (object.variantLabel != null) {
      yield r'variant_label';
      yield serializers.serialize(
        object.variantLabel,
        specifiedType: const FullType(String),
      );
    }
    yield r'price_centavos';
    yield serializers.serialize(
      object.priceCentavos,
      specifiedType: const FullType(int),
    );
    yield r'normalized_php';
    yield serializers.serialize(
      object.normalizedPhp,
      specifiedType: const FullType(String),
    );
    yield r'tax_label';
    yield serializers.serialize(
      object.taxLabel,
      specifiedType: const FullType(String),
    );
    yield r'price_as_of';
    yield serializers.serialize(
      object.priceAsOf,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorOwnOffer object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorOwnOfferBuilder result,
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
        case r'variant_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.variantId = valueDes;
          break;
        case r'display_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.displayName = valueDes;
          break;
        case r'variant_label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.variantLabel = valueDes;
          break;
        case r'price_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.priceCentavos = valueDes;
          break;
        case r'normalized_php':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.normalizedPhp = valueDes;
          break;
        case r'tax_label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.taxLabel = valueDes;
          break;
        case r'price_as_of':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.priceAsOf = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorOwnOffer deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorOwnOfferBuilder();
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


