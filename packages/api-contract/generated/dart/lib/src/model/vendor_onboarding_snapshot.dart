//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/vendor_onboarding_section.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_onboarding_snapshot.g.dart';

/// VendorOnboardingSnapshot
///
/// Properties:
/// * [organization]
/// * [sections]
/// * [verification]
/// * [setup]
/// * [activation]
/// * [welcomeRequired]
/// * [permissions]
@BuiltValue()
abstract class VendorOnboardingSnapshot implements Built<VendorOnboardingSnapshot, VendorOnboardingSnapshotBuilder> {
  @BuiltValueField(wireName: r'organization')
  BuiltMap<String, JsonObject?> get organization;

  @BuiltValueField(wireName: r'sections')
  BuiltMap<String, VendorOnboardingSection> get sections;

  @BuiltValueField(wireName: r'verification')
  BuiltMap<String, JsonObject?> get verification;

  @BuiltValueField(wireName: r'setup')
  BuiltMap<String, JsonObject?> get setup;

  @BuiltValueField(wireName: r'activation')
  BuiltMap<String, JsonObject?> get activation;

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
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
    yield r'activation';
    yield serializers.serialize(
      object.activation,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
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
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.setup.replace(valueDes);
          break;
        case r'activation':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
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


