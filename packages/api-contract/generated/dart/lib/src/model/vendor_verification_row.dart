//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_verification_row.g.dart';

/// VendorVerificationRow
///
/// Properties:
/// * [id]
/// * [storeName]
/// * [onboardingStatus]
/// * [storeVerificationStatus]
/// * [storeSetupStatus]
/// * [activationStatus]
/// * [discoverabilityStatus]
/// * [marketplaceStatus]
/// * [lockVersion]
/// * [submittedAt]
@BuiltValue()
abstract class VendorVerificationRow implements Built<VendorVerificationRow, VendorVerificationRowBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'store_name')
  String get storeName;

  @BuiltValueField(wireName: r'onboarding_status')
  VendorVerificationRowOnboardingStatusEnum get onboardingStatus;
  // enum onboardingStatusEnum {  NOT_STARTED,  IN_PROGRESS,  SUBMITTED,  PENDING_VERIFICATION,  APPROVED,  COMPLETED,  CHANGES_REQUIRED,  REJECTED,  EXPIRED,  NOT_APPLICABLE,  };

  @BuiltValueField(wireName: r'store_verification_status')
  VendorVerificationRowStoreVerificationStatusEnum get storeVerificationStatus;
  // enum storeVerificationStatusEnum {  NOT_STARTED,  IN_PROGRESS,  SUBMITTED,  PENDING_VERIFICATION,  APPROVED,  COMPLETED,  CHANGES_REQUIRED,  REJECTED,  EXPIRED,  NOT_APPLICABLE,  };

  @BuiltValueField(wireName: r'store_setup_status')
  VendorVerificationRowStoreSetupStatusEnum get storeSetupStatus;
  // enum storeSetupStatusEnum {  NOT_STARTED,  IN_PROGRESS,  SUBMITTED,  PENDING_VERIFICATION,  APPROVED,  COMPLETED,  CHANGES_REQUIRED,  REJECTED,  EXPIRED,  NOT_APPLICABLE,  };

  @BuiltValueField(wireName: r'activation_status')
  String get activationStatus;

  @BuiltValueField(wireName: r'discoverability_status')
  String get discoverabilityStatus;

  @BuiltValueField(wireName: r'marketplace_status')
  String get marketplaceStatus;

  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  @BuiltValueField(wireName: r'submitted_at')
  String get submittedAt;

  VendorVerificationRow._();

  factory VendorVerificationRow([void updates(VendorVerificationRowBuilder b)]) = _$VendorVerificationRow;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorVerificationRowBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorVerificationRow> get serializer => _$VendorVerificationRowSerializer();
}

class _$VendorVerificationRowSerializer implements PrimitiveSerializer<VendorVerificationRow> {
  @override
  final Iterable<Type> types = const [VendorVerificationRow, _$VendorVerificationRow];

  @override
  final String wireName = r'VendorVerificationRow';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorVerificationRow object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'store_name';
    yield serializers.serialize(
      object.storeName,
      specifiedType: const FullType(String),
    );
    yield r'onboarding_status';
    yield serializers.serialize(
      object.onboardingStatus,
      specifiedType: const FullType(VendorVerificationRowOnboardingStatusEnum),
    );
    yield r'store_verification_status';
    yield serializers.serialize(
      object.storeVerificationStatus,
      specifiedType: const FullType(VendorVerificationRowStoreVerificationStatusEnum),
    );
    yield r'store_setup_status';
    yield serializers.serialize(
      object.storeSetupStatus,
      specifiedType: const FullType(VendorVerificationRowStoreSetupStatusEnum),
    );
    yield r'activation_status';
    yield serializers.serialize(
      object.activationStatus,
      specifiedType: const FullType(String),
    );
    yield r'discoverability_status';
    yield serializers.serialize(
      object.discoverabilityStatus,
      specifiedType: const FullType(String),
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
    yield r'submitted_at';
    yield serializers.serialize(
      object.submittedAt,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorVerificationRow object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorVerificationRowBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'store_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.storeName = valueDes;
          break;
        case r'onboarding_status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorVerificationRowOnboardingStatusEnum),
          ) as VendorVerificationRowOnboardingStatusEnum;
          result.onboardingStatus = valueDes;
          break;
        case r'store_verification_status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorVerificationRowStoreVerificationStatusEnum),
          ) as VendorVerificationRowStoreVerificationStatusEnum;
          result.storeVerificationStatus = valueDes;
          break;
        case r'store_setup_status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorVerificationRowStoreSetupStatusEnum),
          ) as VendorVerificationRowStoreSetupStatusEnum;
          result.storeSetupStatus = valueDes;
          break;
        case r'activation_status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.activationStatus = valueDes;
          break;
        case r'discoverability_status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
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
        case r'submitted_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.submittedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorVerificationRow deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorVerificationRowBuilder();
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


class VendorVerificationRowOnboardingStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'NOT_STARTED')
  static const VendorVerificationRowOnboardingStatusEnum NOT_STARTED = _$vendorVerificationRowOnboardingStatusEnum_NOT_STARTED;
  @BuiltValueEnumConst(wireName: r'IN_PROGRESS')
  static const VendorVerificationRowOnboardingStatusEnum IN_PROGRESS = _$vendorVerificationRowOnboardingStatusEnum_IN_PROGRESS;
  @BuiltValueEnumConst(wireName: r'SUBMITTED')
  static const VendorVerificationRowOnboardingStatusEnum SUBMITTED = _$vendorVerificationRowOnboardingStatusEnum_SUBMITTED;
  @BuiltValueEnumConst(wireName: r'PENDING_VERIFICATION')
  static const VendorVerificationRowOnboardingStatusEnum PENDING_VERIFICATION = _$vendorVerificationRowOnboardingStatusEnum_PENDING_VERIFICATION;
  @BuiltValueEnumConst(wireName: r'APPROVED')
  static const VendorVerificationRowOnboardingStatusEnum APPROVED = _$vendorVerificationRowOnboardingStatusEnum_APPROVED;
  @BuiltValueEnumConst(wireName: r'COMPLETED')
  static const VendorVerificationRowOnboardingStatusEnum COMPLETED = _$vendorVerificationRowOnboardingStatusEnum_COMPLETED;
  @BuiltValueEnumConst(wireName: r'CHANGES_REQUIRED')
  static const VendorVerificationRowOnboardingStatusEnum CHANGES_REQUIRED = _$vendorVerificationRowOnboardingStatusEnum_CHANGES_REQUIRED;
  @BuiltValueEnumConst(wireName: r'REJECTED')
  static const VendorVerificationRowOnboardingStatusEnum REJECTED = _$vendorVerificationRowOnboardingStatusEnum_REJECTED;
  @BuiltValueEnumConst(wireName: r'EXPIRED')
  static const VendorVerificationRowOnboardingStatusEnum EXPIRED = _$vendorVerificationRowOnboardingStatusEnum_EXPIRED;
  @BuiltValueEnumConst(wireName: r'NOT_APPLICABLE')
  static const VendorVerificationRowOnboardingStatusEnum NOT_APPLICABLE = _$vendorVerificationRowOnboardingStatusEnum_NOT_APPLICABLE;

  static Serializer<VendorVerificationRowOnboardingStatusEnum> get serializer => _$vendorVerificationRowOnboardingStatusEnumSerializer;

  const VendorVerificationRowOnboardingStatusEnum._(String name): super(name);

  static BuiltSet<VendorVerificationRowOnboardingStatusEnum> get values => _$vendorVerificationRowOnboardingStatusEnumValues;
  static VendorVerificationRowOnboardingStatusEnum valueOf(String name) => _$vendorVerificationRowOnboardingStatusEnumValueOf(name);
}

class VendorVerificationRowStoreVerificationStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'NOT_STARTED')
  static const VendorVerificationRowStoreVerificationStatusEnum NOT_STARTED = _$vendorVerificationRowStoreVerificationStatusEnum_NOT_STARTED;
  @BuiltValueEnumConst(wireName: r'IN_PROGRESS')
  static const VendorVerificationRowStoreVerificationStatusEnum IN_PROGRESS = _$vendorVerificationRowStoreVerificationStatusEnum_IN_PROGRESS;
  @BuiltValueEnumConst(wireName: r'SUBMITTED')
  static const VendorVerificationRowStoreVerificationStatusEnum SUBMITTED = _$vendorVerificationRowStoreVerificationStatusEnum_SUBMITTED;
  @BuiltValueEnumConst(wireName: r'PENDING_VERIFICATION')
  static const VendorVerificationRowStoreVerificationStatusEnum PENDING_VERIFICATION = _$vendorVerificationRowStoreVerificationStatusEnum_PENDING_VERIFICATION;
  @BuiltValueEnumConst(wireName: r'APPROVED')
  static const VendorVerificationRowStoreVerificationStatusEnum APPROVED = _$vendorVerificationRowStoreVerificationStatusEnum_APPROVED;
  @BuiltValueEnumConst(wireName: r'COMPLETED')
  static const VendorVerificationRowStoreVerificationStatusEnum COMPLETED = _$vendorVerificationRowStoreVerificationStatusEnum_COMPLETED;
  @BuiltValueEnumConst(wireName: r'CHANGES_REQUIRED')
  static const VendorVerificationRowStoreVerificationStatusEnum CHANGES_REQUIRED = _$vendorVerificationRowStoreVerificationStatusEnum_CHANGES_REQUIRED;
  @BuiltValueEnumConst(wireName: r'REJECTED')
  static const VendorVerificationRowStoreVerificationStatusEnum REJECTED = _$vendorVerificationRowStoreVerificationStatusEnum_REJECTED;
  @BuiltValueEnumConst(wireName: r'EXPIRED')
  static const VendorVerificationRowStoreVerificationStatusEnum EXPIRED = _$vendorVerificationRowStoreVerificationStatusEnum_EXPIRED;
  @BuiltValueEnumConst(wireName: r'NOT_APPLICABLE')
  static const VendorVerificationRowStoreVerificationStatusEnum NOT_APPLICABLE = _$vendorVerificationRowStoreVerificationStatusEnum_NOT_APPLICABLE;

  static Serializer<VendorVerificationRowStoreVerificationStatusEnum> get serializer => _$vendorVerificationRowStoreVerificationStatusEnumSerializer;

  const VendorVerificationRowStoreVerificationStatusEnum._(String name): super(name);

  static BuiltSet<VendorVerificationRowStoreVerificationStatusEnum> get values => _$vendorVerificationRowStoreVerificationStatusEnumValues;
  static VendorVerificationRowStoreVerificationStatusEnum valueOf(String name) => _$vendorVerificationRowStoreVerificationStatusEnumValueOf(name);
}

class VendorVerificationRowStoreSetupStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'NOT_STARTED')
  static const VendorVerificationRowStoreSetupStatusEnum NOT_STARTED = _$vendorVerificationRowStoreSetupStatusEnum_NOT_STARTED;
  @BuiltValueEnumConst(wireName: r'IN_PROGRESS')
  static const VendorVerificationRowStoreSetupStatusEnum IN_PROGRESS = _$vendorVerificationRowStoreSetupStatusEnum_IN_PROGRESS;
  @BuiltValueEnumConst(wireName: r'SUBMITTED')
  static const VendorVerificationRowStoreSetupStatusEnum SUBMITTED = _$vendorVerificationRowStoreSetupStatusEnum_SUBMITTED;
  @BuiltValueEnumConst(wireName: r'PENDING_VERIFICATION')
  static const VendorVerificationRowStoreSetupStatusEnum PENDING_VERIFICATION = _$vendorVerificationRowStoreSetupStatusEnum_PENDING_VERIFICATION;
  @BuiltValueEnumConst(wireName: r'APPROVED')
  static const VendorVerificationRowStoreSetupStatusEnum APPROVED = _$vendorVerificationRowStoreSetupStatusEnum_APPROVED;
  @BuiltValueEnumConst(wireName: r'COMPLETED')
  static const VendorVerificationRowStoreSetupStatusEnum COMPLETED = _$vendorVerificationRowStoreSetupStatusEnum_COMPLETED;
  @BuiltValueEnumConst(wireName: r'CHANGES_REQUIRED')
  static const VendorVerificationRowStoreSetupStatusEnum CHANGES_REQUIRED = _$vendorVerificationRowStoreSetupStatusEnum_CHANGES_REQUIRED;
  @BuiltValueEnumConst(wireName: r'REJECTED')
  static const VendorVerificationRowStoreSetupStatusEnum REJECTED = _$vendorVerificationRowStoreSetupStatusEnum_REJECTED;
  @BuiltValueEnumConst(wireName: r'EXPIRED')
  static const VendorVerificationRowStoreSetupStatusEnum EXPIRED = _$vendorVerificationRowStoreSetupStatusEnum_EXPIRED;
  @BuiltValueEnumConst(wireName: r'NOT_APPLICABLE')
  static const VendorVerificationRowStoreSetupStatusEnum NOT_APPLICABLE = _$vendorVerificationRowStoreSetupStatusEnum_NOT_APPLICABLE;

  static Serializer<VendorVerificationRowStoreSetupStatusEnum> get serializer => _$vendorVerificationRowStoreSetupStatusEnumSerializer;

  const VendorVerificationRowStoreSetupStatusEnum._(String name): super(name);

  static BuiltSet<VendorVerificationRowStoreSetupStatusEnum> get values => _$vendorVerificationRowStoreSetupStatusEnumValues;
  static VendorVerificationRowStoreSetupStatusEnum valueOf(String name) => _$vendorVerificationRowStoreSetupStatusEnumValueOf(name);
}

