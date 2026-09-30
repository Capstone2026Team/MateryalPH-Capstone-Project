//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/money_nrpc.dart';
import 'package:materyalph_api_client/src/model/money_delivery.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/processing_fee.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'money_breakdown.g.dart';

/// FIN-02 Buyer amounts in integer centavos. Prices include any Vendor VAT; E = M − V. Online pays M + D + F; COD/In-Store without NRPC pays M + D directly; with NRPC pays N + F online and M + D − N directly. Vendor commission and merchant withholding are never Buyer charges.
///
/// Properties:
/// * [currency]
/// * [calculationVersion]
/// * [status]
/// * [materialsGrossCentavos]
/// * [vendorDiscountCentavos]
/// * [materialsSubtotalCentavos]
/// * [includedVatCentavos]
/// * [vatExclusiveCentavos]
/// * [vatTreatment]
/// * [delivery]
/// * [nrpc]
/// * [processingFee]
/// * [commercialTotalCentavos]
/// * [amountDueOnlineCentavos]
/// * [onlinePrincipalCentavos]
/// * [physicalBalanceCentavos]
/// * [paymentPurpose]
/// * [excludes]
@BuiltValue()
abstract class MoneyBreakdown implements Built<MoneyBreakdown, MoneyBreakdownBuilder> {
  @BuiltValueField(wireName: r'currency')
  MoneyBreakdownCurrencyEnum get currency;
  // enum currencyEnum {  PHP,  };

  @BuiltValueField(wireName: r'calculation_version')
  String get calculationVersion;

  @BuiltValueField(wireName: r'status')
  MoneyBreakdownStatusEnum get status;
  // enum statusEnum {  ADVISORY_UNTIL_VENDOR_CONFIRMATION,  AWAITING_BUYER_ACCEPTANCE,  ACCEPTED,  };

  @BuiltValueField(wireName: r'materials_gross_centavos')
  int get materialsGrossCentavos;

  @BuiltValueField(wireName: r'vendor_discount_centavos')
  int get vendorDiscountCentavos;

  @BuiltValueField(wireName: r'materials_subtotal_centavos')
  int get materialsSubtotalCentavos;

  @BuiltValueField(wireName: r'included_vat_centavos')
  int get includedVatCentavos;

  @BuiltValueField(wireName: r'vat_exclusive_centavos')
  int get vatExclusiveCentavos;

  @BuiltValueField(wireName: r'vat_treatment')
  MoneyBreakdownVatTreatmentEnum get vatTreatment;
  // enum vatTreatmentEnum {  PRICES_INCLUDE_VAT,  NO_INCLUDED_VAT,  };

  @BuiltValueField(wireName: r'delivery')
  MoneyDelivery get delivery;

  @BuiltValueField(wireName: r'nrpc')
  MoneyNrpc get nrpc;

  @BuiltValueField(wireName: r'processing_fee')
  ProcessingFee get processingFee;

  @BuiltValueField(wireName: r'commercial_total_centavos')
  int? get commercialTotalCentavos;

  @BuiltValueField(wireName: r'amount_due_online_centavos')
  int? get amountDueOnlineCentavos;

  @BuiltValueField(wireName: r'online_principal_centavos')
  int? get onlinePrincipalCentavos;

  @BuiltValueField(wireName: r'physical_balance_centavos')
  int? get physicalBalanceCentavos;

  @BuiltValueField(wireName: r'payment_purpose')
  MoneyBreakdownPaymentPurposeEnum? get paymentPurpose;
  // enum paymentPurposeEnum {  FULL_ORDER_PAYMENT,  NRPC_ASSURANCE_PAYMENT,  ,  };

  @BuiltValueField(wireName: r'excludes')
  BuiltList<MoneyBreakdownExcludesEnum> get excludes;
  // enum excludesEnum {  VENDOR_COMMISSION,  MERCHANT_WITHHOLDING,  };

  MoneyBreakdown._();

  factory MoneyBreakdown([void updates(MoneyBreakdownBuilder b)]) = _$MoneyBreakdown;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MoneyBreakdownBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MoneyBreakdown> get serializer => _$MoneyBreakdownSerializer();
}

class _$MoneyBreakdownSerializer implements PrimitiveSerializer<MoneyBreakdown> {
  @override
  final Iterable<Type> types = const [MoneyBreakdown, _$MoneyBreakdown];

  @override
  final String wireName = r'MoneyBreakdown';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MoneyBreakdown object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'currency';
    yield serializers.serialize(
      object.currency,
      specifiedType: const FullType(MoneyBreakdownCurrencyEnum),
    );
    yield r'calculation_version';
    yield serializers.serialize(
      object.calculationVersion,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(MoneyBreakdownStatusEnum),
    );
    yield r'materials_gross_centavos';
    yield serializers.serialize(
      object.materialsGrossCentavos,
      specifiedType: const FullType(int),
    );
    yield r'vendor_discount_centavos';
    yield serializers.serialize(
      object.vendorDiscountCentavos,
      specifiedType: const FullType(int),
    );
    yield r'materials_subtotal_centavos';
    yield serializers.serialize(
      object.materialsSubtotalCentavos,
      specifiedType: const FullType(int),
    );
    yield r'included_vat_centavos';
    yield serializers.serialize(
      object.includedVatCentavos,
      specifiedType: const FullType(int),
    );
    yield r'vat_exclusive_centavos';
    yield serializers.serialize(
      object.vatExclusiveCentavos,
      specifiedType: const FullType(int),
    );
    yield r'vat_treatment';
    yield serializers.serialize(
      object.vatTreatment,
      specifiedType: const FullType(MoneyBreakdownVatTreatmentEnum),
    );
    yield r'delivery';
    yield serializers.serialize(
      object.delivery,
      specifiedType: const FullType(MoneyDelivery),
    );
    yield r'nrpc';
    yield serializers.serialize(
      object.nrpc,
      specifiedType: const FullType(MoneyNrpc),
    );
    yield r'processing_fee';
    yield serializers.serialize(
      object.processingFee,
      specifiedType: const FullType(ProcessingFee),
    );
    yield r'commercial_total_centavos';
    yield object.commercialTotalCentavos == null ? null : serializers.serialize(
      object.commercialTotalCentavos,
      specifiedType: const FullType.nullable(int),
    );
    yield r'amount_due_online_centavos';
    yield object.amountDueOnlineCentavos == null ? null : serializers.serialize(
      object.amountDueOnlineCentavos,
      specifiedType: const FullType.nullable(int),
    );
    yield r'online_principal_centavos';
    yield object.onlinePrincipalCentavos == null ? null : serializers.serialize(
      object.onlinePrincipalCentavos,
      specifiedType: const FullType.nullable(int),
    );
    yield r'physical_balance_centavos';
    yield object.physicalBalanceCentavos == null ? null : serializers.serialize(
      object.physicalBalanceCentavos,
      specifiedType: const FullType.nullable(int),
    );
    yield r'payment_purpose';
    yield object.paymentPurpose == null ? null : serializers.serialize(
      object.paymentPurpose,
      specifiedType: const FullType.nullable(MoneyBreakdownPaymentPurposeEnum),
    );
    yield r'excludes';
    yield serializers.serialize(
      object.excludes,
      specifiedType: const FullType(BuiltList, [FullType(MoneyBreakdownExcludesEnum)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MoneyBreakdown object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MoneyBreakdownBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'currency':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(MoneyBreakdownCurrencyEnum),
          ) as MoneyBreakdownCurrencyEnum;
          result.currency = valueDes;
          break;
        case r'calculation_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.calculationVersion = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(MoneyBreakdownStatusEnum),
          ) as MoneyBreakdownStatusEnum;
          result.status = valueDes;
          break;
        case r'materials_gross_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.materialsGrossCentavos = valueDes;
          break;
        case r'vendor_discount_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.vendorDiscountCentavos = valueDes;
          break;
        case r'materials_subtotal_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.materialsSubtotalCentavos = valueDes;
          break;
        case r'included_vat_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.includedVatCentavos = valueDes;
          break;
        case r'vat_exclusive_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.vatExclusiveCentavos = valueDes;
          break;
        case r'vat_treatment':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(MoneyBreakdownVatTreatmentEnum),
          ) as MoneyBreakdownVatTreatmentEnum;
          result.vatTreatment = valueDes;
          break;
        case r'delivery':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(MoneyDelivery),
          ) as MoneyDelivery;
          result.delivery.replace(valueDes);
          break;
        case r'nrpc':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(MoneyNrpc),
          ) as MoneyNrpc;
          result.nrpc.replace(valueDes);
          break;
        case r'processing_fee':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ProcessingFee),
          ) as ProcessingFee;
          result.processingFee.replace(valueDes);
          break;
        case r'commercial_total_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.commercialTotalCentavos = valueDes;
          break;
        case r'amount_due_online_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.amountDueOnlineCentavos = valueDes;
          break;
        case r'online_principal_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.onlinePrincipalCentavos = valueDes;
          break;
        case r'physical_balance_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.physicalBalanceCentavos = valueDes;
          break;
        case r'payment_purpose':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(MoneyBreakdownPaymentPurposeEnum),
          ) as MoneyBreakdownPaymentPurposeEnum?;
          if (valueDes == null) continue;
          result.paymentPurpose = valueDes;
          break;
        case r'excludes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(MoneyBreakdownExcludesEnum)]),
          ) as BuiltList<MoneyBreakdownExcludesEnum>;
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
  MoneyBreakdown deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MoneyBreakdownBuilder();
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


class MoneyBreakdownCurrencyEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PHP')
  static const MoneyBreakdownCurrencyEnum PHP = _$moneyBreakdownCurrencyEnum_PHP;

  static Serializer<MoneyBreakdownCurrencyEnum> get serializer => _$moneyBreakdownCurrencyEnumSerializer;

  const MoneyBreakdownCurrencyEnum._(String name): super(name);

  static BuiltSet<MoneyBreakdownCurrencyEnum> get values => _$moneyBreakdownCurrencyEnumValues;
  static MoneyBreakdownCurrencyEnum valueOf(String name) => _$moneyBreakdownCurrencyEnumValueOf(name);
}

class MoneyBreakdownStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ADVISORY_UNTIL_VENDOR_CONFIRMATION')
  static const MoneyBreakdownStatusEnum ADVISORY_UNTIL_VENDOR_CONFIRMATION = _$moneyBreakdownStatusEnum_ADVISORY_UNTIL_VENDOR_CONFIRMATION;
  @BuiltValueEnumConst(wireName: r'AWAITING_BUYER_ACCEPTANCE')
  static const MoneyBreakdownStatusEnum AWAITING_BUYER_ACCEPTANCE = _$moneyBreakdownStatusEnum_AWAITING_BUYER_ACCEPTANCE;
  @BuiltValueEnumConst(wireName: r'ACCEPTED')
  static const MoneyBreakdownStatusEnum ACCEPTED = _$moneyBreakdownStatusEnum_ACCEPTED;

  static Serializer<MoneyBreakdownStatusEnum> get serializer => _$moneyBreakdownStatusEnumSerializer;

  const MoneyBreakdownStatusEnum._(String name): super(name);

  static BuiltSet<MoneyBreakdownStatusEnum> get values => _$moneyBreakdownStatusEnumValues;
  static MoneyBreakdownStatusEnum valueOf(String name) => _$moneyBreakdownStatusEnumValueOf(name);
}

class MoneyBreakdownVatTreatmentEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PRICES_INCLUDE_VAT')
  static const MoneyBreakdownVatTreatmentEnum PRICES_INCLUDE_VAT = _$moneyBreakdownVatTreatmentEnum_PRICES_INCLUDE_VAT;
  @BuiltValueEnumConst(wireName: r'NO_INCLUDED_VAT')
  static const MoneyBreakdownVatTreatmentEnum NO_INCLUDED_VAT = _$moneyBreakdownVatTreatmentEnum_NO_INCLUDED_VAT;

  static Serializer<MoneyBreakdownVatTreatmentEnum> get serializer => _$moneyBreakdownVatTreatmentEnumSerializer;

  const MoneyBreakdownVatTreatmentEnum._(String name): super(name);

  static BuiltSet<MoneyBreakdownVatTreatmentEnum> get values => _$moneyBreakdownVatTreatmentEnumValues;
  static MoneyBreakdownVatTreatmentEnum valueOf(String name) => _$moneyBreakdownVatTreatmentEnumValueOf(name);
}

class MoneyBreakdownPaymentPurposeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'FULL_ORDER_PAYMENT')
  static const MoneyBreakdownPaymentPurposeEnum FULL_ORDER_PAYMENT = _$moneyBreakdownPaymentPurposeEnum_FULL_ORDER_PAYMENT;
  @BuiltValueEnumConst(wireName: r'NRPC_ASSURANCE_PAYMENT')
  static const MoneyBreakdownPaymentPurposeEnum NRPC_ASSURANCE_PAYMENT = _$moneyBreakdownPaymentPurposeEnum_NRPC_ASSURANCE_PAYMENT;

  static Serializer<MoneyBreakdownPaymentPurposeEnum> get serializer => _$moneyBreakdownPaymentPurposeEnumSerializer;

  const MoneyBreakdownPaymentPurposeEnum._(String name): super(name);

  static BuiltSet<MoneyBreakdownPaymentPurposeEnum> get values => _$moneyBreakdownPaymentPurposeEnumValues;
  static MoneyBreakdownPaymentPurposeEnum valueOf(String name) => _$moneyBreakdownPaymentPurposeEnumValueOf(name);
}

class MoneyBreakdownExcludesEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'VENDOR_COMMISSION')
  static const MoneyBreakdownExcludesEnum VENDOR_COMMISSION = _$moneyBreakdownExcludesEnum_VENDOR_COMMISSION;
  @BuiltValueEnumConst(wireName: r'MERCHANT_WITHHOLDING')
  static const MoneyBreakdownExcludesEnum MERCHANT_WITHHOLDING = _$moneyBreakdownExcludesEnum_MERCHANT_WITHHOLDING;

  static Serializer<MoneyBreakdownExcludesEnum> get serializer => _$moneyBreakdownExcludesEnumSerializer;

  const MoneyBreakdownExcludesEnum._(String name): super(name);

  static BuiltSet<MoneyBreakdownExcludesEnum> get values => _$moneyBreakdownExcludesEnumValues;
  static MoneyBreakdownExcludesEnum valueOf(String name) => _$moneyBreakdownExcludesEnumValueOf(name);
}

