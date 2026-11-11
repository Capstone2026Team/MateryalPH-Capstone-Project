//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'tutorial_progress.g.dart';

/// TutorialProgress
///
/// Properties:
/// * [tutorialKey]
/// * [status]
/// * [updatedAt]
@BuiltValue()
abstract class TutorialProgress implements Built<TutorialProgress, TutorialProgressBuilder> {
  @BuiltValueField(wireName: r'tutorial_key')
  String get tutorialKey;

  @BuiltValueField(wireName: r'status')
  TutorialProgressStatusEnum get status;
  // enum statusEnum {  COMPLETED,  SKIPPED,  };

  @BuiltValueField(wireName: r'updated_at')
  DateTime get updatedAt;

  TutorialProgress._();

  factory TutorialProgress([void updates(TutorialProgressBuilder b)]) = _$TutorialProgress;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TutorialProgressBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TutorialProgress> get serializer => _$TutorialProgressSerializer();
}

class _$TutorialProgressSerializer implements PrimitiveSerializer<TutorialProgress> {
  @override
  final Iterable<Type> types = const [TutorialProgress, _$TutorialProgress];

  @override
  final String wireName = r'TutorialProgress';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TutorialProgress object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'tutorial_key';
    yield serializers.serialize(
      object.tutorialKey,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(TutorialProgressStatusEnum),
    );
    yield r'updated_at';
    yield serializers.serialize(
      object.updatedAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TutorialProgress object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TutorialProgressBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'tutorial_key':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.tutorialKey = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TutorialProgressStatusEnum),
          ) as TutorialProgressStatusEnum;
          result.status = valueDes;
          break;
        case r'updated_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.updatedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TutorialProgress deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TutorialProgressBuilder();
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


class TutorialProgressStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'COMPLETED')
  static const TutorialProgressStatusEnum COMPLETED = _$tutorialProgressStatusEnum_COMPLETED;
  @BuiltValueEnumConst(wireName: r'SKIPPED')
  static const TutorialProgressStatusEnum SKIPPED = _$tutorialProgressStatusEnum_SKIPPED;

  static Serializer<TutorialProgressStatusEnum> get serializer => _$tutorialProgressStatusEnumSerializer;

  const TutorialProgressStatusEnum._(String name): super(name);

  static BuiltSet<TutorialProgressStatusEnum> get values => _$tutorialProgressStatusEnumValues;
  static TutorialProgressStatusEnum valueOf(String name) => _$tutorialProgressStatusEnumValueOf(name);
}

