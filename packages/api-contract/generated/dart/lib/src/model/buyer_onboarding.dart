//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/material_category_option.dart';
import 'package:materyalph_api_client/src/model/radius_km.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/buyer_industry_classification.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'buyer_onboarding.g.dart';

/// BuyerOnboarding
///
/// Properties:
/// * [status]
/// * [completedAt]
/// * [buyerType]
/// * [companyName]
/// * [positionTitle]
/// * [industryClassification]
/// * [industryOtherLabel]
/// * [preferredCategoryIds]
/// * [discoveryRadiusKm]
/// * [hasPrimaryLocation]
/// * [lockVersion]
/// * [categories]
/// * [industries]
@BuiltValue()
abstract class BuyerOnboarding implements Built<BuyerOnboarding, BuyerOnboardingBuilder> {
  @BuiltValueField(wireName: r'status')
  BuyerOnboardingStatusEnum get status;
  // enum statusEnum {  NOT_STARTED,  SKIPPED,  COMPLETED,  };

  @BuiltValueField(wireName: r'completed_at')
  DateTime? get completedAt;

  @BuiltValueField(wireName: r'buyer_type')
  String get buyerType;

  @BuiltValueField(wireName: r'company_name')
  String? get companyName;

  @BuiltValueField(wireName: r'position_title')
  String? get positionTitle;

  @BuiltValueField(wireName: r'industry_classification')
  BuyerIndustryClassification? get industryClassification;
  // enum industryClassificationEnum {  GENERAL_CONTRACTOR,  SUBCONTRACTOR_TRADE,  INDEPENDENT_BUILDER,  DIY_HOMEOWNER,  OTHER,  };

  @BuiltValueField(wireName: r'industry_other_label')
  String? get industryOtherLabel;

  @BuiltValueField(wireName: r'preferred_category_ids')
  BuiltList<String> get preferredCategoryIds;

  @BuiltValueField(wireName: r'discovery_radius_km')
  RadiusKm get discoveryRadiusKm;
  // enum discoveryRadiusKmEnum {  5,  10,  20,  30,  40,  50,  };

  @BuiltValueField(wireName: r'has_primary_location')
  bool get hasPrimaryLocation;

  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  @BuiltValueField(wireName: r'categories')
  BuiltList<MaterialCategoryOption> get categories;

  @BuiltValueField(wireName: r'industries')
  BuiltList<BuyerIndustryClassification> get industries;

  BuyerOnboarding._();

  factory BuyerOnboarding([void updates(BuyerOnboardingBuilder b)]) = _$BuyerOnboarding;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BuyerOnboardingBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BuyerOnboarding> get serializer => _$BuyerOnboardingSerializer();
}

class _$BuyerOnboardingSerializer implements PrimitiveSerializer<BuyerOnboarding> {
  @override
  final Iterable<Type> types = const [BuyerOnboarding, _$BuyerOnboarding];

  @override
  final String wireName = r'BuyerOnboarding';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BuyerOnboarding object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(BuyerOnboardingStatusEnum),
    );
    yield r'completed_at';
    yield object.completedAt == null ? null : serializers.serialize(
      object.completedAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'buyer_type';
    yield serializers.serialize(
      object.buyerType,
      specifiedType: const FullType(String),
    );
    yield r'company_name';
    yield object.companyName == null ? null : serializers.serialize(
      object.companyName,
      specifiedType: const FullType.nullable(String),
    );
    yield r'position_title';
    yield object.positionTitle == null ? null : serializers.serialize(
      object.positionTitle,
      specifiedType: const FullType.nullable(String),
    );
    yield r'industry_classification';
    yield object.industryClassification == null ? null : serializers.serialize(
      object.industryClassification,
      specifiedType: const FullType.nullable(BuyerIndustryClassification),
    );
    yield r'industry_other_label';
    yield object.industryOtherLabel == null ? null : serializers.serialize(
      object.industryOtherLabel,
      specifiedType: const FullType.nullable(String),
    );
    yield r'preferred_category_ids';
    yield serializers.serialize(
      object.preferredCategoryIds,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'discovery_radius_km';
    yield serializers.serialize(
      object.discoveryRadiusKm,
      specifiedType: const FullType(RadiusKm),
    );
    yield r'has_primary_location';
    yield serializers.serialize(
      object.hasPrimaryLocation,
      specifiedType: const FullType(bool),
    );
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
    yield r'categories';
    yield serializers.serialize(
      object.categories,
      specifiedType: const FullType(BuiltList, [FullType(MaterialCategoryOption)]),
    );
    yield r'industries';
    yield serializers.serialize(
      object.industries,
      specifiedType: const FullType(BuiltList, [FullType(BuyerIndustryClassification)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    BuyerOnboarding object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BuyerOnboardingBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuyerOnboardingStatusEnum),
          ) as BuyerOnboardingStatusEnum;
          result.status = valueDes;
          break;
        case r'completed_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.completedAt = valueDes;
          break;
        case r'buyer_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.buyerType = valueDes;
          break;
        case r'company_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.companyName = valueDes;
          break;
        case r'position_title':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.positionTitle = valueDes;
          break;
        case r'industry_classification':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuyerIndustryClassification),
          ) as BuyerIndustryClassification?;
          if (valueDes == null) continue;
          result.industryClassification = valueDes;
          break;
        case r'industry_other_label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.industryOtherLabel = valueDes;
          break;
        case r'preferred_category_ids':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.preferredCategoryIds.replace(valueDes);
          break;
        case r'discovery_radius_km':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(RadiusKm),
          ) as RadiusKm;
          result.discoveryRadiusKm = valueDes;
          break;
        case r'has_primary_location':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.hasPrimaryLocation = valueDes;
          break;
        case r'lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lockVersion = valueDes;
          break;
        case r'categories':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(MaterialCategoryOption)]),
          ) as BuiltList<MaterialCategoryOption>;
          result.categories.replace(valueDes);
          break;
        case r'industries':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(BuyerIndustryClassification)]),
          ) as BuiltList<BuyerIndustryClassification>;
          result.industries.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BuyerOnboarding deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BuyerOnboardingBuilder();
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


class BuyerOnboardingStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'NOT_STARTED')
  static const BuyerOnboardingStatusEnum NOT_STARTED = _$buyerOnboardingStatusEnum_NOT_STARTED;
  @BuiltValueEnumConst(wireName: r'SKIPPED')
  static const BuyerOnboardingStatusEnum SKIPPED = _$buyerOnboardingStatusEnum_SKIPPED;
  @BuiltValueEnumConst(wireName: r'COMPLETED')
  static const BuyerOnboardingStatusEnum COMPLETED = _$buyerOnboardingStatusEnum_COMPLETED;

  static Serializer<BuyerOnboardingStatusEnum> get serializer => _$buyerOnboardingStatusEnumSerializer;

  const BuyerOnboardingStatusEnum._(String name): super(name);

  static BuiltSet<BuyerOnboardingStatusEnum> get values => _$buyerOnboardingStatusEnumValues;
  static BuyerOnboardingStatusEnum valueOf(String name) => _$buyerOnboardingStatusEnumValueOf(name);
}

