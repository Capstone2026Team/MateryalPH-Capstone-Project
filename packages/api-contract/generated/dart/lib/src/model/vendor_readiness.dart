//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/vendor_checklist_item.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_readiness.g.dart';

/// VendorReadiness
///
/// Properties:
/// * [organizationId]
/// * [storeName]
/// * [onboardingStatus]
/// * [storeVerificationStatus]
/// * [storeSetupStatus]
/// * [activationStatus]
/// * [discoverabilityStatus]
/// * [marketplaceStatus]
/// * [lockVersion]
/// * [environment]
/// * [ruleVersion]
/// * [ready]
/// * [evaluatedAt]
/// * [checklist]
@BuiltValue()
abstract class VendorReadiness implements Built<VendorReadiness, VendorReadinessBuilder> {
  @BuiltValueField(wireName: r'organization_id')
  String get organizationId;

  @BuiltValueField(wireName: r'store_name')
  String? get storeName;

  @BuiltValueField(wireName: r'onboarding_status')
  VendorReadinessOnboardingStatusEnum get onboardingStatus;
  // enum onboardingStatusEnum {  NOT_STARTED,  IN_PROGRESS,  SUBMITTED,  PENDING_VERIFICATION,  APPROVED,  COMPLETED,  CHANGES_REQUIRED,  REJECTED,  EXPIRED,  NOT_APPLICABLE,  };

  @BuiltValueField(wireName: r'store_verification_status')
  VendorReadinessStoreVerificationStatusEnum get storeVerificationStatus;
  // enum storeVerificationStatusEnum {  NOT_STARTED,  IN_PROGRESS,  SUBMITTED,  PENDING_VERIFICATION,  APPROVED,  COMPLETED,  CHANGES_REQUIRED,  REJECTED,  EXPIRED,  NOT_APPLICABLE,  };

  @BuiltValueField(wireName: r'store_setup_status')
  VendorReadinessStoreSetupStatusEnum get storeSetupStatus;
  // enum storeSetupStatusEnum {  NOT_STARTED,  IN_PROGRESS,  SUBMITTED,  PENDING_VERIFICATION,  APPROVED,  COMPLETED,  CHANGES_REQUIRED,  REJECTED,  EXPIRED,  NOT_APPLICABLE,  };

  @BuiltValueField(wireName: r'activation_status')
  VendorReadinessActivationStatusEnum get activationStatus;
  // enum activationStatusEnum {  NOT_ACTIVE,  ACTIVE,  RESTRICTED,  SUSPENDED,  };

  @BuiltValueField(wireName: r'discoverability_status')
  VendorReadinessDiscoverabilityStatusEnum get discoverabilityStatus;
  // enum discoverabilityStatusEnum {  NOT_DISCOVERABLE,  NO_ACTIVE_LISTINGS,  DISCOVERABLE,  RESTRICTED,  };

  @BuiltValueField(wireName: r'marketplace_status')
  String get marketplaceStatus;

  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  @BuiltValueField(wireName: r'environment')
  VendorReadinessEnvironmentEnum get environment;
  // enum environmentEnum {  TEST,  };

  @BuiltValueField(wireName: r'rule_version')
  String get ruleVersion;

  @BuiltValueField(wireName: r'ready')
  bool get ready;

  @BuiltValueField(wireName: r'evaluated_at')
  String get evaluatedAt;

  @BuiltValueField(wireName: r'checklist')
  BuiltList<VendorChecklistItem> get checklist;

  VendorReadiness._();

  factory VendorReadiness([void updates(VendorReadinessBuilder b)]) = _$VendorReadiness;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorReadinessBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorReadiness> get serializer => _$VendorReadinessSerializer();
}

class _$VendorReadinessSerializer implements PrimitiveSerializer<VendorReadiness> {
  @override
  final Iterable<Type> types = const [VendorReadiness, _$VendorReadiness];

  @override
  final String wireName = r'VendorReadiness';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorReadiness object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'organization_id';
    yield serializers.serialize(
      object.organizationId,
      specifiedType: const FullType(String),
    );
    yield r'store_name';
    yield object.storeName == null ? null : serializers.serialize(
      object.storeName,
      specifiedType: const FullType.nullable(String),
    );
    yield r'onboarding_status';
    yield serializers.serialize(
      object.onboardingStatus,
      specifiedType: const FullType(VendorReadinessOnboardingStatusEnum),
    );
    yield r'store_verification_status';
    yield serializers.serialize(
      object.storeVerificationStatus,
      specifiedType: const FullType(VendorReadinessStoreVerificationStatusEnum),
    );
    yield r'store_setup_status';
    yield serializers.serialize(
      object.storeSetupStatus,
      specifiedType: const FullType(VendorReadinessStoreSetupStatusEnum),
    );
    yield r'activation_status';
    yield serializers.serialize(
      object.activationStatus,
      specifiedType: const FullType(VendorReadinessActivationStatusEnum),
    );
    yield r'discoverability_status';
    yield serializers.serialize(
      object.discoverabilityStatus,
      specifiedType: const FullType(VendorReadinessDiscoverabilityStatusEnum),
    );
    yield r'marketplace_status';
    yield serializers.serialize(
      object.marketplaceStatus,
      specifiedType: const FullType(String),
    );
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
    yield r'environment';
    yield serializers.serialize(
      object.environment,
      specifiedType: const FullType(VendorReadinessEnvironmentEnum),
    );
    yield r'rule_version';
    yield serializers.serialize(
      object.ruleVersion,
      specifiedType: const FullType(String),
    );
    yield r'ready';
    yield serializers.serialize(
      object.ready,
      specifiedType: const FullType(bool),
    );
    yield r'evaluated_at';
    yield serializers.serialize(
      object.evaluatedAt,
      specifiedType: const FullType(String),
    );
    yield r'checklist';
    yield serializers.serialize(
      object.checklist,
      specifiedType: const FullType(BuiltList, [FullType(VendorChecklistItem)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorReadiness object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorReadinessBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'organization_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.organizationId = valueDes;
          break;
        case r'store_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.storeName = valueDes;
          break;
        case r'onboarding_status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorReadinessOnboardingStatusEnum),
          ) as VendorReadinessOnboardingStatusEnum;
          result.onboardingStatus = valueDes;
          break;
        case r'store_verification_status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorReadinessStoreVerificationStatusEnum),
          ) as VendorReadinessStoreVerificationStatusEnum;
          result.storeVerificationStatus = valueDes;
          break;
        case r'store_setup_status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorReadinessStoreSetupStatusEnum),
          ) as VendorReadinessStoreSetupStatusEnum;
          result.storeSetupStatus = valueDes;
          break;
        case r'activation_status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorReadinessActivationStatusEnum),
          ) as VendorReadinessActivationStatusEnum;
          result.activationStatus = valueDes;
          break;
        case r'discoverability_status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorReadinessDiscoverabilityStatusEnum),
          ) as VendorReadinessDiscoverabilityStatusEnum;
          result.discoverabilityStatus = valueDes;
          break;
        case r'marketplace_status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.marketplaceStatus = valueDes;
          break;
        case r'lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lockVersion = valueDes;
          break;
        case r'environment':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorReadinessEnvironmentEnum),
          ) as VendorReadinessEnvironmentEnum;
          result.environment = valueDes;
          break;
        case r'rule_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.ruleVersion = valueDes;
          break;
        case r'ready':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.ready = valueDes;
          break;
        case r'evaluated_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.evaluatedAt = valueDes;
          break;
        case r'checklist':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(VendorChecklistItem)]),
          ) as BuiltList<VendorChecklistItem>;
          result.checklist.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorReadiness deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorReadinessBuilder();
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


class VendorReadinessOnboardingStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'NOT_STARTED')
  static const VendorReadinessOnboardingStatusEnum NOT_STARTED = _$vendorReadinessOnboardingStatusEnum_NOT_STARTED;
  @BuiltValueEnumConst(wireName: r'IN_PROGRESS')
  static const VendorReadinessOnboardingStatusEnum IN_PROGRESS = _$vendorReadinessOnboardingStatusEnum_IN_PROGRESS;
  @BuiltValueEnumConst(wireName: r'SUBMITTED')
  static const VendorReadinessOnboardingStatusEnum SUBMITTED = _$vendorReadinessOnboardingStatusEnum_SUBMITTED;
  @BuiltValueEnumConst(wireName: r'PENDING_VERIFICATION')
  static const VendorReadinessOnboardingStatusEnum PENDING_VERIFICATION = _$vendorReadinessOnboardingStatusEnum_PENDING_VERIFICATION;
  @BuiltValueEnumConst(wireName: r'APPROVED')
  static const VendorReadinessOnboardingStatusEnum APPROVED = _$vendorReadinessOnboardingStatusEnum_APPROVED;
  @BuiltValueEnumConst(wireName: r'COMPLETED')
  static const VendorReadinessOnboardingStatusEnum COMPLETED = _$vendorReadinessOnboardingStatusEnum_COMPLETED;
  @BuiltValueEnumConst(wireName: r'CHANGES_REQUIRED')
  static const VendorReadinessOnboardingStatusEnum CHANGES_REQUIRED = _$vendorReadinessOnboardingStatusEnum_CHANGES_REQUIRED;
  @BuiltValueEnumConst(wireName: r'REJECTED')
  static const VendorReadinessOnboardingStatusEnum REJECTED = _$vendorReadinessOnboardingStatusEnum_REJECTED;
  @BuiltValueEnumConst(wireName: r'EXPIRED')
  static const VendorReadinessOnboardingStatusEnum EXPIRED = _$vendorReadinessOnboardingStatusEnum_EXPIRED;
  @BuiltValueEnumConst(wireName: r'NOT_APPLICABLE')
  static const VendorReadinessOnboardingStatusEnum NOT_APPLICABLE = _$vendorReadinessOnboardingStatusEnum_NOT_APPLICABLE;

  static Serializer<VendorReadinessOnboardingStatusEnum> get serializer => _$vendorReadinessOnboardingStatusEnumSerializer;

  const VendorReadinessOnboardingStatusEnum._(String name): super(name);

  static BuiltSet<VendorReadinessOnboardingStatusEnum> get values => _$vendorReadinessOnboardingStatusEnumValues;
  static VendorReadinessOnboardingStatusEnum valueOf(String name) => _$vendorReadinessOnboardingStatusEnumValueOf(name);
}

class VendorReadinessStoreVerificationStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'NOT_STARTED')
  static const VendorReadinessStoreVerificationStatusEnum NOT_STARTED = _$vendorReadinessStoreVerificationStatusEnum_NOT_STARTED;
  @BuiltValueEnumConst(wireName: r'IN_PROGRESS')
  static const VendorReadinessStoreVerificationStatusEnum IN_PROGRESS = _$vendorReadinessStoreVerificationStatusEnum_IN_PROGRESS;
  @BuiltValueEnumConst(wireName: r'SUBMITTED')
  static const VendorReadinessStoreVerificationStatusEnum SUBMITTED = _$vendorReadinessStoreVerificationStatusEnum_SUBMITTED;
  @BuiltValueEnumConst(wireName: r'PENDING_VERIFICATION')
  static const VendorReadinessStoreVerificationStatusEnum PENDING_VERIFICATION = _$vendorReadinessStoreVerificationStatusEnum_PENDING_VERIFICATION;
  @BuiltValueEnumConst(wireName: r'APPROVED')
  static const VendorReadinessStoreVerificationStatusEnum APPROVED = _$vendorReadinessStoreVerificationStatusEnum_APPROVED;
  @BuiltValueEnumConst(wireName: r'COMPLETED')
  static const VendorReadinessStoreVerificationStatusEnum COMPLETED = _$vendorReadinessStoreVerificationStatusEnum_COMPLETED;
  @BuiltValueEnumConst(wireName: r'CHANGES_REQUIRED')
  static const VendorReadinessStoreVerificationStatusEnum CHANGES_REQUIRED = _$vendorReadinessStoreVerificationStatusEnum_CHANGES_REQUIRED;
  @BuiltValueEnumConst(wireName: r'REJECTED')
  static const VendorReadinessStoreVerificationStatusEnum REJECTED = _$vendorReadinessStoreVerificationStatusEnum_REJECTED;
  @BuiltValueEnumConst(wireName: r'EXPIRED')
  static const VendorReadinessStoreVerificationStatusEnum EXPIRED = _$vendorReadinessStoreVerificationStatusEnum_EXPIRED;
  @BuiltValueEnumConst(wireName: r'NOT_APPLICABLE')
  static const VendorReadinessStoreVerificationStatusEnum NOT_APPLICABLE = _$vendorReadinessStoreVerificationStatusEnum_NOT_APPLICABLE;

  static Serializer<VendorReadinessStoreVerificationStatusEnum> get serializer => _$vendorReadinessStoreVerificationStatusEnumSerializer;

  const VendorReadinessStoreVerificationStatusEnum._(String name): super(name);

  static BuiltSet<VendorReadinessStoreVerificationStatusEnum> get values => _$vendorReadinessStoreVerificationStatusEnumValues;
  static VendorReadinessStoreVerificationStatusEnum valueOf(String name) => _$vendorReadinessStoreVerificationStatusEnumValueOf(name);
}

class VendorReadinessStoreSetupStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'NOT_STARTED')
  static const VendorReadinessStoreSetupStatusEnum NOT_STARTED = _$vendorReadinessStoreSetupStatusEnum_NOT_STARTED;
  @BuiltValueEnumConst(wireName: r'IN_PROGRESS')
  static const VendorReadinessStoreSetupStatusEnum IN_PROGRESS = _$vendorReadinessStoreSetupStatusEnum_IN_PROGRESS;
  @BuiltValueEnumConst(wireName: r'SUBMITTED')
  static const VendorReadinessStoreSetupStatusEnum SUBMITTED = _$vendorReadinessStoreSetupStatusEnum_SUBMITTED;
  @BuiltValueEnumConst(wireName: r'PENDING_VERIFICATION')
  static const VendorReadinessStoreSetupStatusEnum PENDING_VERIFICATION = _$vendorReadinessStoreSetupStatusEnum_PENDING_VERIFICATION;
  @BuiltValueEnumConst(wireName: r'APPROVED')
  static const VendorReadinessStoreSetupStatusEnum APPROVED = _$vendorReadinessStoreSetupStatusEnum_APPROVED;
  @BuiltValueEnumConst(wireName: r'COMPLETED')
  static const VendorReadinessStoreSetupStatusEnum COMPLETED = _$vendorReadinessStoreSetupStatusEnum_COMPLETED;
  @BuiltValueEnumConst(wireName: r'CHANGES_REQUIRED')
  static const VendorReadinessStoreSetupStatusEnum CHANGES_REQUIRED = _$vendorReadinessStoreSetupStatusEnum_CHANGES_REQUIRED;
  @BuiltValueEnumConst(wireName: r'REJECTED')
  static const VendorReadinessStoreSetupStatusEnum REJECTED = _$vendorReadinessStoreSetupStatusEnum_REJECTED;
  @BuiltValueEnumConst(wireName: r'EXPIRED')
  static const VendorReadinessStoreSetupStatusEnum EXPIRED = _$vendorReadinessStoreSetupStatusEnum_EXPIRED;
  @BuiltValueEnumConst(wireName: r'NOT_APPLICABLE')
  static const VendorReadinessStoreSetupStatusEnum NOT_APPLICABLE = _$vendorReadinessStoreSetupStatusEnum_NOT_APPLICABLE;

  static Serializer<VendorReadinessStoreSetupStatusEnum> get serializer => _$vendorReadinessStoreSetupStatusEnumSerializer;

  const VendorReadinessStoreSetupStatusEnum._(String name): super(name);

  static BuiltSet<VendorReadinessStoreSetupStatusEnum> get values => _$vendorReadinessStoreSetupStatusEnumValues;
  static VendorReadinessStoreSetupStatusEnum valueOf(String name) => _$vendorReadinessStoreSetupStatusEnumValueOf(name);
}

class VendorReadinessActivationStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'NOT_ACTIVE')
  static const VendorReadinessActivationStatusEnum NOT_ACTIVE = _$vendorReadinessActivationStatusEnum_NOT_ACTIVE;
  @BuiltValueEnumConst(wireName: r'ACTIVE')
  static const VendorReadinessActivationStatusEnum ACTIVE = _$vendorReadinessActivationStatusEnum_ACTIVE;
  @BuiltValueEnumConst(wireName: r'RESTRICTED')
  static const VendorReadinessActivationStatusEnum RESTRICTED = _$vendorReadinessActivationStatusEnum_RESTRICTED;
  @BuiltValueEnumConst(wireName: r'SUSPENDED')
  static const VendorReadinessActivationStatusEnum SUSPENDED = _$vendorReadinessActivationStatusEnum_SUSPENDED;

  static Serializer<VendorReadinessActivationStatusEnum> get serializer => _$vendorReadinessActivationStatusEnumSerializer;

  const VendorReadinessActivationStatusEnum._(String name): super(name);

  static BuiltSet<VendorReadinessActivationStatusEnum> get values => _$vendorReadinessActivationStatusEnumValues;
  static VendorReadinessActivationStatusEnum valueOf(String name) => _$vendorReadinessActivationStatusEnumValueOf(name);
}

class VendorReadinessDiscoverabilityStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'NOT_DISCOVERABLE')
  static const VendorReadinessDiscoverabilityStatusEnum NOT_DISCOVERABLE = _$vendorReadinessDiscoverabilityStatusEnum_NOT_DISCOVERABLE;
  @BuiltValueEnumConst(wireName: r'NO_ACTIVE_LISTINGS')
  static const VendorReadinessDiscoverabilityStatusEnum NO_ACTIVE_LISTINGS = _$vendorReadinessDiscoverabilityStatusEnum_NO_ACTIVE_LISTINGS;
  @BuiltValueEnumConst(wireName: r'DISCOVERABLE')
  static const VendorReadinessDiscoverabilityStatusEnum DISCOVERABLE = _$vendorReadinessDiscoverabilityStatusEnum_DISCOVERABLE;
  @BuiltValueEnumConst(wireName: r'RESTRICTED')
  static const VendorReadinessDiscoverabilityStatusEnum RESTRICTED = _$vendorReadinessDiscoverabilityStatusEnum_RESTRICTED;

  static Serializer<VendorReadinessDiscoverabilityStatusEnum> get serializer => _$vendorReadinessDiscoverabilityStatusEnumSerializer;

  const VendorReadinessDiscoverabilityStatusEnum._(String name): super(name);

  static BuiltSet<VendorReadinessDiscoverabilityStatusEnum> get values => _$vendorReadinessDiscoverabilityStatusEnumValues;
  static VendorReadinessDiscoverabilityStatusEnum valueOf(String name) => _$vendorReadinessDiscoverabilityStatusEnumValueOf(name);
}

class VendorReadinessEnvironmentEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'TEST')
  static const VendorReadinessEnvironmentEnum TEST = _$vendorReadinessEnvironmentEnum_TEST;

  static Serializer<VendorReadinessEnvironmentEnum> get serializer => _$vendorReadinessEnvironmentEnumSerializer;

  const VendorReadinessEnvironmentEnum._(String name): super(name);

  static BuiltSet<VendorReadinessEnvironmentEnum> get values => _$vendorReadinessEnvironmentEnumValues;
  static VendorReadinessEnvironmentEnum valueOf(String name) => _$vendorReadinessEnvironmentEnumValueOf(name);
}

