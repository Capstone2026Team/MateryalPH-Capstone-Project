//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'review_window_rules.g.dart';

/// ReviewWindowRules
///
/// Properties:
/// * [windowDays]
/// * [editHours]
/// * [commentMax]
/// * [mediaMax]
/// * [photoMaxBytes]
/// * [videoMaxBytes]
/// * [blindReveal]
@BuiltValue()
abstract class ReviewWindowRules implements Built<ReviewWindowRules, ReviewWindowRulesBuilder> {
  @BuiltValueField(wireName: r'window_days')
  int get windowDays;

  @BuiltValueField(wireName: r'edit_hours')
  int get editHours;

  @BuiltValueField(wireName: r'comment_max')
  int get commentMax;

  @BuiltValueField(wireName: r'media_max')
  int get mediaMax;

  @BuiltValueField(wireName: r'photo_max_bytes')
  int? get photoMaxBytes;

  @BuiltValueField(wireName: r'video_max_bytes')
  int? get videoMaxBytes;

  @BuiltValueField(wireName: r'blind_reveal')
  String get blindReveal;

  ReviewWindowRules._();

  factory ReviewWindowRules([void updates(ReviewWindowRulesBuilder b)]) = _$ReviewWindowRules;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ReviewWindowRulesBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ReviewWindowRules> get serializer => _$ReviewWindowRulesSerializer();
}

class _$ReviewWindowRulesSerializer implements PrimitiveSerializer<ReviewWindowRules> {
  @override
  final Iterable<Type> types = const [ReviewWindowRules, _$ReviewWindowRules];

  @override
  final String wireName = r'ReviewWindowRules';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ReviewWindowRules object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'window_days';
    yield serializers.serialize(
      object.windowDays,
      specifiedType: const FullType(int),
    );
    yield r'edit_hours';
    yield serializers.serialize(
      object.editHours,
      specifiedType: const FullType(int),
    );
    yield r'comment_max';
    yield serializers.serialize(
      object.commentMax,
      specifiedType: const FullType(int),
    );
    yield r'media_max';
    yield serializers.serialize(
      object.mediaMax,
      specifiedType: const FullType(int),
    );
    if (object.photoMaxBytes != null) {
      yield r'photo_max_bytes';
      yield serializers.serialize(
        object.photoMaxBytes,
        specifiedType: const FullType(int),
      );
    }
    if (object.videoMaxBytes != null) {
      yield r'video_max_bytes';
      yield serializers.serialize(
        object.videoMaxBytes,
        specifiedType: const FullType(int),
      );
    }
    yield r'blind_reveal';
    yield serializers.serialize(
      object.blindReveal,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ReviewWindowRules object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ReviewWindowRulesBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'window_days':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.windowDays = valueDes;
          break;
        case r'edit_hours':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.editHours = valueDes;
          break;
        case r'comment_max':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.commentMax = valueDes;
          break;
        case r'media_max':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.mediaMax = valueDes;
          break;
        case r'photo_max_bytes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.photoMaxBytes = valueDes;
          break;
        case r'video_max_bytes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.videoMaxBytes = valueDes;
          break;
        case r'blind_reveal':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.blindReveal = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ReviewWindowRules deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ReviewWindowRulesBuilder();
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


