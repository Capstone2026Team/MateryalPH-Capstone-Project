//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/payment_method_eligibility.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/cart_issue.dart';
import 'package:materyalph_api_client/src/model/checkout_vendor_ref.dart';
import 'package:materyalph_api_client/src/model/delivery_preview.dart';
import 'package:materyalph_api_client/src/model/financial_preview.dart';
import 'package:materyalph_api_client/src/model/cart_line.dart';
import 'package:materyalph_api_client/src/model/pickup_preview.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'checkout_group_preview.g.dart';

/// CheckoutGroupPreview
///
/// Properties:
/// * [vendor]
/// * [fulfillmentMethod]
/// * [fulfillmentOptions]
/// * [status]
/// * [issues]
/// * [lines]
/// * [delivery]
/// * [pickup]
/// * [paymentMethods]
/// * [amounts]
@BuiltValue()
abstract class CheckoutGroupPreview implements Built<CheckoutGroupPreview, CheckoutGroupPreviewBuilder> {
  @BuiltValueField(wireName: r'vendor')
  CheckoutVendorRef get vendor;

  @BuiltValueField(wireName: r'fulfillment_method')
  CheckoutGroupPreviewFulfillmentMethodEnum? get fulfillmentMethod;
  // enum fulfillmentMethodEnum {  DELIVERY,  PICKUP,  ,  };

  @BuiltValueField(wireName: r'fulfillment_options')
  BuiltList<CheckoutGroupPreviewFulfillmentOptionsEnum> get fulfillmentOptions;
  // enum fulfillmentOptionsEnum {  DELIVERY,  PICKUP,  };

  @BuiltValueField(wireName: r'status')
  CheckoutGroupPreviewStatusEnum get status;
  // enum statusEnum {  READY,  ACTION_REQUIRED,  BLOCKED,  };

  @BuiltValueField(wireName: r'issues')
  BuiltList<CartIssue> get issues;

  @BuiltValueField(wireName: r'lines')
  BuiltList<CartLine> get lines;

  @BuiltValueField(wireName: r'delivery')
  DeliveryPreview get delivery;

  @BuiltValueField(wireName: r'pickup')
  PickupPreview? get pickup;

  @BuiltValueField(wireName: r'payment_methods')
  BuiltList<PaymentMethodEligibility> get paymentMethods;

  @BuiltValueField(wireName: r'amounts')
  FinancialPreview get amounts;

  CheckoutGroupPreview._();

  factory CheckoutGroupPreview([void updates(CheckoutGroupPreviewBuilder b)]) = _$CheckoutGroupPreview;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CheckoutGroupPreviewBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CheckoutGroupPreview> get serializer => _$CheckoutGroupPreviewSerializer();
}

class _$CheckoutGroupPreviewSerializer implements PrimitiveSerializer<CheckoutGroupPreview> {
  @override
  final Iterable<Type> types = const [CheckoutGroupPreview, _$CheckoutGroupPreview];

  @override
  final String wireName = r'CheckoutGroupPreview';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CheckoutGroupPreview object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'vendor';
    yield serializers.serialize(
      object.vendor,
      specifiedType: const FullType(CheckoutVendorRef),
    );
    yield r'fulfillment_method';
    yield object.fulfillmentMethod == null ? null : serializers.serialize(
      object.fulfillmentMethod,
      specifiedType: const FullType.nullable(CheckoutGroupPreviewFulfillmentMethodEnum),
    );
    yield r'fulfillment_options';
    yield serializers.serialize(
      object.fulfillmentOptions,
      specifiedType: const FullType(BuiltList, [FullType(CheckoutGroupPreviewFulfillmentOptionsEnum)]),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(CheckoutGroupPreviewStatusEnum),
    );
    yield r'issues';
    yield serializers.serialize(
      object.issues,
      specifiedType: const FullType(BuiltList, [FullType(CartIssue)]),
    );
    yield r'lines';
    yield serializers.serialize(
      object.lines,
      specifiedType: const FullType(BuiltList, [FullType(CartLine)]),
    );
    yield r'delivery';
    yield serializers.serialize(
      object.delivery,
      specifiedType: const FullType(DeliveryPreview),
    );
    yield r'pickup';
    yield object.pickup == null ? null : serializers.serialize(
      object.pickup,
      specifiedType: const FullType.nullable(PickupPreview),
    );
    yield r'payment_methods';
    yield serializers.serialize(
      object.paymentMethods,
      specifiedType: const FullType(BuiltList, [FullType(PaymentMethodEligibility)]),
    );
    yield r'amounts';
    yield serializers.serialize(
      object.amounts,
      specifiedType: const FullType(FinancialPreview),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CheckoutGroupPreview object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CheckoutGroupPreviewBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'vendor':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CheckoutVendorRef),
          ) as CheckoutVendorRef;
          result.vendor.replace(valueDes);
          break;
        case r'fulfillment_method':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(CheckoutGroupPreviewFulfillmentMethodEnum),
          ) as CheckoutGroupPreviewFulfillmentMethodEnum?;
          if (valueDes == null) continue;
          result.fulfillmentMethod = valueDes;
          break;
        case r'fulfillment_options':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CheckoutGroupPreviewFulfillmentOptionsEnum)]),
          ) as BuiltList<CheckoutGroupPreviewFulfillmentOptionsEnum>;
          result.fulfillmentOptions.replace(valueDes);
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CheckoutGroupPreviewStatusEnum),
          ) as CheckoutGroupPreviewStatusEnum;
          result.status = valueDes;
          break;
        case r'issues':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CartIssue)]),
          ) as BuiltList<CartIssue>;
          result.issues.replace(valueDes);
          break;
        case r'lines':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CartLine)]),
          ) as BuiltList<CartLine>;
          result.lines.replace(valueDes);
          break;
        case r'delivery':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DeliveryPreview),
          ) as DeliveryPreview;
          result.delivery.replace(valueDes);
          break;
        case r'pickup':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(PickupPreview),
          ) as PickupPreview?;
          if (valueDes == null) continue;
          result.pickup.replace(valueDes);
          break;
        case r'payment_methods':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(PaymentMethodEligibility)]),
          ) as BuiltList<PaymentMethodEligibility>;
          result.paymentMethods.replace(valueDes);
          break;
        case r'amounts':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(FinancialPreview),
          ) as FinancialPreview;
          result.amounts.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CheckoutGroupPreview deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CheckoutGroupPreviewBuilder();
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


class CheckoutGroupPreviewFulfillmentMethodEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DELIVERY')
  static const CheckoutGroupPreviewFulfillmentMethodEnum DELIVERY = _$checkoutGroupPreviewFulfillmentMethodEnum_DELIVERY;
  @BuiltValueEnumConst(wireName: r'PICKUP')
  static const CheckoutGroupPreviewFulfillmentMethodEnum PICKUP = _$checkoutGroupPreviewFulfillmentMethodEnum_PICKUP;

  static Serializer<CheckoutGroupPreviewFulfillmentMethodEnum> get serializer => _$checkoutGroupPreviewFulfillmentMethodEnumSerializer;

  const CheckoutGroupPreviewFulfillmentMethodEnum._(String name): super(name);

  static BuiltSet<CheckoutGroupPreviewFulfillmentMethodEnum> get values => _$checkoutGroupPreviewFulfillmentMethodEnumValues;
  static CheckoutGroupPreviewFulfillmentMethodEnum valueOf(String name) => _$checkoutGroupPreviewFulfillmentMethodEnumValueOf(name);
}

class CheckoutGroupPreviewFulfillmentOptionsEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DELIVERY')
  static const CheckoutGroupPreviewFulfillmentOptionsEnum DELIVERY = _$checkoutGroupPreviewFulfillmentOptionsEnum_DELIVERY;
  @BuiltValueEnumConst(wireName: r'PICKUP')
  static const CheckoutGroupPreviewFulfillmentOptionsEnum PICKUP = _$checkoutGroupPreviewFulfillmentOptionsEnum_PICKUP;

  static Serializer<CheckoutGroupPreviewFulfillmentOptionsEnum> get serializer => _$checkoutGroupPreviewFulfillmentOptionsEnumSerializer;

  const CheckoutGroupPreviewFulfillmentOptionsEnum._(String name): super(name);

  static BuiltSet<CheckoutGroupPreviewFulfillmentOptionsEnum> get values => _$checkoutGroupPreviewFulfillmentOptionsEnumValues;
  static CheckoutGroupPreviewFulfillmentOptionsEnum valueOf(String name) => _$checkoutGroupPreviewFulfillmentOptionsEnumValueOf(name);
}

class CheckoutGroupPreviewStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'READY')
  static const CheckoutGroupPreviewStatusEnum READY = _$checkoutGroupPreviewStatusEnum_READY;
  @BuiltValueEnumConst(wireName: r'ACTION_REQUIRED')
  static const CheckoutGroupPreviewStatusEnum ACTION_REQUIRED = _$checkoutGroupPreviewStatusEnum_ACTION_REQUIRED;
  @BuiltValueEnumConst(wireName: r'BLOCKED')
  static const CheckoutGroupPreviewStatusEnum BLOCKED = _$checkoutGroupPreviewStatusEnum_BLOCKED;

  static Serializer<CheckoutGroupPreviewStatusEnum> get serializer => _$checkoutGroupPreviewStatusEnumSerializer;

  const CheckoutGroupPreviewStatusEnum._(String name): super(name);

  static BuiltSet<CheckoutGroupPreviewStatusEnum> get values => _$checkoutGroupPreviewStatusEnumValues;
  static CheckoutGroupPreviewStatusEnum valueOf(String name) => _$checkoutGroupPreviewStatusEnumValueOf(name);
}

