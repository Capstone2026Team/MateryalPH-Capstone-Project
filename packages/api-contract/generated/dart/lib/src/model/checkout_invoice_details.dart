//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'checkout_invoice_details.g.dart';

/// Optional billing details saved atomically for each submitted child order. TIN is encrypted and displayed masked. This supplies details before issuance; invoice copy/correction requests remain available once the sale is confirmed. No default billing profile is saved.
///
/// Properties:
/// * [billingName]
/// * [billingAddress]
/// * [tin]
@BuiltValue()
abstract class CheckoutInvoiceDetails implements Built<CheckoutInvoiceDetails, CheckoutInvoiceDetailsBuilder> {
  @BuiltValueField(wireName: r'billing_name')
  String get billingName;

  @BuiltValueField(wireName: r'billing_address')
  String get billingAddress;

  @BuiltValueField(wireName: r'tin')
  String? get tin;

  CheckoutInvoiceDetails._();

  factory CheckoutInvoiceDetails([void updates(CheckoutInvoiceDetailsBuilder b)]) = _$CheckoutInvoiceDetails;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CheckoutInvoiceDetailsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CheckoutInvoiceDetails> get serializer => _$CheckoutInvoiceDetailsSerializer();
}

class _$CheckoutInvoiceDetailsSerializer implements PrimitiveSerializer<CheckoutInvoiceDetails> {
  @override
  final Iterable<Type> types = const [CheckoutInvoiceDetails, _$CheckoutInvoiceDetails];

  @override
  final String wireName = r'CheckoutInvoiceDetails';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CheckoutInvoiceDetails object, {
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
  }

  @override
  Object serialize(
    Serializers serializers,
    CheckoutInvoiceDetails object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CheckoutInvoiceDetailsBuilder result,
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CheckoutInvoiceDetails deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CheckoutInvoiceDetailsBuilder();
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


