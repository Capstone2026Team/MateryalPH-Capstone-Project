//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/fulfillment_thread_ref.dart';
import 'package:materyalph_api_client/src/model/fulfillment_vehicle_issue.dart';
import 'package:materyalph_api_client/src/model/fulfillment_issue.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/fulfillment_arrangement.dart';
import 'package:materyalph_api_client/src/model/fulfillment_proof.dart';
import 'package:materyalph_api_client/src/model/fulfillment_receipt.dart';
import 'package:materyalph_api_client/src/model/fulfillment_step.dart';
import 'package:materyalph_api_client/src/model/fulfillment_trip.dart';
import 'package:materyalph_api_client/src/model/fulfillment_assignment.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'order_fulfillment.g.dart';

/// Server-derived milestone stepper. Step completion comes only from recorded milestones; there is no live GPS or vehicle position.
///
/// Properties:
/// * [method]
/// * [state]
/// * [expectedDate]
/// * [late_]
/// * [steps]
/// * [proof]
/// * [trackingNotice]
/// * [trips]
/// * [acceptedArrangement]
/// * [receipt]
/// * [issue]
/// * [assignment]
/// * [vehicleIssues]
/// * [thread]
/// * [nextAction]
@BuiltValue()
abstract class OrderFulfillment implements Built<OrderFulfillment, OrderFulfillmentBuilder> {
  @BuiltValueField(wireName: r'method')
  OrderFulfillmentMethodEnum get method;
  // enum methodEnum {  DELIVERY,  PICKUP,  };

  @BuiltValueField(wireName: r'state')
  String get state;

  @BuiltValueField(wireName: r'expected_date')
  String? get expectedDate;

  @BuiltValueField(wireName: r'late')
  bool get late_;

  @BuiltValueField(wireName: r'steps')
  BuiltList<FulfillmentStep> get steps;

  @BuiltValueField(wireName: r'proof')
  FulfillmentProof? get proof;

  @BuiltValueField(wireName: r'tracking_notice')
  String get trackingNotice;

  @BuiltValueField(wireName: r'trips')
  BuiltList<FulfillmentTrip> get trips;

  @BuiltValueField(wireName: r'accepted_arrangement')
  FulfillmentArrangement? get acceptedArrangement;

  @BuiltValueField(wireName: r'receipt')
  FulfillmentReceipt get receipt;

  @BuiltValueField(wireName: r'issue')
  FulfillmentIssue? get issue;

  @BuiltValueField(wireName: r'assignment')
  FulfillmentAssignment? get assignment;

  @BuiltValueField(wireName: r'vehicle_issues')
  BuiltList<FulfillmentVehicleIssue> get vehicleIssues;

  @BuiltValueField(wireName: r'thread')
  FulfillmentThreadRef get thread;

  @BuiltValueField(wireName: r'next_action')
  OrderFulfillmentNextActionEnum get nextAction;
  // enum nextActionEnum {  START_PREPARATION,  MARK_READY,  DISPATCH,  RECORD_PICKUP,  RECORD_DELIVERY,  AWAIT_RECEIPT,  RESPOND_TO_CANCELLATION,  NONE,  CONFIRM_RECEIPT,  };

  OrderFulfillment._();

  factory OrderFulfillment([void updates(OrderFulfillmentBuilder b)]) = _$OrderFulfillment;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OrderFulfillmentBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OrderFulfillment> get serializer => _$OrderFulfillmentSerializer();
}

class _$OrderFulfillmentSerializer implements PrimitiveSerializer<OrderFulfillment> {
  @override
  final Iterable<Type> types = const [OrderFulfillment, _$OrderFulfillment];

  @override
  final String wireName = r'OrderFulfillment';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OrderFulfillment object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'method';
    yield serializers.serialize(
      object.method,
      specifiedType: const FullType(OrderFulfillmentMethodEnum),
    );
    yield r'state';
    yield serializers.serialize(
      object.state,
      specifiedType: const FullType(String),
    );
    if (object.expectedDate != null) {
      yield r'expected_date';
      yield serializers.serialize(
        object.expectedDate,
        specifiedType: const FullType(String),
      );
    }
    yield r'late';
    yield serializers.serialize(
      object.late_,
      specifiedType: const FullType(bool),
    );
    yield r'steps';
    yield serializers.serialize(
      object.steps,
      specifiedType: const FullType(BuiltList, [FullType(FulfillmentStep)]),
    );
    if (object.proof != null) {
      yield r'proof';
      yield serializers.serialize(
        object.proof,
        specifiedType: const FullType.nullable(FulfillmentProof),
      );
    }
    yield r'tracking_notice';
    yield serializers.serialize(
      object.trackingNotice,
      specifiedType: const FullType(String),
    );
    yield r'trips';
    yield serializers.serialize(
      object.trips,
      specifiedType: const FullType(BuiltList, [FullType(FulfillmentTrip)]),
    );
    if (object.acceptedArrangement != null) {
      yield r'accepted_arrangement';
      yield serializers.serialize(
        object.acceptedArrangement,
        specifiedType: const FullType.nullable(FulfillmentArrangement),
      );
    }
    yield r'receipt';
    yield serializers.serialize(
      object.receipt,
      specifiedType: const FullType(FulfillmentReceipt),
    );
    if (object.issue != null) {
      yield r'issue';
      yield serializers.serialize(
        object.issue,
        specifiedType: const FullType.nullable(FulfillmentIssue),
      );
    }
    if (object.assignment != null) {
      yield r'assignment';
      yield serializers.serialize(
        object.assignment,
        specifiedType: const FullType.nullable(FulfillmentAssignment),
      );
    }
    yield r'vehicle_issues';
    yield serializers.serialize(
      object.vehicleIssues,
      specifiedType: const FullType(BuiltList, [FullType(FulfillmentVehicleIssue)]),
    );
    yield r'thread';
    yield serializers.serialize(
      object.thread,
      specifiedType: const FullType(FulfillmentThreadRef),
    );
    yield r'next_action';
    yield serializers.serialize(
      object.nextAction,
      specifiedType: const FullType(OrderFulfillmentNextActionEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    OrderFulfillment object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OrderFulfillmentBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'method':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(OrderFulfillmentMethodEnum),
          ) as OrderFulfillmentMethodEnum;
          result.method = valueDes;
          break;
        case r'state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.state = valueDes;
          break;
        case r'expected_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.expectedDate = valueDes;
          break;
        case r'late':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.late_ = valueDes;
          break;
        case r'steps':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(FulfillmentStep)]),
          ) as BuiltList<FulfillmentStep>;
          result.steps.replace(valueDes);
          break;
        case r'proof':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(FulfillmentProof),
          ) as FulfillmentProof?;
          if (valueDes == null) continue;
          result.proof.replace(valueDes);
          break;
        case r'tracking_notice':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.trackingNotice = valueDes;
          break;
        case r'trips':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(FulfillmentTrip)]),
          ) as BuiltList<FulfillmentTrip>;
          result.trips.replace(valueDes);
          break;
        case r'accepted_arrangement':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(FulfillmentArrangement),
          ) as FulfillmentArrangement?;
          if (valueDes == null) continue;
          result.acceptedArrangement.replace(valueDes);
          break;
        case r'receipt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(FulfillmentReceipt),
          ) as FulfillmentReceipt;
          result.receipt.replace(valueDes);
          break;
        case r'issue':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(FulfillmentIssue),
          ) as FulfillmentIssue?;
          if (valueDes == null) continue;
          result.issue.replace(valueDes);
          break;
        case r'assignment':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(FulfillmentAssignment),
          ) as FulfillmentAssignment?;
          if (valueDes == null) continue;
          result.assignment.replace(valueDes);
          break;
        case r'vehicle_issues':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(FulfillmentVehicleIssue)]),
          ) as BuiltList<FulfillmentVehicleIssue>;
          result.vehicleIssues.replace(valueDes);
          break;
        case r'thread':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(FulfillmentThreadRef),
          ) as FulfillmentThreadRef;
          result.thread.replace(valueDes);
          break;
        case r'next_action':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(OrderFulfillmentNextActionEnum),
          ) as OrderFulfillmentNextActionEnum;
          result.nextAction = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  OrderFulfillment deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OrderFulfillmentBuilder();
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


class OrderFulfillmentMethodEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DELIVERY')
  static const OrderFulfillmentMethodEnum DELIVERY = _$orderFulfillmentMethodEnum_DELIVERY;
  @BuiltValueEnumConst(wireName: r'PICKUP')
  static const OrderFulfillmentMethodEnum PICKUP = _$orderFulfillmentMethodEnum_PICKUP;

  static Serializer<OrderFulfillmentMethodEnum> get serializer => _$orderFulfillmentMethodEnumSerializer;

  const OrderFulfillmentMethodEnum._(String name): super(name);

  static BuiltSet<OrderFulfillmentMethodEnum> get values => _$orderFulfillmentMethodEnumValues;
  static OrderFulfillmentMethodEnum valueOf(String name) => _$orderFulfillmentMethodEnumValueOf(name);
}

class OrderFulfillmentNextActionEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'START_PREPARATION')
  static const OrderFulfillmentNextActionEnum START_PREPARATION = _$orderFulfillmentNextActionEnum_START_PREPARATION;
  @BuiltValueEnumConst(wireName: r'MARK_READY')
  static const OrderFulfillmentNextActionEnum MARK_READY = _$orderFulfillmentNextActionEnum_MARK_READY;
  @BuiltValueEnumConst(wireName: r'DISPATCH')
  static const OrderFulfillmentNextActionEnum DISPATCH = _$orderFulfillmentNextActionEnum_DISPATCH;
  @BuiltValueEnumConst(wireName: r'RECORD_PICKUP')
  static const OrderFulfillmentNextActionEnum RECORD_PICKUP = _$orderFulfillmentNextActionEnum_RECORD_PICKUP;
  @BuiltValueEnumConst(wireName: r'RECORD_DELIVERY')
  static const OrderFulfillmentNextActionEnum RECORD_DELIVERY = _$orderFulfillmentNextActionEnum_RECORD_DELIVERY;
  @BuiltValueEnumConst(wireName: r'AWAIT_RECEIPT')
  static const OrderFulfillmentNextActionEnum AWAIT_RECEIPT = _$orderFulfillmentNextActionEnum_AWAIT_RECEIPT;
  @BuiltValueEnumConst(wireName: r'RESPOND_TO_CANCELLATION')
  static const OrderFulfillmentNextActionEnum RESPOND_TO_CANCELLATION = _$orderFulfillmentNextActionEnum_RESPOND_TO_CANCELLATION;
  @BuiltValueEnumConst(wireName: r'NONE')
  static const OrderFulfillmentNextActionEnum NONE = _$orderFulfillmentNextActionEnum_NONE;
  @BuiltValueEnumConst(wireName: r'CONFIRM_RECEIPT')
  static const OrderFulfillmentNextActionEnum CONFIRM_RECEIPT = _$orderFulfillmentNextActionEnum_CONFIRM_RECEIPT;

  static Serializer<OrderFulfillmentNextActionEnum> get serializer => _$orderFulfillmentNextActionEnumSerializer;

  const OrderFulfillmentNextActionEnum._(String name): super(name);

  static BuiltSet<OrderFulfillmentNextActionEnum> get values => _$orderFulfillmentNextActionEnumValues;
  static OrderFulfillmentNextActionEnum valueOf(String name) => _$orderFulfillmentNextActionEnumValueOf(name);
}

