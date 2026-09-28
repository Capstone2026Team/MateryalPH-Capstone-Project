//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'score_label.g.dart';

/// Tier 2 shows VPS or New Vendor; Tier 1 shows Directory. A Google rating is never a ScoreLabel.
///
/// Properties:
/// * [kind]
/// * [value] - One-decimal VPS for kind VPS; null otherwise.
/// * [text]
@BuiltValue()
abstract class ScoreLabel implements Built<ScoreLabel, ScoreLabelBuilder> {
  @BuiltValueField(wireName: r'kind')
  ScoreLabelKindEnum get kind;
  // enum kindEnum {  VPS,  NEW_VENDOR,  DIRECTORY,  };

  /// One-decimal VPS for kind VPS; null otherwise.
  @BuiltValueField(wireName: r'value')
  String? get value;

  @BuiltValueField(wireName: r'text')
  String get text;

  ScoreLabel._();

  factory ScoreLabel([void updates(ScoreLabelBuilder b)]) = _$ScoreLabel;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ScoreLabelBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ScoreLabel> get serializer => _$ScoreLabelSerializer();
}

class _$ScoreLabelSerializer implements PrimitiveSerializer<ScoreLabel> {
  @override
  final Iterable<Type> types = const [ScoreLabel, _$ScoreLabel];

  @override
  final String wireName = r'ScoreLabel';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ScoreLabel object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(ScoreLabelKindEnum),
    );
    yield r'value';
    yield object.value == null ? null : serializers.serialize(
      object.value,
      specifiedType: const FullType.nullable(String),
    );
    yield r'text';
    yield serializers.serialize(
      object.text,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ScoreLabel object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ScoreLabelBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'kind':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ScoreLabelKindEnum),
          ) as ScoreLabelKindEnum;
          result.kind = valueDes;
          break;
        case r'value':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.value = valueDes;
          break;
        case r'text':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.text = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ScoreLabel deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ScoreLabelBuilder();
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


class ScoreLabelKindEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'VPS')
  static const ScoreLabelKindEnum VPS = _$scoreLabelKindEnum_VPS;
  @BuiltValueEnumConst(wireName: r'NEW_VENDOR')
  static const ScoreLabelKindEnum NEW_VENDOR = _$scoreLabelKindEnum_NEW_VENDOR;
  @BuiltValueEnumConst(wireName: r'DIRECTORY')
  static const ScoreLabelKindEnum DIRECTORY = _$scoreLabelKindEnum_DIRECTORY;

  static Serializer<ScoreLabelKindEnum> get serializer => _$scoreLabelKindEnumSerializer;

  const ScoreLabelKindEnum._(String name): super(name);

  static BuiltSet<ScoreLabelKindEnum> get values => _$scoreLabelKindEnumValues;
  static ScoreLabelKindEnum valueOf(String name) => _$scoreLabelKindEnumValueOf(name);
}

