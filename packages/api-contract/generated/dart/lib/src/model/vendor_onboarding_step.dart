//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_onboarding_step.g.dart';

/// VendorOnboardingStep
///
/// Properties:
/// * [id]
/// * [key]
/// * [label]
/// * [level]
/// * [status]
/// * [reason]
/// * [lockVersion]
/// * [submittedAt]
/// * [reviewedAt]
@BuiltValue()
abstract class VendorOnboardingStep implements Built<VendorOnboardingStep, VendorOnboardingStepBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'key')
  String get key;

  @BuiltValueField(wireName: r'label')
  String get label;

  @BuiltValueField(wireName: r'level')
  VendorOnboardingStepLevelEnum get level;
  // enum levelEnum {  REQUIRED,  OPTIONAL,  CONDITIONALLY_REQUIRED,  };

  @BuiltValueField(wireName: r'status')
  VendorOnboardingStepStatusEnum get status;
  // enum statusEnum {  NOT_STARTED,  IN_PROGRESS,  SUBMITTED,  PENDING_VERIFICATION,  APPROVED,  CHANGES_REQUIRED,  REJECTED,  EXPIRED,  NOT_APPLICABLE,  COMPLETED,  };

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  @BuiltValueField(wireName: r'submitted_at')
  DateTime? get submittedAt;

  @BuiltValueField(wireName: r'reviewed_at')
  DateTime? get reviewedAt;

  VendorOnboardingStep._();

  factory VendorOnboardingStep([void updates(VendorOnboardingStepBuilder b)]) = _$VendorOnboardingStep;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorOnboardingStepBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorOnboardingStep> get serializer => _$VendorOnboardingStepSerializer();
}

class _$VendorOnboardingStepSerializer implements PrimitiveSerializer<VendorOnboardingStep> {
  @override
  final Iterable<Type> types = const [VendorOnboardingStep, _$VendorOnboardingStep];

  @override
  final String wireName = r'VendorOnboardingStep';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorOnboardingStep object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'key';
    yield serializers.serialize(
      object.key,
      specifiedType: const FullType(String),
    );
    yield r'label';
    yield serializers.serialize(
      object.label,
      specifiedType: const FullType(String),
    );
    yield r'level';
    yield serializers.serialize(
      object.level,
      specifiedType: const FullType(VendorOnboardingStepLevelEnum),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(VendorOnboardingStepStatusEnum),
    );
    if (object.reason != null) {
      yield r'reason';
      yield serializers.serialize(
        object.reason,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
    if (object.submittedAt != null) {
      yield r'submitted_at';
      yield serializers.serialize(
        object.submittedAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    if (object.reviewedAt != null) {
      yield r'reviewed_at';
      yield serializers.serialize(
        object.reviewedAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorOnboardingStep object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorOnboardingStepBuilder result,
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
        case r'key':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.key = valueDes;
          break;
        case r'label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.label = valueDes;
          break;
        case r'level':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorOnboardingStepLevelEnum),
          ) as VendorOnboardingStepLevelEnum;
          result.level = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorOnboardingStepStatusEnum),
          ) as VendorOnboardingStepStatusEnum;
          result.status = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.reason = valueDes;
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
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.submittedAt = valueDes;
          break;
        case r'reviewed_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.reviewedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorOnboardingStep deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorOnboardingStepBuilder();
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


class VendorOnboardingStepLevelEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'REQUIRED')
  static const VendorOnboardingStepLevelEnum REQUIRED = _$vendorOnboardingStepLevelEnum_REQUIRED;
  @BuiltValueEnumConst(wireName: r'OPTIONAL')
  static const VendorOnboardingStepLevelEnum OPTIONAL = _$vendorOnboardingStepLevelEnum_OPTIONAL;
  @BuiltValueEnumConst(wireName: r'CONDITIONALLY_REQUIRED')
  static const VendorOnboardingStepLevelEnum CONDITIONALLY_REQUIRED = _$vendorOnboardingStepLevelEnum_CONDITIONALLY_REQUIRED;

  static Serializer<VendorOnboardingStepLevelEnum> get serializer => _$vendorOnboardingStepLevelEnumSerializer;

  const VendorOnboardingStepLevelEnum._(String name): super(name);

  static BuiltSet<VendorOnboardingStepLevelEnum> get values => _$vendorOnboardingStepLevelEnumValues;
  static VendorOnboardingStepLevelEnum valueOf(String name) => _$vendorOnboardingStepLevelEnumValueOf(name);
}

class VendorOnboardingStepStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'NOT_STARTED')
  static const VendorOnboardingStepStatusEnum NOT_STARTED = _$vendorOnboardingStepStatusEnum_NOT_STARTED;
  @BuiltValueEnumConst(wireName: r'IN_PROGRESS')
  static const VendorOnboardingStepStatusEnum IN_PROGRESS = _$vendorOnboardingStepStatusEnum_IN_PROGRESS;
  @BuiltValueEnumConst(wireName: r'SUBMITTED')
  static const VendorOnboardingStepStatusEnum SUBMITTED = _$vendorOnboardingStepStatusEnum_SUBMITTED;
  @BuiltValueEnumConst(wireName: r'PENDING_VERIFICATION')
  static const VendorOnboardingStepStatusEnum PENDING_VERIFICATION = _$vendorOnboardingStepStatusEnum_PENDING_VERIFICATION;
  @BuiltValueEnumConst(wireName: r'APPROVED')
  static const VendorOnboardingStepStatusEnum APPROVED = _$vendorOnboardingStepStatusEnum_APPROVED;
  @BuiltValueEnumConst(wireName: r'CHANGES_REQUIRED')
  static const VendorOnboardingStepStatusEnum CHANGES_REQUIRED = _$vendorOnboardingStepStatusEnum_CHANGES_REQUIRED;
  @BuiltValueEnumConst(wireName: r'REJECTED')
  static const VendorOnboardingStepStatusEnum REJECTED = _$vendorOnboardingStepStatusEnum_REJECTED;
  @BuiltValueEnumConst(wireName: r'EXPIRED')
  static const VendorOnboardingStepStatusEnum EXPIRED = _$vendorOnboardingStepStatusEnum_EXPIRED;
  @BuiltValueEnumConst(wireName: r'NOT_APPLICABLE')
  static const VendorOnboardingStepStatusEnum NOT_APPLICABLE = _$vendorOnboardingStepStatusEnum_NOT_APPLICABLE;
  @BuiltValueEnumConst(wireName: r'COMPLETED')
  static const VendorOnboardingStepStatusEnum COMPLETED = _$vendorOnboardingStepStatusEnum_COMPLETED;

  static Serializer<VendorOnboardingStepStatusEnum> get serializer => _$vendorOnboardingStepStatusEnumSerializer;

  const VendorOnboardingStepStatusEnum._(String name): super(name);

  static BuiltSet<VendorOnboardingStepStatusEnum> get values => _$vendorOnboardingStepStatusEnumValues;
  static VendorOnboardingStepStatusEnum valueOf(String name) => _$vendorOnboardingStepStatusEnumValueOf(name);
}

