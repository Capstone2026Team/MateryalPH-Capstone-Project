//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/order_first_line.dart';
import 'package:materyalph_api_client/src/model/date.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/order_vendor_ref.dart';
import 'package:materyalph_api_client/src/model/vendor_order_primary_action.dart';
import 'package:materyalph_api_client/src/model/order_buyer_ref.dart';
import 'package:materyalph_api_client/src/model/order_deadline.dart';
import 'package:materyalph_api_client/src/model/order_state_row.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'order_summary.g.dart';

/// Buyer rows add next_action; Vendor rows add buyer, primary_action and nrpc_indicator.
///
/// Properties:
/// * [id]
/// * [reference]
/// * [vendor]
/// * [submittedAt]
/// * [procurementType]
/// * [confirmationSource]
/// * [states]
/// * [fulfillmentMethod]
/// * [paymentMethod]
/// * [lineCount]
/// * [firstLine]
/// * [materialsCentavos]
/// * [deliveryCentavos]
/// * [commercialTotalCentavos]
/// * [deliveryPending]
/// * [deadline]
/// * [expectedFulfillmentDate]
/// * [nextAction]
/// * [paymentRetryable] - Buyer list only. True when the order is Pending Payment and its latest checkout attempt failed or expired. Retry uses the same order and principal.
/// * [buyer]
/// * [primaryAction]
/// * [nrpcIndicator]
@BuiltValue()
abstract class OrderSummary implements Built<OrderSummary, OrderSummaryBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'reference')
  String get reference;

  @BuiltValueField(wireName: r'vendor')
  OrderVendorRef get vendor;

  @BuiltValueField(wireName: r'submitted_at')
  DateTime? get submittedAt;

  @BuiltValueField(wireName: r'procurement_type')
  OrderSummaryProcurementTypeEnum get procurementType;
  // enum procurementTypeEnum {  ITEM_BASED,  PROJECT_BASED,  };

  @BuiltValueField(wireName: r'confirmation_source')
  OrderSummaryConfirmationSourceEnum? get confirmationSource;
  // enum confirmationSourceEnum {  MANUAL,  AUTO_ACCEPT,  ,  };

  @BuiltValueField(wireName: r'states')
  BuiltList<OrderStateRow> get states;

  @BuiltValueField(wireName: r'fulfillment_method')
  OrderSummaryFulfillmentMethodEnum get fulfillmentMethod;
  // enum fulfillmentMethodEnum {  DELIVERY,  PICKUP,  };

  @BuiltValueField(wireName: r'payment_method')
  OrderSummaryPaymentMethodEnum get paymentMethod;
  // enum paymentMethodEnum {  ONLINE,  CASH_ON_DELIVERY,  IN_STORE,  };

  @BuiltValueField(wireName: r'line_count')
  int get lineCount;

  @BuiltValueField(wireName: r'first_line')
  OrderFirstLine get firstLine;

  @BuiltValueField(wireName: r'materials_centavos')
  int get materialsCentavos;

  @BuiltValueField(wireName: r'delivery_centavos')
  int? get deliveryCentavos;

  @BuiltValueField(wireName: r'commercial_total_centavos')
  int get commercialTotalCentavos;

  @BuiltValueField(wireName: r'delivery_pending')
  bool get deliveryPending;

  @BuiltValueField(wireName: r'deadline')
  OrderDeadline? get deadline;

  @BuiltValueField(wireName: r'expected_fulfillment_date')
  Date? get expectedFulfillmentDate;

  @BuiltValueField(wireName: r'next_action')
  OrderSummaryNextActionEnum? get nextAction;
  // enum nextActionEnum {  REVIEW_REVISION,  REVIEW_NRPC,  PAY,  CONFIRM_RECEIPT,  ,  };

  /// Buyer list only. True when the order is Pending Payment and its latest checkout attempt failed or expired. Retry uses the same order and principal.
  @BuiltValueField(wireName: r'payment_retryable')
  bool? get paymentRetryable;

  @BuiltValueField(wireName: r'buyer')
  OrderBuyerRef? get buyer;

  @BuiltValueField(wireName: r'primary_action')
  VendorOrderPrimaryAction? get primaryAction;
  // enum primaryActionEnum {  CONFIRM,  WAITING_FOR_BUYER,  WAITING_FOR_PAYMENT,  PREPARE_WHEN_AVAILABLE,  START_PREPARATION,  MARK_READY,  DISPATCH,  RECORD_PICKUP,  RECORD_DELIVERY,  AWAIT_RECEIPT,  RESPOND_TO_CANCELLATION,  NONE,  };

  @BuiltValueField(wireName: r'nrpc_indicator')
  bool? get nrpcIndicator;

  OrderSummary._();

  factory OrderSummary([void updates(OrderSummaryBuilder b)]) = _$OrderSummary;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OrderSummaryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OrderSummary> get serializer => _$OrderSummarySerializer();
}

class _$OrderSummarySerializer implements PrimitiveSerializer<OrderSummary> {
  @override
  final Iterable<Type> types = const [OrderSummary, _$OrderSummary];

  @override
  final String wireName = r'OrderSummary';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OrderSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
    yield r'vendor';
    yield serializers.serialize(
      object.vendor,
      specifiedType: const FullType(OrderVendorRef),
    );
    yield r'submitted_at';
    yield object.submittedAt == null ? null : serializers.serialize(
      object.submittedAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'procurement_type';
    yield serializers.serialize(
      object.procurementType,
      specifiedType: const FullType(OrderSummaryProcurementTypeEnum),
    );
    yield r'confirmation_source';
    yield object.confirmationSource == null ? null : serializers.serialize(
      object.confirmationSource,
      specifiedType: const FullType.nullable(OrderSummaryConfirmationSourceEnum),
    );
    yield r'states';
    yield serializers.serialize(
      object.states,
      specifiedType: const FullType(BuiltList, [FullType(OrderStateRow)]),
    );
    yield r'fulfillment_method';
    yield serializers.serialize(
      object.fulfillmentMethod,
      specifiedType: const FullType(OrderSummaryFulfillmentMethodEnum),
    );
    yield r'payment_method';
    yield serializers.serialize(
      object.paymentMethod,
      specifiedType: const FullType(OrderSummaryPaymentMethodEnum),
    );
    yield r'line_count';
    yield serializers.serialize(
      object.lineCount,
      specifiedType: const FullType(int),
    );
    yield r'first_line';
    yield serializers.serialize(
      object.firstLine,
      specifiedType: const FullType(OrderFirstLine),
    );
    yield r'materials_centavos';
    yield serializers.serialize(
      object.materialsCentavos,
      specifiedType: const FullType(int),
    );
    yield r'delivery_centavos';
    yield object.deliveryCentavos == null ? null : serializers.serialize(
      object.deliveryCentavos,
      specifiedType: const FullType.nullable(int),
    );
    yield r'commercial_total_centavos';
    yield serializers.serialize(
      object.commercialTotalCentavos,
      specifiedType: const FullType(int),
    );
    yield r'delivery_pending';
    yield serializers.serialize(
      object.deliveryPending,
      specifiedType: const FullType(bool),
    );
    yield r'deadline';
    yield object.deadline == null ? null : serializers.serialize(
      object.deadline,
      specifiedType: const FullType.nullable(OrderDeadline),
    );
    yield r'expected_fulfillment_date';
    yield object.expectedFulfillmentDate == null ? null : serializers.serialize(
      object.expectedFulfillmentDate,
      specifiedType: const FullType.nullable(Date),
    );
    if (object.nextAction != null) {
      yield r'next_action';
      yield serializers.serialize(
        object.nextAction,
        specifiedType: const FullType.nullable(OrderSummaryNextActionEnum),
      );
    }
    if (object.paymentRetryable != null) {
      yield r'payment_retryable';
      yield serializers.serialize(
        object.paymentRetryable,
        specifiedType: const FullType(bool),
      );
    }
    if (object.buyer != null) {
      yield r'buyer';
      yield serializers.serialize(
        object.buyer,
        specifiedType: const FullType(OrderBuyerRef),
      );
    }
    if (object.primaryAction != null) {
      yield r'primary_action';
      yield serializers.serialize(
        object.primaryAction,
        specifiedType: const FullType(VendorOrderPrimaryAction),
      );
    }
    if (object.nrpcIndicator != null) {
      yield r'nrpc_indicator';
      yield serializers.serialize(
        object.nrpcIndicator,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    OrderSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OrderSummaryBuilder result,
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
        case r'reference':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reference = valueDes;
          break;
        case r'vendor':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(OrderVendorRef),
          ) as OrderVendorRef;
          result.vendor.replace(valueDes);
          break;
        case r'submitted_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.submittedAt = valueDes;
          break;
        case r'procurement_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(OrderSummaryProcurementTypeEnum),
          ) as OrderSummaryProcurementTypeEnum;
          result.procurementType = valueDes;
          break;
        case r'confirmation_source':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(OrderSummaryConfirmationSourceEnum),
          ) as OrderSummaryConfirmationSourceEnum?;
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
        case r'fulfillment_method':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(OrderSummaryFulfillmentMethodEnum),
          ) as OrderSummaryFulfillmentMethodEnum;
          result.fulfillmentMethod = valueDes;
          break;
        case r'payment_method':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(OrderSummaryPaymentMethodEnum),
          ) as OrderSummaryPaymentMethodEnum;
          result.paymentMethod = valueDes;
          break;
        case r'line_count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lineCount = valueDes;
          break;
        case r'first_line':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(OrderFirstLine),
          ) as OrderFirstLine;
          result.firstLine.replace(valueDes);
          break;
        case r'materials_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.materialsCentavos = valueDes;
          break;
        case r'delivery_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.deliveryCentavos = valueDes;
          break;
        case r'commercial_total_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.commercialTotalCentavos = valueDes;
          break;
        case r'delivery_pending':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.deliveryPending = valueDes;
          break;
        case r'deadline':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(OrderDeadline),
          ) as OrderDeadline?;
          if (valueDes == null) continue;
          result.deadline.replace(valueDes);
          break;
        case r'expected_fulfillment_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Date),
          ) as Date?;
          if (valueDes == null) continue;
          result.expectedFulfillmentDate = valueDes;
          break;
        case r'next_action':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(OrderSummaryNextActionEnum),
          ) as OrderSummaryNextActionEnum?;
          if (valueDes == null) continue;
          result.nextAction = valueDes;
          break;
        case r'payment_retryable':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.paymentRetryable = valueDes;
          break;
        case r'buyer':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(OrderBuyerRef),
          ) as OrderBuyerRef?;
          if (valueDes == null) continue;
          result.buyer.replace(valueDes);
          break;
        case r'primary_action':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(VendorOrderPrimaryAction),
          ) as VendorOrderPrimaryAction?;
          if (valueDes == null) continue;
          result.primaryAction = valueDes;
          break;
        case r'nrpc_indicator':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.nrpcIndicator = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  OrderSummary deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OrderSummaryBuilder();
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


class OrderSummaryProcurementTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ITEM_BASED')
  static const OrderSummaryProcurementTypeEnum ITEM_BASED = _$orderSummaryProcurementTypeEnum_ITEM_BASED;
  @BuiltValueEnumConst(wireName: r'PROJECT_BASED')
  static const OrderSummaryProcurementTypeEnum PROJECT_BASED = _$orderSummaryProcurementTypeEnum_PROJECT_BASED;

  static Serializer<OrderSummaryProcurementTypeEnum> get serializer => _$orderSummaryProcurementTypeEnumSerializer;

  const OrderSummaryProcurementTypeEnum._(String name): super(name);

  static BuiltSet<OrderSummaryProcurementTypeEnum> get values => _$orderSummaryProcurementTypeEnumValues;
  static OrderSummaryProcurementTypeEnum valueOf(String name) => _$orderSummaryProcurementTypeEnumValueOf(name);
}

class OrderSummaryConfirmationSourceEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'MANUAL')
  static const OrderSummaryConfirmationSourceEnum MANUAL = _$orderSummaryConfirmationSourceEnum_MANUAL;
  @BuiltValueEnumConst(wireName: r'AUTO_ACCEPT')
  static const OrderSummaryConfirmationSourceEnum AUTO_ACCEPT = _$orderSummaryConfirmationSourceEnum_AUTO_ACCEPT;

  static Serializer<OrderSummaryConfirmationSourceEnum> get serializer => _$orderSummaryConfirmationSourceEnumSerializer;

  const OrderSummaryConfirmationSourceEnum._(String name): super(name);

  static BuiltSet<OrderSummaryConfirmationSourceEnum> get values => _$orderSummaryConfirmationSourceEnumValues;
  static OrderSummaryConfirmationSourceEnum valueOf(String name) => _$orderSummaryConfirmationSourceEnumValueOf(name);
}

class OrderSummaryFulfillmentMethodEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DELIVERY')
  static const OrderSummaryFulfillmentMethodEnum DELIVERY = _$orderSummaryFulfillmentMethodEnum_DELIVERY;
  @BuiltValueEnumConst(wireName: r'PICKUP')
  static const OrderSummaryFulfillmentMethodEnum PICKUP = _$orderSummaryFulfillmentMethodEnum_PICKUP;

  static Serializer<OrderSummaryFulfillmentMethodEnum> get serializer => _$orderSummaryFulfillmentMethodEnumSerializer;

  const OrderSummaryFulfillmentMethodEnum._(String name): super(name);

  static BuiltSet<OrderSummaryFulfillmentMethodEnum> get values => _$orderSummaryFulfillmentMethodEnumValues;
  static OrderSummaryFulfillmentMethodEnum valueOf(String name) => _$orderSummaryFulfillmentMethodEnumValueOf(name);
}

class OrderSummaryPaymentMethodEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ONLINE')
  static const OrderSummaryPaymentMethodEnum ONLINE = _$orderSummaryPaymentMethodEnum_ONLINE;
  @BuiltValueEnumConst(wireName: r'CASH_ON_DELIVERY')
  static const OrderSummaryPaymentMethodEnum CASH_ON_DELIVERY = _$orderSummaryPaymentMethodEnum_CASH_ON_DELIVERY;
  @BuiltValueEnumConst(wireName: r'IN_STORE')
  static const OrderSummaryPaymentMethodEnum IN_STORE = _$orderSummaryPaymentMethodEnum_IN_STORE;

  static Serializer<OrderSummaryPaymentMethodEnum> get serializer => _$orderSummaryPaymentMethodEnumSerializer;

  const OrderSummaryPaymentMethodEnum._(String name): super(name);

  static BuiltSet<OrderSummaryPaymentMethodEnum> get values => _$orderSummaryPaymentMethodEnumValues;
  static OrderSummaryPaymentMethodEnum valueOf(String name) => _$orderSummaryPaymentMethodEnumValueOf(name);
}

class OrderSummaryNextActionEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'REVIEW_REVISION')
  static const OrderSummaryNextActionEnum REVIEW_REVISION = _$orderSummaryNextActionEnum_REVIEW_REVISION;
  @BuiltValueEnumConst(wireName: r'REVIEW_NRPC')
  static const OrderSummaryNextActionEnum REVIEW_NRPC = _$orderSummaryNextActionEnum_REVIEW_NRPC;
  @BuiltValueEnumConst(wireName: r'PAY')
  static const OrderSummaryNextActionEnum PAY = _$orderSummaryNextActionEnum_PAY;
  @BuiltValueEnumConst(wireName: r'CONFIRM_RECEIPT')
  static const OrderSummaryNextActionEnum CONFIRM_RECEIPT = _$orderSummaryNextActionEnum_CONFIRM_RECEIPT;

  static Serializer<OrderSummaryNextActionEnum> get serializer => _$orderSummaryNextActionEnumSerializer;

  const OrderSummaryNextActionEnum._(String name): super(name);

  static BuiltSet<OrderSummaryNextActionEnum> get values => _$orderSummaryNextActionEnumValues;
  static OrderSummaryNextActionEnum valueOf(String name) => _$orderSummaryNextActionEnumValueOf(name);
}

