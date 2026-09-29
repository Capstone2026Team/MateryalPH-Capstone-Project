//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/delivery_amount.dart';
import 'package:materyalph_api_client/src/model/financial_preview_line.dart';
import 'package:materyalph_api_client/src/model/processing_fee_amount.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'financial_preview.g.dart';

/// FIN-02 preview. M = Σ line payable amounts, V = included VAT, E = M − V; D estimate or pending; F pending until a payment channel. Never includes Vendor commission or merchant withholding.
///
/// Properties:
/// * [currency]
/// * [calculationVersion]
/// * [lines]
/// * [materialsSubtotalCentavos]
/// * [includedVatCentavos]
/// * [vatExclusiveMaterialsCentavos]
/// * [vatTreatment]
/// * [delivery]
/// * [processingFee]
/// * [totalBeforeProcessingMinCentavos]
/// * [totalBeforeProcessingMaxCentavos]
/// * [excludes]
/// * [status]
@BuiltValue()
abstract class FinancialPreview implements Built<FinancialPreview, FinancialPreviewBuilder> {
  @BuiltValueField(wireName: r'currency')
  FinancialPreviewCurrencyEnum get currency;
  // enum currencyEnum {  PHP,  };

  @BuiltValueField(wireName: r'calculation_version')
  String get calculationVersion;

  @BuiltValueField(wireName: r'lines')
  BuiltList<FinancialPreviewLine> get lines;

  @BuiltValueField(wireName: r'materials_subtotal_centavos')
  int get materialsSubtotalCentavos;

  @BuiltValueField(wireName: r'included_vat_centavos')
  int get includedVatCentavos;

  @BuiltValueField(wireName: r'vat_exclusive_materials_centavos')
  int get vatExclusiveMaterialsCentavos;

  @BuiltValueField(wireName: r'vat_treatment')
  FinancialPreviewVatTreatmentEnum get vatTreatment;
  // enum vatTreatmentEnum {  PRICES_INCLUDE_VAT,  NO_INCLUDED_VAT,  };

  @BuiltValueField(wireName: r'delivery')
  DeliveryAmount get delivery;

  @BuiltValueField(wireName: r'processing_fee')
  ProcessingFeeAmount get processingFee;

  @BuiltValueField(wireName: r'total_before_processing_min_centavos')
  int? get totalBeforeProcessingMinCentavos;

  @BuiltValueField(wireName: r'total_before_processing_max_centavos')
  int? get totalBeforeProcessingMaxCentavos;

  @BuiltValueField(wireName: r'excludes')
  BuiltList<FinancialPreviewExcludesEnum> get excludes;
  // enum excludesEnum {  VENDOR_COMMISSION,  MERCHANT_WITHHOLDING,  };

  @BuiltValueField(wireName: r'status')
  FinancialPreviewStatusEnum get status;
  // enum statusEnum {  ADVISORY_UNTIL_VENDOR_CONFIRMATION,  };

  FinancialPreview._();

  factory FinancialPreview([void updates(FinancialPreviewBuilder b)]) = _$FinancialPreview;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FinancialPreviewBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FinancialPreview> get serializer => _$FinancialPreviewSerializer();
}

class _$FinancialPreviewSerializer implements PrimitiveSerializer<FinancialPreview> {
  @override
  final Iterable<Type> types = const [FinancialPreview, _$FinancialPreview];

  @override
  final String wireName = r'FinancialPreview';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FinancialPreview object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'currency';
    yield serializers.serialize(
      object.currency,
      specifiedType: const FullType(FinancialPreviewCurrencyEnum),
    );
    yield r'calculation_version';
    yield serializers.serialize(
      object.calculationVersion,
      specifiedType: const FullType(String),
    );
    yield r'lines';
    yield serializers.serialize(
      object.lines,
      specifiedType: const FullType(BuiltList, [FullType(FinancialPreviewLine)]),
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
    yield r'vat_exclusive_materials_centavos';
    yield serializers.serialize(
      object.vatExclusiveMaterialsCentavos,
      specifiedType: const FullType(int),
    );
    yield r'vat_treatment';
    yield serializers.serialize(
      object.vatTreatment,
      specifiedType: const FullType(FinancialPreviewVatTreatmentEnum),
    );
    yield r'delivery';
    yield serializers.serialize(
      object.delivery,
      specifiedType: const FullType(DeliveryAmount),
    );
    yield r'processing_fee';
    yield serializers.serialize(
      object.processingFee,
      specifiedType: const FullType(ProcessingFeeAmount),
    );
    yield r'total_before_processing_min_centavos';
    yield object.totalBeforeProcessingMinCentavos == null ? null : serializers.serialize(
      object.totalBeforeProcessingMinCentavos,
      specifiedType: const FullType.nullable(int),
    );
    yield r'total_before_processing_max_centavos';
    yield object.totalBeforeProcessingMaxCentavos == null ? null : serializers.serialize(
      object.totalBeforeProcessingMaxCentavos,
      specifiedType: const FullType.nullable(int),
    );
    yield r'excludes';
    yield serializers.serialize(
      object.excludes,
      specifiedType: const FullType(BuiltList, [FullType(FinancialPreviewExcludesEnum)]),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(FinancialPreviewStatusEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    FinancialPreview object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FinancialPreviewBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'currency':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(FinancialPreviewCurrencyEnum),
          ) as FinancialPreviewCurrencyEnum;
          result.currency = valueDes;
          break;
        case r'calculation_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.calculationVersion = valueDes;
          break;
        case r'lines':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(FinancialPreviewLine)]),
          ) as BuiltList<FinancialPreviewLine>;
          result.lines.replace(valueDes);
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
        case r'vat_exclusive_materials_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.vatExclusiveMaterialsCentavos = valueDes;
          break;
        case r'vat_treatment':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(FinancialPreviewVatTreatmentEnum),
          ) as FinancialPreviewVatTreatmentEnum;
          result.vatTreatment = valueDes;
          break;
        case r'delivery':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DeliveryAmount),
          ) as DeliveryAmount;
          result.delivery.replace(valueDes);
          break;
        case r'processing_fee':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ProcessingFeeAmount),
          ) as ProcessingFeeAmount;
          result.processingFee.replace(valueDes);
          break;
        case r'total_before_processing_min_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.totalBeforeProcessingMinCentavos = valueDes;
          break;
        case r'total_before_processing_max_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.totalBeforeProcessingMaxCentavos = valueDes;
          break;
        case r'excludes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(FinancialPreviewExcludesEnum)]),
          ) as BuiltList<FinancialPreviewExcludesEnum>;
          result.excludes.replace(valueDes);
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(FinancialPreviewStatusEnum),
          ) as FinancialPreviewStatusEnum;
          result.status = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FinancialPreview deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FinancialPreviewBuilder();
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


class FinancialPreviewCurrencyEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PHP')
  static const FinancialPreviewCurrencyEnum PHP = _$financialPreviewCurrencyEnum_PHP;

  static Serializer<FinancialPreviewCurrencyEnum> get serializer => _$financialPreviewCurrencyEnumSerializer;

  const FinancialPreviewCurrencyEnum._(String name): super(name);

  static BuiltSet<FinancialPreviewCurrencyEnum> get values => _$financialPreviewCurrencyEnumValues;
  static FinancialPreviewCurrencyEnum valueOf(String name) => _$financialPreviewCurrencyEnumValueOf(name);
}

class FinancialPreviewVatTreatmentEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PRICES_INCLUDE_VAT')
  static const FinancialPreviewVatTreatmentEnum PRICES_INCLUDE_VAT = _$financialPreviewVatTreatmentEnum_PRICES_INCLUDE_VAT;
  @BuiltValueEnumConst(wireName: r'NO_INCLUDED_VAT')
  static const FinancialPreviewVatTreatmentEnum NO_INCLUDED_VAT = _$financialPreviewVatTreatmentEnum_NO_INCLUDED_VAT;

  static Serializer<FinancialPreviewVatTreatmentEnum> get serializer => _$financialPreviewVatTreatmentEnumSerializer;

  const FinancialPreviewVatTreatmentEnum._(String name): super(name);

  static BuiltSet<FinancialPreviewVatTreatmentEnum> get values => _$financialPreviewVatTreatmentEnumValues;
  static FinancialPreviewVatTreatmentEnum valueOf(String name) => _$financialPreviewVatTreatmentEnumValueOf(name);
}

class FinancialPreviewExcludesEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'VENDOR_COMMISSION')
  static const FinancialPreviewExcludesEnum VENDOR_COMMISSION = _$financialPreviewExcludesEnum_VENDOR_COMMISSION;
  @BuiltValueEnumConst(wireName: r'MERCHANT_WITHHOLDING')
  static const FinancialPreviewExcludesEnum MERCHANT_WITHHOLDING = _$financialPreviewExcludesEnum_MERCHANT_WITHHOLDING;

  static Serializer<FinancialPreviewExcludesEnum> get serializer => _$financialPreviewExcludesEnumSerializer;

  const FinancialPreviewExcludesEnum._(String name): super(name);

  static BuiltSet<FinancialPreviewExcludesEnum> get values => _$financialPreviewExcludesEnumValues;
  static FinancialPreviewExcludesEnum valueOf(String name) => _$financialPreviewExcludesEnumValueOf(name);
}

class FinancialPreviewStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ADVISORY_UNTIL_VENDOR_CONFIRMATION')
  static const FinancialPreviewStatusEnum ADVISORY_UNTIL_VENDOR_CONFIRMATION = _$financialPreviewStatusEnum_ADVISORY_UNTIL_VENDOR_CONFIRMATION;

  static Serializer<FinancialPreviewStatusEnum> get serializer => _$financialPreviewStatusEnumSerializer;

  const FinancialPreviewStatusEnum._(String name): super(name);

  static BuiltSet<FinancialPreviewStatusEnum> get values => _$financialPreviewStatusEnumValues;
  static FinancialPreviewStatusEnum valueOf(String name) => _$financialPreviewStatusEnumValueOf(name);
}

