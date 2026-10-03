//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_earnings.g.dart';

/// VendorEarnings
///
/// Properties:
/// * [demo]
/// * [environment]
/// * [notice]
/// * [commercialSalesCentavos]
/// * [includedVatCentavos]
/// * [onlineCollectionsCentavos]
/// * [buyerProcessingFeesCentavos]
/// * [physicalCollectionsCentavos]
/// * [providerChargesCentavos]
/// * [simulatedCwtCentavos]
/// * [estimatedRemittanceCashCentavos]
/// * [earnedCommissionCentavos]
/// * [estimatedCommissionCentavos]
/// * [unpaidStatementsCentavos]
@BuiltValue()
abstract class VendorEarnings implements Built<VendorEarnings, VendorEarningsBuilder> {
  @BuiltValueField(wireName: r'demo')
  bool get demo;

  @BuiltValueField(wireName: r'environment')
  String get environment;

  @BuiltValueField(wireName: r'notice')
  String get notice;

  @BuiltValueField(wireName: r'commercial_sales_centavos')
  int get commercialSalesCentavos;

  @BuiltValueField(wireName: r'included_vat_centavos')
  int get includedVatCentavos;

  @BuiltValueField(wireName: r'online_collections_centavos')
  int get onlineCollectionsCentavos;

  @BuiltValueField(wireName: r'buyer_processing_fees_centavos')
  int get buyerProcessingFeesCentavos;

  @BuiltValueField(wireName: r'physical_collections_centavos')
  int get physicalCollectionsCentavos;

  @BuiltValueField(wireName: r'provider_charges_centavos')
  int get providerChargesCentavos;

  @BuiltValueField(wireName: r'simulated_cwt_centavos')
  int get simulatedCwtCentavos;

  @BuiltValueField(wireName: r'estimated_remittance_cash_centavos')
  int get estimatedRemittanceCashCentavos;

  @BuiltValueField(wireName: r'earned_commission_centavos')
  int get earnedCommissionCentavos;

  @BuiltValueField(wireName: r'estimated_commission_centavos')
  int get estimatedCommissionCentavos;

  @BuiltValueField(wireName: r'unpaid_statements_centavos')
  int get unpaidStatementsCentavos;

  VendorEarnings._();

  factory VendorEarnings([void updates(VendorEarningsBuilder b)]) = _$VendorEarnings;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorEarningsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorEarnings> get serializer => _$VendorEarningsSerializer();
}

class _$VendorEarningsSerializer implements PrimitiveSerializer<VendorEarnings> {
  @override
  final Iterable<Type> types = const [VendorEarnings, _$VendorEarnings];

  @override
  final String wireName = r'VendorEarnings';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorEarnings object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'demo';
    yield serializers.serialize(
      object.demo,
      specifiedType: const FullType(bool),
    );
    yield r'environment';
    yield serializers.serialize(
      object.environment,
      specifiedType: const FullType(String),
    );
    yield r'notice';
    yield serializers.serialize(
      object.notice,
      specifiedType: const FullType(String),
    );
    yield r'commercial_sales_centavos';
    yield serializers.serialize(
      object.commercialSalesCentavos,
      specifiedType: const FullType(int),
    );
    yield r'included_vat_centavos';
    yield serializers.serialize(
      object.includedVatCentavos,
      specifiedType: const FullType(int),
    );
    yield r'online_collections_centavos';
    yield serializers.serialize(
      object.onlineCollectionsCentavos,
      specifiedType: const FullType(int),
    );
    yield r'buyer_processing_fees_centavos';
    yield serializers.serialize(
      object.buyerProcessingFeesCentavos,
      specifiedType: const FullType(int),
    );
    yield r'physical_collections_centavos';
    yield serializers.serialize(
      object.physicalCollectionsCentavos,
      specifiedType: const FullType(int),
    );
    yield r'provider_charges_centavos';
    yield serializers.serialize(
      object.providerChargesCentavos,
      specifiedType: const FullType(int),
    );
    yield r'simulated_cwt_centavos';
    yield serializers.serialize(
      object.simulatedCwtCentavos,
      specifiedType: const FullType(int),
    );
    yield r'estimated_remittance_cash_centavos';
    yield serializers.serialize(
      object.estimatedRemittanceCashCentavos,
      specifiedType: const FullType(int),
    );
    yield r'earned_commission_centavos';
    yield serializers.serialize(
      object.earnedCommissionCentavos,
      specifiedType: const FullType(int),
    );
    yield r'estimated_commission_centavos';
    yield serializers.serialize(
      object.estimatedCommissionCentavos,
      specifiedType: const FullType(int),
    );
    yield r'unpaid_statements_centavos';
    yield serializers.serialize(
      object.unpaidStatementsCentavos,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorEarnings object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorEarningsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'demo':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.demo = valueDes;
          break;
        case r'environment':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.environment = valueDes;
          break;
        case r'notice':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.notice = valueDes;
          break;
        case r'commercial_sales_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.commercialSalesCentavos = valueDes;
          break;
        case r'included_vat_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.includedVatCentavos = valueDes;
          break;
        case r'online_collections_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.onlineCollectionsCentavos = valueDes;
          break;
        case r'buyer_processing_fees_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.buyerProcessingFeesCentavos = valueDes;
          break;
        case r'physical_collections_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.physicalCollectionsCentavos = valueDes;
          break;
        case r'provider_charges_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.providerChargesCentavos = valueDes;
          break;
        case r'simulated_cwt_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.simulatedCwtCentavos = valueDes;
          break;
        case r'estimated_remittance_cash_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.estimatedRemittanceCashCentavos = valueDes;
          break;
        case r'earned_commission_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.earnedCommissionCentavos = valueDes;
          break;
        case r'estimated_commission_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.estimatedCommissionCentavos = valueDes;
          break;
        case r'unpaid_statements_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.unpaidStatementsCentavos = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorEarnings deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorEarningsBuilder();
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


