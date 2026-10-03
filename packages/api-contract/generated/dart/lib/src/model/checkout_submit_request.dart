//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
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

