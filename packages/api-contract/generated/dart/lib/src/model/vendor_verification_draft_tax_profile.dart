//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/date.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_verification_draft_tax_profile.g.dart';

/// VendorVerificationDraftTaxProfile
///
/// Properties:
/// * [taxpayerKey]
/// * [tin] - Combined 9-digit TIN and 3 to 5 digit branch code; use 000 when no branch code applies.
/// * [declarationYear]
/// * [birCorReference]
/// * [entityClass]
/// * [registrationCategory]
/// * [vatCategory]
/// * [fiscalYearStartMonth]
/// * [declarationType]
/// * [thresholdPosition]
/// * [submissionDate]
/// * [outsidePlatformAsOf]
/// * [withholdingScenario]
/// * [taxReliefClaimed]
/// * [ownerAttested]
@BuiltValue()
abstract class VendorVerificationDraftTaxProfile implements Built<VendorVerificationDraftTaxProfile, VendorVerificationDraftTaxProfileBuilder> {
  @BuiltValueField(wireName: r'taxpayer_key')
  String? get taxpayerKey;

  /// Combined 9-digit TIN and 3 to 5 digit branch code; use 000 when no branch code applies.
  @BuiltValueField(wireName: r'tin')
  String? get tin;

  @BuiltValueField(wireName: r'declaration_year')
  int? get declarationYear;

  @BuiltValueField(wireName: r'bir_cor_reference')
  String? get birCorReference;

  @BuiltValueField(wireName: r'entity_class')
  VendorVerificationDraftTaxProfileEntityClassEnum? get entityClass;
  // enum entityClassEnum {  INDIVIDUAL,  CORPORATION,  PARTNERSHIP,  COOPERATIVE,  };

  @BuiltValueField(wireName: r'registration_category')
  String? get registrationCategory;

  @BuiltValueField(wireName: r'vat_category')
  VendorVerificationDraftTaxProfileVatCategoryEnum? get vatCategory;
  // enum vatCategoryEnum {  VAT,  NON_VAT,  VAT_ZERO,  VAT_EXEMPT,  };

  @BuiltValueField(wireName: r'fiscal_year_start_month')
  int? get fiscalYearStartMonth;

  @BuiltValueField(wireName: r'declaration_type')
  String? get declarationType;

  @BuiltValueField(wireName: r'threshold_position')
  String? get thresholdPosition;

  @BuiltValueField(wireName: r'submission_date')
  Date? get submissionDate;

  @BuiltValueField(wireName: r'outside_platform_as_of')
  Date? get outsidePlatformAsOf;

  @BuiltValueField(wireName: r'withholding_scenario')
  VendorVerificationDraftTaxProfileWithholdingScenarioEnum? get withholdingScenario;
  // enum withholdingScenarioEnum {  DEMO_PLATFORM_WITHHOLDER,  DEMO_PROVIDER_WITHHOLDER,  };

  @BuiltValueField(wireName: r'tax_relief_claimed')
  bool? get taxReliefClaimed;

  @BuiltValueField(wireName: r'owner_attested')
  bool? get ownerAttested;

  VendorVerificationDraftTaxProfile._();

  factory VendorVerificationDraftTaxProfile([void updates(VendorVerificationDraftTaxProfileBuilder b)]) = _$VendorVerificationDraftTaxProfile;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorVerificationDraftTaxProfileBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorVerificationDraftTaxProfile> get serializer => _$VendorVerificationDraftTaxProfileSerializer();
}

class _$VendorVerificationDraftTaxProfileSerializer implements PrimitiveSerializer<VendorVerificationDraftTaxProfile> {
  @override
  final Iterable<Type> types = const [VendorVerificationDraftTaxProfile, _$VendorVerificationDraftTaxProfile];

  @override
  final String wireName = r'VendorVerificationDraftTaxProfile';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorVerificationDraftTaxProfile object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.taxpayerKey != null) {
      yield r'taxpayer_key';
      yield serializers.serialize(
        object.taxpayerKey,
        specifiedType: const FullType(String),
      );
    }
    if (object.tin != null) {
      yield r'tin';
      yield serializers.serialize(
        object.tin,
        specifiedType: const FullType(String),
      );
    }
    if (object.declarationYear != null) {
      yield r'declaration_year';
      yield serializers.serialize(
        object.declarationYear,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.birCorReference != null) {
      yield r'bir_cor_reference';
      yield serializers.serialize(
        object.birCorReference,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.entityClass != null) {
      yield r'entity_class';
      yield serializers.serialize(
        object.entityClass,
        specifiedType: const FullType(VendorVerificationDraftTaxProfileEntityClassEnum),
      );
    }
    if (object.registrationCategory != null) {
      yield r'registration_category';
      yield serializers.serialize(
        object.registrationCategory,
        specifiedType: const FullType(String),
      );
    }
    if (object.vatCategory != null) {
      yield r'vat_category';
      yield serializers.serialize(
        object.vatCategory,
        specifiedType: const FullType(VendorVerificationDraftTaxProfileVatCategoryEnum),
      );
    }
    if (object.fiscalYearStartMonth != null) {
      yield r'fiscal_year_start_month';
      yield serializers.serialize(
        object.fiscalYearStartMonth,
        specifiedType: const FullType(int),
      );
    }
    if (object.declarationType != null) {
      yield r'declaration_type';
      yield serializers.serialize(
        object.declarationType,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.thresholdPosition != null) {
      yield r'threshold_position';
      yield serializers.serialize(
        object.thresholdPosition,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.submissionDate != null) {
      yield r'submission_date';
      yield serializers.serialize(
        object.submissionDate,
        specifiedType: const FullType.nullable(Date),
      );
    }
    if (object.outsidePlatformAsOf != null) {
      yield r'outside_platform_as_of';
      yield serializers.serialize(
        object.outsidePlatformAsOf,
        specifiedType: const FullType.nullable(Date),
      );
    }
    if (object.withholdingScenario != null) {
      yield r'withholding_scenario';
      yield serializers.serialize(
        object.withholdingScenario,
        specifiedType: const FullType.nullable(VendorVerificationDraftTaxProfileWithholdingScenarioEnum),
      );
    }
    if (object.taxReliefClaimed != null) {
      yield r'tax_relief_claimed';
      yield serializers.serialize(
        object.taxReliefClaimed,
        specifiedType: const FullType(bool),
      );
    }
    if (object.ownerAttested != null) {
      yield r'owner_attested';
      yield serializers.serialize(
        object.ownerAttested,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorVerificationDraftTaxProfile object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorVerificationDraftTaxProfileBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'taxpayer_key':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.taxpayerKey = valueDes;
          break;
        case r'tin':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.tin = valueDes;
          break;
        case r'declaration_year':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.declarationYear = valueDes;
          break;
        case r'bir_cor_reference':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.birCorReference = valueDes;
          break;
        case r'entity_class':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(VendorVerificationDraftTaxProfileEntityClassEnum),
          ) as VendorVerificationDraftTaxProfileEntityClassEnum?;
          if (valueDes == null) continue;
          result.entityClass = valueDes;
          break;
        case r'registration_category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.registrationCategory = valueDes;
          break;
        case r'vat_category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(VendorVerificationDraftTaxProfileVatCategoryEnum),
          ) as VendorVerificationDraftTaxProfileVatCategoryEnum?;
          if (valueDes == null) continue;
          result.vatCategory = valueDes;
          break;
        case r'fiscal_year_start_month':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.fiscalYearStartMonth = valueDes;
          break;
        case r'declaration_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.declarationType = valueDes;
          break;
        case r'threshold_position':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.thresholdPosition = valueDes;
          break;
        case r'submission_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Date),
          ) as Date?;
          if (valueDes == null) continue;
          result.submissionDate = valueDes;
          break;
        case r'outside_platform_as_of':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Date),
          ) as Date?;
          if (valueDes == null) continue;
          result.outsidePlatformAsOf = valueDes;
          break;
        case r'withholding_scenario':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(VendorVerificationDraftTaxProfileWithholdingScenarioEnum),
          ) as VendorVerificationDraftTaxProfileWithholdingScenarioEnum?;
          if (valueDes == null) continue;
          result.withholdingScenario = valueDes;
          break;
        case r'tax_relief_claimed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.taxReliefClaimed = valueDes;
          break;
        case r'owner_attested':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.ownerAttested = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorVerificationDraftTaxProfile deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorVerificationDraftTaxProfileBuilder();
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


class VendorVerificationDraftTaxProfileEntityClassEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'INDIVIDUAL')
  static const VendorVerificationDraftTaxProfileEntityClassEnum INDIVIDUAL = _$vendorVerificationDraftTaxProfileEntityClassEnum_INDIVIDUAL;
  @BuiltValueEnumConst(wireName: r'CORPORATION')
  static const VendorVerificationDraftTaxProfileEntityClassEnum CORPORATION = _$vendorVerificationDraftTaxProfileEntityClassEnum_CORPORATION;
  @BuiltValueEnumConst(wireName: r'PARTNERSHIP')
  static const VendorVerificationDraftTaxProfileEntityClassEnum PARTNERSHIP = _$vendorVerificationDraftTaxProfileEntityClassEnum_PARTNERSHIP;
  @BuiltValueEnumConst(wireName: r'COOPERATIVE')
  static const VendorVerificationDraftTaxProfileEntityClassEnum COOPERATIVE = _$vendorVerificationDraftTaxProfileEntityClassEnum_COOPERATIVE;

  static Serializer<VendorVerificationDraftTaxProfileEntityClassEnum> get serializer => _$vendorVerificationDraftTaxProfileEntityClassEnumSerializer;

  const VendorVerificationDraftTaxProfileEntityClassEnum._(String name): super(name);

  static BuiltSet<VendorVerificationDraftTaxProfileEntityClassEnum> get values => _$vendorVerificationDraftTaxProfileEntityClassEnumValues;
  static VendorVerificationDraftTaxProfileEntityClassEnum valueOf(String name) => _$vendorVerificationDraftTaxProfileEntityClassEnumValueOf(name);
}

class VendorVerificationDraftTaxProfileVatCategoryEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'VAT')
  static const VendorVerificationDraftTaxProfileVatCategoryEnum VAT = _$vendorVerificationDraftTaxProfileVatCategoryEnum_VAT;
  @BuiltValueEnumConst(wireName: r'NON_VAT')
  static const VendorVerificationDraftTaxProfileVatCategoryEnum NON_VAT = _$vendorVerificationDraftTaxProfileVatCategoryEnum_NON_VAT;
  @BuiltValueEnumConst(wireName: r'VAT_ZERO')
  static const VendorVerificationDraftTaxProfileVatCategoryEnum VAT_ZERO = _$vendorVerificationDraftTaxProfileVatCategoryEnum_VAT_ZERO;
  @BuiltValueEnumConst(wireName: r'VAT_EXEMPT')
  static const VendorVerificationDraftTaxProfileVatCategoryEnum VAT_EXEMPT = _$vendorVerificationDraftTaxProfileVatCategoryEnum_VAT_EXEMPT;

  static Serializer<VendorVerificationDraftTaxProfileVatCategoryEnum> get serializer => _$vendorVerificationDraftTaxProfileVatCategoryEnumSerializer;

  const VendorVerificationDraftTaxProfileVatCategoryEnum._(String name): super(name);

  static BuiltSet<VendorVerificationDraftTaxProfileVatCategoryEnum> get values => _$vendorVerificationDraftTaxProfileVatCategoryEnumValues;
  static VendorVerificationDraftTaxProfileVatCategoryEnum valueOf(String name) => _$vendorVerificationDraftTaxProfileVatCategoryEnumValueOf(name);
}

class VendorVerificationDraftTaxProfileWithholdingScenarioEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DEMO_PLATFORM_WITHHOLDER')
  static const VendorVerificationDraftTaxProfileWithholdingScenarioEnum DEMO_PLATFORM_WITHHOLDER = _$vendorVerificationDraftTaxProfileWithholdingScenarioEnum_DEMO_PLATFORM_WITHHOLDER;
  @BuiltValueEnumConst(wireName: r'DEMO_PROVIDER_WITHHOLDER')
  static const VendorVerificationDraftTaxProfileWithholdingScenarioEnum DEMO_PROVIDER_WITHHOLDER = _$vendorVerificationDraftTaxProfileWithholdingScenarioEnum_DEMO_PROVIDER_WITHHOLDER;

  static Serializer<VendorVerificationDraftTaxProfileWithholdingScenarioEnum> get serializer => _$vendorVerificationDraftTaxProfileWithholdingScenarioEnumSerializer;

  const VendorVerificationDraftTaxProfileWithholdingScenarioEnum._(String name): super(name);

  static BuiltSet<VendorVerificationDraftTaxProfileWithholdingScenarioEnum> get values => _$vendorVerificationDraftTaxProfileWithholdingScenarioEnumValues;
  static VendorVerificationDraftTaxProfileWithholdingScenarioEnum valueOf(String name) => _$vendorVerificationDraftTaxProfileWithholdingScenarioEnumValueOf(name);
}

