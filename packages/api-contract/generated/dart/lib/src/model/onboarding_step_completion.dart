//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'onboarding_step_completion.g.dart';

/// OnboardingStepCompletion
///
/// Properties:
/// * [key]
/// * [workstream]
/// * [complete] - All applicable mandatory requirements have their successful final status.
/// * [required_]
@BuiltValue()
abstract class OnboardingStepCompletion implements Built<OnboardingStepCompletion, OnboardingStepCompletionBuilder> {
  @BuiltValueField(wireName: r'key')
  OnboardingStepCompletionKeyEnum get key;
  // enum keyEnum {  V1,  V2,  V3,  V4,  S1,  S2,  S3,  S4,  S5,  S6,  };

  @BuiltValueField(wireName: r'workstream')
  OnboardingStepCompletionWorkstreamEnum get workstream;
  // enum workstreamEnum {  STORE_VERIFICATION,  STORE_SETUP,  };

  /// All applicable mandatory requirements have their successful final status.
  @BuiltValueField(wireName: r'complete')
  bool get complete;

  @BuiltValueField(wireName: r'required')
  bool get required_;

  OnboardingStepCompletion._();

  factory OnboardingStepCompletion([void updates(OnboardingStepCompletionBuilder b)]) = _$OnboardingStepCompletion;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OnboardingStepCompletionBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OnboardingStepCompletion> get serializer => _$OnboardingStepCompletionSerializer();
}

class _$OnboardingStepCompletionSerializer implements PrimitiveSerializer<OnboardingStepCompletion> {
  @override
  final Iterable<Type> types = const [OnboardingStepCompletion, _$OnboardingStepCompletion];

  @override
  final String wireName = r'OnboardingStepCompletion';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OnboardingStepCompletion object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'key';
    yield serializers.serialize(
      object.key,
      specifiedType: const FullType(OnboardingStepCompletionKeyEnum),
    );
    yield r'workstream';
    yield serializers.serialize(
      object.workstream,
      specifiedType: const FullType(OnboardingStepCompletionWorkstreamEnum),
    );
    yield r'complete';
    yield serializers.serialize(
      object.complete,
      specifiedType: const FullType(bool),
    );
    yield r'required';
    yield serializers.serialize(
      object.required_,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    OnboardingStepCompletion object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OnboardingStepCompletionBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'key':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(OnboardingStepCompletionKeyEnum),
          ) as OnboardingStepCompletionKeyEnum;
          result.key = valueDes;
          break;
        case r'workstream':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(OnboardingStepCompletionWorkstreamEnum),
          ) as OnboardingStepCompletionWorkstreamEnum;
          result.workstream = valueDes;
          break;
        case r'complete':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.complete = valueDes;
          break;
        case r'required':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.required_ = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  OnboardingStepCompletion deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OnboardingStepCompletionBuilder();
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


class OnboardingStepCompletionKeyEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'V1')
  static const OnboardingStepCompletionKeyEnum V1 = _$onboardingStepCompletionKeyEnum_V1;
  @BuiltValueEnumConst(wireName: r'V2')
  static const OnboardingStepCompletionKeyEnum V2 = _$onboardingStepCompletionKeyEnum_V2;
  @BuiltValueEnumConst(wireName: r'V3')
  static const OnboardingStepCompletionKeyEnum V3 = _$onboardingStepCompletionKeyEnum_V3;
  @BuiltValueEnumConst(wireName: r'V4')
  static const OnboardingStepCompletionKeyEnum V4 = _$onboardingStepCompletionKeyEnum_V4;
  @BuiltValueEnumConst(wireName: r'S1')
  static const OnboardingStepCompletionKeyEnum S1 = _$onboardingStepCompletionKeyEnum_S1;
  @BuiltValueEnumConst(wireName: r'S2')
  static const OnboardingStepCompletionKeyEnum S2 = _$onboardingStepCompletionKeyEnum_S2;
  @BuiltValueEnumConst(wireName: r'S3')
  static const OnboardingStepCompletionKeyEnum S3 = _$onboardingStepCompletionKeyEnum_S3;
  @BuiltValueEnumConst(wireName: r'S4')
  static const OnboardingStepCompletionKeyEnum S4 = _$onboardingStepCompletionKeyEnum_S4;
  @BuiltValueEnumConst(wireName: r'S5')
  static const OnboardingStepCompletionKeyEnum S5 = _$onboardingStepCompletionKeyEnum_S5;
  @BuiltValueEnumConst(wireName: r'S6')
  static const OnboardingStepCompletionKeyEnum S6 = _$onboardingStepCompletionKeyEnum_S6;

  static Serializer<OnboardingStepCompletionKeyEnum> get serializer => _$onboardingStepCompletionKeyEnumSerializer;

  const OnboardingStepCompletionKeyEnum._(String name): super(name);

  static BuiltSet<OnboardingStepCompletionKeyEnum> get values => _$onboardingStepCompletionKeyEnumValues;
  static OnboardingStepCompletionKeyEnum valueOf(String name) => _$onboardingStepCompletionKeyEnumValueOf(name);
}

class OnboardingStepCompletionWorkstreamEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'STORE_VERIFICATION')
  static const OnboardingStepCompletionWorkstreamEnum STORE_VERIFICATION = _$onboardingStepCompletionWorkstreamEnum_STORE_VERIFICATION;
  @BuiltValueEnumConst(wireName: r'STORE_SETUP')
  static const OnboardingStepCompletionWorkstreamEnum STORE_SETUP = _$onboardingStepCompletionWorkstreamEnum_STORE_SETUP;

  static Serializer<OnboardingStepCompletionWorkstreamEnum> get serializer => _$onboardingStepCompletionWorkstreamEnumSerializer;

  const OnboardingStepCompletionWorkstreamEnum._(String name): super(name);

  static BuiltSet<OnboardingStepCompletionWorkstreamEnum> get values => _$onboardingStepCompletionWorkstreamEnumValues;
  static OnboardingStepCompletionWorkstreamEnum valueOf(String name) => _$onboardingStepCompletionWorkstreamEnumValueOf(name);
}

