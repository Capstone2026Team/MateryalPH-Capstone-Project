//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'discovery_search_request.g.dart';

/// Send location_id or latitude/longitude (never both). Omit both to use the primary saved location. radius_km defaults to the saved preference.
///
/// Properties:
/// * [locationId]
/// * [latitude]
/// * [longitude]
/// * [originSource]
/// * [radiusKm] - Must be one of 5, 10, 20, 30, 40 or 50; otherwise 422 RADIUS_UNSUPPORTED.
/// * [includeVerified]
/// * [includeDirectory]
/// * [favoritesOnly] - Limits both tiers to the Buyer's Favorite Suppliers. Unlike supplier_type and category_id, it does not hide Directory Suppliers.
/// * [directoryMinRating] - Inclusive minimum Google rating, Directory Suppliers only. Send a JSON number; a value of 3.0 keeps ratings from 3.0 through 5.0 and excludes lower-rated and unrated places. Verified Vendors and VPS are unchanged.
/// * [directoryMaxDistanceKm] - Directory Suppliers only. Must not exceed the effective selected radius.
/// * [supplierType] - WHOLESALER_DISTRIBUTOR, RETAIL_HARDWARE_STORE, SPECIALIZED_SUPPLIER or OTHER. Tier-specific filters hide Directory Suppliers.
/// * [categoryId]
/// * [page]
/// * [perPage]
@BuiltValue()
abstract class DiscoverySearchRequest implements Built<DiscoverySearchRequest, DiscoverySearchRequestBuilder> {
  @BuiltValueField(wireName: r'location_id')
  String? get locationId;

  @BuiltValueField(wireName: r'latitude')
  double? get latitude;

  @BuiltValueField(wireName: r'longitude')
  double? get longitude;

  @BuiltValueField(wireName: r'origin_source')
  DiscoverySearchRequestOriginSourceEnum? get originSource;
  // enum originSourceEnum {  DEVICE,  MAP_PIN,  SEARCH,  };

  /// Must be one of 5, 10, 20, 30, 40 or 50; otherwise 422 RADIUS_UNSUPPORTED.
  @BuiltValueField(wireName: r'radius_km')
  int? get radiusKm;

  @BuiltValueField(wireName: r'include_verified')
  bool? get includeVerified;

  @BuiltValueField(wireName: r'include_directory')
  bool? get includeDirectory;

  /// Limits both tiers to the Buyer's Favorite Suppliers. Unlike supplier_type and category_id, it does not hide Directory Suppliers.
  @BuiltValueField(wireName: r'favorites_only')
  bool? get favoritesOnly;

  /// Inclusive minimum Google rating, Directory Suppliers only. Send a JSON number; a value of 3.0 keeps ratings from 3.0 through 5.0 and excludes lower-rated and unrated places. Verified Vendors and VPS are unchanged.
  @BuiltValueField(wireName: r'directory_min_rating')
  DiscoverySearchRequestDirectoryMinRatingEnum? get directoryMinRating;
  // enum directoryMinRatingEnum {  3.0,  3.5,  4.0,  4.5,  ,  };

  /// Directory Suppliers only. Must not exceed the effective selected radius.
  @BuiltValueField(wireName: r'directory_max_distance_km')
  DiscoverySearchRequestDirectoryMaxDistanceKmEnum? get directoryMaxDistanceKm;
  // enum directoryMaxDistanceKmEnum {  1,  3,  5,  10,  20,  ,  };

  /// WHOLESALER_DISTRIBUTOR, RETAIL_HARDWARE_STORE, SPECIALIZED_SUPPLIER or OTHER. Tier-specific filters hide Directory Suppliers.
  @BuiltValueField(wireName: r'supplier_type')
  String? get supplierType;

  @BuiltValueField(wireName: r'category_id')
  String? get categoryId;

  @BuiltValueField(wireName: r'page')
  int? get page;

  @BuiltValueField(wireName: r'per_page')
  int? get perPage;

  DiscoverySearchRequest._();

  factory DiscoverySearchRequest([void updates(DiscoverySearchRequestBuilder b)]) = _$DiscoverySearchRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DiscoverySearchRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DiscoverySearchRequest> get serializer => _$DiscoverySearchRequestSerializer();
}

class _$DiscoverySearchRequestSerializer implements PrimitiveSerializer<DiscoverySearchRequest> {
  @override
  final Iterable<Type> types = const [DiscoverySearchRequest, _$DiscoverySearchRequest];

  @override
  final String wireName = r'DiscoverySearchRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DiscoverySearchRequest object, {
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
        specifiedType: const FullType(DiscoverySearchRequestOriginSourceEnum),
      );
    }
    if (object.radiusKm != null) {
      yield r'radius_km';
      yield serializers.serialize(
        object.radiusKm,
        specifiedType: const FullType(int),
      );
    }
    if (object.includeVerified != null) {
      yield r'include_verified';
      yield serializers.serialize(
        object.includeVerified,
        specifiedType: const FullType(bool),
      );
    }
    if (object.includeDirectory != null) {
      yield r'include_directory';
      yield serializers.serialize(
        object.includeDirectory,
        specifiedType: const FullType(bool),
      );
    }
    if (object.favoritesOnly != null) {
      yield r'favorites_only';
      yield serializers.serialize(
        object.favoritesOnly,
        specifiedType: const FullType(bool),
      );
    }
    if (object.directoryMinRating != null) {
      yield r'directory_min_rating';
      yield serializers.serialize(
        object.directoryMinRating,
        specifiedType: const FullType.nullable(DiscoverySearchRequestDirectoryMinRatingEnum),
      );
    }
    if (object.directoryMaxDistanceKm != null) {
      yield r'directory_max_distance_km';
      yield serializers.serialize(
        object.directoryMaxDistanceKm,
        specifiedType: const FullType.nullable(DiscoverySearchRequestDirectoryMaxDistanceKmEnum),
      );
    }
    if (object.supplierType != null) {
      yield r'supplier_type';
      yield serializers.serialize(
        object.supplierType,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.categoryId != null) {
      yield r'category_id';
      yield serializers.serialize(
        object.categoryId,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.page != null) {
      yield r'page';
      yield serializers.serialize(
        object.page,
        specifiedType: const FullType(int),
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
    DiscoverySearchRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DiscoverySearchRequestBuilder result,
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
            specifiedType: const FullType.nullable(DiscoverySearchRequestOriginSourceEnum),
          ) as DiscoverySearchRequestOriginSourceEnum?;
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
        case r'include_verified':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.includeVerified = valueDes;
          break;
        case r'include_directory':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.includeDirectory = valueDes;
          break;
        case r'favorites_only':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.favoritesOnly = valueDes;
          break;
        case r'directory_min_rating':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DiscoverySearchRequestDirectoryMinRatingEnum),
          ) as DiscoverySearchRequestDirectoryMinRatingEnum?;
          if (valueDes == null) continue;
          result.directoryMinRating = valueDes;
          break;
        case r'directory_max_distance_km':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DiscoverySearchRequestDirectoryMaxDistanceKmEnum),
          ) as DiscoverySearchRequestDirectoryMaxDistanceKmEnum?;
          if (valueDes == null) continue;
          result.directoryMaxDistanceKm = valueDes;
          break;
        case r'supplier_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.supplierType = valueDes;
          break;
        case r'category_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.categoryId = valueDes;
          break;
        case r'page':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.page = valueDes;
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
  DiscoverySearchRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DiscoverySearchRequestBuilder();
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


class DiscoverySearchRequestOriginSourceEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DEVICE')
  static const DiscoverySearchRequestOriginSourceEnum DEVICE = _$discoverySearchRequestOriginSourceEnum_DEVICE;
  @BuiltValueEnumConst(wireName: r'MAP_PIN')
  static const DiscoverySearchRequestOriginSourceEnum MAP_PIN = _$discoverySearchRequestOriginSourceEnum_MAP_PIN;
  @BuiltValueEnumConst(wireName: r'SEARCH')
  static const DiscoverySearchRequestOriginSourceEnum SEARCH = _$discoverySearchRequestOriginSourceEnum_SEARCH;

  static Serializer<DiscoverySearchRequestOriginSourceEnum> get serializer => _$discoverySearchRequestOriginSourceEnumSerializer;

  const DiscoverySearchRequestOriginSourceEnum._(String name): super(name);

  static BuiltSet<DiscoverySearchRequestOriginSourceEnum> get values => _$discoverySearchRequestOriginSourceEnumValues;
  static DiscoverySearchRequestOriginSourceEnum valueOf(String name) => _$discoverySearchRequestOriginSourceEnumValueOf(name);
}

/// Inclusive minimum Google rating, Directory Suppliers only. Send a JSON number; a value of 3.0 keeps ratings from 3.0 through 5.0 and excludes lower-rated and unrated places. Verified Vendors and VPS are unchanged.
class DiscoverySearchRequestDirectoryMinRatingEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'3.0')
  static const DiscoverySearchRequestDirectoryMinRatingEnum number3Period0 = _$discoverySearchRequestDirectoryMinRatingEnum_number3Period0;
  @BuiltValueEnumConst(wireName: r'3.5')
  static const DiscoverySearchRequestDirectoryMinRatingEnum number3Period5 = _$discoverySearchRequestDirectoryMinRatingEnum_number3Period5;
  @BuiltValueEnumConst(wireName: r'4.0')
  static const DiscoverySearchRequestDirectoryMinRatingEnum number4Period0 = _$discoverySearchRequestDirectoryMinRatingEnum_number4Period0;
  @BuiltValueEnumConst(wireName: r'4.5')
  static const DiscoverySearchRequestDirectoryMinRatingEnum number4Period5 = _$discoverySearchRequestDirectoryMinRatingEnum_number4Period5;

  static Serializer<DiscoverySearchRequestDirectoryMinRatingEnum> get serializer => _$discoverySearchRequestDirectoryMinRatingEnumSerializer;

  const DiscoverySearchRequestDirectoryMinRatingEnum._(String name): super(name);

  static BuiltSet<DiscoverySearchRequestDirectoryMinRatingEnum> get values => _$discoverySearchRequestDirectoryMinRatingEnumValues;
  static DiscoverySearchRequestDirectoryMinRatingEnum valueOf(String name) => _$discoverySearchRequestDirectoryMinRatingEnumValueOf(name);
}

/// Directory Suppliers only. Must not exceed the effective selected radius.
class DiscoverySearchRequestDirectoryMaxDistanceKmEnum extends EnumClass {

  @BuiltValueEnumConst(wireNumber: 1)
  static const DiscoverySearchRequestDirectoryMaxDistanceKmEnum number1 = _$discoverySearchRequestDirectoryMaxDistanceKmEnum_number1;
  @BuiltValueEnumConst(wireNumber: 3)
  static const DiscoverySearchRequestDirectoryMaxDistanceKmEnum number3 = _$discoverySearchRequestDirectoryMaxDistanceKmEnum_number3;
  @BuiltValueEnumConst(wireNumber: 5)
  static const DiscoverySearchRequestDirectoryMaxDistanceKmEnum number5 = _$discoverySearchRequestDirectoryMaxDistanceKmEnum_number5;
  @BuiltValueEnumConst(wireNumber: 10)
  static const DiscoverySearchRequestDirectoryMaxDistanceKmEnum number10 = _$discoverySearchRequestDirectoryMaxDistanceKmEnum_number10;
  @BuiltValueEnumConst(wireNumber: 20)
  static const DiscoverySearchRequestDirectoryMaxDistanceKmEnum number20 = _$discoverySearchRequestDirectoryMaxDistanceKmEnum_number20;

  static Serializer<DiscoverySearchRequestDirectoryMaxDistanceKmEnum> get serializer => _$discoverySearchRequestDirectoryMaxDistanceKmEnumSerializer;

  const DiscoverySearchRequestDirectoryMaxDistanceKmEnum._(String name): super(name);

  static BuiltSet<DiscoverySearchRequestDirectoryMaxDistanceKmEnum> get values => _$discoverySearchRequestDirectoryMaxDistanceKmEnumValues;
  static DiscoverySearchRequestDirectoryMaxDistanceKmEnum valueOf(String name) => _$discoverySearchRequestDirectoryMaxDistanceKmEnumValueOf(name);
}

