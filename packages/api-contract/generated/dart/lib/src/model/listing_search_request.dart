//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/listing_search_sort.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'listing_search_request.g.dart';

/// Origin fields as BuyerOriginRequest plus optional filters. ANY means no filter. A cursor is valid only for the same scope, query, sort, weights and filters.
///
/// Properties:
/// * [locationId]
/// * [latitude]
/// * [longitude]
/// * [originSource]
/// * [radiusKm]
/// * [query]
/// * [sort]
/// * [categoryId]
/// * [brand]
/// * [variant]
/// * [availability]
/// * [fulfillment]
/// * [favoritesOnly]
/// * [compliance]
/// * [minPriceCentavos]
/// * [maxPriceCentavos]
/// * [vendorId] - Browse one Verified Vendor's eligible listings from its Store Profile.
/// * [cursor]
/// * [perPage]
@BuiltValue()
abstract class ListingSearchRequest implements Built<ListingSearchRequest, ListingSearchRequestBuilder> {
  @BuiltValueField(wireName: r'location_id')
  String? get locationId;

  @BuiltValueField(wireName: r'latitude')
  double? get latitude;

  @BuiltValueField(wireName: r'longitude')
  double? get longitude;

  @BuiltValueField(wireName: r'origin_source')
  ListingSearchRequestOriginSourceEnum? get originSource;
  // enum originSourceEnum {  DEVICE,  MAP_PIN,  SEARCH,  };

  @BuiltValueField(wireName: r'radius_km')
  int? get radiusKm;

  @BuiltValueField(wireName: r'query')
  String? get query;

  @BuiltValueField(wireName: r'sort')
  ListingSearchSort? get sort;
  // enum sortEnum {  BEST_DEAL,  DISTANCE,  PRICE,  RATING,  FAVORITES_FIRST,  };

  @BuiltValueField(wireName: r'category_id')
  String? get categoryId;

  @BuiltValueField(wireName: r'brand')
  String? get brand;

  @BuiltValueField(wireName: r'variant')
  String? get variant;

  @BuiltValueField(wireName: r'availability')
  ListingSearchRequestAvailabilityEnum? get availability;
  // enum availabilityEnum {  ANY,  IN_STOCK,  ,  };

  @BuiltValueField(wireName: r'fulfillment')
  ListingSearchRequestFulfillmentEnum? get fulfillment;
  // enum fulfillmentEnum {  ANY,  DELIVERY,  PICKUP,  ,  };

  @BuiltValueField(wireName: r'favorites_only')
  bool? get favoritesOnly;

  @BuiltValueField(wireName: r'compliance')
  ListingSearchRequestComplianceEnum? get compliance;
  // enum complianceEnum {  ANY,  PS_ICC_VERIFIED,  ,  };

  @BuiltValueField(wireName: r'min_price_centavos')
  int? get minPriceCentavos;

  @BuiltValueField(wireName: r'max_price_centavos')
  int? get maxPriceCentavos;

  /// Browse one Verified Vendor's eligible listings from its Store Profile.
  @BuiltValueField(wireName: r'vendor_id')
  String? get vendorId;

  @BuiltValueField(wireName: r'cursor')
  String? get cursor;

  @BuiltValueField(wireName: r'per_page')
  int? get perPage;

  ListingSearchRequest._();

  factory ListingSearchRequest([void updates(ListingSearchRequestBuilder b)]) = _$ListingSearchRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ListingSearchRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ListingSearchRequest> get serializer => _$ListingSearchRequestSerializer();
}

class _$ListingSearchRequestSerializer implements PrimitiveSerializer<ListingSearchRequest> {
  @override
  final Iterable<Type> types = const [ListingSearchRequest, _$ListingSearchRequest];

  @override
  final String wireName = r'ListingSearchRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ListingSearchRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.locationId != null) {
      yield r'location_id';
      yield serializers.serialize(
        object.locationId,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.latitude != null) {
      yield r'latitude';
      yield serializers.serialize(
        object.latitude,
        specifiedType: const FullType(double),
      );
    }
    if (object.longitude != null) {
      yield r'longitude';
      yield serializers.serialize(
        object.longitude,
        specifiedType: const FullType(double),
      );
    }
    if (object.originSource != null) {
      yield r'origin_source';
      yield serializers.serialize(
        object.originSource,
        specifiedType: const FullType(ListingSearchRequestOriginSourceEnum),
      );
    }
    if (object.radiusKm != null) {
      yield r'radius_km';
      yield serializers.serialize(
        object.radiusKm,
        specifiedType: const FullType(int),
      );
    }
    if (object.query != null) {
      yield r'query';
      yield serializers.serialize(
        object.query,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.sort != null) {
      yield r'sort';
      yield serializers.serialize(
        object.sort,
        specifiedType: const FullType.nullable(ListingSearchSort),
      );
    }
    if (object.categoryId != null) {
      yield r'category_id';
      yield serializers.serialize(
        object.categoryId,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.brand != null) {
      yield r'brand';
      yield serializers.serialize(
        object.brand,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.variant != null) {
      yield r'variant';
      yield serializers.serialize(
        object.variant,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.availability != null) {
      yield r'availability';
      yield serializers.serialize(
        object.availability,
        specifiedType: const FullType.nullable(ListingSearchRequestAvailabilityEnum),
      );
    }
    if (object.fulfillment != null) {
      yield r'fulfillment';
      yield serializers.serialize(
        object.fulfillment,
        specifiedType: const FullType.nullable(ListingSearchRequestFulfillmentEnum),
      );
    }
    if (object.favoritesOnly != null) {
      yield r'favorites_only';
      yield serializers.serialize(
        object.favoritesOnly,
        specifiedType: const FullType(bool),
      );
    }
    if (object.compliance != null) {
      yield r'compliance';
      yield serializers.serialize(
        object.compliance,
        specifiedType: const FullType.nullable(ListingSearchRequestComplianceEnum),
      );
    }
    if (object.minPriceCentavos != null) {
      yield r'min_price_centavos';
      yield serializers.serialize(
        object.minPriceCentavos,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.maxPriceCentavos != null) {
      yield r'max_price_centavos';
      yield serializers.serialize(
        object.maxPriceCentavos,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.vendorId != null) {
      yield r'vendor_id';
      yield serializers.serialize(
        object.vendorId,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.cursor != null) {
      yield r'cursor';
      yield serializers.serialize(
        object.cursor,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.perPage != null) {
      yield r'per_page';
      yield serializers.serialize(
        object.perPage,
        specifiedType: const FullType(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ListingSearchRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ListingSearchRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'location_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.locationId = valueDes;
          break;
        case r'latitude':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(double),
          ) as double?;
          if (valueDes == null) continue;
          result.latitude = valueDes;
          break;
        case r'longitude':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(double),
          ) as double?;
          if (valueDes == null) continue;
          result.longitude = valueDes;
          break;
        case r'origin_source':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ListingSearchRequestOriginSourceEnum),
          ) as ListingSearchRequestOriginSourceEnum?;
          if (valueDes == null) continue;
          result.originSource = valueDes;
          break;
        case r'radius_km':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.radiusKm = valueDes;
          break;
        case r'query':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.query = valueDes;
          break;
        case r'sort':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ListingSearchSort),
          ) as ListingSearchSort?;
          if (valueDes == null) continue;
          result.sort = valueDes;
          break;
        case r'category_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.categoryId = valueDes;
          break;
        case r'brand':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.brand = valueDes;
          break;
        case r'variant':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.variant = valueDes;
          break;
        case r'availability':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ListingSearchRequestAvailabilityEnum),
          ) as ListingSearchRequestAvailabilityEnum?;
          if (valueDes == null) continue;
          result.availability = valueDes;
          break;
        case r'fulfillment':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ListingSearchRequestFulfillmentEnum),
          ) as ListingSearchRequestFulfillmentEnum?;
          if (valueDes == null) continue;
          result.fulfillment = valueDes;
          break;
        case r'favorites_only':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.favoritesOnly = valueDes;
          break;
        case r'compliance':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ListingSearchRequestComplianceEnum),
          ) as ListingSearchRequestComplianceEnum?;
          if (valueDes == null) continue;
          result.compliance = valueDes;
          break;
        case r'min_price_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.minPriceCentavos = valueDes;
          break;
        case r'max_price_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.maxPriceCentavos = valueDes;
          break;
        case r'vendor_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.vendorId = valueDes;
          break;
        case r'cursor':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.cursor = valueDes;
          break;
        case r'per_page':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.perPage = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ListingSearchRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ListingSearchRequestBuilder();
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


class ListingSearchRequestOriginSourceEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DEVICE')
  static const ListingSearchRequestOriginSourceEnum DEVICE = _$listingSearchRequestOriginSourceEnum_DEVICE;
  @BuiltValueEnumConst(wireName: r'MAP_PIN')
  static const ListingSearchRequestOriginSourceEnum MAP_PIN = _$listingSearchRequestOriginSourceEnum_MAP_PIN;
  @BuiltValueEnumConst(wireName: r'SEARCH')
  static const ListingSearchRequestOriginSourceEnum SEARCH = _$listingSearchRequestOriginSourceEnum_SEARCH;

  static Serializer<ListingSearchRequestOriginSourceEnum> get serializer => _$listingSearchRequestOriginSourceEnumSerializer;

  const ListingSearchRequestOriginSourceEnum._(String name): super(name);

  static BuiltSet<ListingSearchRequestOriginSourceEnum> get values => _$listingSearchRequestOriginSourceEnumValues;
  static ListingSearchRequestOriginSourceEnum valueOf(String name) => _$listingSearchRequestOriginSourceEnumValueOf(name);
}

class ListingSearchRequestAvailabilityEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ANY')
  static const ListingSearchRequestAvailabilityEnum ANY = _$listingSearchRequestAvailabilityEnum_ANY;
  @BuiltValueEnumConst(wireName: r'IN_STOCK')
  static const ListingSearchRequestAvailabilityEnum IN_STOCK = _$listingSearchRequestAvailabilityEnum_IN_STOCK;

  static Serializer<ListingSearchRequestAvailabilityEnum> get serializer => _$listingSearchRequestAvailabilityEnumSerializer;

  const ListingSearchRequestAvailabilityEnum._(String name): super(name);

  static BuiltSet<ListingSearchRequestAvailabilityEnum> get values => _$listingSearchRequestAvailabilityEnumValues;
  static ListingSearchRequestAvailabilityEnum valueOf(String name) => _$listingSearchRequestAvailabilityEnumValueOf(name);
}

class ListingSearchRequestFulfillmentEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ANY')
  static const ListingSearchRequestFulfillmentEnum ANY = _$listingSearchRequestFulfillmentEnum_ANY;
  @BuiltValueEnumConst(wireName: r'DELIVERY')
  static const ListingSearchRequestFulfillmentEnum DELIVERY = _$listingSearchRequestFulfillmentEnum_DELIVERY;
  @BuiltValueEnumConst(wireName: r'PICKUP')
  static const ListingSearchRequestFulfillmentEnum PICKUP = _$listingSearchRequestFulfillmentEnum_PICKUP;

  static Serializer<ListingSearchRequestFulfillmentEnum> get serializer => _$listingSearchRequestFulfillmentEnumSerializer;

  const ListingSearchRequestFulfillmentEnum._(String name): super(name);

  static BuiltSet<ListingSearchRequestFulfillmentEnum> get values => _$listingSearchRequestFulfillmentEnumValues;
  static ListingSearchRequestFulfillmentEnum valueOf(String name) => _$listingSearchRequestFulfillmentEnumValueOf(name);
}

class ListingSearchRequestComplianceEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ANY')
  static const ListingSearchRequestComplianceEnum ANY = _$listingSearchRequestComplianceEnum_ANY;
  @BuiltValueEnumConst(wireName: r'PS_ICC_VERIFIED')
  static const ListingSearchRequestComplianceEnum PS_ICC_VERIFIED = _$listingSearchRequestComplianceEnum_PS_ICC_VERIFIED;

  static Serializer<ListingSearchRequestComplianceEnum> get serializer => _$listingSearchRequestComplianceEnumSerializer;

  const ListingSearchRequestComplianceEnum._(String name): super(name);

  static BuiltSet<ListingSearchRequestComplianceEnum> get values => _$listingSearchRequestComplianceEnumValues;
  static ListingSearchRequestComplianceEnum valueOf(String name) => _$listingSearchRequestComplianceEnumValueOf(name);
}

