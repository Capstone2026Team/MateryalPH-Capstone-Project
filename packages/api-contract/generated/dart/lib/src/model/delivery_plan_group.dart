//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/delivery_plan_vehicle.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'delivery_plan_group.g.dart';

/// DeliveryPlanGroup
///
/// Properties:
/// * [key]
/// * [label]
/// * [status]
/// * [manualReviewReasons]
/// * [candidates]
@BuiltValue()
abstract class DeliveryPlanGroup implements Built<DeliveryPlanGroup, DeliveryPlanGroupBuilder> {
  @BuiltValueField(wireName: r'key')
  String get key;

  @BuiltValueField(wireName: r'label')
  String get label;

  @BuiltValueField(wireName: r'status')
  DeliveryPlanGroupStatusEnum get status;
  // enum statusEnum {  CANDIDATES_AVAILABLE,  MANUAL_REVIEW_REQUIRED,  NO_ELIGIBLE_VEHICLE,  };

  @BuiltValueField(wireName: r'manual_review_reasons')
  BuiltList<String> get manualReviewReasons;

  @BuiltValueField(wireName: r'candidates')
  BuiltList<DeliveryPlanVehicle> get candidates;

  DeliveryPlanGroup._();

  factory DeliveryPlanGroup([void updates(DeliveryPlanGroupBuilder b)]) = _$DeliveryPlanGroup;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DeliveryPlanGroupBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DeliveryPlanGroup> get serializer => _$DeliveryPlanGroupSerializer();
}

class _$DeliveryPlanGroupSerializer implements PrimitiveSerializer<DeliveryPlanGroup> {
  @override
  final Iterable<Type> types = const [DeliveryPlanGroup, _$DeliveryPlanGroup];

  @override
  final String wireName = r'DeliveryPlanGroup';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DeliveryPlanGroup object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'key';
    yield serializers.serialize(
      object.key,
      specifiedType: const FullType(String),
    );
    yield r'label';
    yield serializers.serialize(
      object.label,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(DeliveryPlanGroupStatusEnum),
    );
    yield r'manual_review_reasons';
    yield serializers.serialize(
      object.manualReviewReasons,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'candidates';
    yield serializers.serialize(
      object.candidates,
      specifiedType: const FullType(BuiltList, [FullType(DeliveryPlanVehicle)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DeliveryPlanGroup object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DeliveryPlanGroupBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'key':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.key = valueDes;
          break;
        case r'label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.label = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DeliveryPlanGroupStatusEnum),
          ) as DeliveryPlanGroupStatusEnum;
          result.status = valueDes;
          break;
        case r'manual_review_reasons':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.manualReviewReasons.replace(valueDes);
          break;
        case r'candidates':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(DeliveryPlanVehicle)]),
          ) as BuiltList<DeliveryPlanVehicle>;
          result.candidates.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DeliveryPlanGroup deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DeliveryPlanGroupBuilder();
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


class DeliveryPlanGroupStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'CANDIDATES_AVAILABLE')
  static const DeliveryPlanGroupStatusEnum CANDIDATES_AVAILABLE = _$deliveryPlanGroupStatusEnum_CANDIDATES_AVAILABLE;
  @BuiltValueEnumConst(wireName: r'MANUAL_REVIEW_REQUIRED')
  static const DeliveryPlanGroupStatusEnum MANUAL_REVIEW_REQUIRED = _$deliveryPlanGroupStatusEnum_MANUAL_REVIEW_REQUIRED;
  @BuiltValueEnumConst(wireName: r'NO_ELIGIBLE_VEHICLE')
  static const DeliveryPlanGroupStatusEnum NO_ELIGIBLE_VEHICLE = _$deliveryPlanGroupStatusEnum_NO_ELIGIBLE_VEHICLE;

  static Serializer<DeliveryPlanGroupStatusEnum> get serializer => _$deliveryPlanGroupStatusEnumSerializer;

  const DeliveryPlanGroupStatusEnum._(String name): super(name);

  static BuiltSet<DeliveryPlanGroupStatusEnum> get values => _$deliveryPlanGroupStatusEnumValues;
  static DeliveryPlanGroupStatusEnum valueOf(String name) => _$deliveryPlanGroupStatusEnumValueOf(name);
}

