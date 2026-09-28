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
/// * [favoritesOnly]
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

  @BuiltValueField(wireName: r'favorites_only')
  bool? get favoritesOnly;

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

