//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/listing_detail_fulfillment.dart';
import 'package:materyalph_api_client/src/model/listing_detail_vendor.dart';
import 'package:materyalph_api_client/src/model/listing_compliance.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/listing_image.dart';
import 'package:materyalph_api_client/src/model/discovery_scope.dart';
import 'package:materyalph_api_client/src/model/listing_variant_offer.dart';
import 'package:materyalph_api_client/src/model/product_rating_summary.dart';
import 'package:materyalph_api_client/src/model/listing_category_ref.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'listing_details.g.dart';

/// ListingDetails
///
/// Properties:
/// * [listingId]
/// * [publicationVersion]
/// * [displayName]
/// * [description]
/// * [brand]
/// * [model]
/// * [manufacturer]
/// * [countryOfManufacture]
/// * [category]
/// * [technicalAttributes]
/// * [images]
/// * [compliance]
/// * [productRating]
/// * [unitsSold]
/// * [isFavorite]
/// * [purchasable]
/// * [notPurchasableReason]
/// * [distanceMeters]
/// * [vendor]
/// * [fulfillment]
/// * [variants]
/// * [scope]
/// * [currentAsOf]
/// * [eligibilityVersion]
@BuiltValue()
abstract class ListingDetails implements Built<ListingDetails, ListingDetailsBuilder> {
  @BuiltValueField(wireName: r'listing_id')
  String get listingId;

  @BuiltValueField(wireName: r'publication_version')
  int get publicationVersion;

  @BuiltValueField(wireName: r'display_name')
  String get displayName;

  @BuiltValueField(wireName: r'description')
  String? get description;

  @BuiltValueField(wireName: r'brand')
  String? get brand;

  @BuiltValueField(wireName: r'model')
  String? get model;

  @BuiltValueField(wireName: r'manufacturer')
  String? get manufacturer;

  @BuiltValueField(wireName: r'country_of_manufacture')
  String? get countryOfManufacture;

  @BuiltValueField(wireName: r'category')
  ListingCategoryRef? get category;

  @BuiltValueField(wireName: r'technical_attributes')
  BuiltMap<String, JsonObject?> get technicalAttributes;

  @BuiltValueField(wireName: r'images')
  BuiltList<ListingImage> get images;

  @BuiltValueField(wireName: r'compliance')
  ListingCompliance get compliance;

  @BuiltValueField(wireName: r'product_rating')
  ProductRatingSummary get productRating;

  @BuiltValueField(wireName: r'units_sold')
  String get unitsSold;

  @BuiltValueField(wireName: r'is_favorite')
  bool get isFavorite;

  @BuiltValueField(wireName: r'purchasable')
  bool get purchasable;

  @BuiltValueField(wireName: r'not_purchasable_reason')
  ListingDetailsNotPurchasableReasonEnum? get notPurchasableReason;
  // enum notPurchasableReasonEnum {  OUTSIDE_SELECTED_RADIUS,  STORE_PAUSED,  ,  };

  @BuiltValueField(wireName: r'distance_meters')
  int get distanceMeters;

  @BuiltValueField(wireName: r'vendor')
  ListingDetailVendor get vendor;

  @BuiltValueField(wireName: r'fulfillment')
  ListingDetailFulfillment get fulfillment;

  @BuiltValueField(wireName: r'variants')
  BuiltList<ListingVariantOffer> get variants;

  @BuiltValueField(wireName: r'scope')
  DiscoveryScope get scope;

  @BuiltValueField(wireName: r'current_as_of')
  DateTime get currentAsOf;

  @BuiltValueField(wireName: r'eligibility_version')
  String get eligibilityVersion;

  ListingDetails._();

  factory ListingDetails([void updates(ListingDetailsBuilder b)]) = _$ListingDetails;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ListingDetailsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ListingDetails> get serializer => _$ListingDetailsSerializer();
}

class _$ListingDetailsSerializer implements PrimitiveSerializer<ListingDetails> {
  @override
  final Iterable<Type> types = const [ListingDetails, _$ListingDetails];

  @override
  final String wireName = r'ListingDetails';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ListingDetails object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'listing_id';
    yield serializers.serialize(
      object.listingId,
      specifiedType: const FullType(String),
    );
    yield r'publication_version';
    yield serializers.serialize(
      object.publicationVersion,
      specifiedType: const FullType(int),
    );
    yield r'display_name';
    yield serializers.serialize(
      object.displayName,
      specifiedType: const FullType(String),
    );
    yield r'description';
    yield object.description == null ? null : serializers.serialize(
      object.description,
      specifiedType: const FullType.nullable(String),
    );
    yield r'brand';
    yield object.brand == null ? null : serializers.serialize(
      object.brand,
      specifiedType: const FullType.nullable(String),
    );
    yield r'model';
    yield object.model == null ? null : serializers.serialize(
      object.model,
      specifiedType: const FullType.nullable(String),
    );
    yield r'manufacturer';
    yield object.manufacturer == null ? null : serializers.serialize(
      object.manufacturer,
      specifiedType: const FullType.nullable(String),
    );
    yield r'country_of_manufacture';
    yield object.countryOfManufacture == null ? null : serializers.serialize(
      object.countryOfManufacture,
      specifiedType: const FullType.nullable(String),
    );
    yield r'category';
    yield object.category == null ? null : serializers.serialize(
      object.category,
      specifiedType: const FullType.nullable(ListingCategoryRef),
    );
    yield r'technical_attributes';
    yield serializers.serialize(
      object.technicalAttributes,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
    yield r'images';
    yield serializers.serialize(
      object.images,
      specifiedType: const FullType(BuiltList, [FullType(ListingImage)]),
    );
    yield r'compliance';
    yield serializers.serialize(
      object.compliance,
      specifiedType: const FullType(ListingCompliance),
    );
    yield r'product_rating';
    yield serializers.serialize(
      object.productRating,
      specifiedType: const FullType(ProductRatingSummary),
    );
    yield r'units_sold';
    yield serializers.serialize(
      object.unitsSold,
      specifiedType: const FullType(String),
    );
    yield r'is_favorite';
    yield serializers.serialize(
      object.isFavorite,
      specifiedType: const FullType(bool),
    );
    yield r'purchasable';
    yield serializers.serialize(
      object.purchasable,
      specifiedType: const FullType(bool),
    );
    yield r'not_purchasable_reason';
    yield object.notPurchasableReason == null ? null : serializers.serialize(
      object.notPurchasableReason,
      specifiedType: const FullType.nullable(ListingDetailsNotPurchasableReasonEnum),
    );
    yield r'distance_meters';
    yield serializers.serialize(
      object.distanceMeters,
      specifiedType: const FullType(int),
    );
    yield r'vendor';
    yield serializers.serialize(
      object.vendor,
      specifiedType: const FullType(ListingDetailVendor),
    );
    yield r'fulfillment';
    yield serializers.serialize(
      object.fulfillment,
      specifiedType: const FullType(ListingDetailFulfillment),
    );
    yield r'variants';
    yield serializers.serialize(
      object.variants,
      specifiedType: const FullType(BuiltList, [FullType(ListingVariantOffer)]),
    );
    yield r'scope';
    yield serializers.serialize(
      object.scope,
      specifiedType: const FullType(DiscoveryScope),
    );
    yield r'current_as_of';
    yield serializers.serialize(
      object.currentAsOf,
      specifiedType: const FullType(DateTime),
    );
    yield r'eligibility_version';
    yield serializers.serialize(
      object.eligibilityVersion,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ListingDetails object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ListingDetailsBuilder result,
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
        case r'publication_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.publicationVersion = valueDes;
          break;
        case r'display_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.displayName = valueDes;
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.description = valueDes;
          break;
        case r'brand':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.brand = valueDes;
          break;
        case r'model':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.model = valueDes;
          break;
        case r'manufacturer':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.manufacturer = valueDes;
          break;
        case r'country_of_manufacture':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.countryOfManufacture = valueDes;
          break;
        case r'category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ListingCategoryRef),
          ) as ListingCategoryRef?;
          if (valueDes == null) continue;
          result.category.replace(valueDes);
          break;
        case r'technical_attributes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.technicalAttributes.replace(valueDes);
          break;
        case r'images':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ListingImage)]),
          ) as BuiltList<ListingImage>;
          result.images.replace(valueDes);
          break;
        case r'compliance':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ListingCompliance),
          ) as ListingCompliance;
          result.compliance.replace(valueDes);
          break;
        case r'product_rating':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ProductRatingSummary),
          ) as ProductRatingSummary;
          result.productRating.replace(valueDes);
          break;
        case r'units_sold':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.unitsSold = valueDes;
          break;
        case r'is_favorite':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isFavorite = valueDes;
          break;
        case r'purchasable':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.purchasable = valueDes;
          break;
        case r'not_purchasable_reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ListingDetailsNotPurchasableReasonEnum),
          ) as ListingDetailsNotPurchasableReasonEnum?;
          if (valueDes == null) continue;
          result.notPurchasableReason = valueDes;
          break;
        case r'distance_meters':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.distanceMeters = valueDes;
          break;
        case r'vendor':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ListingDetailVendor),
          ) as ListingDetailVendor;
          result.vendor.replace(valueDes);
          break;
        case r'fulfillment':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ListingDetailFulfillment),
          ) as ListingDetailFulfillment;
          result.fulfillment.replace(valueDes);
          break;
        case r'variants':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ListingVariantOffer)]),
          ) as BuiltList<ListingVariantOffer>;
          result.variants.replace(valueDes);
          break;
        case r'scope':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DiscoveryScope),
          ) as DiscoveryScope;
          result.scope.replace(valueDes);
          break;
        case r'current_as_of':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.currentAsOf = valueDes;
          break;
        case r'eligibility_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.eligibilityVersion = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ListingDetails deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ListingDetailsBuilder();
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


class ListingDetailsNotPurchasableReasonEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'OUTSIDE_SELECTED_RADIUS')
  static const ListingDetailsNotPurchasableReasonEnum OUTSIDE_SELECTED_RADIUS = _$listingDetailsNotPurchasableReasonEnum_OUTSIDE_SELECTED_RADIUS;
  @BuiltValueEnumConst(wireName: r'STORE_PAUSED')
  static const ListingDetailsNotPurchasableReasonEnum STORE_PAUSED = _$listingDetailsNotPurchasableReasonEnum_STORE_PAUSED;

  static Serializer<ListingDetailsNotPurchasableReasonEnum> get serializer => _$listingDetailsNotPurchasableReasonEnumSerializer;

  const ListingDetailsNotPurchasableReasonEnum._(String name): super(name);

  static BuiltSet<ListingDetailsNotPurchasableReasonEnum> get values => _$listingDetailsNotPurchasableReasonEnumValues;
  static ListingDetailsNotPurchasableReasonEnum valueOf(String name) => _$listingDetailsNotPurchasableReasonEnumValueOf(name);
}

