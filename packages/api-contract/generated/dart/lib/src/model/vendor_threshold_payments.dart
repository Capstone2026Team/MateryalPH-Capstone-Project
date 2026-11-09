//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/assessed_online_payment_totals.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/assessed_online_payment.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_threshold_payments.g.dart';

/// VendorThresholdPayments
///
/// Properties:
/// * [taxableYear]
/// * [payments]
/// * [totals]
/// * [otherStoreTotals] - Combined amounts from other stores under the same taxpayer, without their order references or identities. Null when none.
@BuiltValue()
abstract class VendorThresholdPayments implements Built<VendorThresholdPayments, VendorThresholdPaymentsBuilder> {
  @BuiltValueField(wireName: r'taxable_year')
  int get taxableYear;

  @BuiltValueField(wireName: r'payments')
  BuiltList<AssessedOnlinePayment> get payments;

  @BuiltValueField(wireName: r'totals')
  AssessedOnlinePaymentTotals get totals;

  /// Combined amounts from other stores under the same taxpayer, without their order references or identities. Null when none.
  @BuiltValueField(wireName: r'other_store_totals')
  AssessedOnlinePaymentTotals? get otherStoreTotals;

  VendorThresholdPayments._();

  factory VendorThresholdPayments([void updates(VendorThresholdPaymentsBuilder b)]) = _$VendorThresholdPayments;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorThresholdPaymentsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorThresholdPayments> get serializer => _$VendorThresholdPaymentsSerializer();
}

class _$VendorThresholdPaymentsSerializer implements PrimitiveSerializer<VendorThresholdPayments> {
  @override
  final Iterable<Type> types = const [VendorThresholdPayments, _$VendorThresholdPayments];

  @override
  final String wireName = r'VendorThresholdPayments';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorThresholdPayments object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'taxable_year';
    yield serializers.serialize(
      object.taxableYear,
      specifiedType: const FullType(int),
    );
    yield r'payments';
    yield serializers.serialize(
      object.payments,
      specifiedType: const FullType(BuiltList, [FullType(AssessedOnlinePayment)]),
    );
    yield r'totals';
    yield serializers.serialize(
      object.totals,
      specifiedType: const FullType(AssessedOnlinePaymentTotals),
    );
    yield r'other_store_totals';
    yield object.otherStoreTotals == null ? null : serializers.serialize(
      object.otherStoreTotals,
      specifiedType: const FullType.nullable(AssessedOnlinePaymentTotals),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorThresholdPayments object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorThresholdPaymentsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'taxable_year':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.taxableYear = valueDes;
          break;
        case r'payments':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AssessedOnlinePayment)]),
          ) as BuiltList<AssessedOnlinePayment>;
          result.payments.replace(valueDes);
          break;
        case r'totals':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AssessedOnlinePaymentTotals),
          ) as AssessedOnlinePaymentTotals;
          result.totals.replace(valueDes);
          break;
        case r'other_store_totals':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(AssessedOnlinePaymentTotals),
          ) as AssessedOnlinePaymentTotals?;
          if (valueDes == null) continue;
          result.otherStoreTotals.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorThresholdPayments deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorThresholdPaymentsBuilder();
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


