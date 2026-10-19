//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/work_package_budget_estimate_line.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'work_package_budget_estimate.g.dart';

/// WorkPackageBudgetEstimate
///
/// Properties:
/// * [deliveryCentavos] - Actual route/vehicle estimate for a representative exact-match supplier plan, consolidated per supplier. Zero for pickup-only supplies; ready-mixed concrete includes mixer delivery even under PICKUP. Null when delivery or supplier availability needs review.
/// * [estimatedTotalCentavos] - Average eligible material prices plus applicable supplier delivery. Null until every material and delivery fee can be estimated.
/// * [deliveryStatus]
/// * [deliveryIssues]
/// * [fulfillmentMethod] - Both is budgeted using the Site Delivery scenario.
/// * [lines]
/// * [materialsTotalCentavos]
/// * [pricedLineCount]
/// * [unpricedLineCount]
/// * [radiusKm]
/// * [basis]
/// * [excludes]
/// * [computedAt]
@BuiltValue()
abstract class WorkPackageBudgetEstimate implements Built<WorkPackageBudgetEstimate, WorkPackageBudgetEstimateBuilder> {
  /// Actual route/vehicle estimate for a representative exact-match supplier plan, consolidated per supplier. Zero for pickup-only supplies; ready-mixed concrete includes mixer delivery even under PICKUP. Null when delivery or supplier availability needs review.
  @BuiltValueField(wireName: r'delivery_centavos')
  int? get deliveryCentavos;

  /// Average eligible material prices plus applicable supplier delivery. Null until every material and delivery fee can be estimated.
  @BuiltValueField(wireName: r'estimated_total_centavos')
  int? get estimatedTotalCentavos;

  @BuiltValueField(wireName: r'delivery_status')
  WorkPackageBudgetEstimateDeliveryStatusEnum? get deliveryStatus;
  // enum deliveryStatusEnum {  NOT_APPLICABLE,  ESTIMATED,  REVIEW_REQUIRED,  };

  @BuiltValueField(wireName: r'delivery_issues')
  BuiltList<String>? get deliveryIssues;

  /// Both is budgeted using the Site Delivery scenario.
  @BuiltValueField(wireName: r'fulfillment_method')
  WorkPackageBudgetEstimateFulfillmentMethodEnum? get fulfillmentMethod;
  // enum fulfillmentMethodEnum {  DELIVERY,  PICKUP,  };

  @BuiltValueField(wireName: r'lines')
  BuiltList<WorkPackageBudgetEstimateLine> get lines;

  @BuiltValueField(wireName: r'materials_total_centavos')
  int get materialsTotalCentavos;

  @BuiltValueField(wireName: r'priced_line_count')
  int get pricedLineCount;

  @BuiltValueField(wireName: r'unpriced_line_count')
  int get unpricedLineCount;

  @BuiltValueField(wireName: r'radius_km')
  int get radiusKm;

  @BuiltValueField(wireName: r'basis')
  WorkPackageBudgetEstimateBasisEnum get basis;
  // enum basisEnum {  AVERAGE_OF_VENDOR_LOWEST_ELIGIBLE_PRICE,  };

  @BuiltValueField(wireName: r'excludes')
  BuiltList<String> get excludes;

  @BuiltValueField(wireName: r'computed_at')
  String get computedAt;

  WorkPackageBudgetEstimate._();

  factory WorkPackageBudgetEstimate([void updates(WorkPackageBudgetEstimateBuilder b)]) = _$WorkPackageBudgetEstimate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(WorkPackageBudgetEstimateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<WorkPackageBudgetEstimate> get serializer => _$WorkPackageBudgetEstimateSerializer();
}

class _$WorkPackageBudgetEstimateSerializer implements PrimitiveSerializer<WorkPackageBudgetEstimate> {
  @override
  final Iterable<Type> types = const [WorkPackageBudgetEstimate, _$WorkPackageBudgetEstimate];

  @override
  final String wireName = r'WorkPackageBudgetEstimate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    WorkPackageBudgetEstimate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.deliveryCentavos != null) {
      yield r'delivery_centavos';
      yield serializers.serialize(
        object.deliveryCentavos,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.estimatedTotalCentavos != null) {
      yield r'estimated_total_centavos';
      yield serializers.serialize(
        object.estimatedTotalCentavos,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.deliveryStatus != null) {
      yield r'delivery_status';
      yield serializers.serialize(
        object.deliveryStatus,
        specifiedType: const FullType(WorkPackageBudgetEstimateDeliveryStatusEnum),
      );
    }
    if (object.deliveryIssues != null) {
      yield r'delivery_issues';
      yield serializers.serialize(
        object.deliveryIssues,
        specifiedType: const FullType(BuiltList, [FullType(String)]),
      );
    }
    if (object.fulfillmentMethod != null) {
      yield r'fulfillment_method';
      yield serializers.serialize(
        object.fulfillmentMethod,
        specifiedType: const FullType(WorkPackageBudgetEstimateFulfillmentMethodEnum),
      );
    }
    yield r'lines';
    yield serializers.serialize(
      object.lines,
      specifiedType: const FullType(BuiltList, [FullType(WorkPackageBudgetEstimateLine)]),
    );
    yield r'materials_total_centavos';
    yield serializers.serialize(
      object.materialsTotalCentavos,
      specifiedType: const FullType(int),
    );
    yield r'priced_line_count';
    yield serializers.serialize(
      object.pricedLineCount,
      specifiedType: const FullType(int),
    );
    yield r'unpriced_line_count';
    yield serializers.serialize(
      object.unpricedLineCount,
      specifiedType: const FullType(int),
    );
    yield r'radius_km';
    yield serializers.serialize(
      object.radiusKm,
      specifiedType: const FullType(int),
    );
    yield r'basis';
    yield serializers.serialize(
      object.basis,
      specifiedType: const FullType(WorkPackageBudgetEstimateBasisEnum),
    );
    yield r'excludes';
    yield serializers.serialize(
      object.excludes,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'computed_at';
    yield serializers.serialize(
      object.computedAt,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    WorkPackageBudgetEstimate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required WorkPackageBudgetEstimateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'delivery_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.deliveryCentavos = valueDes;
          break;
        case r'estimated_total_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.estimatedTotalCentavos = valueDes;
          break;
        case r'delivery_status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(WorkPackageBudgetEstimateDeliveryStatusEnum),
          ) as WorkPackageBudgetEstimateDeliveryStatusEnum?;
          if (valueDes == null) continue;
          result.deliveryStatus = valueDes;
          break;
        case r'delivery_issues':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(String)]),
          ) as BuiltList<String>?;
          if (valueDes == null) continue;
          result.deliveryIssues.replace(valueDes);
          break;
        case r'fulfillment_method':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(WorkPackageBudgetEstimateFulfillmentMethodEnum),
          ) as WorkPackageBudgetEstimateFulfillmentMethodEnum?;
          if (valueDes == null) continue;
          result.fulfillmentMethod = valueDes;
          break;
        case r'lines':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(WorkPackageBudgetEstimateLine)]),
          ) as BuiltList<WorkPackageBudgetEstimateLine>;
          result.lines.replace(valueDes);
          break;
        case r'materials_total_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.materialsTotalCentavos = valueDes;
          break;
        case r'priced_line_count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.pricedLineCount = valueDes;
          break;
        case r'unpriced_line_count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.unpricedLineCount = valueDes;
          break;
        case r'radius_km':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.radiusKm = valueDes;
          break;
        case r'basis':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(WorkPackageBudgetEstimateBasisEnum),
          ) as WorkPackageBudgetEstimateBasisEnum;
          result.basis = valueDes;
          break;
        case r'excludes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.excludes.replace(valueDes);
          break;
        case r'computed_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.computedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  WorkPackageBudgetEstimate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = WorkPackageBudgetEstimateBuilder();
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


class WorkPackageBudgetEstimateDeliveryStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'NOT_APPLICABLE')
  static const WorkPackageBudgetEstimateDeliveryStatusEnum NOT_APPLICABLE = _$workPackageBudgetEstimateDeliveryStatusEnum_NOT_APPLICABLE;
  @BuiltValueEnumConst(wireName: r'ESTIMATED')
  static const WorkPackageBudgetEstimateDeliveryStatusEnum ESTIMATED = _$workPackageBudgetEstimateDeliveryStatusEnum_ESTIMATED;
  @BuiltValueEnumConst(wireName: r'REVIEW_REQUIRED')
  static const WorkPackageBudgetEstimateDeliveryStatusEnum REVIEW_REQUIRED = _$workPackageBudgetEstimateDeliveryStatusEnum_REVIEW_REQUIRED;

  static Serializer<WorkPackageBudgetEstimateDeliveryStatusEnum> get serializer => _$workPackageBudgetEstimateDeliveryStatusEnumSerializer;

  const WorkPackageBudgetEstimateDeliveryStatusEnum._(String name): super(name);

  static BuiltSet<WorkPackageBudgetEstimateDeliveryStatusEnum> get values => _$workPackageBudgetEstimateDeliveryStatusEnumValues;
  static WorkPackageBudgetEstimateDeliveryStatusEnum valueOf(String name) => _$workPackageBudgetEstimateDeliveryStatusEnumValueOf(name);
}

/// Both is budgeted using the Site Delivery scenario.
class WorkPackageBudgetEstimateFulfillmentMethodEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DELIVERY')
  static const WorkPackageBudgetEstimateFulfillmentMethodEnum DELIVERY = _$workPackageBudgetEstimateFulfillmentMethodEnum_DELIVERY;
  @BuiltValueEnumConst(wireName: r'PICKUP')
  static const WorkPackageBudgetEstimateFulfillmentMethodEnum PICKUP = _$workPackageBudgetEstimateFulfillmentMethodEnum_PICKUP;

  static Serializer<WorkPackageBudgetEstimateFulfillmentMethodEnum> get serializer => _$workPackageBudgetEstimateFulfillmentMethodEnumSerializer;

  const WorkPackageBudgetEstimateFulfillmentMethodEnum._(String name): super(name);

  static BuiltSet<WorkPackageBudgetEstimateFulfillmentMethodEnum> get values => _$workPackageBudgetEstimateFulfillmentMethodEnumValues;
  static WorkPackageBudgetEstimateFulfillmentMethodEnum valueOf(String name) => _$workPackageBudgetEstimateFulfillmentMethodEnumValueOf(name);
}

class WorkPackageBudgetEstimateBasisEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'AVERAGE_OF_VENDOR_LOWEST_ELIGIBLE_PRICE')
  static const WorkPackageBudgetEstimateBasisEnum AVERAGE_OF_VENDOR_LOWEST_ELIGIBLE_PRICE = _$workPackageBudgetEstimateBasisEnum_AVERAGE_OF_VENDOR_LOWEST_ELIGIBLE_PRICE;

  static Serializer<WorkPackageBudgetEstimateBasisEnum> get serializer => _$workPackageBudgetEstimateBasisEnumSerializer;

  const WorkPackageBudgetEstimateBasisEnum._(String name): super(name);

  static BuiltSet<WorkPackageBudgetEstimateBasisEnum> get values => _$workPackageBudgetEstimateBasisEnumValues;
  static WorkPackageBudgetEstimateBasisEnum valueOf(String name) => _$workPackageBudgetEstimateBasisEnumValueOf(name);
}

