//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'review_flag_request.g.dart';

/// ReviewFlagRequest
///
/// Properties:
/// * [reasonCode]
/// * [details]
@BuiltValue()
abstract class ReviewFlagRequest implements Built<ReviewFlagRequest, ReviewFlagRequestBuilder> {
  @BuiltValueField(wireName: r'reason_code')
  ReviewFlagRequestReasonCodeEnum get reasonCode;
  // enum reasonCodeEnum {  OFFENSIVE,  PERSONAL_INFORMATION,  SPAM,  IRRELEVANT,  CONFLICT_OF_INTEREST,  FALSE_CLAIM,  OTHER,  };

  @BuiltValueField(wireName: r'details')
  String? get details;

  ReviewFlagRequest._();

  factory ReviewFlagRequest([void updates(ReviewFlagRequestBuilder b)]) = _$ReviewFlagRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ReviewFlagRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ReviewFlagRequest> get serializer => _$ReviewFlagRequestSerializer();
}

class _$ReviewFlagRequestSerializer implements PrimitiveSerializer<ReviewFlagRequest> {
  @override
  final Iterable<Type> types = const [ReviewFlagRequest, _$ReviewFlagRequest];

  @override
  final String wireName = r'ReviewFlagRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ReviewFlagRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'reason_code';
    yield serializers.serialize(
      object.reasonCode,
      specifiedType: const FullType(ReviewFlagRequestReasonCodeEnum),
    );
    if (object.details != null) {
      yield r'details';
      yield serializers.serialize(
        object.details,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ReviewFlagRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ReviewFlagRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'reason_code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ReviewFlagRequestReasonCodeEnum),
          ) as ReviewFlagRequestReasonCodeEnum;
          result.reasonCode = valueDes;
          break;
        case r'details':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.details = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ReviewFlagRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ReviewFlagRequestBuilder();
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


class ReviewFlagRequestReasonCodeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'OFFENSIVE')
  static const ReviewFlagRequestReasonCodeEnum OFFENSIVE = _$reviewFlagRequestReasonCodeEnum_OFFENSIVE;
  @BuiltValueEnumConst(wireName: r'PERSONAL_INFORMATION')
  static const ReviewFlagRequestReasonCodeEnum PERSONAL_INFORMATION = _$reviewFlagRequestReasonCodeEnum_PERSONAL_INFORMATION;
  @BuiltValueEnumConst(wireName: r'SPAM')
  static const ReviewFlagRequestReasonCodeEnum SPAM = _$reviewFlagRequestReasonCodeEnum_SPAM;
  @BuiltValueEnumConst(wireName: r'IRRELEVANT')
  static const ReviewFlagRequestReasonCodeEnum IRRELEVANT = _$reviewFlagRequestReasonCodeEnum_IRRELEVANT;
  @BuiltValueEnumConst(wireName: r'CONFLICT_OF_INTEREST')
  static const ReviewFlagRequestReasonCodeEnum CONFLICT_OF_INTEREST = _$reviewFlagRequestReasonCodeEnum_CONFLICT_OF_INTEREST;
  @BuiltValueEnumConst(wireName: r'FALSE_CLAIM')
  static const ReviewFlagRequestReasonCodeEnum FALSE_CLAIM = _$reviewFlagRequestReasonCodeEnum_FALSE_CLAIM;
  @BuiltValueEnumConst(wireName: r'OTHER')
  static const ReviewFlagRequestReasonCodeEnum OTHER = _$reviewFlagRequestReasonCodeEnum_OTHER;

  static Serializer<ReviewFlagRequestReasonCodeEnum> get serializer => _$reviewFlagRequestReasonCodeEnumSerializer;

  const ReviewFlagRequestReasonCodeEnum._(String name): super(name);

  static BuiltSet<ReviewFlagRequestReasonCodeEnum> get values => _$reviewFlagRequestReasonCodeEnumValues;
  static ReviewFlagRequestReasonCodeEnum valueOf(String name) => _$reviewFlagRequestReasonCodeEnumValueOf(name);
}

