//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'review_display_option.g.dart';

/// ReviewDisplayOption
///
/// Properties:
/// * [choice]
/// * [preview]
@BuiltValue()
abstract class ReviewDisplayOption implements Built<ReviewDisplayOption, ReviewDisplayOptionBuilder> {
  @BuiltValueField(wireName: r'choice')
  ReviewDisplayOptionChoiceEnum get choice;
  // enum choiceEnum {  FIRST_NAME_LAST_INITIAL,  VERIFIED_BUYER,  };

  @BuiltValueField(wireName: r'preview')
  String get preview;

  ReviewDisplayOption._();

  factory ReviewDisplayOption([void updates(ReviewDisplayOptionBuilder b)]) = _$ReviewDisplayOption;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ReviewDisplayOptionBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ReviewDisplayOption> get serializer => _$ReviewDisplayOptionSerializer();
}

class _$ReviewDisplayOptionSerializer implements PrimitiveSerializer<ReviewDisplayOption> {
  @override
  final Iterable<Type> types = const [ReviewDisplayOption, _$ReviewDisplayOption];

  @override
  final String wireName = r'ReviewDisplayOption';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ReviewDisplayOption object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'choice';
    yield serializers.serialize(
      object.choice,
      specifiedType: const FullType(ReviewDisplayOptionChoiceEnum),
    );
    yield r'preview';
    yield serializers.serialize(
      object.preview,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ReviewDisplayOption object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ReviewDisplayOptionBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'choice':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ReviewDisplayOptionChoiceEnum),
          ) as ReviewDisplayOptionChoiceEnum;
          result.choice = valueDes;
          break;
        case r'preview':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.preview = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ReviewDisplayOption deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ReviewDisplayOptionBuilder();
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


class ReviewDisplayOptionChoiceEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'FIRST_NAME_LAST_INITIAL')
  static const ReviewDisplayOptionChoiceEnum FIRST_NAME_LAST_INITIAL = _$reviewDisplayOptionChoiceEnum_FIRST_NAME_LAST_INITIAL;
  @BuiltValueEnumConst(wireName: r'VERIFIED_BUYER')
  static const ReviewDisplayOptionChoiceEnum VERIFIED_BUYER = _$reviewDisplayOptionChoiceEnum_VERIFIED_BUYER;

  static Serializer<ReviewDisplayOptionChoiceEnum> get serializer => _$reviewDisplayOptionChoiceEnumSerializer;

  const ReviewDisplayOptionChoiceEnum._(String name): super(name);

  static BuiltSet<ReviewDisplayOptionChoiceEnum> get values => _$reviewDisplayOptionChoiceEnumValues;
  static ReviewDisplayOptionChoiceEnum valueOf(String name) => _$reviewDisplayOptionChoiceEnumValueOf(name);
}

