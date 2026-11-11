//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'tutorial_acknowledgment.g.dart';

/// TutorialAcknowledgment
///
/// Properties:
/// * [status]
@BuiltValue()
abstract class TutorialAcknowledgment implements Built<TutorialAcknowledgment, TutorialAcknowledgmentBuilder> {
  @BuiltValueField(wireName: r'status')
  TutorialAcknowledgmentStatusEnum get status;
  // enum statusEnum {  COMPLETED,  SKIPPED,  };

  TutorialAcknowledgment._();

  factory TutorialAcknowledgment([void updates(TutorialAcknowledgmentBuilder b)]) = _$TutorialAcknowledgment;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TutorialAcknowledgmentBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TutorialAcknowledgment> get serializer => _$TutorialAcknowledgmentSerializer();
}

class _$TutorialAcknowledgmentSerializer implements PrimitiveSerializer<TutorialAcknowledgment> {
  @override
  final Iterable<Type> types = const [TutorialAcknowledgment, _$TutorialAcknowledgment];

  @override
  final String wireName = r'TutorialAcknowledgment';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TutorialAcknowledgment object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(TutorialAcknowledgmentStatusEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TutorialAcknowledgment object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TutorialAcknowledgmentBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TutorialAcknowledgmentStatusEnum),
          ) as TutorialAcknowledgmentStatusEnum;
          result.status = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TutorialAcknowledgment deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TutorialAcknowledgmentBuilder();
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


class TutorialAcknowledgmentStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'COMPLETED')
  static const TutorialAcknowledgmentStatusEnum COMPLETED = _$tutorialAcknowledgmentStatusEnum_COMPLETED;
  @BuiltValueEnumConst(wireName: r'SKIPPED')
  static const TutorialAcknowledgmentStatusEnum SKIPPED = _$tutorialAcknowledgmentStatusEnum_SKIPPED;

  static Serializer<TutorialAcknowledgmentStatusEnum> get serializer => _$tutorialAcknowledgmentStatusEnumSerializer;

  const TutorialAcknowledgmentStatusEnum._(String name): super(name);

  static BuiltSet<TutorialAcknowledgmentStatusEnum> get values => _$tutorialAcknowledgmentStatusEnumValues;
  static TutorialAcknowledgmentStatusEnum valueOf(String name) => _$tutorialAcknowledgmentStatusEnumValueOf(name);
}

