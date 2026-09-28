//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/buyer_industry_classification.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'buyer_onboarding_update.g.dart';

/// BuyerOnboardingUpdate
///
/// Properties:
/// * [lockVersion]
/// * [action]
/// * [companyName]
/// * [positionTitle]
/// * [industryClassification]
/// * [industryOtherLabel]
/// * [preferredCategoryIds]
@BuiltValue()
abstract class BuyerOnboardingUpdate implements Built<BuyerOnboardingUpdate, BuyerOnboardingUpdateBuilder> {
  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  @BuiltValueField(wireName: r'action')
  BuyerOnboardingUpdateActionEnum get action;
  // enum actionEnum {  SAVE,  COMPLETE,  SKIP,  };

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
  BuiltList<String>? get preferredCategoryIds;

  BuyerOnboardingUpdate._();

  factory BuyerOnboardingUpdate([void updates(BuyerOnboardingUpdateBuilder b)]) = _$BuyerOnboardingUpdate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BuyerOnboardingUpdateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BuyerOnboardingUpdate> get serializer => _$BuyerOnboardingUpdateSerializer();
}

class _$BuyerOnboardingUpdateSerializer implements PrimitiveSerializer<BuyerOnboardingUpdate> {
  @override
  final Iterable<Type> types = const [BuyerOnboardingUpdate, _$BuyerOnboardingUpdate];

  @override
  final String wireName = r'BuyerOnboardingUpdate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BuyerOnboardingUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
    yield r'action';
    yield serializers.serialize(
      object.action,
      specifiedType: const FullType(BuyerOnboardingUpdateActionEnum),
    );
    if (object.companyName != null) {
      yield r'company_name';
      yield serializers.serialize(
        object.companyName,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.positionTitle != null) {
      yield r'position_title';
      yield serializers.serialize(
        object.positionTitle,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.industryClassification != null) {
      yield r'industry_classification';
      yield serializers.serialize(
        object.industryClassification,
        specifiedType: const FullType.nullable(BuyerIndustryClassification),
      );
    }
    if (object.industryOtherLabel != null) {
      yield r'industry_other_label';
      yield serializers.serialize(
        object.industryOtherLabel,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.preferredCategoryIds != null) {
      yield r'preferred_category_ids';
      yield serializers.serialize(
        object.preferredCategoryIds,
        specifiedType: const FullType(BuiltList, [FullType(String)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    BuyerOnboardingUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BuyerOnboardingUpdateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lockVersion = valueDes;
          break;
        case r'action':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuyerOnboardingUpdateActionEnum),
          ) as BuyerOnboardingUpdateActionEnum;
          result.action = valueDes;
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
            specifiedType: const FullType.nullable(BuiltList, [FullType(String)]),
          ) as BuiltList<String>?;
          if (valueDes == null) continue;
          result.preferredCategoryIds.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BuyerOnboardingUpdate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BuyerOnboardingUpdateBuilder();
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


class BuyerOnboardingUpdateActionEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'SAVE')
  static const BuyerOnboardingUpdateActionEnum SAVE = _$buyerOnboardingUpdateActionEnum_SAVE;
  @BuiltValueEnumConst(wireName: r'COMPLETE')
  static const BuyerOnboardingUpdateActionEnum COMPLETE = _$buyerOnboardingUpdateActionEnum_COMPLETE;
  @BuiltValueEnumConst(wireName: r'SKIP')
  static const BuyerOnboardingUpdateActionEnum SKIP = _$buyerOnboardingUpdateActionEnum_SKIP;

  static Serializer<BuyerOnboardingUpdateActionEnum> get serializer => _$buyerOnboardingUpdateActionEnumSerializer;

  const BuyerOnboardingUpdateActionEnum._(String name): super(name);

  static BuiltSet<BuyerOnboardingUpdateActionEnum> get values => _$buyerOnboardingUpdateActionEnumValues;
  static BuyerOnboardingUpdateActionEnum valueOf(String name) => _$buyerOnboardingUpdateActionEnumValueOf(name);
}

