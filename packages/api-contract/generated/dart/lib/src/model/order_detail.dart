//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/order_payment_availability.dart';
import 'package:materyalph_api_client/src/model/order_checkout_ref.dart';
import 'package:materyalph_api_client/src/model/order_timeline_event.dart';
import 'package:materyalph_api_client/src/model/order_vendor_ref.dart';
import 'package:materyalph_api_client/src/model/order_reservation.dart';
import 'package:materyalph_api_client/src/model/auto_accept_outcome.dart';
import 'package:materyalph_api_client/src/model/order_destination.dart';
import 'package:materyalph_api_client/src/model/order_state_row.dart';
import 'package:materyalph_api_client/src/model/vendor_order_permissions.dart';
import 'package:materyalph_api_client/src/model/vendor_order_decline_reason.dart';
import 'package:materyalph_api_client/src/model/nrpc_terms_ref.dart';
import 'package:materyalph_api_client/src/model/date.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/order_nrpc.dart';
import 'package:materyalph_api_client/src/model/vendor_order_primary_action.dart';
import 'package:materyalph_api_client/src/model/money_breakdown.dart';
import 'package:materyalph_api_client/src/model/order_deadlines.dart';
import 'package:materyalph_api_client/src/model/order_buyer_ref.dart';
import 'package:materyalph_api_client/src/model/order_delivery.dart';
import 'package:materyalph_api_client/src/model/order_line.dart';
import 'package:materyalph_api_client/src/model/order_commercial_version.dart';
import 'package:materyalph_api_client/src/model/order_change.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'order_detail.g.dart';

/// Buyer responses add available_actions and payment; Vendor responses add buyer, auto_accept, reservations, permissions, primary_action, nrpc_terms and decline_reasons.
///
/// Properties:
/// * [projectContext]
/// * [id]
/// * [reference]
/// * [checkout]
/// * [vendor]
/// * [procurementType]
/// * [fulfillmentMethod]
/// * [paymentMethod]
/// * [submittedAt]
/// * [acceptedAt]
/// * [closedAt]
/// * [terminalReasonCode]
/// * [confirmationSource]
/// * [states]
/// * [deadlines]
/// * [commercialVersion]
/// * [changes]
/// * [expectedFulfillmentDate]
/// * [lines]
/// * [destination]
/// * [delivery]
/// * [money]
/// * [nrpc]
/// * [timeline]
/// * [lockVersion]
/// * [availableActions]
/// * [payment]
/// * [buyer]
/// * [autoAccept]
/// * [reservations]
/// * [permissions]
/// * [primaryAction]
/// * [nrpcTerms]
/// * [declineReasons]
@BuiltValue()
abstract class OrderDetail implements Built<OrderDetail, OrderDetailBuilder> {
  @BuiltValueField(wireName: r'project_context')
  BuiltMap<String, JsonObject?>? get projectContext;

  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'reference')
  String get reference;

  @BuiltValueField(wireName: r'checkout')
  OrderCheckoutRef? get checkout;

  @BuiltValueField(wireName: r'vendor')
  OrderVendorRef get vendor;

  @BuiltValueField(wireName: r'procurement_type')
  OrderDetailProcurementTypeEnum get procurementType;
  // enum procurementTypeEnum {  ITEM_BASED,  PROJECT_BASED,  };

  @BuiltValueField(wireName: r'fulfillment_method')
  OrderDetailFulfillmentMethodEnum get fulfillmentMethod;
  // enum fulfillmentMethodEnum {  DELIVERY,  PICKUP,  };

  @BuiltValueField(wireName: r'payment_method')
  OrderDetailPaymentMethodEnum get paymentMethod;
  // enum paymentMethodEnum {  ONLINE,  CASH_ON_DELIVERY,  IN_STORE,  };

  @BuiltValueField(wireName: r'submitted_at')
  DateTime? get submittedAt;

  @BuiltValueField(wireName: r'accepted_at')
  DateTime? get acceptedAt;

  @BuiltValueField(wireName: r'closed_at')
  DateTime? get closedAt;

  @BuiltValueField(wireName: r'terminal_reason_code')
  String? get terminalReasonCode;

  @BuiltValueField(wireName: r'confirmation_source')
  OrderDetailConfirmationSourceEnum? get confirmationSource;
  // enum confirmationSourceEnum {  MANUAL,  AUTO_ACCEPT,  ,  };

  @BuiltValueField(wireName: r'states')
  BuiltList<OrderStateRow> get states;

  @BuiltValueField(wireName: r'deadlines')
  OrderDeadlines get deadlines;

  @BuiltValueField(wireName: r'commercial_version')
  OrderCommercialVersion get commercialVersion;

  @BuiltValueField(wireName: r'changes')
  BuiltList<OrderChange> get changes;

  @BuiltValueField(wireName: r'expected_fulfillment_date')
  Date? get expectedFulfillmentDate;

  @BuiltValueField(wireName: r'lines')
  BuiltList<OrderLine> get lines;

  @BuiltValueField(wireName: r'destination')
  OrderDestination? get destination;

  @BuiltValueField(wireName: r'delivery')
  OrderDelivery get delivery;

  @BuiltValueField(wireName: r'money')
  MoneyBreakdown get money;

  @BuiltValueField(wireName: r'nrpc')
  OrderNrpc? get nrpc;

  @BuiltValueField(wireName: r'timeline')
  BuiltList<OrderTimelineEvent> get timeline;

  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  @BuiltValueField(wireName: r'available_actions')
  BuiltList<OrderDetailAvailableActionsEnum>? get availableActions;
  // enum availableActionsEnum {  APPROVE_REVISION,  REJECT_REVISION,  ACCEPT_NRPC,  REJECT_NRPC,  FLAG_NRPC,  PAY,  };

  @BuiltValueField(wireName: r'payment')
  OrderPaymentAvailability? get payment;

  @BuiltValueField(wireName: r'buyer')
  OrderBuyerRef? get buyer;

  @BuiltValueField(wireName: r'auto_accept')
  AutoAcceptOutcome? get autoAccept;

  @BuiltValueField(wireName: r'reservations')
  BuiltList<OrderReservation>? get reservations;

  @BuiltValueField(wireName: r'permissions')
  VendorOrderPermissions? get permissions;

  @BuiltValueField(wireName: r'primary_action')
  VendorOrderPrimaryAction? get primaryAction;
  // enum primaryActionEnum {  CONFIRM,  WAITING_FOR_BUYER,  WAITING_FOR_PAYMENT,  PREPARE_WHEN_AVAILABLE,  NONE,  };

  @BuiltValueField(wireName: r'nrpc_terms')
  NrpcTermsRef? get nrpcTerms;

  @BuiltValueField(wireName: r'decline_reasons')
  BuiltList<VendorOrderDeclineReason>? get declineReasons;

  OrderDetail._();

  factory OrderDetail([void updates(OrderDetailBuilder b)]) = _$OrderDetail;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OrderDetailBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OrderDetail> get serializer => _$OrderDetailSerializer();
}

class _$OrderDetailSerializer implements PrimitiveSerializer<OrderDetail> {
  @override
  final Iterable<Type> types = const [OrderDetail, _$OrderDetail];

  @override
  final String wireName = r'OrderDetail';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OrderDetail object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.projectContext != null) {
      yield r'project_context';
      yield serializers.serialize(
        object.projectContext,
        specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
      );
    }
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'reference';
    yield serializers.serialize(
      object.reference,
      specifiedType: const FullType(String),
    );
    yield r'checkout';
    yield object.checkout == null ? null : serializers.serialize(
      object.checkout,
      specifiedType: const FullType.nullable(OrderCheckoutRef),
    );
    yield r'vendor';
    yield serializers.serialize(
      object.vendor,
      specifiedType: const FullType(OrderVendorRef),
    );
    yield r'procurement_type';
    yield serializers.serialize(
      object.procurementType,
      specifiedType: const FullType(OrderDetailProcurementTypeEnum),
    );
    yield r'fulfillment_method';
    yield serializers.serialize(
      object.fulfillmentMethod,
      specifiedType: const FullType(OrderDetailFulfillmentMethodEnum),
    );
    yield r'payment_method';
    yield serializers.serialize(
      object.paymentMethod,
      specifiedType: const FullType(OrderDetailPaymentMethodEnum),
    );
    yield r'submitted_at';
    yield object.submittedAt == null ? null : serializers.serialize(
      object.submittedAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'accepted_at';
    yield object.acceptedAt == null ? null : serializers.serialize(
      object.acceptedAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'closed_at';
    yield object.closedAt == null ? null : serializers.serialize(
      object.closedAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'terminal_reason_code';
    yield object.terminalReasonCode == null ? null : serializers.serialize(
      object.terminalReasonCode,
      specifiedType: const FullType.nullable(String),
    );
    yield r'confirmation_source';
    yield object.confirmationSource == null ? null : serializers.serialize(
      object.confirmationSource,
      specifiedType: const FullType.nullable(OrderDetailConfirmationSourceEnum),
    );
    yield r'states';
    yield serializers.serialize(
      object.states,
      specifiedType: const FullType(BuiltList, [FullType(OrderStateRow)]),
    );
    yield r'deadlines';
    yield serializers.serialize(
      object.deadlines,
      specifiedType: const FullType(OrderDeadlines),
    );
    yield r'commercial_version';
    yield serializers.serialize(
      object.commercialVersion,
      specifiedType: const FullType(OrderCommercialVersion),
    );
    yield r'changes';
    yield serializers.serialize(
      object.changes,
      specifiedType: const FullType(BuiltList, [FullType(OrderChange)]),
    );
    yield r'expected_fulfillment_date';
    yield object.expectedFulfillmentDate == null ? null : serializers.serialize(
      object.expectedFulfillmentDate,
      specifiedType: const FullType.nullable(Date),
    );
    yield r'lines';
    yield serializers.serialize(
      object.lines,
      specifiedType: const FullType(BuiltList, [FullType(OrderLine)]),
    );
    yield r'destination';
    yield object.destination == null ? null : serializers.serialize(
      object.destination,
      specifiedType: const FullType.nullable(OrderDestination),
    );
    yield r'delivery';
    yield serializers.serialize(
      object.delivery,
      specifiedType: const FullType(OrderDelivery),
    );
    yield r'money';
    yield serializers.serialize(
      object.money,
      specifiedType: const FullType(MoneyBreakdown),
    );
    yield r'nrpc';
    yield object.nrpc == null ? null : serializers.serialize(
      object.nrpc,
      specifiedType: const FullType.nullable(OrderNrpc),
    );
    yield r'timeline';
    yield serializers.serialize(
      object.timeline,
      specifiedType: const FullType(BuiltList, [FullType(OrderTimelineEvent)]),
    );
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
    if (object.availableActions != null) {
      yield r'available_actions';
      yield serializers.serialize(
        object.availableActions,
        specifiedType: const FullType(BuiltList, [FullType(OrderDetailAvailableActionsEnum)]),
      );
    }
    if (object.payment != null) {
      yield r'payment';
      yield serializers.serialize(
        object.payment,
        specifiedType: const FullType(OrderPaymentAvailability),
      );
    }
    if (object.buyer != null) {
      yield r'buyer';
      yield serializers.serialize(
        object.buyer,
        specifiedType: const FullType(OrderBuyerRef),
      );
    }
    if (object.autoAccept != null) {
      yield r'auto_accept';
      yield serializers.serialize(
        object.autoAccept,
        specifiedType: const FullType.nullable(AutoAcceptOutcome),
      );
    }
    if (object.reservations != null) {
      yield r'reservations';
      yield serializers.serialize(
        object.reservations,
        specifiedType: const FullType(BuiltList, [FullType(OrderReservation)]),
      );
    }
    if (object.permissions != null) {
      yield r'permissions';
      yield serializers.serialize(
        object.permissions,
        specifiedType: const FullType(VendorOrderPermissions),
      );
    }
    if (object.primaryAction != null) {
      yield r'primary_action';
      yield serializers.serialize(
        object.primaryAction,
        specifiedType: const FullType(VendorOrderPrimaryAction),
      );
    }
    if (object.nrpcTerms != null) {
      yield r'nrpc_terms';
      yield serializers.serialize(
        object.nrpcTerms,
        specifiedType: const FullType.nullable(NrpcTermsRef),
      );
    }
    if (object.declineReasons != null) {
      yield r'decline_reasons';
      yield serializers.serialize(
        object.declineReasons,
        specifiedType: const FullType(BuiltList, [FullType(VendorOrderDeclineReason)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    OrderDetail object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OrderDetailBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'project_context':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>?;
          if (valueDes == null) continue;
          result.projectContext.replace(valueDes);
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'reference':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reference = valueDes;
          break;
        case r'checkout':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(OrderCheckoutRef),
          ) as OrderCheckoutRef?;
          if (valueDes == null) continue;
          result.checkout.replace(valueDes);
          break;
        case r'vendor':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(OrderVendorRef),
          ) as OrderVendorRef;
          result.vendor.replace(valueDes);
          break;
        case r'procurement_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(OrderDetailProcurementTypeEnum),
          ) as OrderDetailProcurementTypeEnum;
          result.procurementType = valueDes;
          break;
        case r'fulfillment_method':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(OrderDetailFulfillmentMethodEnum),
          ) as OrderDetailFulfillmentMethodEnum;
          result.fulfillmentMethod = valueDes;
          break;
        case r'payment_method':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(OrderDetailPaymentMethodEnum),
          ) as OrderDetailPaymentMethodEnum;
          result.paymentMethod = valueDes;
          break;
        case r'submitted_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.submittedAt = valueDes;
          break;
        case r'accepted_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.acceptedAt = valueDes;
          break;
        case r'closed_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.closedAt = valueDes;
          break;
        case r'terminal_reason_code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.terminalReasonCode = valueDes;
          break;
        case r'confirmation_source':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(OrderDetailConfirmationSourceEnum),
          ) as OrderDetailConfirmationSourceEnum?;
          if (valueDes == null) continue;
          result.confirmationSource = valueDes;
          break;
        case r'states':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(OrderStateRow)]),
          ) as BuiltList<OrderStateRow>;
          result.states.replace(valueDes);
          break;
        case r'deadlines':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(OrderDeadlines),
          ) as OrderDeadlines;
          result.deadlines.replace(valueDes);
          break;
        case r'commercial_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(OrderCommercialVersion),
          ) as OrderCommercialVersion;
          result.commercialVersion.replace(valueDes);
          break;
        case r'changes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(OrderChange)]),
          ) as BuiltList<OrderChange>;
          result.changes.replace(valueDes);
          break;
        case r'expected_fulfillment_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Date),
          ) as Date?;
          if (valueDes == null) continue;
          result.expectedFulfillmentDate = valueDes;
          break;
        case r'lines':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(OrderLine)]),
          ) as BuiltList<OrderLine>;
          result.lines.replace(valueDes);
          break;
        case r'destination':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(OrderDestination),
          ) as OrderDestination?;
          if (valueDes == null) continue;
          result.destination.replace(valueDes);
          break;
        case r'delivery':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(OrderDelivery),
          ) as OrderDelivery;
          result.delivery.replace(valueDes);
          break;
        case r'money':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(MoneyBreakdown),
          ) as MoneyBreakdown;
          result.money.replace(valueDes);
          break;
        case r'nrpc':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(OrderNrpc),
          ) as OrderNrpc?;
          if (valueDes == null) continue;
          result.nrpc.replace(valueDes);
          break;
        case r'timeline':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(OrderTimelineEvent)]),
          ) as BuiltList<OrderTimelineEvent>;
          result.timeline.replace(valueDes);
          break;
        case r'lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lockVersion = valueDes;
          break;
        case r'available_actions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(OrderDetailAvailableActionsEnum)]),
          ) as BuiltList<OrderDetailAvailableActionsEnum>?;
          if (valueDes == null) continue;
          result.availableActions.replace(valueDes);
          break;
        case r'payment':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(OrderPaymentAvailability),
          ) as OrderPaymentAvailability?;
          if (valueDes == null) continue;
          result.payment.replace(valueDes);
          break;
        case r'buyer':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(OrderBuyerRef),
          ) as OrderBuyerRef?;
          if (valueDes == null) continue;
          result.buyer.replace(valueDes);
          break;
        case r'auto_accept':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(AutoAcceptOutcome),
          ) as AutoAcceptOutcome?;
          if (valueDes == null) continue;
          result.autoAccept.replace(valueDes);
          break;
        case r'reservations':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(OrderReservation)]),
          ) as BuiltList<OrderReservation>?;
          if (valueDes == null) continue;
          result.reservations.replace(valueDes);
          break;
        case r'permissions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(VendorOrderPermissions),
          ) as VendorOrderPermissions?;
          if (valueDes == null) continue;
          result.permissions.replace(valueDes);
          break;
        case r'primary_action':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(VendorOrderPrimaryAction),
          ) as VendorOrderPrimaryAction?;
          if (valueDes == null) continue;
          result.primaryAction = valueDes;
          break;
        case r'nrpc_terms':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(NrpcTermsRef),
          ) as NrpcTermsRef?;
          if (valueDes == null) continue;
          result.nrpcTerms.replace(valueDes);
          break;
        case r'decline_reasons':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(VendorOrderDeclineReason)]),
          ) as BuiltList<VendorOrderDeclineReason>?;
          if (valueDes == null) continue;
          result.declineReasons.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  OrderDetail deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OrderDetailBuilder();
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


class OrderDetailProcurementTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ITEM_BASED')
  static const OrderDetailProcurementTypeEnum ITEM_BASED = _$orderDetailProcurementTypeEnum_ITEM_BASED;
  @BuiltValueEnumConst(wireName: r'PROJECT_BASED')
  static const OrderDetailProcurementTypeEnum PROJECT_BASED = _$orderDetailProcurementTypeEnum_PROJECT_BASED;

  static Serializer<OrderDetailProcurementTypeEnum> get serializer => _$orderDetailProcurementTypeEnumSerializer;

  const OrderDetailProcurementTypeEnum._(String name): super(name);

  static BuiltSet<OrderDetailProcurementTypeEnum> get values => _$orderDetailProcurementTypeEnumValues;
  static OrderDetailProcurementTypeEnum valueOf(String name) => _$orderDetailProcurementTypeEnumValueOf(name);
}

class OrderDetailFulfillmentMethodEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DELIVERY')
  static const OrderDetailFulfillmentMethodEnum DELIVERY = _$orderDetailFulfillmentMethodEnum_DELIVERY;
  @BuiltValueEnumConst(wireName: r'PICKUP')
  static const OrderDetailFulfillmentMethodEnum PICKUP = _$orderDetailFulfillmentMethodEnum_PICKUP;

  static Serializer<OrderDetailFulfillmentMethodEnum> get serializer => _$orderDetailFulfillmentMethodEnumSerializer;

  const OrderDetailFulfillmentMethodEnum._(String name): super(name);

  static BuiltSet<OrderDetailFulfillmentMethodEnum> get values => _$orderDetailFulfillmentMethodEnumValues;
  static OrderDetailFulfillmentMethodEnum valueOf(String name) => _$orderDetailFulfillmentMethodEnumValueOf(name);
}

class OrderDetailPaymentMethodEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ONLINE')
  static const OrderDetailPaymentMethodEnum ONLINE = _$orderDetailPaymentMethodEnum_ONLINE;
  @BuiltValueEnumConst(wireName: r'CASH_ON_DELIVERY')
  static const OrderDetailPaymentMethodEnum CASH_ON_DELIVERY = _$orderDetailPaymentMethodEnum_CASH_ON_DELIVERY;
  @BuiltValueEnumConst(wireName: r'IN_STORE')
  static const OrderDetailPaymentMethodEnum IN_STORE = _$orderDetailPaymentMethodEnum_IN_STORE;

  static Serializer<OrderDetailPaymentMethodEnum> get serializer => _$orderDetailPaymentMethodEnumSerializer;

  const OrderDetailPaymentMethodEnum._(String name): super(name);

  static BuiltSet<OrderDetailPaymentMethodEnum> get values => _$orderDetailPaymentMethodEnumValues;
  static OrderDetailPaymentMethodEnum valueOf(String name) => _$orderDetailPaymentMethodEnumValueOf(name);
}

class OrderDetailConfirmationSourceEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'MANUAL')
  static const OrderDetailConfirmationSourceEnum MANUAL = _$orderDetailConfirmationSourceEnum_MANUAL;
  @BuiltValueEnumConst(wireName: r'AUTO_ACCEPT')
  static const OrderDetailConfirmationSourceEnum AUTO_ACCEPT = _$orderDetailConfirmationSourceEnum_AUTO_ACCEPT;

  static Serializer<OrderDetailConfirmationSourceEnum> get serializer => _$orderDetailConfirmationSourceEnumSerializer;

  const OrderDetailConfirmationSourceEnum._(String name): super(name);

  static BuiltSet<OrderDetailConfirmationSourceEnum> get values => _$orderDetailConfirmationSourceEnumValues;
  static OrderDetailConfirmationSourceEnum valueOf(String name) => _$orderDetailConfirmationSourceEnumValueOf(name);
}

class OrderDetailAvailableActionsEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'APPROVE_REVISION')
  static const OrderDetailAvailableActionsEnum APPROVE_REVISION = _$orderDetailAvailableActionsEnum_APPROVE_REVISION;
  @BuiltValueEnumConst(wireName: r'REJECT_REVISION')
  static const OrderDetailAvailableActionsEnum REJECT_REVISION = _$orderDetailAvailableActionsEnum_REJECT_REVISION;
  @BuiltValueEnumConst(wireName: r'ACCEPT_NRPC')
  static const OrderDetailAvailableActionsEnum ACCEPT_NRPC = _$orderDetailAvailableActionsEnum_ACCEPT_NRPC;
  @BuiltValueEnumConst(wireName: r'REJECT_NRPC')
  static const OrderDetailAvailableActionsEnum REJECT_NRPC = _$orderDetailAvailableActionsEnum_REJECT_NRPC;
  @BuiltValueEnumConst(wireName: r'FLAG_NRPC')
  static const OrderDetailAvailableActionsEnum FLAG_NRPC = _$orderDetailAvailableActionsEnum_FLAG_NRPC;
  @BuiltValueEnumConst(wireName: r'PAY')
  static const OrderDetailAvailableActionsEnum PAY = _$orderDetailAvailableActionsEnum_PAY;

  static Serializer<OrderDetailAvailableActionsEnum> get serializer => _$orderDetailAvailableActionsEnumSerializer;

  const OrderDetailAvailableActionsEnum._(String name): super(name);

  static BuiltSet<OrderDetailAvailableActionsEnum> get values => _$orderDetailAvailableActionsEnumValues;
  static OrderDetailAvailableActionsEnum valueOf(String name) => _$orderDetailAvailableActionsEnumValueOf(name);
}

