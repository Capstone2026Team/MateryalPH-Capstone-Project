//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/onboarding_requirement.dart';
import 'package:materyalph_api_client/src/model/vendor_onboarding_section.dart';
import 'package:materyalph_api_client/src/model/vendor_onboarding_snapshot_setup.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/onboarding_step_completion.dart';
import 'package:materyalph_api_client/src/model/vendor_activation_snapshot.dart';
import 'package:materyalph_api_client/src/model/onboarding_draft_version.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_onboarding_snapshot.g.dart';

/// VendorOnboardingSnapshot
///
/// Properties:
/// * [stepCompletion]
/// * [lockVersion]
/// * [requirements]
/// * [drafts]
/// * [organization]
/// * [sections]
/// * [verification]
/// * [setup]
/// * [activation]
/// * [welcomeRequired]
/// * [permissions]
@BuiltValue()
abstract class VendorOnboardingSnapshot implements Built<VendorOnboardingSnapshot, VendorOnboardingSnapshotBuilder> {
  @BuiltValueField(wireName: r'step_completion')
  BuiltList<OnboardingStepCompletion> get stepCompletion;

  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  @BuiltValueField(wireName: r'requirements')
  BuiltList<OnboardingRequirement> get requirements;

  @BuiltValueField(wireName: r'drafts')
  BuiltList<OnboardingDraftVersion> get drafts;

  @BuiltValueField(wireName: r'organization')
  BuiltMap<String, JsonObject?> get organization;

  @BuiltValueField(wireName: r'sections')
  BuiltMap<String, VendorOnboardingSection> get sections;

  @BuiltValueField(wireName: r'verification')
  BuiltMap<String, JsonObject?> get verification;

  @BuiltValueField(wireName: r'setup')
  VendorOnboardingSnapshotSetup get setup;

  @BuiltValueField(wireName: r'activation')
  VendorActivationSnapshot get activation;

  @BuiltValueField(wireName: r'welcome_required')
  bool get welcomeRequired;

  @BuiltValueField(wireName: r'permissions')
  BuiltList<String> get permissions;

  VendorOnboardingSnapshot._();

  factory VendorOnboardingSnapshot([void updates(VendorOnboardingSnapshotBuilder b)]) = _$VendorOnboardingSnapshot;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorOnboardingSnapshotBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorOnboardingSnapshot> get serializer => _$VendorOnboardingSnapshotSerializer();
}

class _$VendorOnboardingSnapshotSerializer implements PrimitiveSerializer<VendorOnboardingSnapshot> {
  @override
  final Iterable<Type> types = const [VendorOnboardingSnapshot, _$VendorOnboardingSnapshot];

  @override
  final String wireName = r'VendorOnboardingSnapshot';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorOnboardingSnapshot object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'step_completion';
    yield serializers.serialize(
      object.stepCompletion,
      specifiedType: const FullType(BuiltList, [FullType(OnboardingStepCompletion)]),
    );
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
    yield r'requirements';
    yield serializers.serialize(
      object.requirements,
      specifiedType: const FullType(BuiltList, [FullType(OnboardingRequirement)]),
    );
    yield r'drafts';
    yield serializers.serialize(
      object.drafts,
      specifiedType: const FullType(BuiltList, [FullType(OnboardingDraftVersion)]),
    );
    yield r'organization';
    yield serializers.serialize(
      object.organization,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
    yield r'sections';
    yield serializers.serialize(
      object.sections,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType(VendorOnboardingSection)]),
    );
    yield r'verification';
    yield serializers.serialize(
      object.verification,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
    yield r'setup';
    yield serializers.serialize(
      object.setup,
      specifiedType: const FullType(VendorOnboardingSnapshotSetup),
    );
    yield r'activation';
    yield serializers.serialize(
      object.activation,
      specifiedType: const FullType(VendorActivationSnapshot),
    );
    yield r'welcome_required';
    yield serializers.serialize(
      object.welcomeRequired,
      specifiedType: const FullType(bool),
    );
    yield r'permissions';
    yield serializers.serialize(
      object.permissions,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorOnboardingSnapshot object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorOnboardingSnapshotBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'step_completion':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(OnboardingStepCompletion)]),
          ) as BuiltList<OnboardingStepCompletion>;
          result.stepCompletion.replace(valueDes);
          break;
        case r'lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lockVersion = valueDes;
          break;
        case r'requirements':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(OnboardingRequirement)]),
          ) as BuiltList<OnboardingRequirement>;
          result.requirements.replace(valueDes);
          break;
        case r'drafts':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(OnboardingDraftVersion)]),
          ) as BuiltList<OnboardingDraftVersion>;
          result.drafts.replace(valueDes);
          break;
        case r'organization':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.organization.replace(valueDes);
          break;
        case r'sections':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType(VendorOnboardingSection)]),
          ) as BuiltMap<String, VendorOnboardingSection>;
          result.sections.replace(valueDes);
          break;
        case r'verification':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.verification.replace(valueDes);
          break;
        case r'setup':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorOnboardingSnapshotSetup),
          ) as VendorOnboardingSnapshotSetup;
          result.setup = valueDes.toBuilder();
          break;
        case r'activation':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorActivationSnapshot),
          ) as VendorActivationSnapshot;
          result.activation.replace(valueDes);
          break;
        case r'welcome_required':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.welcomeRequired = valueDes;
          break;
        case r'permissions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.permissions.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorOnboardingSnapshot deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorOnboardingSnapshotBuilder();
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


