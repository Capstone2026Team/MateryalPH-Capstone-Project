//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/cancellation_plan_payment.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'cancellation_plan.g.dart';

/// FIN-07 amounts from the original frozen allocations. Vendor withholding, commission and provider deductions never reduce a Buyer refund.
///
/// Properties:
/// * [cause]
/// * [nrpcRetainedCentavos]
/// * [nrpcAcceptedCentavos]
/// * [online]
/// * [onlineRefundTotalCentavos]
/// * [cashReimbursementCentavos]
/// * [releasedUnpaidCentavos]
/// * [paidTotalCentavos]
/// * [excludes]
@BuiltValue()
abstract class CancellationPlan implements Built<CancellationPlan, CancellationPlanBuilder> {
  @BuiltValueField(wireName: r'cause')
  CancellationPlanCauseEnum get cause;
  // enum causeEnum {  BUYER,  VENDOR,  };

  @BuiltValueField(wireName: r'nrpc_retained_centavos')
  int get nrpcRetainedCentavos;

  @BuiltValueField(wireName: r'nrpc_accepted_centavos')
  int get nrpcAcceptedCentavos;

  @BuiltValueField(wireName: r'online')
  BuiltList<CancellationPlanPayment> get online;

  @BuiltValueField(wireName: r'online_refund_total_centavos')
  int get onlineRefundTotalCentavos;

  @BuiltValueField(wireName: r'cash_reimbursement_centavos')
  int get cashReimbursementCentavos;

  @BuiltValueField(wireName: r'released_unpaid_centavos')
  int get releasedUnpaidCentavos;

  @BuiltValueField(wireName: r'paid_total_centavos')
  int get paidTotalCentavos;

  @BuiltValueField(wireName: r'excludes')
  BuiltList<CancellationPlanExcludesEnum> get excludes;
  // enum excludesEnum {  VENDOR_COMMISSION,  MERCHANT_WITHHOLDING,  PROVIDER_SETTLEMENT_DEDUCTIONS,  };

  CancellationPlan._();

  factory CancellationPlan([void updates(CancellationPlanBuilder b)]) = _$CancellationPlan;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CancellationPlanBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CancellationPlan> get serializer => _$CancellationPlanSerializer();
}

class _$CancellationPlanSerializer implements PrimitiveSerializer<CancellationPlan> {
  @override
  final Iterable<Type> types = const [CancellationPlan, _$CancellationPlan];

  @override
  final String wireName = r'CancellationPlan';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CancellationPlan object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'cause';
    yield serializers.serialize(
      object.cause,
      specifiedType: const FullType(CancellationPlanCauseEnum),
    );
    yield r'nrpc_retained_centavos';
    yield serializers.serialize(
      object.nrpcRetainedCentavos,
      specifiedType: const FullType(int),
    );
    yield r'nrpc_accepted_centavos';
    yield serializers.serialize(
      object.nrpcAcceptedCentavos,
      specifiedType: const FullType(int),
    );
    yield r'online';
    yield serializers.serialize(
      object.online,
      specifiedType: const FullType(BuiltList, [FullType(CancellationPlanPayment)]),
    );
    yield r'online_refund_total_centavos';
    yield serializers.serialize(
      object.onlineRefundTotalCentavos,
      specifiedType: const FullType(int),
    );
    yield r'cash_reimbursement_centavos';
    yield serializers.serialize(
      object.cashReimbursementCentavos,
      specifiedType: const FullType(int),
    );
    yield r'released_unpaid_centavos';
    yield serializers.serialize(
      object.releasedUnpaidCentavos,
      specifiedType: const FullType(int),
    );
    yield r'paid_total_centavos';
    yield serializers.serialize(
      object.paidTotalCentavos,
      specifiedType: const FullType(int),
    );
    yield r'excludes';
    yield serializers.serialize(
      object.excludes,
      specifiedType: const FullType(BuiltList, [FullType(CancellationPlanExcludesEnum)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CancellationPlan object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CancellationPlanBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'cause':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CancellationPlanCauseEnum),
          ) as CancellationPlanCauseEnum;
          result.cause = valueDes;
          break;
        case r'nrpc_retained_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.nrpcRetainedCentavos = valueDes;
          break;
        case r'nrpc_accepted_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.nrpcAcceptedCentavos = valueDes;
          break;
        case r'online':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CancellationPlanPayment)]),
          ) as BuiltList<CancellationPlanPayment>;
          result.online.replace(valueDes);
          break;
        case r'online_refund_total_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.onlineRefundTotalCentavos = valueDes;
          break;
        case r'cash_reimbursement_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.cashReimbursementCentavos = valueDes;
          break;
        case r'released_unpaid_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.releasedUnpaidCentavos = valueDes;
          break;
        case r'paid_total_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.paidTotalCentavos = valueDes;
          break;
        case r'excludes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CancellationPlanExcludesEnum)]),
          ) as BuiltList<CancellationPlanExcludesEnum>;
          result.excludes.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CancellationPlan deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CancellationPlanBuilder();
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


class CancellationPlanCauseEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'BUYER')
  static const CancellationPlanCauseEnum BUYER = _$cancellationPlanCauseEnum_BUYER;
  @BuiltValueEnumConst(wireName: r'VENDOR')
  static const CancellationPlanCauseEnum VENDOR = _$cancellationPlanCauseEnum_VENDOR;

  static Serializer<CancellationPlanCauseEnum> get serializer => _$cancellationPlanCauseEnumSerializer;

  const CancellationPlanCauseEnum._(String name): super(name);

  static BuiltSet<CancellationPlanCauseEnum> get values => _$cancellationPlanCauseEnumValues;
  static CancellationPlanCauseEnum valueOf(String name) => _$cancellationPlanCauseEnumValueOf(name);
}

class CancellationPlanExcludesEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'VENDOR_COMMISSION')
  static const CancellationPlanExcludesEnum VENDOR_COMMISSION = _$cancellationPlanExcludesEnum_VENDOR_COMMISSION;
  @BuiltValueEnumConst(wireName: r'MERCHANT_WITHHOLDING')
  static const CancellationPlanExcludesEnum MERCHANT_WITHHOLDING = _$cancellationPlanExcludesEnum_MERCHANT_WITHHOLDING;
  @BuiltValueEnumConst(wireName: r'PROVIDER_SETTLEMENT_DEDUCTIONS')
  static const CancellationPlanExcludesEnum PROVIDER_SETTLEMENT_DEDUCTIONS = _$cancellationPlanExcludesEnum_PROVIDER_SETTLEMENT_DEDUCTIONS;

  static Serializer<CancellationPlanExcludesEnum> get serializer => _$cancellationPlanExcludesEnumSerializer;

  const CancellationPlanExcludesEnum._(String name): super(name);

  static BuiltSet<CancellationPlanExcludesEnum> get values => _$cancellationPlanExcludesEnumValues;
  static CancellationPlanExcludesEnum valueOf(String name) => _$cancellationPlanExcludesEnumValueOf(name);
}

