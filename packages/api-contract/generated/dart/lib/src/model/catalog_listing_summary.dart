//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/listing_compliance_status.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/listing_status.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'catalog_listing_summary.g.dart';

/// CatalogListingSummary
///
/// Properties:
/// * [id]
/// * [displayName]
/// * [vendorSku]
/// * [status]
/// * [complianceStatus]
/// * [regulated]
/// * [categoryName]
/// * [materialName]
/// * [otherLabel]
/// * [lockVersion]
/// * [updatedAt]
/// * [variantCount]
/// * [minPriceCentavos]
/// * [maxPriceCentavos]
/// * [publicAvailability] - The only availability a Buyer would see.
/// * [primaryImageFileId]
/// * [deletable] - True when the caller may delete this never-published listing.
/// * [primaryImageUrl] - Short-lived signed URL of the first ready product photo; expires within minutes.
/// * [unitCode] - Sale unit code when every active variant uses the same unit.
/// * [availableQuantity] - Vendor-only summed available-to-sell quantity when every active variant shares one unit and has a stock count. Never returned to Buyers.
@BuiltValue()
abstract class CatalogListingSummary implements Built<CatalogListingSummary, CatalogListingSummaryBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'display_name')
  String get displayName;

  @BuiltValueField(wireName: r'vendor_sku')
  String get vendorSku;

  @BuiltValueField(wireName: r'status')
  ListingStatus get status;
  // enum statusEnum {  DRAFT,  PENDING_COMPLIANCE,  PENDING_ADMIN_REVIEW,  ACTIVE,  INACTIVE,  TEMPORARILY_HIDDEN_STOCK_NOT_CONFIRMED,  REJECTED,  };

  @BuiltValueField(wireName: r'compliance_status')
  ListingComplianceStatus get complianceStatus;
  // enum complianceStatusEnum {  NOT_REQUIRED,  NOT_SUBMITTED,  PENDING_ADMIN_REVIEW,  VERIFIED,  CHANGES_REQUIRED,  REJECTED,  };

  @BuiltValueField(wireName: r'regulated')
  bool get regulated;

  @BuiltValueField(wireName: r'category_name')
  String? get categoryName;

  @BuiltValueField(wireName: r'material_name')
  String? get materialName;

  @BuiltValueField(wireName: r'other_label')
  String? get otherLabel;

  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  @BuiltValueField(wireName: r'updated_at')
  String? get updatedAt;

  @BuiltValueField(wireName: r'variant_count')
  int get variantCount;

  @BuiltValueField(wireName: r'min_price_centavos')
  int? get minPriceCentavos;

  @BuiltValueField(wireName: r'max_price_centavos')
  int? get maxPriceCentavos;

  /// The only availability a Buyer would see.
  @BuiltValueField(wireName: r'public_availability')
  CatalogListingSummaryPublicAvailabilityEnum get publicAvailability;
  // enum publicAvailabilityEnum {  IN_STOCK,  OUT_OF_STOCK,  };

  @BuiltValueField(wireName: r'primary_image_file_id')
  String? get primaryImageFileId;

  /// True when the caller may delete this never-published listing.
  @BuiltValueField(wireName: r'deletable')
  bool? get deletable;

  /// Short-lived signed URL of the first ready product photo; expires within minutes.
  @BuiltValueField(wireName: r'primary_image_url')
  String? get primaryImageUrl;

  /// Sale unit code when every active variant uses the same unit.
  @BuiltValueField(wireName: r'unit_code')
  String? get unitCode;

  /// Vendor-only summed available-to-sell quantity when every active variant shares one unit and has a stock count. Never returned to Buyers.
  @BuiltValueField(wireName: r'available_quantity')
  String? get availableQuantity;

  CatalogListingSummary._();

  factory CatalogListingSummary([void updates(CatalogListingSummaryBuilder b)]) = _$CatalogListingSummary;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CatalogListingSummaryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CatalogListingSummary> get serializer => _$CatalogListingSummarySerializer();
}

class _$CatalogListingSummarySerializer implements PrimitiveSerializer<CatalogListingSummary> {
  @override
  final Iterable<Type> types = const [CatalogListingSummary, _$CatalogListingSummary];

  @override
  final String wireName = r'CatalogListingSummary';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CatalogListingSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'display_name';
    yield serializers.serialize(
      object.displayName,
      specifiedType: const FullType(String),
    );
    yield r'vendor_sku';
    yield serializers.serialize(
      object.vendorSku,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(ListingStatus),
    );
    yield r'compliance_status';
    yield serializers.serialize(
      object.complianceStatus,
      specifiedType: const FullType(ListingComplianceStatus),
    );
    yield r'regulated';
    yield serializers.serialize(
      object.regulated,
      specifiedType: const FullType(bool),
    );
    if (object.categoryName != null) {
      yield r'category_name';
      yield serializers.serialize(
        object.categoryName,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.materialName != null) {
      yield r'material_name';
      yield serializers.serialize(
        object.materialName,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.otherLabel != null) {
      yield r'other_label';
      yield serializers.serialize(
        object.otherLabel,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
    if (object.updatedAt != null) {
      yield r'updated_at';
      yield serializers.serialize(
        object.updatedAt,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'variant_count';
    yield serializers.serialize(
      object.variantCount,
      specifiedType: const FullType(int),
    );
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
    yield r'public_availability';
    yield serializers.serialize(
      object.publicAvailability,
      specifiedType: const FullType(CatalogListingSummaryPublicAvailabilityEnum),
    );
    if (object.primaryImageFileId != null) {
      yield r'primary_image_file_id';
      yield serializers.serialize(
        object.primaryImageFileId,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.deletable != null) {
      yield r'deletable';
      yield serializers.serialize(
        object.deletable,
        specifiedType: const FullType(bool),
      );
    }
    if (object.primaryImageUrl != null) {
      yield r'primary_image_url';
      yield serializers.serialize(
        object.primaryImageUrl,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.unitCode != null) {
      yield r'unit_code';
      yield serializers.serialize(
        object.unitCode,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.availableQuantity != null) {
      yield r'available_quantity';
      yield serializers.serialize(
        object.availableQuantity,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CatalogListingSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CatalogListingSummaryBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'display_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.displayName = valueDes;
          break;
        case r'vendor_sku':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.vendorSku = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ListingStatus),
          ) as ListingStatus;
          result.status = valueDes;
          break;
        case r'compliance_status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ListingComplianceStatus),
          ) as ListingComplianceStatus;
          result.complianceStatus = valueDes;
          break;
        case r'regulated':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.regulated = valueDes;
          break;
        case r'category_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.categoryName = valueDes;
          break;
        case r'material_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.materialName = valueDes;
          break;
        case r'other_label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.otherLabel = valueDes;
          break;
        case r'lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lockVersion = valueDes;
          break;
        case r'updated_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.updatedAt = valueDes;
          break;
        case r'variant_count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.variantCount = valueDes;
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
        case r'public_availability':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CatalogListingSummaryPublicAvailabilityEnum),
          ) as CatalogListingSummaryPublicAvailabilityEnum;
          result.publicAvailability = valueDes;
          break;
        case r'primary_image_file_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.primaryImageFileId = valueDes;
          break;
        case r'deletable':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.deletable = valueDes;
          break;
        case r'primary_image_url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.primaryImageUrl = valueDes;
          break;
        case r'unit_code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.unitCode = valueDes;
          break;
        case r'available_quantity':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.availableQuantity = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CatalogListingSummary deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CatalogListingSummaryBuilder();
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


/// The only availability a Buyer would see.
class CatalogListingSummaryPublicAvailabilityEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'IN_STOCK')
  static const CatalogListingSummaryPublicAvailabilityEnum IN_STOCK = _$catalogListingSummaryPublicAvailabilityEnum_IN_STOCK;
  @BuiltValueEnumConst(wireName: r'OUT_OF_STOCK')
  static const CatalogListingSummaryPublicAvailabilityEnum OUT_OF_STOCK = _$catalogListingSummaryPublicAvailabilityEnum_OUT_OF_STOCK;

  static Serializer<CatalogListingSummaryPublicAvailabilityEnum> get serializer => _$catalogListingSummaryPublicAvailabilityEnumSerializer;

  const CatalogListingSummaryPublicAvailabilityEnum._(String name): super(name);

  static BuiltSet<CatalogListingSummaryPublicAvailabilityEnum> get values => _$catalogListingSummaryPublicAvailabilityEnumValues;
  static CatalogListingSummaryPublicAvailabilityEnum valueOf(String name) => _$catalogListingSummaryPublicAvailabilityEnumValueOf(name);
}

