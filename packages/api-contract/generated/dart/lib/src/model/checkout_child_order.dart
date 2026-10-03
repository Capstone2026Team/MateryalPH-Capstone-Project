//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/order_payment_state.dart';
import 'package:materyalph_api_client/src/model/order_vendor_ref.dart';
import 'package:materyalph_api_client/src/model/order_state.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'checkout_child_order.g.dart';

/// CheckoutChildOrder
///
/// Properties:
/// * [id]
/// * [reference]
/// * [vendor]
/// * [orderState]
/// * [paymentState]
/// * [fulfillmentMethod]
/// * [paymentMethod]
/// * [confirmationSource]
/// * [materialsCentavos]
/// * [deliveryCentavos] - Null while the Vendor has not confirmed the delivery fee.
/// * [commercialTotalCentavos]
/// * [vendorResponseDueAt]
/// * [paymentExpiresAt]
@BuiltValue()
abstract class CheckoutChildOrder implements Built<CheckoutChildOrder, CheckoutChildOrderBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'reference')
  String get reference;

  @BuiltValueField(wireName: r'vendor')
  OrderVendorRef get vendor;

  @BuiltValueField(wireName: r'order_state')
  OrderState get orderState;
  // enum orderStateEnum {  AWAITING_VENDOR_CONFIRMATION,  AWAITING_BUYER_APPROVAL,  AWAITING_NRPC_ACCEPTANCE,  AWAITING_PAYMENT,  CONFIRMED,  PROCESSING,  READY_FOR_PICKUP,  OUT_FOR_DELIVERY,  DELIVERED,  PICKED_UP,  COMPLETED,  CANCELLATION_REQUESTED,  DECLINED,  EXPIRED,  CANCELLED,  DISPUTED,  };

  @BuiltValueField(wireName: r'payment_state')
  OrderPaymentState get paymentState;
  // enum paymentStateEnum {  NOT_REQUIRED,  PENDING,  PAID,  FAILED,  EXPIRED,  };

  @BuiltValueField(wireName: r'fulfillment_method')
  CheckoutChildOrderFulfillmentMethodEnum get fulfillmentMethod;
  // enum fulfillmentMethodEnum {  DELIVERY,  PICKUP,  };

  @BuiltValueField(wireName: r'payment_method')
  CheckoutChildOrderPaymentMethodEnum get paymentMethod;
  // enum paymentMethodEnum {  ONLINE,  CASH_ON_DELIVERY,  IN_STORE,  };

  @BuiltValueField(wireName: r'confirmation_source')
  CheckoutChildOrderConfirmationSourceEnum? get confirmationSource;
  // enum confirmationSourceEnum {  MANUAL,  AUTO_ACCEPT,  ,  };

  @BuiltValueField(wireName: r'materials_centavos')
  int get materialsCentavos;

  /// Null while the Vendor has not confirmed the delivery fee.
  @BuiltValueField(wireName: r'delivery_centavos')
  int? get deliveryCentavos;

  @BuiltValueField(wireName: r'commercial_total_centavos')
  int get commercialTotalCentavos;

  @BuiltValueField(wireName: r'vendor_response_due_at')
  DateTime? get vendorResponseDueAt;

  @BuiltValueField(wireName: r'payment_expires_at')
  DateTime? get paymentExpiresAt;

  CheckoutChildOrder._();

  factory CheckoutChildOrder([void updates(CheckoutChildOrderBuilder b)]) = _$CheckoutChildOrder;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CheckoutChildOrderBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CheckoutChildOrder> get serializer => _$CheckoutChildOrderSerializer();
}

class _$CheckoutChildOrderSerializer implements PrimitiveSerializer<CheckoutChildOrder> {
  @override
  final Iterable<Type> types = const [CheckoutChildOrder, _$CheckoutChildOrder];

  @override
  final String wireName = r'CheckoutChildOrder';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CheckoutChildOrder object, {
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
    yield r'order_state';
    yield serializers.serialize(
      object.orderState,
      specifiedType: const FullType(OrderState),
    );
    yield r'payment_state';
    yield serializers.serialize(
      object.paymentState,
      specifiedType: const FullType(OrderPaymentState),
    );
    yield r'fulfillment_method';
    yield serializers.serialize(
      object.fulfillmentMethod,
      specifiedType: const FullType(CheckoutChildOrderFulfillmentMethodEnum),
    );
    yield r'payment_method';
    yield serializers.serialize(
      object.paymentMethod,
      specifiedType: const FullType(CheckoutChildOrderPaymentMethodEnum),
    );
    yield r'confirmation_source';
    yield object.confirmationSource == null ? null : serializers.serialize(
      object.confirmationSource,
      specifiedType: const FullType.nullable(CheckoutChildOrderConfirmationSourceEnum),
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
    yield r'vendor_response_due_at';
    yield object.vendorResponseDueAt == null ? null : serializers.serialize(
      object.vendorResponseDueAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'payment_expires_at';
    yield object.paymentExpiresAt == null ? null : serializers.serialize(
      object.paymentExpiresAt,
      specifiedType: const FullType.nullable(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CheckoutChildOrder object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CheckoutChildOrderBuilder result,
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
        case r'order_state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(OrderState),
          ) as OrderState;
          result.orderState = valueDes;
          break;
        case r'payment_state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(OrderPaymentState),
          ) as OrderPaymentState;
          result.paymentState = valueDes;
          break;
        case r'fulfillment_method':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CheckoutChildOrderFulfillmentMethodEnum),
          ) as CheckoutChildOrderFulfillmentMethodEnum;
          result.fulfillmentMethod = valueDes;
          break;
        case r'payment_method':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CheckoutChildOrderPaymentMethodEnum),
          ) as CheckoutChildOrderPaymentMethodEnum;
          result.paymentMethod = valueDes;
          break;
        case r'confirmation_source':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(CheckoutChildOrderConfirmationSourceEnum),
          ) as CheckoutChildOrderConfirmationSourceEnum?;
          if (valueDes == null) continue;
          result.confirmationSource = valueDes;
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
        case r'vendor_response_due_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.vendorResponseDueAt = valueDes;
          break;
        case r'payment_expires_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.paymentExpiresAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CheckoutChildOrder deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CheckoutChildOrderBuilder();
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


class CheckoutChildOrderFulfillmentMethodEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DELIVERY')
  static const CheckoutChildOrderFulfillmentMethodEnum DELIVERY = _$checkoutChildOrderFulfillmentMethodEnum_DELIVERY;
  @BuiltValueEnumConst(wireName: r'PICKUP')
  static const CheckoutChildOrderFulfillmentMethodEnum PICKUP = _$checkoutChildOrderFulfillmentMethodEnum_PICKUP;

  static Serializer<CheckoutChildOrderFulfillmentMethodEnum> get serializer => _$checkoutChildOrderFulfillmentMethodEnumSerializer;

  const CheckoutChildOrderFulfillmentMethodEnum._(String name): super(name);

  static BuiltSet<CheckoutChildOrderFulfillmentMethodEnum> get values => _$checkoutChildOrderFulfillmentMethodEnumValues;
  static CheckoutChildOrderFulfillmentMethodEnum valueOf(String name) => _$checkoutChildOrderFulfillmentMethodEnumValueOf(name);
}

class CheckoutChildOrderPaymentMethodEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ONLINE')
  static const CheckoutChildOrderPaymentMethodEnum ONLINE = _$checkoutChildOrderPaymentMethodEnum_ONLINE;
  @BuiltValueEnumConst(wireName: r'CASH_ON_DELIVERY')
  static const CheckoutChildOrderPaymentMethodEnum CASH_ON_DELIVERY = _$checkoutChildOrderPaymentMethodEnum_CASH_ON_DELIVERY;
  @BuiltValueEnumConst(wireName: r'IN_STORE')
  static const CheckoutChildOrderPaymentMethodEnum IN_STORE = _$checkoutChildOrderPaymentMethodEnum_IN_STORE;

  static Serializer<CheckoutChildOrderPaymentMethodEnum> get serializer => _$checkoutChildOrderPaymentMethodEnumSerializer;

  const CheckoutChildOrderPaymentMethodEnum._(String name): super(name);

  static BuiltSet<CheckoutChildOrderPaymentMethodEnum> get values => _$checkoutChildOrderPaymentMethodEnumValues;
  static CheckoutChildOrderPaymentMethodEnum valueOf(String name) => _$checkoutChildOrderPaymentMethodEnumValueOf(name);
}

class CheckoutChildOrderConfirmationSourceEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'MANUAL')
  static const CheckoutChildOrderConfirmationSourceEnum MANUAL = _$checkoutChildOrderConfirmationSourceEnum_MANUAL;
  @BuiltValueEnumConst(wireName: r'AUTO_ACCEPT')
  static const CheckoutChildOrderConfirmationSourceEnum AUTO_ACCEPT = _$checkoutChildOrderConfirmationSourceEnum_AUTO_ACCEPT;

  static Serializer<CheckoutChildOrderConfirmationSourceEnum> get serializer => _$checkoutChildOrderConfirmationSourceEnumSerializer;

  const CheckoutChildOrderConfirmationSourceEnum._(String name): super(name);

  static BuiltSet<CheckoutChildOrderConfirmationSourceEnum> get values => _$checkoutChildOrderConfirmationSourceEnumValues;
  static CheckoutChildOrderConfirmationSourceEnum valueOf(String name) => _$checkoutChildOrderConfirmationSourceEnumValueOf(name);
}

