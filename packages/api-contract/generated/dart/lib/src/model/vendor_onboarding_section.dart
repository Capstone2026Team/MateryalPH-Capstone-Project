//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/vendor_onboarding_step.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_onboarding_section.g.dart';

/// VendorOnboardingSection
///
/// Properties:
/// * [key]
/// * [label]
/// * [status]
/// * [complete]
/// * [total]
/// * [progress]
/// * [steps]
@BuiltValue()
abstract class VendorOnboardingSection implements Built<VendorOnboardingSection, VendorOnboardingSectionBuilder> {
  @BuiltValueField(wireName: r'key')
  String get key;

  @BuiltValueField(wireName: r'label')
  String get label;

  @BuiltValueField(wireName: r'status')
  String get status;

  @BuiltValueField(wireName: r'complete')
  int get complete;

  @BuiltValueField(wireName: r'total')
  int get total;

  @BuiltValueField(wireName: r'progress')
  BuiltMap<String, JsonObject?> get progress;

  @BuiltValueField(wireName: r'steps')
  BuiltList<VendorOnboardingStep> get steps;

  VendorOnboardingSection._();

  factory VendorOnboardingSection([void updates(VendorOnboardingSectionBuilder b)]) = _$VendorOnboardingSection;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorOnboardingSectionBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorOnboardingSection> get serializer => _$VendorOnboardingSectionSerializer();
}

class _$VendorOnboardingSectionSerializer implements PrimitiveSerializer<VendorOnboardingSection> {
  @override
  final Iterable<Type> types = const [VendorOnboardingSection, _$VendorOnboardingSection];

  @override
  final String wireName = r'VendorOnboardingSection';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorOnboardingSection object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(String),
    );
    yield r'complete';
    yield serializers.serialize(
      object.complete,
      specifiedType: const FullType(int),
    );
    yield r'total';
    yield serializers.serialize(
      object.total,
      specifiedType: const FullType(int),
    );
    yield r'progress';
    yield serializers.serialize(
      object.progress,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
    yield r'steps';
    yield serializers.serialize(
      object.steps,
      specifiedType: const FullType(BuiltList, [FullType(VendorOnboardingStep)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorOnboardingSection object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorOnboardingSectionBuilder result,
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
        case r'label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.label = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.status = valueDes;
          break;
        case r'complete':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.complete = valueDes;
          break;
        case r'total':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.total = valueDes;
          break;
        case r'progress':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.progress.replace(valueDes);
          break;
        case r'steps':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(VendorOnboardingStep)]),
          ) as BuiltList<VendorOnboardingStep>;
          result.steps.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorOnboardingSection deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorOnboardingSectionBuilder();
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


