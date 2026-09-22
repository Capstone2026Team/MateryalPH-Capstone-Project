//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'onboarding_requirement.g.dart';

/// OnboardingRequirement
///
/// Properties:
/// * [key]
/// * [workstream]
/// * [level]
/// * [status]
/// * [blocking]
/// * [blockingReason]
/// * [applicabilityReason] - Required nonempty reason for an inapplicable conditional requirement. Never used for REQUIRED items.
/// * [correctionReason]
/// * [lockVersion]
@BuiltValue()
abstract class OnboardingRequirement implements Built<OnboardingRequirement, OnboardingRequirementBuilder> {
  @BuiltValueField(wireName: r'key')
  String get key;

  @BuiltValueField(wireName: r'workstream')
  OnboardingRequirementWorkstreamEnum get workstream;
  // enum workstreamEnum {  STORE_VERIFICATION,  STORE_SETUP,  };

  @BuiltValueField(wireName: r'level')
  OnboardingRequirementLevelEnum get level;
  // enum levelEnum {  REQUIRED,  OPTIONAL,  CONDITIONALLY_REQUIRED,  };

  @BuiltValueField(wireName: r'status')
  OnboardingRequirementStatusEnum get status;
  // enum statusEnum {  NOT_STARTED,  IN_PROGRESS,  SUBMITTED,  PENDING_VERIFICATION,  APPROVED,  COMPLETED,  CHANGES_REQUIRED,  REJECTED,  EXPIRED,  NOT_APPLICABLE,  };

  @BuiltValueField(wireName: r'blocking')
  bool get blocking;

  @BuiltValueField(wireName: r'blocking_reason')
  String? get blockingReason;

  /// Required nonempty reason for an inapplicable conditional requirement. Never used for REQUIRED items.
  @BuiltValueField(wireName: r'applicability_reason')
  String? get applicabilityReason;

  @BuiltValueField(wireName: r'correction_reason')
  String? get correctionReason;

  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  OnboardingRequirement._();

  factory OnboardingRequirement([void updates(OnboardingRequirementBuilder b)]) = _$OnboardingRequirement;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OnboardingRequirementBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OnboardingRequirement> get serializer => _$OnboardingRequirementSerializer();
}

class _$OnboardingRequirementSerializer implements PrimitiveSerializer<OnboardingRequirement> {
  @override
  final Iterable<Type> types = const [OnboardingRequirement, _$OnboardingRequirement];

  @override
  final String wireName = r'OnboardingRequirement';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OnboardingRequirement object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'key';
    yield serializers.serialize(
      object.key,
      specifiedType: const FullType(String),
    );
    yield r'workstream';
    yield serializers.serialize(
      object.workstream,
      specifiedType: const FullType(OnboardingRequirementWorkstreamEnum),
    );
    yield r'level';
    yield serializers.serialize(
      object.level,
      specifiedType: const FullType(OnboardingRequirementLevelEnum),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(OnboardingRequirementStatusEnum),
    );
    yield r'blocking';
    yield serializers.serialize(
      object.blocking,
      specifiedType: const FullType(bool),
    );
    yield r'blocking_reason';
    yield object.blockingReason == null ? null : serializers.serialize(
      object.blockingReason,
      specifiedType: const FullType.nullable(String),
    );
    yield r'applicability_reason';
    yield object.applicabilityReason == null ? null : serializers.serialize(
      object.applicabilityReason,
      specifiedType: const FullType.nullable(String),
    );
    yield r'correction_reason';
    yield object.correctionReason == null ? null : serializers.serialize(
      object.correctionReason,
      specifiedType: const FullType.nullable(String),
    );
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    OnboardingRequirement object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OnboardingRequirementBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'key':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.key = valueDes;
          break;
        case r'workstream':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(OnboardingRequirementWorkstreamEnum),
          ) as OnboardingRequirementWorkstreamEnum;
          result.workstream = valueDes;
          break;
        case r'level':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(OnboardingRequirementLevelEnum),
          ) as OnboardingRequirementLevelEnum;
          result.level = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(OnboardingRequirementStatusEnum),
          ) as OnboardingRequirementStatusEnum;
          result.status = valueDes;
          break;
        case r'blocking':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.blocking = valueDes;
          break;
        case r'blocking_reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.blockingReason = valueDes;
          break;
        case r'applicability_reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.applicabilityReason = valueDes;
          break;
        case r'correction_reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.correctionReason = valueDes;
          break;
        case r'lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lockVersion = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  OnboardingRequirement deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OnboardingRequirementBuilder();
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


class OnboardingRequirementWorkstreamEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'STORE_VERIFICATION')
  static const OnboardingRequirementWorkstreamEnum STORE_VERIFICATION = _$onboardingRequirementWorkstreamEnum_STORE_VERIFICATION;
  @BuiltValueEnumConst(wireName: r'STORE_SETUP')
  static const OnboardingRequirementWorkstreamEnum STORE_SETUP = _$onboardingRequirementWorkstreamEnum_STORE_SETUP;

  static Serializer<OnboardingRequirementWorkstreamEnum> get serializer => _$onboardingRequirementWorkstreamEnumSerializer;

  const OnboardingRequirementWorkstreamEnum._(String name): super(name);

  static BuiltSet<OnboardingRequirementWorkstreamEnum> get values => _$onboardingRequirementWorkstreamEnumValues;
  static OnboardingRequirementWorkstreamEnum valueOf(String name) => _$onboardingRequirementWorkstreamEnumValueOf(name);
}

class OnboardingRequirementLevelEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'REQUIRED')
  static const OnboardingRequirementLevelEnum REQUIRED = _$onboardingRequirementLevelEnum_REQUIRED;
  @BuiltValueEnumConst(wireName: r'OPTIONAL')
  static const OnboardingRequirementLevelEnum OPTIONAL = _$onboardingRequirementLevelEnum_OPTIONAL;
  @BuiltValueEnumConst(wireName: r'CONDITIONALLY_REQUIRED')
  static const OnboardingRequirementLevelEnum CONDITIONALLY_REQUIRED = _$onboardingRequirementLevelEnum_CONDITIONALLY_REQUIRED;

  static Serializer<OnboardingRequirementLevelEnum> get serializer => _$onboardingRequirementLevelEnumSerializer;

  const OnboardingRequirementLevelEnum._(String name): super(name);

  static BuiltSet<OnboardingRequirementLevelEnum> get values => _$onboardingRequirementLevelEnumValues;
  static OnboardingRequirementLevelEnum valueOf(String name) => _$onboardingRequirementLevelEnumValueOf(name);
}

class OnboardingRequirementStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'NOT_STARTED')
  static const OnboardingRequirementStatusEnum NOT_STARTED = _$onboardingRequirementStatusEnum_NOT_STARTED;
  @BuiltValueEnumConst(wireName: r'IN_PROGRESS')
  static const OnboardingRequirementStatusEnum IN_PROGRESS = _$onboardingRequirementStatusEnum_IN_PROGRESS;
  @BuiltValueEnumConst(wireName: r'SUBMITTED')
  static const OnboardingRequirementStatusEnum SUBMITTED = _$onboardingRequirementStatusEnum_SUBMITTED;
  @BuiltValueEnumConst(wireName: r'PENDING_VERIFICATION')
  static const OnboardingRequirementStatusEnum PENDING_VERIFICATION = _$onboardingRequirementStatusEnum_PENDING_VERIFICATION;
  @BuiltValueEnumConst(wireName: r'APPROVED')
  static const OnboardingRequirementStatusEnum APPROVED = _$onboardingRequirementStatusEnum_APPROVED;
  @BuiltValueEnumConst(wireName: r'COMPLETED')
  static const OnboardingRequirementStatusEnum COMPLETED = _$onboardingRequirementStatusEnum_COMPLETED;
  @BuiltValueEnumConst(wireName: r'CHANGES_REQUIRED')
  static const OnboardingRequirementStatusEnum CHANGES_REQUIRED = _$onboardingRequirementStatusEnum_CHANGES_REQUIRED;
  @BuiltValueEnumConst(wireName: r'REJECTED')
  static const OnboardingRequirementStatusEnum REJECTED = _$onboardingRequirementStatusEnum_REJECTED;
  @BuiltValueEnumConst(wireName: r'EXPIRED')
  static const OnboardingRequirementStatusEnum EXPIRED = _$onboardingRequirementStatusEnum_EXPIRED;
  @BuiltValueEnumConst(wireName: r'NOT_APPLICABLE')
  static const OnboardingRequirementStatusEnum NOT_APPLICABLE = _$onboardingRequirementStatusEnum_NOT_APPLICABLE;

  static Serializer<OnboardingRequirementStatusEnum> get serializer => _$onboardingRequirementStatusEnumSerializer;

  const OnboardingRequirementStatusEnum._(String name): super(name);

  static BuiltSet<OnboardingRequirementStatusEnum> get values => _$onboardingRequirementStatusEnumValues;
  static OnboardingRequirementStatusEnum valueOf(String name) => _$onboardingRequirementStatusEnumValueOf(name);
}

