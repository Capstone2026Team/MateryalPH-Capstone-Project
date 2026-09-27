//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/compliance_path.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'product_compliance_queue_item.g.dart';

/// ProductComplianceQueueItem
///
/// Properties:
/// * [id]
/// * [version]
/// * [path]
/// * [status]
/// * [markingType]
/// * [submittedAt]
/// * [listingId]
/// * [displayName]
/// * [vendorSku]
/// * [publicStoreName]
/// * [materialName]
/// * [productName]
/// * [referenceStandard]
/// * [referenceResult]
@BuiltValue()
abstract class ProductComplianceQueueItem implements Built<ProductComplianceQueueItem, ProductComplianceQueueItemBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'version')
  int get version;

  @BuiltValueField(wireName: r'path')
  CompliancePath get path;
  // enum pathEnum {  PHOTO_OCR,  QR,  MANUAL,  };

  @BuiltValueField(wireName: r'status')
  String get status;

  @BuiltValueField(wireName: r'marking_type')
  String? get markingType;

  @BuiltValueField(wireName: r'submitted_at')
  String? get submittedAt;

  @BuiltValueField(wireName: r'listing_id')
  String get listingId;

  @BuiltValueField(wireName: r'display_name')
  String get displayName;

  @BuiltValueField(wireName: r'vendor_sku')
  String get vendorSku;

  @BuiltValueField(wireName: r'public_store_name')
  String? get publicStoreName;

  @BuiltValueField(wireName: r'material_name')
  String? get materialName;

  @BuiltValueField(wireName: r'product_name')
  String? get productName;

  @BuiltValueField(wireName: r'reference_standard')
  String? get referenceStandard;

  @BuiltValueField(wireName: r'reference_result')
  String? get referenceResult;

  ProductComplianceQueueItem._();

  factory ProductComplianceQueueItem([void updates(ProductComplianceQueueItemBuilder b)]) = _$ProductComplianceQueueItem;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProductComplianceQueueItemBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProductComplianceQueueItem> get serializer => _$ProductComplianceQueueItemSerializer();
}

class _$ProductComplianceQueueItemSerializer implements PrimitiveSerializer<ProductComplianceQueueItem> {
  @override
  final Iterable<Type> types = const [ProductComplianceQueueItem, _$ProductComplianceQueueItem];

  @override
  final String wireName = r'ProductComplianceQueueItem';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProductComplianceQueueItem object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'version';
    yield serializers.serialize(
      object.version,
      specifiedType: const FullType(int),
    );
    yield r'path';
    yield serializers.serialize(
      object.path,
      specifiedType: const FullType(CompliancePath),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(String),
    );
    if (object.markingType != null) {
      yield r'marking_type';
      yield serializers.serialize(
        object.markingType,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.submittedAt != null) {
      yield r'submitted_at';
      yield serializers.serialize(
        object.submittedAt,
        specifiedType: const FullType.nullable(String),
      );
    }
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
    yield r'vendor_sku';
    yield serializers.serialize(
      object.vendorSku,
      specifiedType: const FullType(String),
    );
    if (object.publicStoreName != null) {
      yield r'public_store_name';
      yield serializers.serialize(
        object.publicStoreName,
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
    if (object.productName != null) {
      yield r'product_name';
      yield serializers.serialize(
        object.productName,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.referenceStandard != null) {
      yield r'reference_standard';
      yield serializers.serialize(
        object.referenceStandard,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.referenceResult != null) {
      yield r'reference_result';
      yield serializers.serialize(
        object.referenceResult,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ProductComplianceQueueItem object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProductComplianceQueueItemBuilder result,
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
        case r'version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.version = valueDes;
          break;
        case r'path':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CompliancePath),
          ) as CompliancePath;
          result.path = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.status = valueDes;
          break;
        case r'marking_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.markingType = valueDes;
          break;
        case r'submitted_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.submittedAt = valueDes;
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
        case r'vendor_sku':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.vendorSku = valueDes;
          break;
        case r'public_store_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.publicStoreName = valueDes;
          break;
        case r'material_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.materialName = valueDes;
          break;
        case r'product_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.productName = valueDes;
          break;
        case r'reference_standard':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.referenceStandard = valueDes;
          break;
        case r'reference_result':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.referenceResult = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProductComplianceQueueItem deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProductComplianceQueueItemBuilder();
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


