//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/listing_image.dart';
import 'package:materyalph_api_client/src/model/project_specification_detail.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'work_package_alternative.g.dart';

/// WorkPackageAlternative
///
/// Properties:
/// * [listingId]
/// * [variantId]
/// * [priceVersionId]
/// * [displayName]
/// * [variantLabel]
/// * [brand]
/// * [vendorId]
/// * [storeName]
/// * [image] - First public photo of the listing. The server returns an object ({url, alt_text}); declaring it as a string made the generated client reject any page containing a photographed offer, which surfaced as a generic 'Something went wrong' instead of the recommendations.
/// * [unitPriceCentavos]
/// * [unitCode]
/// * [unitPrecision]
/// * [distanceMeters]
/// * [stockLabel] - Availability label only; exact inventory is never returned.
/// * [specifications] - Listing and variant details as the category names them.
/// * [exactMatch] - Brand (when set) and every stated specification match the Work Package line.
/// * [availability] - Whether the store can confirm the whole quantity still needed. PARTIAL stores can be added with `allow_partial_stock` for what they can confirm.
/// * [estimatedTotalCentavos] - Unit price times the quantity still needed.
/// * [fulfillmentMethods] - Methods the store can serve for this product. Ready-mixed concrete uses DELIVERY only even when the primary quotation or package uses PICKUP.
/// * [alreadyAdded] - This product is already in the cart or an open order for the line; adding it again never stacks the quantity.
@BuiltValue()
abstract class WorkPackageAlternative implements Built<WorkPackageAlternative, WorkPackageAlternativeBuilder> {
  @BuiltValueField(wireName: r'listing_id')
  String get listingId;

  @BuiltValueField(wireName: r'variant_id')
  String get variantId;

  @BuiltValueField(wireName: r'price_version_id')
  String get priceVersionId;

  @BuiltValueField(wireName: r'display_name')
  String get displayName;

  @BuiltValueField(wireName: r'variant_label')
  String? get variantLabel;

  @BuiltValueField(wireName: r'brand')
  String? get brand;

  @BuiltValueField(wireName: r'vendor_id')
  String get vendorId;

  @BuiltValueField(wireName: r'store_name')
  String? get storeName;

  /// First public photo of the listing. The server returns an object ({url, alt_text}); declaring it as a string made the generated client reject any page containing a photographed offer, which surfaced as a generic 'Something went wrong' instead of the recommendations.
  @BuiltValueField(wireName: r'image')
  ListingImage? get image;

  @BuiltValueField(wireName: r'unit_price_centavos')
  int get unitPriceCentavos;

  @BuiltValueField(wireName: r'unit_code')
  String get unitCode;

  @BuiltValueField(wireName: r'unit_precision')
  int get unitPrecision;

  @BuiltValueField(wireName: r'distance_meters')
  int get distanceMeters;

  /// Availability label only; exact inventory is never returned.
  @BuiltValueField(wireName: r'stock_label')
  String get stockLabel;

  /// Listing and variant details as the category names them.
  @BuiltValueField(wireName: r'specifications')
  BuiltList<ProjectSpecificationDetail>? get specifications;

  /// Brand (when set) and every stated specification match the Work Package line.
  @BuiltValueField(wireName: r'exact_match')
  bool get exactMatch;

  /// Whether the store can confirm the whole quantity still needed. PARTIAL stores can be added with `allow_partial_stock` for what they can confirm.
  @BuiltValueField(wireName: r'availability')
  WorkPackageAlternativeAvailabilityEnum get availability;
  // enum availabilityEnum {  FULL,  PARTIAL,  };

  /// Unit price times the quantity still needed.
  @BuiltValueField(wireName: r'estimated_total_centavos')
  int get estimatedTotalCentavos;

  /// Methods the store can serve for this product. Ready-mixed concrete uses DELIVERY only even when the primary quotation or package uses PICKUP.
  @BuiltValueField(wireName: r'fulfillment_methods')
  BuiltList<WorkPackageAlternativeFulfillmentMethodsEnum> get fulfillmentMethods;
  // enum fulfillmentMethodsEnum {  DELIVERY,  PICKUP,  };

  /// This product is already in the cart or an open order for the line; adding it again never stacks the quantity.
  @BuiltValueField(wireName: r'already_added')
  bool get alreadyAdded;

  WorkPackageAlternative._();

  factory WorkPackageAlternative([void updates(WorkPackageAlternativeBuilder b)]) = _$WorkPackageAlternative;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(WorkPackageAlternativeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<WorkPackageAlternative> get serializer => _$WorkPackageAlternativeSerializer();
}

class _$WorkPackageAlternativeSerializer implements PrimitiveSerializer<WorkPackageAlternative> {
  @override
  final Iterable<Type> types = const [WorkPackageAlternative, _$WorkPackageAlternative];

  @override
  final String wireName = r'WorkPackageAlternative';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    WorkPackageAlternative object, {
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
    yield r'price_version_id';
    yield serializers.serialize(
      object.priceVersionId,
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
    if (object.brand != null) {
      yield r'brand';
      yield serializers.serialize(
        object.brand,
        specifiedType: const FullType(String),
      );
    }
    yield r'vendor_id';
    yield serializers.serialize(
      object.vendorId,
      specifiedType: const FullType(String),
    );
    if (object.storeName != null) {
      yield r'store_name';
      yield serializers.serialize(
        object.storeName,
        specifiedType: const FullType(String),
      );
    }
    if (object.image != null) {
      yield r'image';
      yield serializers.serialize(
        object.image,
        specifiedType: const FullType.nullable(ListingImage),
      );
    }
    yield r'unit_price_centavos';
    yield serializers.serialize(
      object.unitPriceCentavos,
      specifiedType: const FullType(int),
    );
    yield r'unit_code';
    yield serializers.serialize(
      object.unitCode,
      specifiedType: const FullType(String),
    );
    yield r'unit_precision';
    yield serializers.serialize(
      object.unitPrecision,
      specifiedType: const FullType(int),
    );
    yield r'distance_meters';
    yield serializers.serialize(
      object.distanceMeters,
      specifiedType: const FullType(int),
    );
    yield r'stock_label';
    yield serializers.serialize(
      object.stockLabel,
      specifiedType: const FullType(String),
    );
    if (object.specifications != null) {
      yield r'specifications';
      yield serializers.serialize(
        object.specifications,
        specifiedType: const FullType(BuiltList, [FullType(ProjectSpecificationDetail)]),
      );
    }
    yield r'exact_match';
    yield serializers.serialize(
      object.exactMatch,
      specifiedType: const FullType(bool),
    );
    yield r'availability';
    yield serializers.serialize(
      object.availability,
      specifiedType: const FullType(WorkPackageAlternativeAvailabilityEnum),
    );
    yield r'estimated_total_centavos';
    yield serializers.serialize(
      object.estimatedTotalCentavos,
      specifiedType: const FullType(int),
    );
    yield r'fulfillment_methods';
    yield serializers.serialize(
      object.fulfillmentMethods,
      specifiedType: const FullType(BuiltList, [FullType(WorkPackageAlternativeFulfillmentMethodsEnum)]),
    );
    yield r'already_added';
    yield serializers.serialize(
      object.alreadyAdded,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    WorkPackageAlternative object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required WorkPackageAlternativeBuilder result,
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
        case r'price_version_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.priceVersionId = valueDes;
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
        case r'brand':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.brand = valueDes;
          break;
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
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.storeName = valueDes;
          break;
        case r'image':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ListingImage),
          ) as ListingImage?;
          if (valueDes == null) continue;
          result.image.replace(valueDes);
          break;
        case r'unit_price_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.unitPriceCentavos = valueDes;
          break;
        case r'unit_code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.unitCode = valueDes;
          break;
        case r'unit_precision':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.unitPrecision = valueDes;
          break;
        case r'distance_meters':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.distanceMeters = valueDes;
          break;
        case r'stock_label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.stockLabel = valueDes;
          break;
        case r'specifications':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(ProjectSpecificationDetail)]),
          ) as BuiltList<ProjectSpecificationDetail>?;
          if (valueDes == null) continue;
          result.specifications.replace(valueDes);
          break;
        case r'exact_match':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.exactMatch = valueDes;
          break;
        case r'availability':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(WorkPackageAlternativeAvailabilityEnum),
          ) as WorkPackageAlternativeAvailabilityEnum;
          result.availability = valueDes;
          break;
        case r'estimated_total_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.estimatedTotalCentavos = valueDes;
          break;
        case r'fulfillment_methods':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(WorkPackageAlternativeFulfillmentMethodsEnum)]),
          ) as BuiltList<WorkPackageAlternativeFulfillmentMethodsEnum>;
          result.fulfillmentMethods.replace(valueDes);
          break;
        case r'already_added':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.alreadyAdded = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  WorkPackageAlternative deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = WorkPackageAlternativeBuilder();
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


/// Whether the store can confirm the whole quantity still needed. PARTIAL stores can be added with `allow_partial_stock` for what they can confirm.
class WorkPackageAlternativeAvailabilityEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'FULL')
  static const WorkPackageAlternativeAvailabilityEnum FULL = _$workPackageAlternativeAvailabilityEnum_FULL;
  @BuiltValueEnumConst(wireName: r'PARTIAL')
  static const WorkPackageAlternativeAvailabilityEnum PARTIAL = _$workPackageAlternativeAvailabilityEnum_PARTIAL;

  static Serializer<WorkPackageAlternativeAvailabilityEnum> get serializer => _$workPackageAlternativeAvailabilityEnumSerializer;

  const WorkPackageAlternativeAvailabilityEnum._(String name): super(name);

  static BuiltSet<WorkPackageAlternativeAvailabilityEnum> get values => _$workPackageAlternativeAvailabilityEnumValues;
  static WorkPackageAlternativeAvailabilityEnum valueOf(String name) => _$workPackageAlternativeAvailabilityEnumValueOf(name);
}

class WorkPackageAlternativeFulfillmentMethodsEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DELIVERY')
  static const WorkPackageAlternativeFulfillmentMethodsEnum DELIVERY = _$workPackageAlternativeFulfillmentMethodsEnum_DELIVERY;
  @BuiltValueEnumConst(wireName: r'PICKUP')
  static const WorkPackageAlternativeFulfillmentMethodsEnum PICKUP = _$workPackageAlternativeFulfillmentMethodsEnum_PICKUP;

  static Serializer<WorkPackageAlternativeFulfillmentMethodsEnum> get serializer => _$workPackageAlternativeFulfillmentMethodsEnumSerializer;

  const WorkPackageAlternativeFulfillmentMethodsEnum._(String name): super(name);

  static BuiltSet<WorkPackageAlternativeFulfillmentMethodsEnum> get values => _$workPackageAlternativeFulfillmentMethodsEnumValues;
  static WorkPackageAlternativeFulfillmentMethodsEnum valueOf(String name) => _$workPackageAlternativeFulfillmentMethodsEnumValueOf(name);
}

