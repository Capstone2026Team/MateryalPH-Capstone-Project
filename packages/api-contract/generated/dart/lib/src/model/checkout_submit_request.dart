//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/checkout_invoice_details.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'checkout_submit_request.g.dart';

/// CheckoutSubmitRequest
///
/// Properties:
/// * [cartLockVersion]
/// * [vendorIds]
/// * [splitConfirmed] - Required when fewer Vendor groups are submitted than the cart holds.
/// * [workPackageId] - Optional owned open Work Package under an Active Project. Each submitted child remains ITEM_BASED and contributes to its budget; this does not fulfill missing lines or select the Project Vendor. Tagged cart lines must belong to this version.
/// * [workPackageLockVersion] - Required with work_package_id; stale versions return PROJECT_VERSION_CONFLICT (409).
/// * [budgetOverrideReason] - Explicit Buyer acknowledgement when the combined submitted amount exceeds the Project or Work Package budget. Final acceptance rechecks committed spend.
/// * [invoiceDetails]
/// * [paymentMethods] - Vendor id => chosen method; Online when omitted. COD pairs with Site Delivery, In-Store with Self-Pickup, each only when the Vendor enabled it.
@BuiltValue()
abstract class CheckoutSubmitRequest implements Built<CheckoutSubmitRequest, CheckoutSubmitRequestBuilder> {
  @BuiltValueField(wireName: r'cart_lock_version')
  int get cartLockVersion;

  @BuiltValueField(wireName: r'vendor_ids')
  BuiltSet<String> get vendorIds;

  /// Required when fewer Vendor groups are submitted than the cart holds.
  @BuiltValueField(wireName: r'split_confirmed')
  bool? get splitConfirmed;

  /// Optional owned open Work Package under an Active Project. Each submitted child remains ITEM_BASED and contributes to its budget; this does not fulfill missing lines or select the Project Vendor. Tagged cart lines must belong to this version.
  @BuiltValueField(wireName: r'work_package_id')
  String? get workPackageId;

  /// Required with work_package_id; stale versions return PROJECT_VERSION_CONFLICT (409).
  @BuiltValueField(wireName: r'work_package_lock_version')
  int? get workPackageLockVersion;

  /// Explicit Buyer acknowledgement when the combined submitted amount exceeds the Project or Work Package budget. Final acceptance rechecks committed spend.
  @BuiltValueField(wireName: r'budget_override_reason')
  String? get budgetOverrideReason;

  @BuiltValueField(wireName: r'invoice_details')
  CheckoutInvoiceDetails? get invoiceDetails;

  /// Vendor id => chosen method; Online when omitted. COD pairs with Site Delivery, In-Store with Self-Pickup, each only when the Vendor enabled it.
  @BuiltValueField(wireName: r'payment_methods')
  BuiltMap<String, CheckoutSubmitRequestPaymentMethodsEnum>? get paymentMethods;
  // enum paymentMethodsEnum {  ONLINE,  CASH_ON_DELIVERY,  IN_STORE,  };

  CheckoutSubmitRequest._();

  factory CheckoutSubmitRequest([void updates(CheckoutSubmitRequestBuilder b)]) = _$CheckoutSubmitRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CheckoutSubmitRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CheckoutSubmitRequest> get serializer => _$CheckoutSubmitRequestSerializer();
}

class _$CheckoutSubmitRequestSerializer implements PrimitiveSerializer<CheckoutSubmitRequest> {
  @override
  final Iterable<Type> types = const [CheckoutSubmitRequest, _$CheckoutSubmitRequest];

  @override
  final String wireName = r'CheckoutSubmitRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CheckoutSubmitRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'cart_lock_version';
    yield serializers.serialize(
      object.cartLockVersion,
      specifiedType: const FullType(int),
    );
    yield r'vendor_ids';
    yield serializers.serialize(
      object.vendorIds,
      specifiedType: const FullType(BuiltSet, [FullType(String)]),
    );
    if (object.splitConfirmed != null) {
      yield r'split_confirmed';
      yield serializers.serialize(
        object.splitConfirmed,
        specifiedType: const FullType(bool),
      );
    }
    if (object.workPackageId != null) {
      yield r'work_package_id';
      yield serializers.serialize(
        object.workPackageId,
        specifiedType: const FullType(String),
      );
    }
    if (object.workPackageLockVersion != null) {
      yield r'work_package_lock_version';
      yield serializers.serialize(
        object.workPackageLockVersion,
        specifiedType: const FullType(int),
      );
    }
    if (object.budgetOverrideReason != null) {
      yield r'budget_override_reason';
      yield serializers.serialize(
        object.budgetOverrideReason,
        specifiedType: const FullType(String),
      );
    }
    if (object.invoiceDetails != null) {
      yield r'invoice_details';
      yield serializers.serialize(
        object.invoiceDetails,
        specifiedType: const FullType(CheckoutInvoiceDetails),
      );
    }
    if (object.paymentMethods != null) {
      yield r'payment_methods';
      yield serializers.serialize(
        object.paymentMethods,
        specifiedType: const FullType(BuiltMap, [FullType(String), FullType(CheckoutSubmitRequestPaymentMethodsEnum)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CheckoutSubmitRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CheckoutSubmitRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'cart_lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.cartLockVersion = valueDes;
          break;
        case r'vendor_ids':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltSet, [FullType(String)]),
          ) as BuiltSet<String>;
          result.vendorIds.replace(valueDes);
          break;
        case r'split_confirmed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.splitConfirmed = valueDes;
          break;
        case r'work_package_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.workPackageId = valueDes;
          break;
        case r'work_package_lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.workPackageLockVersion = valueDes;
          break;
        case r'budget_override_reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.budgetOverrideReason = valueDes;
          break;
        case r'invoice_details':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(CheckoutInvoiceDetails),
          ) as CheckoutInvoiceDetails?;
          if (valueDes == null) continue;
          result.invoiceDetails.replace(valueDes);
          break;
        case r'payment_methods':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltMap, [FullType(String), FullType(CheckoutSubmitRequestPaymentMethodsEnum)]),
          ) as BuiltMap<String, CheckoutSubmitRequestPaymentMethodsEnum>?;
          if (valueDes == null) continue;
          result.paymentMethods.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CheckoutSubmitRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CheckoutSubmitRequestBuilder();
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


class CheckoutSubmitRequestPaymentMethodsEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ONLINE')
  static const CheckoutSubmitRequestPaymentMethodsEnum ONLINE = _$checkoutSubmitRequestPaymentMethodsEnum_ONLINE;
  @BuiltValueEnumConst(wireName: r'CASH_ON_DELIVERY')
  static const CheckoutSubmitRequestPaymentMethodsEnum CASH_ON_DELIVERY = _$checkoutSubmitRequestPaymentMethodsEnum_CASH_ON_DELIVERY;
  @BuiltValueEnumConst(wireName: r'IN_STORE')
  static const CheckoutSubmitRequestPaymentMethodsEnum IN_STORE = _$checkoutSubmitRequestPaymentMethodsEnum_IN_STORE;

  static Serializer<CheckoutSubmitRequestPaymentMethodsEnum> get serializer => _$checkoutSubmitRequestPaymentMethodsEnumSerializer;

  const CheckoutSubmitRequestPaymentMethodsEnum._(String name): super(name);

  static BuiltSet<CheckoutSubmitRequestPaymentMethodsEnum> get values => _$checkoutSubmitRequestPaymentMethodsEnumValues;
  static CheckoutSubmitRequestPaymentMethodsEnum valueOf(String name) => _$checkoutSubmitRequestPaymentMethodsEnumValueOf(name);
}

