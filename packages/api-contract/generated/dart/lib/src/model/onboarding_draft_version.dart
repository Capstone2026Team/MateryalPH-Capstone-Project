//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'onboarding_draft_version.g.dart';

/// OnboardingDraftVersion
///
/// Properties:
/// * [workstream]
/// * [lockVersion]
@BuiltValue()
abstract class OnboardingDraftVersion implements Built<OnboardingDraftVersion, OnboardingDraftVersionBuilder> {
  @BuiltValueField(wireName: r'workstream')
  OnboardingDraftVersionWorkstreamEnum get workstream;
  // enum workstreamEnum {  STORE_VERIFICATION,  STORE_SETUP,  };

  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  OnboardingDraftVersion._();

  factory OnboardingDraftVersion([void updates(OnboardingDraftVersionBuilder b)]) = _$OnboardingDraftVersion;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OnboardingDraftVersionBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OnboardingDraftVersion> get serializer => _$OnboardingDraftVersionSerializer();
}

class _$OnboardingDraftVersionSerializer implements PrimitiveSerializer<OnboardingDraftVersion> {
  @override
  final Iterable<Type> types = const [OnboardingDraftVersion, _$OnboardingDraftVersion];

  @override
  final String wireName = r'OnboardingDraftVersion';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OnboardingDraftVersion object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'workstream';
    yield serializers.serialize(
      object.workstream,
      specifiedType: const FullType(OnboardingDraftVersionWorkstreamEnum),
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
    OnboardingDraftVersion object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OnboardingDraftVersionBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'workstream':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(OnboardingDraftVersionWorkstreamEnum),
          ) as OnboardingDraftVersionWorkstreamEnum;
          result.workstream = valueDes;
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
  OnboardingDraftVersion deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OnboardingDraftVersionBuilder();
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


class OnboardingDraftVersionWorkstreamEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'STORE_VERIFICATION')
  static const OnboardingDraftVersionWorkstreamEnum STORE_VERIFICATION = _$onboardingDraftVersionWorkstreamEnum_STORE_VERIFICATION;
  @BuiltValueEnumConst(wireName: r'STORE_SETUP')
  static const OnboardingDraftVersionWorkstreamEnum STORE_SETUP = _$onboardingDraftVersionWorkstreamEnum_STORE_SETUP;

  static Serializer<OnboardingDraftVersionWorkstreamEnum> get serializer => _$onboardingDraftVersionWorkstreamEnumSerializer;

  const OnboardingDraftVersionWorkstreamEnum._(String name): super(name);

  static BuiltSet<OnboardingDraftVersionWorkstreamEnum> get values => _$onboardingDraftVersionWorkstreamEnumValues;
  static OnboardingDraftVersionWorkstreamEnum valueOf(String name) => _$onboardingDraftVersionWorkstreamEnumValueOf(name);
}

