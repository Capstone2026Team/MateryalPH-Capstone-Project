//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/compliance_submission_summary.dart';
import 'package:materyalph_api_client/src/model/listing_compliance_status.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/listing_status.dart';
import 'package:materyalph_api_client/src/model/listing_status_change.dart';
import 'package:materyalph_api_client/src/model/regulated_material_rule.dart';
import 'package:materyalph_api_client/src/model/catalog_media.dart';
import 'package:materyalph_api_client/src/model/catalog_blocker.dart';
import 'package:materyalph_api_client/src/model/catalog_completion.dart';
import 'package:materyalph_api_client/src/model/catalog_listing_material.dart';
import 'package:materyalph_api_client/src/model/catalog_variant.dart';
import 'package:materyalph_api_client/src/model/catalog_listing_permissions.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'catalog_listing.g.dart';

/// CatalogListing
///
/// Properties:
/// * [id]
/// * [status]
/// * [lockVersion]
/// * [displayName]
/// * [vendorSku]
/// * [description]
/// * [material]
/// * [materialMatch]
/// * [materialCategoryId]
/// * [otherLabel] - Listing-only text; never a shared taxonomy entry.
/// * [tagIds]
/// * [technicalAttributes]
/// * [brand]
/// * [model]
/// * [manufacturer]
/// * [manufacturerAddress]
/// * [countryOfManufacture]
/// * [regulated]
/// * [complianceStatus]
/// * [regulatedRule]
/// * [publicationVersion]
/// * [publishedAt]
/// * [publicationRequestedAt]
/// * [variants]
/// * [media]
/// * [complianceSubmissions]
/// * [statusHistory]
/// * [completion]
/// * [blockers]
/// * [permissions]
/// * [uploadedMediaId]
@BuiltValue()
abstract class CatalogListing implements Built<CatalogListing, CatalogListingBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'status')
  ListingStatus get status;
  // enum statusEnum {  DRAFT,  PENDING_COMPLIANCE,  PENDING_ADMIN_REVIEW,  ACTIVE,  INACTIVE,  TEMPORARILY_HIDDEN_STOCK_NOT_CONFIRMED,  REJECTED,  };

  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  @BuiltValueField(wireName: r'display_name')
  String get displayName;

  @BuiltValueField(wireName: r'vendor_sku')
  String get vendorSku;

  @BuiltValueField(wireName: r'description')
  String? get description;

  @BuiltValueField(wireName: r'material')
  CatalogListingMaterial? get material;

  @BuiltValueField(wireName: r'material_match')
  CatalogListingMaterialMatchEnum get materialMatch;
  // enum materialMatchEnum {  EXACT,  ALIAS,  FUZZY_CONFIRMED,  UNMATCHED,  };

  @BuiltValueField(wireName: r'material_category_id')
  String? get materialCategoryId;

  /// Listing-only text; never a shared taxonomy entry.
  @BuiltValueField(wireName: r'other_label')
  String? get otherLabel;

  @BuiltValueField(wireName: r'tag_ids')
  BuiltList<String> get tagIds;

  @BuiltValueField(wireName: r'technical_attributes')
  BuiltMap<String, String> get technicalAttributes;

  @BuiltValueField(wireName: r'brand')
  String? get brand;

  @BuiltValueField(wireName: r'model')
  String? get model;

  @BuiltValueField(wireName: r'manufacturer')
  String? get manufacturer;

  @BuiltValueField(wireName: r'manufacturer_address')
  String? get manufacturerAddress;

  @BuiltValueField(wireName: r'country_of_manufacture')
  String? get countryOfManufacture;

  @BuiltValueField(wireName: r'regulated')
  bool get regulated;

  @BuiltValueField(wireName: r'compliance_status')
  ListingComplianceStatus get complianceStatus;
  // enum complianceStatusEnum {  NOT_REQUIRED,  NOT_SUBMITTED,  PENDING_ADMIN_REVIEW,  VERIFIED,  CHANGES_REQUIRED,  REJECTED,  };

  @BuiltValueField(wireName: r'regulated_rule')
  RegulatedMaterialRule? get regulatedRule;

  @BuiltValueField(wireName: r'publication_version')
  int get publicationVersion;

  @BuiltValueField(wireName: r'published_at')
  String? get publishedAt;

  @BuiltValueField(wireName: r'publication_requested_at')
  String? get publicationRequestedAt;

  @BuiltValueField(wireName: r'variants')
  BuiltList<CatalogVariant> get variants;

  @BuiltValueField(wireName: r'media')
  BuiltList<CatalogMedia> get media;

  @BuiltValueField(wireName: r'compliance_submissions')
  BuiltList<ComplianceSubmissionSummary> get complianceSubmissions;

  @BuiltValueField(wireName: r'status_history')
  BuiltList<ListingStatusChange> get statusHistory;

  @BuiltValueField(wireName: r'completion')
  CatalogCompletion get completion;

  @BuiltValueField(wireName: r'blockers')
  BuiltList<CatalogBlocker> get blockers;

  @BuiltValueField(wireName: r'permissions')
  CatalogListingPermissions get permissions;

  @BuiltValueField(wireName: r'uploaded_media_id')
  String? get uploadedMediaId;

  CatalogListing._();

  factory CatalogListing([void updates(CatalogListingBuilder b)]) = _$CatalogListing;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CatalogListingBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CatalogListing> get serializer => _$CatalogListingSerializer();
}

class _$CatalogListingSerializer implements PrimitiveSerializer<CatalogListing> {
  @override
  final Iterable<Type> types = const [CatalogListing, _$CatalogListing];

  @override
  final String wireName = r'CatalogListing';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CatalogListing object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(ListingStatus),
    );
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
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
    if (object.description != null) {
      yield r'description';
      yield serializers.serialize(
        object.description,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.material != null) {
      yield r'material';
      yield serializers.serialize(
        object.material,
        specifiedType: const FullType.nullable(CatalogListingMaterial),
      );
    }
    yield r'material_match';
    yield serializers.serialize(
      object.materialMatch,
      specifiedType: const FullType(CatalogListingMaterialMatchEnum),
    );
    if (object.materialCategoryId != null) {
      yield r'material_category_id';
      yield serializers.serialize(
        object.materialCategoryId,
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
    yield r'tag_ids';
    yield serializers.serialize(
      object.tagIds,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'technical_attributes';
    yield serializers.serialize(
      object.technicalAttributes,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType(String)]),
    );
    if (object.brand != null) {
      yield r'brand';
      yield serializers.serialize(
        object.brand,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.model != null) {
      yield r'model';
      yield serializers.serialize(
        object.model,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.manufacturer != null) {
      yield r'manufacturer';
      yield serializers.serialize(
        object.manufacturer,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.manufacturerAddress != null) {
      yield r'manufacturer_address';
      yield serializers.serialize(
        object.manufacturerAddress,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.countryOfManufacture != null) {
      yield r'country_of_manufacture';
      yield serializers.serialize(
        object.countryOfManufacture,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'regulated';
    yield serializers.serialize(
      object.regulated,
      specifiedType: const FullType(bool),
    );
    yield r'compliance_status';
    yield serializers.serialize(
      object.complianceStatus,
      specifiedType: const FullType(ListingComplianceStatus),
    );
    if (object.regulatedRule != null) {
      yield r'regulated_rule';
      yield serializers.serialize(
        object.regulatedRule,
        specifiedType: const FullType.nullable(RegulatedMaterialRule),
      );
    }
    yield r'publication_version';
    yield serializers.serialize(
      object.publicationVersion,
      specifiedType: const FullType(int),
    );
    if (object.publishedAt != null) {
      yield r'published_at';
      yield serializers.serialize(
        object.publishedAt,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.publicationRequestedAt != null) {
      yield r'publication_requested_at';
      yield serializers.serialize(
        object.publicationRequestedAt,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'variants';
    yield serializers.serialize(
      object.variants,
      specifiedType: const FullType(BuiltList, [FullType(CatalogVariant)]),
    );
    yield r'media';
    yield serializers.serialize(
      object.media,
      specifiedType: const FullType(BuiltList, [FullType(CatalogMedia)]),
    );
    yield r'compliance_submissions';
    yield serializers.serialize(
      object.complianceSubmissions,
      specifiedType: const FullType(BuiltList, [FullType(ComplianceSubmissionSummary)]),
    );
    yield r'status_history';
    yield serializers.serialize(
      object.statusHistory,
      specifiedType: const FullType(BuiltList, [FullType(ListingStatusChange)]),
    );
    yield r'completion';
    yield serializers.serialize(
      object.completion,
      specifiedType: const FullType(CatalogCompletion),
    );
    yield r'blockers';
    yield serializers.serialize(
      object.blockers,
      specifiedType: const FullType(BuiltList, [FullType(CatalogBlocker)]),
    );
    yield r'permissions';
    yield serializers.serialize(
      object.permissions,
      specifiedType: const FullType(CatalogListingPermissions),
    );
    if (object.uploadedMediaId != null) {
      yield r'uploaded_media_id';
      yield serializers.serialize(
        object.uploadedMediaId,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CatalogListing object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CatalogListingBuilder result,
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
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ListingStatus),
          ) as ListingStatus;
          result.status = valueDes;
          break;
        case r'lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lockVersion = valueDes;
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
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.description = valueDes;
          break;
        case r'material':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(CatalogListingMaterial),
          ) as CatalogListingMaterial?;
          if (valueDes == null) continue;
          result.material.replace(valueDes);
          break;
        case r'material_match':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CatalogListingMaterialMatchEnum),
          ) as CatalogListingMaterialMatchEnum;
          result.materialMatch = valueDes;
          break;
        case r'material_category_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.materialCategoryId = valueDes;
          break;
        case r'other_label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.otherLabel = valueDes;
          break;
        case r'tag_ids':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.tagIds.replace(valueDes);
          break;
        case r'technical_attributes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType(String)]),
          ) as BuiltMap<String, String>;
          result.technicalAttributes.replace(valueDes);
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
        case r'manufacturer_address':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.manufacturerAddress = valueDes;
          break;
        case r'country_of_manufacture':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.countryOfManufacture = valueDes;
          break;
        case r'regulated':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.regulated = valueDes;
          break;
        case r'compliance_status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ListingComplianceStatus),
          ) as ListingComplianceStatus;
          result.complianceStatus = valueDes;
          break;
        case r'regulated_rule':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(RegulatedMaterialRule),
          ) as RegulatedMaterialRule?;
          if (valueDes == null) continue;
          result.regulatedRule.replace(valueDes);
          break;
        case r'publication_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.publicationVersion = valueDes;
          break;
        case r'published_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.publishedAt = valueDes;
          break;
        case r'publication_requested_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.publicationRequestedAt = valueDes;
          break;
        case r'variants':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CatalogVariant)]),
          ) as BuiltList<CatalogVariant>;
          result.variants.replace(valueDes);
          break;
        case r'media':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CatalogMedia)]),
          ) as BuiltList<CatalogMedia>;
          result.media.replace(valueDes);
          break;
        case r'compliance_submissions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ComplianceSubmissionSummary)]),
          ) as BuiltList<ComplianceSubmissionSummary>;
          result.complianceSubmissions.replace(valueDes);
          break;
        case r'status_history':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ListingStatusChange)]),
          ) as BuiltList<ListingStatusChange>;
          result.statusHistory.replace(valueDes);
          break;
        case r'completion':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CatalogCompletion),
          ) as CatalogCompletion;
          result.completion.replace(valueDes);
          break;
        case r'blockers':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CatalogBlocker)]),
          ) as BuiltList<CatalogBlocker>;
          result.blockers.replace(valueDes);
          break;
        case r'permissions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CatalogListingPermissions),
          ) as CatalogListingPermissions;
          result.permissions.replace(valueDes);
          break;
        case r'uploaded_media_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.uploadedMediaId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CatalogListing deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CatalogListingBuilder();
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


class CatalogListingMaterialMatchEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'EXACT')
  static const CatalogListingMaterialMatchEnum EXACT = _$catalogListingMaterialMatchEnum_EXACT;
  @BuiltValueEnumConst(wireName: r'ALIAS')
  static const CatalogListingMaterialMatchEnum ALIAS = _$catalogListingMaterialMatchEnum_ALIAS;
  @BuiltValueEnumConst(wireName: r'FUZZY_CONFIRMED')
  static const CatalogListingMaterialMatchEnum FUZZY_CONFIRMED = _$catalogListingMaterialMatchEnum_FUZZY_CONFIRMED;
  @BuiltValueEnumConst(wireName: r'UNMATCHED')
  static const CatalogListingMaterialMatchEnum UNMATCHED = _$catalogListingMaterialMatchEnum_UNMATCHED;

  static Serializer<CatalogListingMaterialMatchEnum> get serializer => _$catalogListingMaterialMatchEnumSerializer;

  const CatalogListingMaterialMatchEnum._(String name): super(name);

  static BuiltSet<CatalogListingMaterialMatchEnum> get values => _$catalogListingMaterialMatchEnumValues;
  static CatalogListingMaterialMatchEnum valueOf(String name) => _$catalogListingMaterialMatchEnumValueOf(name);
}

