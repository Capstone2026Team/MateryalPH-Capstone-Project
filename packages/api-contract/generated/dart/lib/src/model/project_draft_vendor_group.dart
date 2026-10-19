//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/project_payment_method.dart';
import 'package:materyalph_api_client/src/model/project_separate_purchase.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'project_draft_vendor_group.g.dart';

/// ProjectDraftVendorGroup
///
/// Properties:
/// * [vendorId]
/// * [storeName]
/// * [items]
/// * [materialsCentavos]
/// * [fulfillmentMethod] - This supplier's method. Any group containing ready-mixed concrete uses DELIVERY even when the primary supplier uses PICKUP. Its delivery fee and payment options are calculated independently.
/// * [fulfillmentOptions] - Current fulfillment methods supported for every selected product from this supplier.
/// * [delivery] - Existing delivery preview for this supplier's selected items, including its route, vehicles, trips, estimated fees and review issues.
/// * [paymentMethods]
/// * [issues]
/// * [draftFingerprint]
/// * [deliveryCentavos]
/// * [projectedTotalCentavos]
@BuiltValue()
abstract class ProjectDraftVendorGroup implements Built<ProjectDraftVendorGroup, ProjectDraftVendorGroupBuilder> {
  @BuiltValueField(wireName: r'vendor_id')
  String get vendorId;

  @BuiltValueField(wireName: r'store_name')
  String get storeName;

  @BuiltValueField(wireName: r'items')
  BuiltList<ProjectSeparatePurchase> get items;

  @BuiltValueField(wireName: r'materials_centavos')
  int get materialsCentavos;

  /// This supplier's method. Any group containing ready-mixed concrete uses DELIVERY even when the primary supplier uses PICKUP. Its delivery fee and payment options are calculated independently.
  @BuiltValueField(wireName: r'fulfillment_method')
  ProjectDraftVendorGroupFulfillmentMethodEnum get fulfillmentMethod;
  // enum fulfillmentMethodEnum {  DELIVERY,  PICKUP,  };

  /// Current fulfillment methods supported for every selected product from this supplier.
  @BuiltValueField(wireName: r'fulfillment_options')
  BuiltList<ProjectDraftVendorGroupFulfillmentOptionsEnum>? get fulfillmentOptions;
  // enum fulfillmentOptionsEnum {  DELIVERY,  PICKUP,  };

  /// Existing delivery preview for this supplier's selected items, including its route, vehicles, trips, estimated fees and review issues.
  @BuiltValueField(wireName: r'delivery')
  BuiltMap<String, JsonObject?>? get delivery;

  @BuiltValueField(wireName: r'payment_methods')
  BuiltList<ProjectPaymentMethod> get paymentMethods;

  @BuiltValueField(wireName: r'issues')
  BuiltList<String> get issues;

  @BuiltValueField(wireName: r'draft_fingerprint')
  String get draftFingerprint;

  @BuiltValueField(wireName: r'delivery_centavos')
  int? get deliveryCentavos;

  @BuiltValueField(wireName: r'projected_total_centavos')
  int? get projectedTotalCentavos;

  ProjectDraftVendorGroup._();

  factory ProjectDraftVendorGroup([void updates(ProjectDraftVendorGroupBuilder b)]) = _$ProjectDraftVendorGroup;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProjectDraftVendorGroupBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProjectDraftVendorGroup> get serializer => _$ProjectDraftVendorGroupSerializer();
}

class _$ProjectDraftVendorGroupSerializer implements PrimitiveSerializer<ProjectDraftVendorGroup> {
  @override
  final Iterable<Type> types = const [ProjectDraftVendorGroup, _$ProjectDraftVendorGroup];

  @override
  final String wireName = r'ProjectDraftVendorGroup';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProjectDraftVendorGroup object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'vendor_id';
    yield serializers.serialize(
      object.vendorId,
      specifiedType: const FullType(String),
    );
    yield r'store_name';
    yield serializers.serialize(
      object.storeName,
      specifiedType: const FullType(String),
    );
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(ProjectSeparatePurchase)]),
    );
    yield r'materials_centavos';
    yield serializers.serialize(
      object.materialsCentavos,
      specifiedType: const FullType(int),
    );
    yield r'fulfillment_method';
    yield serializers.serialize(
      object.fulfillmentMethod,
      specifiedType: const FullType(ProjectDraftVendorGroupFulfillmentMethodEnum),
    );
    if (object.fulfillmentOptions != null) {
      yield r'fulfillment_options';
      yield serializers.serialize(
        object.fulfillmentOptions,
        specifiedType: const FullType(BuiltList, [FullType(ProjectDraftVendorGroupFulfillmentOptionsEnum)]),
      );
    }
    if (object.delivery != null) {
      yield r'delivery';
      yield serializers.serialize(
        object.delivery,
        specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
      );
    }
    yield r'payment_methods';
    yield serializers.serialize(
      object.paymentMethods,
      specifiedType: const FullType(BuiltList, [FullType(ProjectPaymentMethod)]),
    );
    yield r'issues';
    yield serializers.serialize(
      object.issues,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'draft_fingerprint';
    yield serializers.serialize(
      object.draftFingerprint,
      specifiedType: const FullType(String),
    );
    if (object.deliveryCentavos != null) {
      yield r'delivery_centavos';
      yield serializers.serialize(
        object.deliveryCentavos,
        specifiedType: const FullType(int),
      );
    }
    if (object.projectedTotalCentavos != null) {
      yield r'projected_total_centavos';
      yield serializers.serialize(
        object.projectedTotalCentavos,
        specifiedType: const FullType(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ProjectDraftVendorGroup object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProjectDraftVendorGroupBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
            specifiedType: const FullType(String),
          ) as String;
          result.storeName = valueDes;
          break;
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ProjectSeparatePurchase)]),
          ) as BuiltList<ProjectSeparatePurchase>;
          result.items.replace(valueDes);
          break;
        case r'materials_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.materialsCentavos = valueDes;
          break;
        case r'fulfillment_method':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ProjectDraftVendorGroupFulfillmentMethodEnum),
          ) as ProjectDraftVendorGroupFulfillmentMethodEnum;
          result.fulfillmentMethod = valueDes;
          break;
        case r'fulfillment_options':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(ProjectDraftVendorGroupFulfillmentOptionsEnum)]),
          ) as BuiltList<ProjectDraftVendorGroupFulfillmentOptionsEnum>?;
          if (valueDes == null) continue;
          result.fulfillmentOptions.replace(valueDes);
          break;
        case r'delivery':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>?;
          if (valueDes == null) continue;
          result.delivery.replace(valueDes);
          break;
        case r'payment_methods':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ProjectPaymentMethod)]),
          ) as BuiltList<ProjectPaymentMethod>;
          result.paymentMethods.replace(valueDes);
          break;
        case r'issues':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.issues.replace(valueDes);
          break;
        case r'draft_fingerprint':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.draftFingerprint = valueDes;
          break;
        case r'delivery_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.deliveryCentavos = valueDes;
          break;
        case r'projected_total_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.projectedTotalCentavos = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProjectDraftVendorGroup deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProjectDraftVendorGroupBuilder();
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


/// This supplier's method. Any group containing ready-mixed concrete uses DELIVERY even when the primary supplier uses PICKUP. Its delivery fee and payment options are calculated independently.
class ProjectDraftVendorGroupFulfillmentMethodEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DELIVERY')
  static const ProjectDraftVendorGroupFulfillmentMethodEnum DELIVERY = _$projectDraftVendorGroupFulfillmentMethodEnum_DELIVERY;
  @BuiltValueEnumConst(wireName: r'PICKUP')
  static const ProjectDraftVendorGroupFulfillmentMethodEnum PICKUP = _$projectDraftVendorGroupFulfillmentMethodEnum_PICKUP;

  static Serializer<ProjectDraftVendorGroupFulfillmentMethodEnum> get serializer => _$projectDraftVendorGroupFulfillmentMethodEnumSerializer;

  const ProjectDraftVendorGroupFulfillmentMethodEnum._(String name): super(name);

  static BuiltSet<ProjectDraftVendorGroupFulfillmentMethodEnum> get values => _$projectDraftVendorGroupFulfillmentMethodEnumValues;
  static ProjectDraftVendorGroupFulfillmentMethodEnum valueOf(String name) => _$projectDraftVendorGroupFulfillmentMethodEnumValueOf(name);
}

class ProjectDraftVendorGroupFulfillmentOptionsEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DELIVERY')
  static const ProjectDraftVendorGroupFulfillmentOptionsEnum DELIVERY = _$projectDraftVendorGroupFulfillmentOptionsEnum_DELIVERY;
  @BuiltValueEnumConst(wireName: r'PICKUP')
  static const ProjectDraftVendorGroupFulfillmentOptionsEnum PICKUP = _$projectDraftVendorGroupFulfillmentOptionsEnum_PICKUP;

  static Serializer<ProjectDraftVendorGroupFulfillmentOptionsEnum> get serializer => _$projectDraftVendorGroupFulfillmentOptionsEnumSerializer;

  const ProjectDraftVendorGroupFulfillmentOptionsEnum._(String name): super(name);

  static BuiltSet<ProjectDraftVendorGroupFulfillmentOptionsEnum> get values => _$projectDraftVendorGroupFulfillmentOptionsEnumValues;
  static ProjectDraftVendorGroupFulfillmentOptionsEnum valueOf(String name) => _$projectDraftVendorGroupFulfillmentOptionsEnumValueOf(name);
}

