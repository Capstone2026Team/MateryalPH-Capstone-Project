//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/listing_image.dart';
import 'package:materyalph_api_client/src/model/project_specification_detail.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'project_separate_purchase.g.dart';

/// ProjectSeparatePurchase
///
/// Properties:
/// * [stage]
/// * [lineId]
/// * [variantId]
/// * [listingId]
/// * [displayName]
/// * [variantLabel]
/// * [vendorId]
/// * [storeName]
/// * [quantity]
/// * [unitCode]
/// * [unitPriceCentavos]
/// * [lineTotalCentavos]
/// * [satisfiesRequirement]
/// * [orderId]
/// * [orderReference]
/// * [draftItemId]
/// * [image]
/// * [specifications]
/// * [coverageQuantity] - Currently available matching quantity used for fulfillment; selected quantity stays unchanged.
@BuiltValue()
abstract class ProjectSeparatePurchase implements Built<ProjectSeparatePurchase, ProjectSeparatePurchaseBuilder> {
  @BuiltValueField(wireName: r'stage')
  ProjectSeparatePurchaseStageEnum get stage;
  // enum stageEnum {  IN_CART,  ORDERED,  DRAFT,  };

  @BuiltValueField(wireName: r'line_id')
  String get lineId;

  @BuiltValueField(wireName: r'variant_id')
  String get variantId;

  @BuiltValueField(wireName: r'listing_id')
  String get listingId;

  @BuiltValueField(wireName: r'display_name')
  String get displayName;

  @BuiltValueField(wireName: r'variant_label')
  String? get variantLabel;

  @BuiltValueField(wireName: r'vendor_id')
  String get vendorId;

  @BuiltValueField(wireName: r'store_name')
  String? get storeName;

  @BuiltValueField(wireName: r'quantity')
  String get quantity;

  @BuiltValueField(wireName: r'unit_code')
  String get unitCode;

  @BuiltValueField(wireName: r'unit_price_centavos')
  int get unitPriceCentavos;

  @BuiltValueField(wireName: r'line_total_centavos')
  int get lineTotalCentavos;

  @BuiltValueField(wireName: r'satisfies_requirement')
  bool get satisfiesRequirement;

  @BuiltValueField(wireName: r'order_id')
  String? get orderId;

  @BuiltValueField(wireName: r'order_reference')
  String? get orderReference;

  @BuiltValueField(wireName: r'draft_item_id')
  String? get draftItemId;

  @BuiltValueField(wireName: r'image')
  ListingImage? get image;

  @BuiltValueField(wireName: r'specifications')
  BuiltList<ProjectSpecificationDetail>? get specifications;

  /// Currently available matching quantity used for fulfillment; selected quantity stays unchanged.
  @BuiltValueField(wireName: r'coverage_quantity')
  String? get coverageQuantity;

  ProjectSeparatePurchase._();

  factory ProjectSeparatePurchase([void updates(ProjectSeparatePurchaseBuilder b)]) = _$ProjectSeparatePurchase;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProjectSeparatePurchaseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProjectSeparatePurchase> get serializer => _$ProjectSeparatePurchaseSerializer();
}

class _$ProjectSeparatePurchaseSerializer implements PrimitiveSerializer<ProjectSeparatePurchase> {
  @override
  final Iterable<Type> types = const [ProjectSeparatePurchase, _$ProjectSeparatePurchase];

  @override
  final String wireName = r'ProjectSeparatePurchase';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProjectSeparatePurchase object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'stage';
    yield serializers.serialize(
      object.stage,
      specifiedType: const FullType(ProjectSeparatePurchaseStageEnum),
    );
    yield r'line_id';
    yield serializers.serialize(
      object.lineId,
      specifiedType: const FullType(String),
    );
    yield r'variant_id';
    yield serializers.serialize(
      object.variantId,
      specifiedType: const FullType(String),
    );
    yield r'listing_id';
    yield serializers.serialize(
      object.listingId,
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
    yield r'quantity';
    yield serializers.serialize(
      object.quantity,
      specifiedType: const FullType(String),
    );
    yield r'unit_code';
    yield serializers.serialize(
      object.unitCode,
      specifiedType: const FullType(String),
    );
    yield r'unit_price_centavos';
    yield serializers.serialize(
      object.unitPriceCentavos,
      specifiedType: const FullType(int),
    );
    yield r'line_total_centavos';
    yield serializers.serialize(
      object.lineTotalCentavos,
      specifiedType: const FullType(int),
    );
    yield r'satisfies_requirement';
    yield serializers.serialize(
      object.satisfiesRequirement,
      specifiedType: const FullType(bool),
    );
    if (object.orderId != null) {
      yield r'order_id';
      yield serializers.serialize(
        object.orderId,
        specifiedType: const FullType(String),
      );
    }
    if (object.orderReference != null) {
      yield r'order_reference';
      yield serializers.serialize(
        object.orderReference,
        specifiedType: const FullType(String),
      );
    }
    if (object.draftItemId != null) {
      yield r'draft_item_id';
      yield serializers.serialize(
        object.draftItemId,
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
    if (object.specifications != null) {
      yield r'specifications';
      yield serializers.serialize(
        object.specifications,
        specifiedType: const FullType(BuiltList, [FullType(ProjectSpecificationDetail)]),
      );
    }
    if (object.coverageQuantity != null) {
      yield r'coverage_quantity';
      yield serializers.serialize(
        object.coverageQuantity,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ProjectSeparatePurchase object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProjectSeparatePurchaseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'stage':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ProjectSeparatePurchaseStageEnum),
          ) as ProjectSeparatePurchaseStageEnum;
          result.stage = valueDes;
          break;
        case r'line_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.lineId = valueDes;
          break;
        case r'variant_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.variantId = valueDes;
          break;
        case r'listing_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.listingId = valueDes;
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
        case r'quantity':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.quantity = valueDes;
          break;
        case r'unit_code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.unitCode = valueDes;
          break;
        case r'unit_price_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.unitPriceCentavos = valueDes;
          break;
        case r'line_total_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lineTotalCentavos = valueDes;
          break;
        case r'satisfies_requirement':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.satisfiesRequirement = valueDes;
          break;
        case r'order_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.orderId = valueDes;
          break;
        case r'order_reference':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.orderReference = valueDes;
          break;
        case r'draft_item_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.draftItemId = valueDes;
          break;
        case r'image':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ListingImage),
          ) as ListingImage?;
          if (valueDes == null) continue;
          result.image.replace(valueDes);
          break;
        case r'specifications':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(ProjectSpecificationDetail)]),
          ) as BuiltList<ProjectSpecificationDetail>?;
          if (valueDes == null) continue;
          result.specifications.replace(valueDes);
          break;
        case r'coverage_quantity':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.coverageQuantity = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProjectSeparatePurchase deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProjectSeparatePurchaseBuilder();
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


class ProjectSeparatePurchaseStageEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'IN_CART')
  static const ProjectSeparatePurchaseStageEnum IN_CART = _$projectSeparatePurchaseStageEnum_IN_CART;
  @BuiltValueEnumConst(wireName: r'ORDERED')
  static const ProjectSeparatePurchaseStageEnum ORDERED = _$projectSeparatePurchaseStageEnum_ORDERED;
  @BuiltValueEnumConst(wireName: r'DRAFT')
  static const ProjectSeparatePurchaseStageEnum DRAFT = _$projectSeparatePurchaseStageEnum_DRAFT;

  static Serializer<ProjectSeparatePurchaseStageEnum> get serializer => _$projectSeparatePurchaseStageEnumSerializer;

  const ProjectSeparatePurchaseStageEnum._(String name): super(name);

  static BuiltSet<ProjectSeparatePurchaseStageEnum> get values => _$projectSeparatePurchaseStageEnumValues;
  static ProjectSeparatePurchaseStageEnum valueOf(String name) => _$projectSeparatePurchaseStageEnumValueOf(name);
}

