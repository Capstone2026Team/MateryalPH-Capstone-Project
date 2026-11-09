//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'assessed_online_payment_totals.g.dart';

/// Current retained payment totals after completed refunds, with fully refunded principal omitted. Buyer fees remain a separate flow. Withholding adds the original rounded tax amounts for these retained payments across all pages and stores under the taxpayer; it does not recalculate posted tax after refunds.
///
/// Properties:
/// * [assessedPayments]
/// * [paymentPrincipalCentavos]
/// * [buyerProcessingFeesCentavos]
/// * [collectionsCentavos]
/// * [withheldCentavos] - Sum of original per-assessment withholding for retained payments in this scope, independent of pagination. Fully refunded payments are omitted even if their posted tax remains in annual tax history.
@BuiltValue()
abstract class AssessedOnlinePaymentTotals implements Built<AssessedOnlinePaymentTotals, AssessedOnlinePaymentTotalsBuilder> {
  @BuiltValueField(wireName: r'assessed_payments')
  int get assessedPayments;

  @BuiltValueField(wireName: r'payment_principal_centavos')
  int get paymentPrincipalCentavos;

  @BuiltValueField(wireName: r'buyer_processing_fees_centavos')
  int get buyerProcessingFeesCentavos;

  @BuiltValueField(wireName: r'collections_centavos')
  int get collectionsCentavos;

  /// Sum of original per-assessment withholding for retained payments in this scope, independent of pagination. Fully refunded payments are omitted even if their posted tax remains in annual tax history.
  @BuiltValueField(wireName: r'withheld_centavos')
  int get withheldCentavos;

  AssessedOnlinePaymentTotals._();

  factory AssessedOnlinePaymentTotals([void updates(AssessedOnlinePaymentTotalsBuilder b)]) = _$AssessedOnlinePaymentTotals;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AssessedOnlinePaymentTotalsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AssessedOnlinePaymentTotals> get serializer => _$AssessedOnlinePaymentTotalsSerializer();
}

class _$AssessedOnlinePaymentTotalsSerializer implements PrimitiveSerializer<AssessedOnlinePaymentTotals> {
  @override
  final Iterable<Type> types = const [AssessedOnlinePaymentTotals, _$AssessedOnlinePaymentTotals];

  @override
  final String wireName = r'AssessedOnlinePaymentTotals';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AssessedOnlinePaymentTotals object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'assessed_payments';
    yield serializers.serialize(
      object.assessedPayments,
      specifiedType: const FullType(int),
    );
    yield r'payment_principal_centavos';
    yield serializers.serialize(
      object.paymentPrincipalCentavos,
      specifiedType: const FullType(int),
    );
    yield r'buyer_processing_fees_centavos';
    yield serializers.serialize(
      object.buyerProcessingFeesCentavos,
      specifiedType: const FullType(int),
    );
    yield r'collections_centavos';
    yield serializers.serialize(
      object.collectionsCentavos,
      specifiedType: const FullType(int),
    );
    yield r'withheld_centavos';
    yield serializers.serialize(
      object.withheldCentavos,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AssessedOnlinePaymentTotals object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AssessedOnlinePaymentTotalsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'assessed_payments':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.assessedPayments = valueDes;
          break;
        case r'payment_principal_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.paymentPrincipalCentavos = valueDes;
          break;
        case r'buyer_processing_fees_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.buyerProcessingFeesCentavos = valueDes;
          break;
        case r'collections_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.collectionsCentavos = valueDes;
          break;
        case r'withheld_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.withheldCentavos = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AssessedOnlinePaymentTotals deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AssessedOnlinePaymentTotalsBuilder();
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


