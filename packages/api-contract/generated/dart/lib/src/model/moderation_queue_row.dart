//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/review_ratings.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'moderation_queue_row.g.dart';

/// ModerationQueueRow
///
/// Properties:
/// * [id]
/// * [type]
/// * [moderationState]
/// * [orderReference]
/// * [storeName]
/// * [displayName]
/// * [ratings]
/// * [comment]
/// * [openFlags]
/// * [submittedAt]
/// * [updatedAt]
@BuiltValue()
abstract class ModerationQueueRow implements Built<ModerationQueueRow, ModerationQueueRowBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'type')
  ModerationQueueRowTypeEnum get type;
  // enum typeEnum {  VENDOR,  PRODUCT,  BUYER,  };

  @BuiltValueField(wireName: r'moderation_state')
  ModerationQueueRowModerationStateEnum get moderationState;
  // enum moderationStateEnum {  NONE,  FLAGGED,  HIDDEN_PENDING_REVIEW,  CORRECTION_REQUESTED,  REMOVED,  };

  @BuiltValueField(wireName: r'order_reference')
  String get orderReference;

  @BuiltValueField(wireName: r'store_name')
  String get storeName;

  @BuiltValueField(wireName: r'display_name')
  String get displayName;

  @BuiltValueField(wireName: r'ratings')
  ReviewRatings get ratings;

  @BuiltValueField(wireName: r'comment')
  String? get comment;

  @BuiltValueField(wireName: r'open_flags')
  int get openFlags;

  @BuiltValueField(wireName: r'submitted_at')
  DateTime? get submittedAt;

  @BuiltValueField(wireName: r'updated_at')
  DateTime? get updatedAt;

  ModerationQueueRow._();

  factory ModerationQueueRow([void updates(ModerationQueueRowBuilder b)]) = _$ModerationQueueRow;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ModerationQueueRowBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ModerationQueueRow> get serializer => _$ModerationQueueRowSerializer();
}

class _$ModerationQueueRowSerializer implements PrimitiveSerializer<ModerationQueueRow> {
  @override
  final Iterable<Type> types = const [ModerationQueueRow, _$ModerationQueueRow];

  @override
  final String wireName = r'ModerationQueueRow';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ModerationQueueRow object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(ModerationQueueRowTypeEnum),
    );
    yield r'moderation_state';
    yield serializers.serialize(
      object.moderationState,
      specifiedType: const FullType(ModerationQueueRowModerationStateEnum),
    );
    yield r'order_reference';
    yield serializers.serialize(
      object.orderReference,
      specifiedType: const FullType(String),
    );
    yield r'store_name';
    yield serializers.serialize(
      object.storeName,
      specifiedType: const FullType(String),
    );
    yield r'display_name';
    yield serializers.serialize(
      object.displayName,
      specifiedType: const FullType(String),
    );
    yield r'ratings';
    yield serializers.serialize(
      object.ratings,
      specifiedType: const FullType(ReviewRatings),
    );
    if (object.comment != null) {
      yield r'comment';
      yield serializers.serialize(
        object.comment,
        specifiedType: const FullType(String),
      );
    }
    yield r'open_flags';
    yield serializers.serialize(
      object.openFlags,
      specifiedType: const FullType(int),
    );
    if (object.submittedAt != null) {
      yield r'submitted_at';
      yield serializers.serialize(
        object.submittedAt,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.updatedAt != null) {
      yield r'updated_at';
      yield serializers.serialize(
        object.updatedAt,
        specifiedType: const FullType(DateTime),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ModerationQueueRow object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ModerationQueueRowBuilder result,
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
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ModerationQueueRowTypeEnum),
          ) as ModerationQueueRowTypeEnum;
          result.type = valueDes;
          break;
        case r'moderation_state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ModerationQueueRowModerationStateEnum),
          ) as ModerationQueueRowModerationStateEnum;
          result.moderationState = valueDes;
          break;
        case r'order_reference':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.orderReference = valueDes;
          break;
        case r'store_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.storeName = valueDes;
          break;
        case r'display_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.displayName = valueDes;
          break;
        case r'ratings':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ReviewRatings),
          ) as ReviewRatings;
          result.ratings.replace(valueDes);
          break;
        case r'comment':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.comment = valueDes;
          break;
        case r'open_flags':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.openFlags = valueDes;
          break;
        case r'submitted_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.submittedAt = valueDes;
          break;
        case r'updated_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
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
  ModerationQueueRow deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ModerationQueueRowBuilder();
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


class ModerationQueueRowTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'VENDOR')
  static const ModerationQueueRowTypeEnum VENDOR = _$moderationQueueRowTypeEnum_VENDOR;
  @BuiltValueEnumConst(wireName: r'PRODUCT')
  static const ModerationQueueRowTypeEnum PRODUCT = _$moderationQueueRowTypeEnum_PRODUCT;
  @BuiltValueEnumConst(wireName: r'BUYER')
  static const ModerationQueueRowTypeEnum BUYER = _$moderationQueueRowTypeEnum_BUYER;

  static Serializer<ModerationQueueRowTypeEnum> get serializer => _$moderationQueueRowTypeEnumSerializer;

  const ModerationQueueRowTypeEnum._(String name): super(name);

  static BuiltSet<ModerationQueueRowTypeEnum> get values => _$moderationQueueRowTypeEnumValues;
  static ModerationQueueRowTypeEnum valueOf(String name) => _$moderationQueueRowTypeEnumValueOf(name);
}

class ModerationQueueRowModerationStateEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'NONE')
  static const ModerationQueueRowModerationStateEnum NONE = _$moderationQueueRowModerationStateEnum_NONE;
  @BuiltValueEnumConst(wireName: r'FLAGGED')
  static const ModerationQueueRowModerationStateEnum FLAGGED = _$moderationQueueRowModerationStateEnum_FLAGGED;
  @BuiltValueEnumConst(wireName: r'HIDDEN_PENDING_REVIEW')
  static const ModerationQueueRowModerationStateEnum HIDDEN_PENDING_REVIEW = _$moderationQueueRowModerationStateEnum_HIDDEN_PENDING_REVIEW;
  @BuiltValueEnumConst(wireName: r'CORRECTION_REQUESTED')
  static const ModerationQueueRowModerationStateEnum CORRECTION_REQUESTED = _$moderationQueueRowModerationStateEnum_CORRECTION_REQUESTED;
  @BuiltValueEnumConst(wireName: r'REMOVED')
  static const ModerationQueueRowModerationStateEnum REMOVED = _$moderationQueueRowModerationStateEnum_REMOVED;

  static Serializer<ModerationQueueRowModerationStateEnum> get serializer => _$moderationQueueRowModerationStateEnumSerializer;

  const ModerationQueueRowModerationStateEnum._(String name): super(name);

  static BuiltSet<ModerationQueueRowModerationStateEnum> get values => _$moderationQueueRowModerationStateEnumValues;
  static ModerationQueueRowModerationStateEnum valueOf(String name) => _$moderationQueueRowModerationStateEnumValueOf(name);
}

