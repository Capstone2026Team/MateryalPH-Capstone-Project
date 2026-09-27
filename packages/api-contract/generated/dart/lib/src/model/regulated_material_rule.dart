//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'regulated_material_rule.g.dart';

/// Transcribed from the DTI-BPS list of regulated building and construction products with marking requirements.
///
/// Properties:
/// * [id]
/// * [version]
/// * [requiredMarking]
/// * [productName]
/// * [referenceStandard]
/// * [technicalRegulation]
/// * [scope]
/// * [markingRequirements]
/// * [sourceReference]
@BuiltValue()
abstract class RegulatedMaterialRule implements Built<RegulatedMaterialRule, RegulatedMaterialRuleBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'version')
  int get version;

  @BuiltValueField(wireName: r'required_marking')
  RegulatedMaterialRuleRequiredMarkingEnum get requiredMarking;
  // enum requiredMarkingEnum {  PS_MARK,  ICC_STICKER,  PS_OR_ICC,  };

  @BuiltValueField(wireName: r'product_name')
  String? get productName;

  @BuiltValueField(wireName: r'reference_standard')
  String? get referenceStandard;

  @BuiltValueField(wireName: r'technical_regulation')
  String? get technicalRegulation;

  @BuiltValueField(wireName: r'scope')
  String? get scope;

  @BuiltValueField(wireName: r'marking_requirements')
  BuiltList<String> get markingRequirements;

  @BuiltValueField(wireName: r'source_reference')
  String get sourceReference;

  RegulatedMaterialRule._();

  factory RegulatedMaterialRule([void updates(RegulatedMaterialRuleBuilder b)]) = _$RegulatedMaterialRule;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RegulatedMaterialRuleBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RegulatedMaterialRule> get serializer => _$RegulatedMaterialRuleSerializer();
}

class _$RegulatedMaterialRuleSerializer implements PrimitiveSerializer<RegulatedMaterialRule> {
  @override
  final Iterable<Type> types = const [RegulatedMaterialRule, _$RegulatedMaterialRule];

  @override
  final String wireName = r'RegulatedMaterialRule';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RegulatedMaterialRule object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'version';
    yield serializers.serialize(
      object.version,
      specifiedType: const FullType(int),
    );
    yield r'required_marking';
    yield serializers.serialize(
      object.requiredMarking,
      specifiedType: const FullType(RegulatedMaterialRuleRequiredMarkingEnum),
    );
    if (object.productName != null) {
      yield r'product_name';
      yield serializers.serialize(
        object.productName,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.referenceStandard != null) {
      yield r'reference_standard';
      yield serializers.serialize(
        object.referenceStandard,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.technicalRegulation != null) {
      yield r'technical_regulation';
      yield serializers.serialize(
        object.technicalRegulation,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.scope != null) {
      yield r'scope';
      yield serializers.serialize(
        object.scope,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'marking_requirements';
    yield serializers.serialize(
      object.markingRequirements,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'source_reference';
    yield serializers.serialize(
      object.sourceReference,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    RegulatedMaterialRule object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RegulatedMaterialRuleBuilder result,
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
        case r'version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.version = valueDes;
          break;
        case r'required_marking':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(RegulatedMaterialRuleRequiredMarkingEnum),
          ) as RegulatedMaterialRuleRequiredMarkingEnum;
          result.requiredMarking = valueDes;
          break;
        case r'product_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.productName = valueDes;
          break;
        case r'reference_standard':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.referenceStandard = valueDes;
          break;
        case r'technical_regulation':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.technicalRegulation = valueDes;
          break;
        case r'scope':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.scope = valueDes;
          break;
        case r'marking_requirements':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.markingRequirements.replace(valueDes);
          break;
        case r'source_reference':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.sourceReference = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RegulatedMaterialRule deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RegulatedMaterialRuleBuilder();
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


class RegulatedMaterialRuleRequiredMarkingEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PS_MARK')
  static const RegulatedMaterialRuleRequiredMarkingEnum PS_MARK = _$regulatedMaterialRuleRequiredMarkingEnum_PS_MARK;
  @BuiltValueEnumConst(wireName: r'ICC_STICKER')
  static const RegulatedMaterialRuleRequiredMarkingEnum ICC_STICKER = _$regulatedMaterialRuleRequiredMarkingEnum_ICC_STICKER;
  @BuiltValueEnumConst(wireName: r'PS_OR_ICC')
  static const RegulatedMaterialRuleRequiredMarkingEnum PS_OR_ICC = _$regulatedMaterialRuleRequiredMarkingEnum_PS_OR_ICC;

  static Serializer<RegulatedMaterialRuleRequiredMarkingEnum> get serializer => _$regulatedMaterialRuleRequiredMarkingEnumSerializer;

  const RegulatedMaterialRuleRequiredMarkingEnum._(String name): super(name);

  static BuiltSet<RegulatedMaterialRuleRequiredMarkingEnum> get values => _$regulatedMaterialRuleRequiredMarkingEnumValues;
  static RegulatedMaterialRuleRequiredMarkingEnum valueOf(String name) => _$regulatedMaterialRuleRequiredMarkingEnumValueOf(name);
}

