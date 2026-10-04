//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_invoice_billing_details.g.dart';

/// VendorInvoiceBillingDetails
///
/// Properties:
/// * [billingName]
/// * [billingAddress]
/// * [tin]
/// * [tinMasked]
@BuiltValue()
abstract class VendorInvoiceBillingDetails implements Built<VendorInvoiceBillingDetails, VendorInvoiceBillingDetailsBuilder> {
  @BuiltValueField(wireName: r'billing_name')
  String get billingName;

  @BuiltValueField(wireName: r'billing_address')
  String get billingAddress;

  @BuiltValueField(wireName: r'tin')
  String? get tin;

  @BuiltValueField(wireName: r'tin_masked')
  String? get tinMasked;

  VendorInvoiceBillingDetails._();

  factory VendorInvoiceBillingDetails([void updates(VendorInvoiceBillingDetailsBuilder b)]) = _$VendorInvoiceBillingDetails;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorInvoiceBillingDetailsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorInvoiceBillingDetails> get serializer => _$VendorInvoiceBillingDetailsSerializer();
}

class _$VendorInvoiceBillingDetailsSerializer implements PrimitiveSerializer<VendorInvoiceBillingDetails> {
  @override
  final Iterable<Type> types = const [VendorInvoiceBillingDetails, _$VendorInvoiceBillingDetails];

  @override
  final String wireName = r'VendorInvoiceBillingDetails';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorInvoiceBillingDetails object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'billing_name';
    yield serializers.serialize(
      object.billingName,
      specifiedType: const FullType(String),
    );
    yield r'billing_address';
    yield serializers.serialize(
      object.billingAddress,
      specifiedType: const FullType(String),
    );
    if (object.tin != null) {
      yield r'tin';
      yield serializers.serialize(
        object.tin,
        specifiedType: const FullType(String),
      );
    }
    if (object.tinMasked != null) {
      yield r'tin_masked';
      yield serializers.serialize(
        object.tinMasked,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorInvoiceBillingDetails object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorInvoiceBillingDetailsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'billing_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.billingName = valueDes;
          break;
        case r'billing_address':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.billingAddress = valueDes;
          break;
        case r'tin':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.tin = valueDes;
          break;
        case r'tin_masked':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.tinMasked = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorInvoiceBillingDetails deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorInvoiceBillingDetailsBuilder();
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


