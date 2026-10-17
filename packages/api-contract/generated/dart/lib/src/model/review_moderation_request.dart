//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'review_moderation_request.g.dart';

/// There is no delete action. Request Correction hides the review and gives its author one correction within 7 days.
///
/// Properties:
/// * [action]
/// * [reason]
/// * [lockVersion]
@BuiltValue()
abstract class ReviewModerationRequest implements Built<ReviewModerationRequest, ReviewModerationRequestBuilder> {
  @BuiltValueField(wireName: r'action')
  ReviewModerationRequestActionEnum get action;
  // enum actionEnum {  DISMISS_FLAG,  REQUEST_CORRECTION,  HIDE_PENDING_REVIEW,  REMOVE,  RESTORE,  };

  @BuiltValueField(wireName: r'reason')
  String get reason;

  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  ReviewModerationRequest._();

  factory ReviewModerationRequest([void updates(ReviewModerationRequestBuilder b)]) = _$ReviewModerationRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ReviewModerationRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ReviewModerationRequest> get serializer => _$ReviewModerationRequestSerializer();
}

class _$ReviewModerationRequestSerializer implements PrimitiveSerializer<ReviewModerationRequest> {
  @override
  final Iterable<Type> types = const [ReviewModerationRequest, _$ReviewModerationRequest];

  @override
  final String wireName = r'ReviewModerationRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ReviewModerationRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'action';
    yield serializers.serialize(
      object.action,
      specifiedType: const FullType(ReviewModerationRequestActionEnum),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
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
    ReviewModerationRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ReviewModerationRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'action':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ReviewModerationRequestActionEnum),
          ) as ReviewModerationRequestActionEnum;
          result.action = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reason = valueDes;
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
  ReviewModerationRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ReviewModerationRequestBuilder();
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


class ReviewModerationRequestActionEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DISMISS_FLAG')
  static const ReviewModerationRequestActionEnum DISMISS_FLAG = _$reviewModerationRequestActionEnum_DISMISS_FLAG;
  @BuiltValueEnumConst(wireName: r'REQUEST_CORRECTION')
  static const ReviewModerationRequestActionEnum REQUEST_CORRECTION = _$reviewModerationRequestActionEnum_REQUEST_CORRECTION;
  @BuiltValueEnumConst(wireName: r'HIDE_PENDING_REVIEW')
  static const ReviewModerationRequestActionEnum HIDE_PENDING_REVIEW = _$reviewModerationRequestActionEnum_HIDE_PENDING_REVIEW;
  @BuiltValueEnumConst(wireName: r'REMOVE')
  static const ReviewModerationRequestActionEnum REMOVE = _$reviewModerationRequestActionEnum_REMOVE;
  @BuiltValueEnumConst(wireName: r'RESTORE')
  static const ReviewModerationRequestActionEnum RESTORE = _$reviewModerationRequestActionEnum_RESTORE;

  static Serializer<ReviewModerationRequestActionEnum> get serializer => _$reviewModerationRequestActionEnumSerializer;

  const ReviewModerationRequestActionEnum._(String name): super(name);

  static BuiltSet<ReviewModerationRequestActionEnum> get values => _$reviewModerationRequestActionEnumValues;
  static ReviewModerationRequestActionEnum valueOf(String name) => _$reviewModerationRequestActionEnumValueOf(name);
}

