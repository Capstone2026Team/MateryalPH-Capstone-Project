//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'nrpc_flag.g.dart';

/// NrpcFlag
///
/// Properties:
/// * [reviewState]
/// * [reason]
/// * [flaggedAt]
@BuiltValue()
abstract class NrpcFlag implements Built<NrpcFlag, NrpcFlagBuilder> {
  @BuiltValueField(wireName: r'review_state')
  NrpcFlagReviewStateEnum get reviewState;
  // enum reviewStateEnum {  PENDING_ADMIN_REVIEW,  };

  @BuiltValueField(wireName: r'reason')
  String get reason;

  @BuiltValueField(wireName: r'flagged_at')
  DateTime? get flaggedAt;

  NrpcFlag._();

  factory NrpcFlag([void updates(NrpcFlagBuilder b)]) = _$NrpcFlag;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(NrpcFlagBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<NrpcFlag> get serializer => _$NrpcFlagSerializer();
}

class _$NrpcFlagSerializer implements PrimitiveSerializer<NrpcFlag> {
  @override
  final Iterable<Type> types = const [NrpcFlag, _$NrpcFlag];

  @override
  final String wireName = r'NrpcFlag';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    NrpcFlag object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'review_state';
    yield serializers.serialize(
      object.reviewState,
      specifiedType: const FullType(NrpcFlagReviewStateEnum),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
    yield r'flagged_at';
    yield object.flaggedAt == null ? null : serializers.serialize(
      object.flaggedAt,
      specifiedType: const FullType.nullable(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    NrpcFlag object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required NrpcFlagBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'review_state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(NrpcFlagReviewStateEnum),
          ) as NrpcFlagReviewStateEnum;
          result.reviewState = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reason = valueDes;
          break;
        case r'flagged_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.flaggedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  NrpcFlag deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = NrpcFlagBuilder();
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


class NrpcFlagReviewStateEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PENDING_ADMIN_REVIEW')
  static const NrpcFlagReviewStateEnum PENDING_ADMIN_REVIEW = _$nrpcFlagReviewStateEnum_PENDING_ADMIN_REVIEW;

  static Serializer<NrpcFlagReviewStateEnum> get serializer => _$nrpcFlagReviewStateEnumSerializer;

  const NrpcFlagReviewStateEnum._(String name): super(name);

  static BuiltSet<NrpcFlagReviewStateEnum> get values => _$nrpcFlagReviewStateEnumValues;
  static NrpcFlagReviewStateEnum valueOf(String name) => _$nrpcFlagReviewStateEnumValueOf(name);
}

