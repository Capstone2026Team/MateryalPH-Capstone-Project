//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'invoice_billing_details_request.g.dart';

/// Collected only for the invoice. The TIN is encrypted and shown masked to the Buyer.
///
/// Properties:
/// * [billingName]
/// * [billingAddress]
/// * [tin]
/// * [lockVersion]
@BuiltValue()
abstract class InvoiceBillingDetailsRequest implements Built<InvoiceBillingDetailsRequest, InvoiceBillingDetailsRequestBuilder> {
  @BuiltValueField(wireName: r'billing_name')
  String get billingName;

  @BuiltValueField(wireName: r'billing_address')
  String get billingAddress;

  @BuiltValueField(wireName: r'tin')
  String? get tin;

  @BuiltValueField(wireName: r'lock_version')
  int? get lockVersion;

  InvoiceBillingDetailsRequest._();

  factory InvoiceBillingDetailsRequest([void updates(InvoiceBillingDetailsRequestBuilder b)]) = _$InvoiceBillingDetailsRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(InvoiceBillingDetailsRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<InvoiceBillingDetailsRequest> get serializer => _$InvoiceBillingDetailsRequestSerializer();
}

class _$InvoiceBillingDetailsRequestSerializer implements PrimitiveSerializer<InvoiceBillingDetailsRequest> {
  @override
  final Iterable<Type> types = const [InvoiceBillingDetailsRequest, _$InvoiceBillingDetailsRequest];

  @override
  final String wireName = r'InvoiceBillingDetailsRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    InvoiceBillingDetailsRequest object, {
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
    if (object.lockVersion != null) {
      yield r'lock_version';
      yield serializers.serialize(
        object.lockVersion,
        specifiedType: const FullType(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    InvoiceBillingDetailsRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required InvoiceBillingDetailsRequestBuilder result,
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
        case r'lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
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
  InvoiceBillingDetailsRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = InvoiceBillingDetailsRequestBuilder();
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


