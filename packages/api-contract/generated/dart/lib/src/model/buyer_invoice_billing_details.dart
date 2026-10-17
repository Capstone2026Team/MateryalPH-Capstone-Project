//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'buyer_invoice_billing_details.g.dart';

/// BuyerInvoiceBillingDetails
///
/// Properties:
/// * [billingName]
/// * [billingAddress]
/// * [tinMasked]
/// * [lockVersion]
@BuiltValue()
abstract class BuyerInvoiceBillingDetails implements Built<BuyerInvoiceBillingDetails, BuyerInvoiceBillingDetailsBuilder> {
  @BuiltValueField(wireName: r'billing_name')
  String get billingName;

  @BuiltValueField(wireName: r'billing_address')
  String get billingAddress;

  @BuiltValueField(wireName: r'tin_masked')
  String? get tinMasked;

  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  BuyerInvoiceBillingDetails._();

  factory BuyerInvoiceBillingDetails([void updates(BuyerInvoiceBillingDetailsBuilder b)]) = _$BuyerInvoiceBillingDetails;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BuyerInvoiceBillingDetailsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BuyerInvoiceBillingDetails> get serializer => _$BuyerInvoiceBillingDetailsSerializer();
}

class _$BuyerInvoiceBillingDetailsSerializer implements PrimitiveSerializer<BuyerInvoiceBillingDetails> {
  @override
  final Iterable<Type> types = const [BuyerInvoiceBillingDetails, _$BuyerInvoiceBillingDetails];

  @override
  final String wireName = r'BuyerInvoiceBillingDetails';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BuyerInvoiceBillingDetails object, {
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
    if (object.tinMasked != null) {
      yield r'tin_masked';
      yield serializers.serialize(
        object.tinMasked,
        specifiedType: const FullType(String),
      );
    }
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    BuyerInvoiceBillingDetails object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BuyerInvoiceBillingDetailsBuilder result,
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
        case r'tin_masked':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.tinMasked = valueDes;
          break;
        case r'lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lockVersion = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BuyerInvoiceBillingDetails deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BuyerInvoiceBillingDetailsBuilder();
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


