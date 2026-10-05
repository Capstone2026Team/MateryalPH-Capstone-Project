//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'score_exclusion_request.g.dart';

/// ScoreExclusionRequest
///
/// Properties:
/// * [orderId]
/// * [reasonCode]
/// * [note]
@BuiltValue()
abstract class ScoreExclusionRequest implements Built<ScoreExclusionRequest, ScoreExclusionRequestBuilder> {
  @BuiltValueField(wireName: r'order_id')
  String get orderId;

  @BuiltValueField(wireName: r'reason_code')
  ScoreExclusionRequestReasonCodeEnum get reasonCode;
  // enum reasonCodeEnum {  FRAUD,  DUPLICATE,  TEST,  INVALID_SOURCE,  };

  @BuiltValueField(wireName: r'note')
  String get note;

  ScoreExclusionRequest._();

  factory ScoreExclusionRequest([void updates(ScoreExclusionRequestBuilder b)]) = _$ScoreExclusionRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ScoreExclusionRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ScoreExclusionRequest> get serializer => _$ScoreExclusionRequestSerializer();
}

class _$ScoreExclusionRequestSerializer implements PrimitiveSerializer<ScoreExclusionRequest> {
  @override
  final Iterable<Type> types = const [ScoreExclusionRequest, _$ScoreExclusionRequest];

  @override
  final String wireName = r'ScoreExclusionRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ScoreExclusionRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'order_id';
    yield serializers.serialize(
      object.orderId,
      specifiedType: const FullType(String),
    );
    yield r'reason_code';
    yield serializers.serialize(
      object.reasonCode,
      specifiedType: const FullType(ScoreExclusionRequestReasonCodeEnum),
    );
    yield r'note';
    yield serializers.serialize(
      object.note,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ScoreExclusionRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ScoreExclusionRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'order_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.orderId = valueDes;
          break;
        case r'reason_code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ScoreExclusionRequestReasonCodeEnum),
          ) as ScoreExclusionRequestReasonCodeEnum;
          result.reasonCode = valueDes;
          break;
        case r'note':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.note = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ScoreExclusionRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ScoreExclusionRequestBuilder();
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


class ScoreExclusionRequestReasonCodeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'FRAUD')
  static const ScoreExclusionRequestReasonCodeEnum FRAUD = _$scoreExclusionRequestReasonCodeEnum_FRAUD;
  @BuiltValueEnumConst(wireName: r'DUPLICATE')
  static const ScoreExclusionRequestReasonCodeEnum DUPLICATE = _$scoreExclusionRequestReasonCodeEnum_DUPLICATE;
  @BuiltValueEnumConst(wireName: r'TEST')
  static const ScoreExclusionRequestReasonCodeEnum TEST = _$scoreExclusionRequestReasonCodeEnum_TEST;
  @BuiltValueEnumConst(wireName: r'INVALID_SOURCE')
  static const ScoreExclusionRequestReasonCodeEnum INVALID_SOURCE = _$scoreExclusionRequestReasonCodeEnum_INVALID_SOURCE;

  static Serializer<ScoreExclusionRequestReasonCodeEnum> get serializer => _$scoreExclusionRequestReasonCodeEnumSerializer;

  const ScoreExclusionRequestReasonCodeEnum._(String name): super(name);

  static BuiltSet<ScoreExclusionRequestReasonCodeEnum> get values => _$scoreExclusionRequestReasonCodeEnumValues;
  static ScoreExclusionRequestReasonCodeEnum valueOf(String name) => _$scoreExclusionRequestReasonCodeEnumValueOf(name);
}

