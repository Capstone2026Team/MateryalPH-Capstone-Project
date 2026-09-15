//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_tax_data.g.dart';

/// VendorTaxData
///
/// Properties:
/// * [taxpayerKey]
/// * [legalName]
/// * [tradeName]
/// * [tin]
/// * [branchCode]
/// * [entityClass]
/// * [registrationCategory]
/// * [vatCategory]
/// * [fiscalYearStartMonth]
/// * [effectiveFrom]
/// * [effectiveUntil]
/// * [birCorVersionId]
/// * [invoiceMethod]
/// * [invoiceCoverage]
/// * [priorYearAmountCentavos]
/// * [priorYearPosition]
/// * [declarationYear]
/// * [declarationReceipt]
/// * [declarationValidFrom]
/// * [declarationValidUntil]
/// * [outsidePlatformAmountCentavos]
/// * [outsidePlatformAsOf]
/// * [overlapScope]
/// * [evidenceVersionIds]
@BuiltValue()
abstract class VendorTaxData implements Built<VendorTaxData, VendorTaxDataBuilder> {
  @BuiltValueField(wireName: r'taxpayer_key')
  String get taxpayerKey;

  @BuiltValueField(wireName: r'legal_name')
  String get legalName;

  @BuiltValueField(wireName: r'trade_name')
  String get tradeName;

  @BuiltValueField(wireName: r'tin')
  String get tin;

  @BuiltValueField(wireName: r'branch_code')
  String? get branchCode;

  @BuiltValueField(wireName: r'entity_class')
  VendorTaxDataEntityClassEnum get entityClass;
  // enum entityClassEnum {  INDIVIDUAL,  CORPORATE,  };

  @BuiltValueField(wireName: r'registration_category')
  String get registrationCategory;

  @BuiltValueField(wireName: r'vat_category')
  VendorTaxDataVatCategoryEnum get vatCategory;
  // enum vatCategoryEnum {  VAT_REGISTERED,  NON_VAT,  };

  @BuiltValueField(wireName: r'fiscal_year_start_month')
  int get fiscalYearStartMonth;

  @BuiltValueField(wireName: r'effective_from')
  String get effectiveFrom;

  @BuiltValueField(wireName: r'effective_until')
  String? get effectiveUntil;

  @BuiltValueField(wireName: r'bir_cor_version_id')
  String get birCorVersionId;

  @BuiltValueField(wireName: r'invoice_method')
  String get invoiceMethod;

  @BuiltValueField(wireName: r'invoice_coverage')
  String get invoiceCoverage;

  @BuiltValueField(wireName: r'prior_year_amount_centavos')
  int? get priorYearAmountCentavos;

  @BuiltValueField(wireName: r'prior_year_position')
  String? get priorYearPosition;

  @BuiltValueField(wireName: r'declaration_year')
  int? get declarationYear;

  @BuiltValueField(wireName: r'declaration_receipt')
  String? get declarationReceipt;

  @BuiltValueField(wireName: r'declaration_valid_from')
  String? get declarationValidFrom;

  @BuiltValueField(wireName: r'declaration_valid_until')
  String? get declarationValidUntil;

  @BuiltValueField(wireName: r'outside_platform_amount_centavos')
  int? get outsidePlatformAmountCentavos;

  @BuiltValueField(wireName: r'outside_platform_as_of')
  String? get outsidePlatformAsOf;

  @BuiltValueField(wireName: r'overlap_scope')
  String? get overlapScope;

  @BuiltValueField(wireName: r'evidence_version_ids')
  BuiltList<String>? get evidenceVersionIds;

  VendorTaxData._();

  factory VendorTaxData([void updates(VendorTaxDataBuilder b)]) = _$VendorTaxData;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorTaxDataBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorTaxData> get serializer => _$VendorTaxDataSerializer();
}

class _$VendorTaxDataSerializer implements PrimitiveSerializer<VendorTaxData> {
  @override
  final Iterable<Type> types = const [VendorTaxData, _$VendorTaxData];

  @override
  final String wireName = r'VendorTaxData';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorTaxData object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'taxpayer_key';
    yield serializers.serialize(
      object.taxpayerKey,
      specifiedType: const FullType(String),
    );
    yield r'legal_name';
    yield serializers.serialize(
      object.legalName,
      specifiedType: const FullType(String),
    );
    yield r'trade_name';
    yield serializers.serialize(
      object.tradeName,
      specifiedType: const FullType(String),
    );
    yield r'tin';
    yield serializers.serialize(
      object.tin,
      specifiedType: const FullType(String),
    );
    if (object.branchCode != null) {
      yield r'branch_code';
      yield serializers.serialize(
        object.branchCode,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'entity_class';
    yield serializers.serialize(
      object.entityClass,
      specifiedType: const FullType(VendorTaxDataEntityClassEnum),
    );
    yield r'registration_category';
    yield serializers.serialize(
      object.registrationCategory,
      specifiedType: const FullType(String),
    );
    yield r'vat_category';
    yield serializers.serialize(
      object.vatCategory,
      specifiedType: const FullType(VendorTaxDataVatCategoryEnum),
    );
    yield r'fiscal_year_start_month';
    yield serializers.serialize(
      object.fiscalYearStartMonth,
      specifiedType: const FullType(int),
    );
    yield r'effective_from';
    yield serializers.serialize(
      object.effectiveFrom,
      specifiedType: const FullType(String),
    );
    if (object.effectiveUntil != null) {
      yield r'effective_until';
      yield serializers.serialize(
        object.effectiveUntil,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'bir_cor_version_id';
    yield serializers.serialize(
      object.birCorVersionId,
      specifiedType: const FullType(String),
    );
    yield r'invoice_method';
    yield serializers.serialize(
      object.invoiceMethod,
      specifiedType: const FullType(String),
    );
    yield r'invoice_coverage';
    yield serializers.serialize(
      object.invoiceCoverage,
      specifiedType: const FullType(String),
    );
    if (object.priorYearAmountCentavos != null) {
      yield r'prior_year_amount_centavos';
      yield serializers.serialize(
        object.priorYearAmountCentavos,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.priorYearPosition != null) {
      yield r'prior_year_position';
      yield serializers.serialize(
        object.priorYearPosition,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.declarationYear != null) {
      yield r'declaration_year';
      yield serializers.serialize(
        object.declarationYear,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.declarationReceipt != null) {
      yield r'declaration_receipt';
      yield serializers.serialize(
        object.declarationReceipt,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.declarationValidFrom != null) {
      yield r'declaration_valid_from';
      yield serializers.serialize(
        object.declarationValidFrom,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.declarationValidUntil != null) {
      yield r'declaration_valid_until';
      yield serializers.serialize(
        object.declarationValidUntil,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.outsidePlatformAmountCentavos != null) {
      yield r'outside_platform_amount_centavos';
      yield serializers.serialize(
        object.outsidePlatformAmountCentavos,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.outsidePlatformAsOf != null) {
      yield r'outside_platform_as_of';
      yield serializers.serialize(
        object.outsidePlatformAsOf,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.overlapScope != null) {
      yield r'overlap_scope';
      yield serializers.serialize(
        object.overlapScope,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.evidenceVersionIds != null) {
      yield r'evidence_version_ids';
      yield serializers.serialize(
        object.evidenceVersionIds,
        specifiedType: const FullType(BuiltList, [FullType(String)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorTaxData object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorTaxDataBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'taxpayer_key':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.taxpayerKey = valueDes;
          break;
        case r'legal_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.legalName = valueDes;
          break;
        case r'trade_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.tradeName = valueDes;
          break;
        case r'tin':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.tin = valueDes;
          break;
        case r'branch_code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.branchCode = valueDes;
          break;
        case r'entity_class':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorTaxDataEntityClassEnum),
          ) as VendorTaxDataEntityClassEnum;
          result.entityClass = valueDes;
          break;
        case r'registration_category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.registrationCategory = valueDes;
          break;
        case r'vat_category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorTaxDataVatCategoryEnum),
          ) as VendorTaxDataVatCategoryEnum;
          result.vatCategory = valueDes;
          break;
        case r'fiscal_year_start_month':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.fiscalYearStartMonth = valueDes;
          break;
        case r'effective_from':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.effectiveFrom = valueDes;
          break;
        case r'effective_until':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.effectiveUntil = valueDes;
          break;
        case r'bir_cor_version_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.birCorVersionId = valueDes;
          break;
        case r'invoice_method':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.invoiceMethod = valueDes;
          break;
        case r'invoice_coverage':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.invoiceCoverage = valueDes;
          break;
        case r'prior_year_amount_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.priorYearAmountCentavos = valueDes;
          break;
        case r'prior_year_position':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.priorYearPosition = valueDes;
          break;
        case r'declaration_year':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.declarationYear = valueDes;
          break;
        case r'declaration_receipt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.declarationReceipt = valueDes;
          break;
        case r'declaration_valid_from':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.declarationValidFrom = valueDes;
          break;
        case r'declaration_valid_until':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.declarationValidUntil = valueDes;
          break;
        case r'outside_platform_amount_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.outsidePlatformAmountCentavos = valueDes;
          break;
        case r'outside_platform_as_of':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.outsidePlatformAsOf = valueDes;
          break;
        case r'overlap_scope':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.overlapScope = valueDes;
          break;
        case r'evidence_version_ids':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(String)]),
          ) as BuiltList<String>?;
          if (valueDes == null) continue;
          result.evidenceVersionIds.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorTaxData deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorTaxDataBuilder();
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


class VendorTaxDataEntityClassEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'INDIVIDUAL')
  static const VendorTaxDataEntityClassEnum INDIVIDUAL = _$vendorTaxDataEntityClassEnum_INDIVIDUAL;
  @BuiltValueEnumConst(wireName: r'CORPORATE')
  static const VendorTaxDataEntityClassEnum CORPORATE = _$vendorTaxDataEntityClassEnum_CORPORATE;

  static Serializer<VendorTaxDataEntityClassEnum> get serializer => _$vendorTaxDataEntityClassEnumSerializer;

  const VendorTaxDataEntityClassEnum._(String name): super(name);

  static BuiltSet<VendorTaxDataEntityClassEnum> get values => _$vendorTaxDataEntityClassEnumValues;
  static VendorTaxDataEntityClassEnum valueOf(String name) => _$vendorTaxDataEntityClassEnumValueOf(name);
}

class VendorTaxDataVatCategoryEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'VAT_REGISTERED')
  static const VendorTaxDataVatCategoryEnum VAT_REGISTERED = _$vendorTaxDataVatCategoryEnum_VAT_REGISTERED;
  @BuiltValueEnumConst(wireName: r'NON_VAT')
  static const VendorTaxDataVatCategoryEnum NON_VAT = _$vendorTaxDataVatCategoryEnum_NON_VAT;

  static Serializer<VendorTaxDataVatCategoryEnum> get serializer => _$vendorTaxDataVatCategoryEnumSerializer;

  const VendorTaxDataVatCategoryEnum._(String name): super(name);

  static BuiltSet<VendorTaxDataVatCategoryEnum> get values => _$vendorTaxDataVatCategoryEnumValues;
  static VendorTaxDataVatCategoryEnum valueOf(String name) => _$vendorTaxDataVatCategoryEnumValueOf(name);
}

