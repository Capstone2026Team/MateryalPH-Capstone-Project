//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'material_offer.g.dart';

/// Buyer-only current public offer; opens the existing Product Details. Never exact stock.
///
/// Properties:
/// * [vendorId]
/// * [storeName]
/// * [listingId]
/// * [variantId]
/// * [displayName]
/// * [variantLabel]
/// * [priceCentavos]
/// * [normalizedPhp]
/// * [taxCategory]
/// * [taxLabel]
/// * [availability]
/// * [distanceMeters]
/// * [priceAsOf]
@BuiltValue()
abstract class MaterialOffer implements Built<MaterialOffer, MaterialOfferBuilder> {
  @BuiltValueField(wireName: r'vendor_id')
  String get vendorId;

  @BuiltValueField(wireName: r'store_name')
  String get storeName;

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

  @BuiltValueField(wireName: r'tax_category')
  String get taxCategory;

  @BuiltValueField(wireName: r'tax_label')
  String get taxLabel;

  @BuiltValueField(wireName: r'availability')
  MaterialOfferAvailabilityEnum get availability;
  // enum availabilityEnum {  IN_STOCK,  LIMITED_STOCK,  OUT_OF_STOCK,  };

  @BuiltValueField(wireName: r'distance_meters')
  int get distanceMeters;

  @BuiltValueField(wireName: r'price_as_of')
  DateTime get priceAsOf;

  MaterialOffer._();

  factory MaterialOffer([void updates(MaterialOfferBuilder b)]) = _$MaterialOffer;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MaterialOfferBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MaterialOffer> get serializer => _$MaterialOfferSerializer();
}

class _$MaterialOfferSerializer implements PrimitiveSerializer<MaterialOffer> {
  @override
  final Iterable<Type> types = const [MaterialOffer, _$MaterialOffer];

  @override
  final String wireName = r'MaterialOffer';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MaterialOffer object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'vendor_id';
    yield serializers.serialize(
      object.vendorId,
      specifiedType: const FullType(String),
    );
    yield r'store_name';
    yield serializers.serialize(
      object.storeName,
      specifiedType: const FullType(String),
    );
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
    yield r'tax_category';
    yield serializers.serialize(
      object.taxCategory,
      specifiedType: const FullType(String),
    );
    yield r'tax_label';
    yield serializers.serialize(
      object.taxLabel,
      specifiedType: const FullType(String),
    );
    yield r'availability';
    yield serializers.serialize(
      object.availability,
      specifiedType: const FullType(MaterialOfferAvailabilityEnum),
    );
    yield r'distance_meters';
    yield serializers.serialize(
      object.distanceMeters,
      specifiedType: const FullType(int),
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
    MaterialOffer object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MaterialOfferBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'vendor_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.vendorId = valueDes;
          break;
        case r'store_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.storeName = valueDes;
          break;
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
        case r'tax_category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.taxCategory = valueDes;
          break;
        case r'tax_label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.taxLabel = valueDes;
          break;
        case r'availability':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(MaterialOfferAvailabilityEnum),
          ) as MaterialOfferAvailabilityEnum;
          result.availability = valueDes;
          break;
        case r'distance_meters':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.distanceMeters = valueDes;
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
  MaterialOffer deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MaterialOfferBuilder();
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


class MaterialOfferAvailabilityEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'IN_STOCK')
  static const MaterialOfferAvailabilityEnum IN_STOCK = _$materialOfferAvailabilityEnum_IN_STOCK;
  @BuiltValueEnumConst(wireName: r'LIMITED_STOCK')
  static const MaterialOfferAvailabilityEnum LIMITED_STOCK = _$materialOfferAvailabilityEnum_LIMITED_STOCK;
  @BuiltValueEnumConst(wireName: r'OUT_OF_STOCK')
  static const MaterialOfferAvailabilityEnum OUT_OF_STOCK = _$materialOfferAvailabilityEnum_OUT_OF_STOCK;

  static Serializer<MaterialOfferAvailabilityEnum> get serializer => _$materialOfferAvailabilityEnumSerializer;

  const MaterialOfferAvailabilityEnum._(String name): super(name);

  static BuiltSet<MaterialOfferAvailabilityEnum> get values => _$materialOfferAvailabilityEnumValues;
  static MaterialOfferAvailabilityEnum valueOf(String name) => _$materialOfferAvailabilityEnumValueOf(name);
}

