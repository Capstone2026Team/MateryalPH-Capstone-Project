//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/analytics_category_ref.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/comparable_specification.dart';
import 'package:materyalph_api_client/src/model/listing_image.dart';
import 'package:materyalph_api_client/src/model/analytics_unit.dart';
import 'package:materyalph_api_client/src/model/analytics_material_ref.dart';
import 'package:materyalph_api_client/src/model/analytics_price_range.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'buyer_analytics_product_variant.g.dart';

/// BuyerAnalyticsProductVariant
///
/// Properties:
/// * [groupId]
/// * [displayName]
/// * [material]
/// * [category]
/// * [specification]
/// * [unit]
/// * [vendorCount]
/// * [listingCount]
/// * [price]
/// * [availability] - Best public stock label among current offers.
/// * [image]
@BuiltValue()
abstract class BuyerAnalyticsProductVariant implements Built<BuyerAnalyticsProductVariant, BuyerAnalyticsProductVariantBuilder> {
  @BuiltValueField(wireName: r'group_id')
  String get groupId;

  @BuiltValueField(wireName: r'display_name')
  String get displayName;

  @BuiltValueField(wireName: r'material')
  AnalyticsMaterialRef get material;

  @BuiltValueField(wireName: r'category')
  AnalyticsCategoryRef get category;

  @BuiltValueField(wireName: r'specification')
  ComparableSpecification get specification;

  @BuiltValueField(wireName: r'unit')
  AnalyticsUnit get unit;

  @BuiltValueField(wireName: r'vendor_count')
  int get vendorCount;

  @BuiltValueField(wireName: r'listing_count')
  int get listingCount;

  @BuiltValueField(wireName: r'price')
  AnalyticsPriceRange get price;

  /// Best public stock label among current offers.
  @BuiltValueField(wireName: r'availability')
  BuyerAnalyticsProductVariantAvailabilityEnum get availability;
  // enum availabilityEnum {  IN_STOCK,  LIMITED_STOCK,  NO_CURRENT_OFFERS,  };

  @BuiltValueField(wireName: r'image')
  ListingImage? get image;

  BuyerAnalyticsProductVariant._();

  factory BuyerAnalyticsProductVariant([void updates(BuyerAnalyticsProductVariantBuilder b)]) = _$BuyerAnalyticsProductVariant;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BuyerAnalyticsProductVariantBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BuyerAnalyticsProductVariant> get serializer => _$BuyerAnalyticsProductVariantSerializer();
}

class _$BuyerAnalyticsProductVariantSerializer implements PrimitiveSerializer<BuyerAnalyticsProductVariant> {
  @override
  final Iterable<Type> types = const [BuyerAnalyticsProductVariant, _$BuyerAnalyticsProductVariant];

  @override
  final String wireName = r'BuyerAnalyticsProductVariant';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BuyerAnalyticsProductVariant object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'group_id';
    yield serializers.serialize(
      object.groupId,
      specifiedType: const FullType(String),
    );
    yield r'display_name';
    yield serializers.serialize(
      object.displayName,
      specifiedType: const FullType(String),
    );
    yield r'material';
    yield serializers.serialize(
      object.material,
      specifiedType: const FullType(AnalyticsMaterialRef),
    );
    yield r'category';
    yield serializers.serialize(
      object.category,
      specifiedType: const FullType(AnalyticsCategoryRef),
    );
    yield r'specification';
    yield serializers.serialize(
      object.specification,
      specifiedType: const FullType(ComparableSpecification),
    );
    yield r'unit';
    yield serializers.serialize(
      object.unit,
      specifiedType: const FullType(AnalyticsUnit),
    );
    yield r'vendor_count';
    yield serializers.serialize(
      object.vendorCount,
      specifiedType: const FullType(int),
    );
    yield r'listing_count';
    yield serializers.serialize(
      object.listingCount,
      specifiedType: const FullType(int),
    );
    yield r'price';
    yield serializers.serialize(
      object.price,
      specifiedType: const FullType(AnalyticsPriceRange),
    );
    yield r'availability';
    yield serializers.serialize(
      object.availability,
      specifiedType: const FullType(BuyerAnalyticsProductVariantAvailabilityEnum),
    );
    if (object.image != null) {
      yield r'image';
      yield serializers.serialize(
        object.image,
        specifiedType: const FullType.nullable(ListingImage),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    BuyerAnalyticsProductVariant object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BuyerAnalyticsProductVariantBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'group_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.groupId = valueDes;
          break;
        case r'display_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.displayName = valueDes;
          break;
        case r'material':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AnalyticsMaterialRef),
          ) as AnalyticsMaterialRef;
          result.material.replace(valueDes);
          break;
        case r'category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AnalyticsCategoryRef),
          ) as AnalyticsCategoryRef;
          result.category.replace(valueDes);
          break;
        case r'specification':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ComparableSpecification),
          ) as ComparableSpecification;
          result.specification.replace(valueDes);
          break;
        case r'unit':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AnalyticsUnit),
          ) as AnalyticsUnit;
          result.unit.replace(valueDes);
          break;
        case r'vendor_count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.vendorCount = valueDes;
          break;
        case r'listing_count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.listingCount = valueDes;
          break;
        case r'price':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AnalyticsPriceRange),
          ) as AnalyticsPriceRange;
          result.price.replace(valueDes);
          break;
        case r'availability':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuyerAnalyticsProductVariantAvailabilityEnum),
          ) as BuyerAnalyticsProductVariantAvailabilityEnum;
          result.availability = valueDes;
          break;
        case r'image':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ListingImage),
          ) as ListingImage?;
          if (valueDes == null) continue;
          result.image.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BuyerAnalyticsProductVariant deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BuyerAnalyticsProductVariantBuilder();
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


/// Best public stock label among current offers.
class BuyerAnalyticsProductVariantAvailabilityEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'IN_STOCK')
  static const BuyerAnalyticsProductVariantAvailabilityEnum IN_STOCK = _$buyerAnalyticsProductVariantAvailabilityEnum_IN_STOCK;
  @BuiltValueEnumConst(wireName: r'LIMITED_STOCK')
  static const BuyerAnalyticsProductVariantAvailabilityEnum LIMITED_STOCK = _$buyerAnalyticsProductVariantAvailabilityEnum_LIMITED_STOCK;
  @BuiltValueEnumConst(wireName: r'NO_CURRENT_OFFERS')
  static const BuyerAnalyticsProductVariantAvailabilityEnum NO_CURRENT_OFFERS = _$buyerAnalyticsProductVariantAvailabilityEnum_NO_CURRENT_OFFERS;

  static Serializer<BuyerAnalyticsProductVariantAvailabilityEnum> get serializer => _$buyerAnalyticsProductVariantAvailabilityEnumSerializer;

  const BuyerAnalyticsProductVariantAvailabilityEnum._(String name): super(name);

  static BuiltSet<BuyerAnalyticsProductVariantAvailabilityEnum> get values => _$buyerAnalyticsProductVariantAvailabilityEnumValues;
  static BuyerAnalyticsProductVariantAvailabilityEnum valueOf(String name) => _$buyerAnalyticsProductVariantAvailabilityEnumValueOf(name);
}

