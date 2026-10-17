//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/work_package_budget_estimate_line_input.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'work_package_budget_estimate_request.g.dart';

/// WorkPackageBudgetEstimateRequest
///
/// Properties:
/// * [siteId]
/// * [radiusKm]
/// * [fulfillmentMethod]
/// * [lines]
@BuiltValue()
abstract class WorkPackageBudgetEstimateRequest implements Built<WorkPackageBudgetEstimateRequest, WorkPackageBudgetEstimateRequestBuilder> {
  @BuiltValueField(wireName: r'site_id')
  String get siteId;

  @BuiltValueField(wireName: r'radius_km')
  WorkPackageBudgetEstimateRequestRadiusKmEnum get radiusKm;
  // enum radiusKmEnum {  5,  10,  20,  30,  40,  50,  };

  @BuiltValueField(wireName: r'fulfillment_method')
  WorkPackageBudgetEstimateRequestFulfillmentMethodEnum get fulfillmentMethod;
  // enum fulfillmentMethodEnum {  PICKUP,  DELIVERY,  };

  @BuiltValueField(wireName: r'lines')
  BuiltList<WorkPackageBudgetEstimateLineInput> get lines;

  WorkPackageBudgetEstimateRequest._();

  factory WorkPackageBudgetEstimateRequest([void updates(WorkPackageBudgetEstimateRequestBuilder b)]) = _$WorkPackageBudgetEstimateRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(WorkPackageBudgetEstimateRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<WorkPackageBudgetEstimateRequest> get serializer => _$WorkPackageBudgetEstimateRequestSerializer();
}

class _$WorkPackageBudgetEstimateRequestSerializer implements PrimitiveSerializer<WorkPackageBudgetEstimateRequest> {
  @override
  final Iterable<Type> types = const [WorkPackageBudgetEstimateRequest, _$WorkPackageBudgetEstimateRequest];

  @override
  final String wireName = r'WorkPackageBudgetEstimateRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    WorkPackageBudgetEstimateRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'site_id';
    yield serializers.serialize(
      object.siteId,
      specifiedType: const FullType(String),
    );
    yield r'radius_km';
    yield serializers.serialize(
      object.radiusKm,
      specifiedType: const FullType(WorkPackageBudgetEstimateRequestRadiusKmEnum),
    );
    yield r'fulfillment_method';
    yield serializers.serialize(
      object.fulfillmentMethod,
      specifiedType: const FullType(WorkPackageBudgetEstimateRequestFulfillmentMethodEnum),
    );
    yield r'lines';
    yield serializers.serialize(
      object.lines,
      specifiedType: const FullType(BuiltList, [FullType(WorkPackageBudgetEstimateLineInput)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    WorkPackageBudgetEstimateRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required WorkPackageBudgetEstimateRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'site_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.siteId = valueDes;
          break;
        case r'radius_km':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(WorkPackageBudgetEstimateRequestRadiusKmEnum),
          ) as WorkPackageBudgetEstimateRequestRadiusKmEnum;
          result.radiusKm = valueDes;
          break;
        case r'fulfillment_method':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(WorkPackageBudgetEstimateRequestFulfillmentMethodEnum),
          ) as WorkPackageBudgetEstimateRequestFulfillmentMethodEnum;
          result.fulfillmentMethod = valueDes;
          break;
        case r'lines':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(WorkPackageBudgetEstimateLineInput)]),
          ) as BuiltList<WorkPackageBudgetEstimateLineInput>;
          result.lines.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  WorkPackageBudgetEstimateRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = WorkPackageBudgetEstimateRequestBuilder();
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


class WorkPackageBudgetEstimateRequestRadiusKmEnum extends EnumClass {

  @BuiltValueEnumConst(wireNumber: 5)
  static const WorkPackageBudgetEstimateRequestRadiusKmEnum number5 = _$workPackageBudgetEstimateRequestRadiusKmEnum_number5;
  @BuiltValueEnumConst(wireNumber: 10)
  static const WorkPackageBudgetEstimateRequestRadiusKmEnum number10 = _$workPackageBudgetEstimateRequestRadiusKmEnum_number10;
  @BuiltValueEnumConst(wireNumber: 20)
  static const WorkPackageBudgetEstimateRequestRadiusKmEnum number20 = _$workPackageBudgetEstimateRequestRadiusKmEnum_number20;
  @BuiltValueEnumConst(wireNumber: 30)
  static const WorkPackageBudgetEstimateRequestRadiusKmEnum number30 = _$workPackageBudgetEstimateRequestRadiusKmEnum_number30;
  @BuiltValueEnumConst(wireNumber: 40)
  static const WorkPackageBudgetEstimateRequestRadiusKmEnum number40 = _$workPackageBudgetEstimateRequestRadiusKmEnum_number40;
  @BuiltValueEnumConst(wireNumber: 50)
  static const WorkPackageBudgetEstimateRequestRadiusKmEnum number50 = _$workPackageBudgetEstimateRequestRadiusKmEnum_number50;

  static Serializer<WorkPackageBudgetEstimateRequestRadiusKmEnum> get serializer => _$workPackageBudgetEstimateRequestRadiusKmEnumSerializer;

  const WorkPackageBudgetEstimateRequestRadiusKmEnum._(String name): super(name);

  static BuiltSet<WorkPackageBudgetEstimateRequestRadiusKmEnum> get values => _$workPackageBudgetEstimateRequestRadiusKmEnumValues;
  static WorkPackageBudgetEstimateRequestRadiusKmEnum valueOf(String name) => _$workPackageBudgetEstimateRequestRadiusKmEnumValueOf(name);
}

class WorkPackageBudgetEstimateRequestFulfillmentMethodEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PICKUP')
  static const WorkPackageBudgetEstimateRequestFulfillmentMethodEnum PICKUP = _$workPackageBudgetEstimateRequestFulfillmentMethodEnum_PICKUP;
  @BuiltValueEnumConst(wireName: r'DELIVERY')
  static const WorkPackageBudgetEstimateRequestFulfillmentMethodEnum DELIVERY = _$workPackageBudgetEstimateRequestFulfillmentMethodEnum_DELIVERY;

  static Serializer<WorkPackageBudgetEstimateRequestFulfillmentMethodEnum> get serializer => _$workPackageBudgetEstimateRequestFulfillmentMethodEnumSerializer;

  const WorkPackageBudgetEstimateRequestFulfillmentMethodEnum._(String name): super(name);

  static BuiltSet<WorkPackageBudgetEstimateRequestFulfillmentMethodEnum> get values => _$workPackageBudgetEstimateRequestFulfillmentMethodEnumValues;
  static WorkPackageBudgetEstimateRequestFulfillmentMethodEnum valueOf(String name) => _$workPackageBudgetEstimateRequestFulfillmentMethodEnumValueOf(name);
}

