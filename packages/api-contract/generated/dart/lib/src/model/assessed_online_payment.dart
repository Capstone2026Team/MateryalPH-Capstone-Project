//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'assessed_online_payment.g.dart';

/// One assessed order payment with positive retained principal. Payment principal, Buyer fees and collections are net of completed refunds; pending or failed refunds do not reduce them. Tax basis, rate and withholding retain the original posted assessment values.
///
/// Properties:
/// * [id] - Assessment record ID, not a provider identifier.
/// * [orderReference]
/// * [assessedAt]
/// * [grossBasisCentavos] - Original posted tax basis; later refunds do not rewrite it.
/// * [rateBasisPoints] - Recorded effective withholding rate in basis points; 50 is 0.5 percent, 0 is recorded relief.
/// * [withheldCentavos] - Original tax amount rounded half-up per assessment; never recomputed from retained principal or an annual basis.
/// * [assessedPaymentCentavos] - Original assessment collection minus its recorded pre-assessment refunds and provider charge, before delivery and material VAT exclusions. Matches the annual tax-basis calculation's Online payments line; later refunds do not change this amount.
/// * [deliveryCentavos] - Separately billed delivery excluded in the original posted tax assessment.
/// * [materialVatCentavos] - Included material VAT excluded in the original posted tax assessment.
/// * [paymentPrincipalCentavos]
/// * [buyerProcessingFeesCentavos]
/// * [collectionsCentavos]
@BuiltValue()
abstract class AssessedOnlinePayment implements Built<AssessedOnlinePayment, AssessedOnlinePaymentBuilder> {
  /// Assessment record ID, not a provider identifier.
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'order_reference')
  String get orderReference;

  @BuiltValueField(wireName: r'assessed_at')
  DateTime get assessedAt;

  /// Original posted tax basis; later refunds do not rewrite it.
  @BuiltValueField(wireName: r'gross_basis_centavos')
  int get grossBasisCentavos;

  /// Recorded effective withholding rate in basis points; 50 is 0.5 percent, 0 is recorded relief.
  @BuiltValueField(wireName: r'rate_basis_points')
  int get rateBasisPoints;

  /// Original tax amount rounded half-up per assessment; never recomputed from retained principal or an annual basis.
  @BuiltValueField(wireName: r'withheld_centavos')
  int get withheldCentavos;

  /// Original assessment collection minus its recorded pre-assessment refunds and provider charge, before delivery and material VAT exclusions. Matches the annual tax-basis calculation's Online payments line; later refunds do not change this amount.
  @BuiltValueField(wireName: r'assessed_payment_centavos')
  int get assessedPaymentCentavos;

  /// Separately billed delivery excluded in the original posted tax assessment.
  @BuiltValueField(wireName: r'delivery_centavos')
  int get deliveryCentavos;

  /// Included material VAT excluded in the original posted tax assessment.
  @BuiltValueField(wireName: r'material_vat_centavos')
  int get materialVatCentavos;

  @BuiltValueField(wireName: r'payment_principal_centavos')
  int get paymentPrincipalCentavos;

  @BuiltValueField(wireName: r'buyer_processing_fees_centavos')
  int get buyerProcessingFeesCentavos;

  @BuiltValueField(wireName: r'collections_centavos')
  int get collectionsCentavos;

  AssessedOnlinePayment._();

  factory AssessedOnlinePayment([void updates(AssessedOnlinePaymentBuilder b)]) = _$AssessedOnlinePayment;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AssessedOnlinePaymentBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AssessedOnlinePayment> get serializer => _$AssessedOnlinePaymentSerializer();
}

class _$AssessedOnlinePaymentSerializer implements PrimitiveSerializer<AssessedOnlinePayment> {
  @override
  final Iterable<Type> types = const [AssessedOnlinePayment, _$AssessedOnlinePayment];

  @override
  final String wireName = r'AssessedOnlinePayment';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AssessedOnlinePayment object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'order_reference';
    yield serializers.serialize(
      object.orderReference,
      specifiedType: const FullType(String),
    );
    yield r'assessed_at';
    yield serializers.serialize(
      object.assessedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'gross_basis_centavos';
    yield serializers.serialize(
      object.grossBasisCentavos,
      specifiedType: const FullType(int),
    );
    yield r'rate_basis_points';
    yield serializers.serialize(
      object.rateBasisPoints,
      specifiedType: const FullType(int),
    );
    yield r'withheld_centavos';
    yield serializers.serialize(
      object.withheldCentavos,
      specifiedType: const FullType(int),
    );
    yield r'assessed_payment_centavos';
    yield serializers.serialize(
      object.assessedPaymentCentavos,
      specifiedType: const FullType(int),
    );
    yield r'delivery_centavos';
    yield serializers.serialize(
      object.deliveryCentavos,
      specifiedType: const FullType(int),
    );
    yield r'material_vat_centavos';
    yield serializers.serialize(
      object.materialVatCentavos,
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
  }

  @override
  Object serialize(
    Serializers serializers,
    AssessedOnlinePayment object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AssessedOnlinePaymentBuilder result,
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
        case r'order_reference':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.orderReference = valueDes;
          break;
        case r'assessed_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.assessedAt = valueDes;
          break;
        case r'gross_basis_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.grossBasisCentavos = valueDes;
          break;
        case r'rate_basis_points':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.rateBasisPoints = valueDes;
          break;
        case r'withheld_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.withheldCentavos = valueDes;
          break;
        case r'assessed_payment_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.assessedPaymentCentavos = valueDes;
          break;
        case r'delivery_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.deliveryCentavos = valueDes;
          break;
        case r'material_vat_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.materialVatCentavos = valueDes;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AssessedOnlinePayment deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AssessedOnlinePaymentBuilder();
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


