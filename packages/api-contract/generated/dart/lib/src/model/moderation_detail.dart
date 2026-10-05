//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/review_ratings.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/review_media_link.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'moderation_detail.g.dart';

/// ModerationDetail
///
/// Properties:
/// * [id]
/// * [type]
/// * [ratings]
/// * [comment]
/// * [displayName]
/// * [moderationState]
/// * [reviewerParty]
/// * [displayNameChoice]
/// * [authorDisplayRule]
/// * [verifiedPurchase]
/// * [relatedDispute]
/// * [revisions]
/// * [flags]
/// * [history]
/// * [availableActions]
/// * [media]
/// * [lockVersion]
/// * [visibility]
@BuiltValue()
abstract class ModerationDetail implements Built<ModerationDetail, ModerationDetailBuilder> {
  @BuiltValueField(wireName: r'id')
  String? get id;

  @BuiltValueField(wireName: r'type')
  String? get type;

  @BuiltValueField(wireName: r'ratings')
  ReviewRatings? get ratings;

  @BuiltValueField(wireName: r'comment')
  String? get comment;

  @BuiltValueField(wireName: r'display_name')
  String? get displayName;

  @BuiltValueField(wireName: r'moderation_state')
  ModerationDetailModerationStateEnum? get moderationState;
  // enum moderationStateEnum {  NONE,  FLAGGED,  HIDDEN_PENDING_REVIEW,  CORRECTION_REQUESTED,  REMOVED,  };

  @BuiltValueField(wireName: r'reviewer_party')
  ModerationDetailReviewerPartyEnum? get reviewerParty;
  // enum reviewerPartyEnum {  BUYER,  VENDOR,  };

  @BuiltValueField(wireName: r'display_name_choice')
  String? get displayNameChoice;

  @BuiltValueField(wireName: r'author_display_rule')
  String? get authorDisplayRule;

  @BuiltValueField(wireName: r'verified_purchase')
  BuiltMap<String, JsonObject?>? get verifiedPurchase;

  @BuiltValueField(wireName: r'related_dispute')
  BuiltMap<String, JsonObject?>? get relatedDispute;

  @BuiltValueField(wireName: r'revisions')
  BuiltList<BuiltMap<String, JsonObject?>>? get revisions;

  @BuiltValueField(wireName: r'flags')
  BuiltList<BuiltMap<String, JsonObject?>>? get flags;

  @BuiltValueField(wireName: r'history')
  BuiltList<BuiltMap<String, JsonObject?>>? get history;

  @BuiltValueField(wireName: r'available_actions')
  BuiltList<ModerationDetailAvailableActionsEnum>? get availableActions;
  // enum availableActionsEnum {  DISMISS_FLAG,  REQUEST_CORRECTION,  HIDE_PENDING_REVIEW,  REMOVE,  RESTORE,  };

  @BuiltValueField(wireName: r'media')
  BuiltList<ReviewMediaLink>? get media;

  @BuiltValueField(wireName: r'lock_version')
  int? get lockVersion;

  @BuiltValueField(wireName: r'visibility')
  ModerationDetailVisibilityEnum? get visibility;
  // enum visibilityEnum {  PUBLIC,  HIDDEN_UNTIL_REVEAL,  WITHHELD_ACTIVE_DISPUTE,  HIDDEN_BY_MODERATION,  REMOVED,  EXCLUDED_BY_INVESTIGATION,  };

  ModerationDetail._();

  factory ModerationDetail([void updates(ModerationDetailBuilder b)]) = _$ModerationDetail;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ModerationDetailBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ModerationDetail> get serializer => _$ModerationDetailSerializer();
}

class _$ModerationDetailSerializer implements PrimitiveSerializer<ModerationDetail> {
  @override
  final Iterable<Type> types = const [ModerationDetail, _$ModerationDetail];

  @override
  final String wireName = r'ModerationDetail';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ModerationDetail object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType(String),
      );
    }
    if (object.type != null) {
      yield r'type';
      yield serializers.serialize(
        object.type,
        specifiedType: const FullType(String),
      );
    }
    if (object.ratings != null) {
      yield r'ratings';
      yield serializers.serialize(
        object.ratings,
        specifiedType: const FullType(ReviewRatings),
      );
    }
    if (object.comment != null) {
      yield r'comment';
      yield serializers.serialize(
        object.comment,
        specifiedType: const FullType(String),
      );
    }
    if (object.displayName != null) {
      yield r'display_name';
      yield serializers.serialize(
        object.displayName,
        specifiedType: const FullType(String),
      );
    }
    if (object.moderationState != null) {
      yield r'moderation_state';
      yield serializers.serialize(
        object.moderationState,
        specifiedType: const FullType(ModerationDetailModerationStateEnum),
      );
    }
    if (object.reviewerParty != null) {
      yield r'reviewer_party';
      yield serializers.serialize(
        object.reviewerParty,
        specifiedType: const FullType(ModerationDetailReviewerPartyEnum),
      );
    }
    if (object.displayNameChoice != null) {
      yield r'display_name_choice';
      yield serializers.serialize(
        object.displayNameChoice,
        specifiedType: const FullType(String),
      );
    }
    if (object.authorDisplayRule != null) {
      yield r'author_display_rule';
      yield serializers.serialize(
        object.authorDisplayRule,
        specifiedType: const FullType(String),
      );
    }
    if (object.verifiedPurchase != null) {
      yield r'verified_purchase';
      yield serializers.serialize(
        object.verifiedPurchase,
        specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
      );
    }
    if (object.relatedDispute != null) {
      yield r'related_dispute';
      yield serializers.serialize(
        object.relatedDispute,
        specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
      );
    }
    if (object.revisions != null) {
      yield r'revisions';
      yield serializers.serialize(
        object.revisions,
        specifiedType: const FullType(BuiltList, [FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)])]),
      );
    }
    if (object.flags != null) {
      yield r'flags';
      yield serializers.serialize(
        object.flags,
        specifiedType: const FullType(BuiltList, [FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)])]),
      );
    }
    if (object.history != null) {
      yield r'history';
      yield serializers.serialize(
        object.history,
        specifiedType: const FullType(BuiltList, [FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)])]),
      );
    }
    if (object.availableActions != null) {
      yield r'available_actions';
      yield serializers.serialize(
        object.availableActions,
        specifiedType: const FullType(BuiltList, [FullType(ModerationDetailAvailableActionsEnum)]),
      );
    }
    if (object.media != null) {
      yield r'media';
      yield serializers.serialize(
        object.media,
        specifiedType: const FullType(BuiltList, [FullType(ReviewMediaLink)]),
      );
    }
    if (object.lockVersion != null) {
      yield r'lock_version';
      yield serializers.serialize(
        object.lockVersion,
        specifiedType: const FullType(int),
      );
    }
    if (object.visibility != null) {
      yield r'visibility';
      yield serializers.serialize(
        object.visibility,
        specifiedType: const FullType(ModerationDetailVisibilityEnum),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ModerationDetail object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ModerationDetailBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.id = valueDes;
          break;
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.type = valueDes;
          break;
        case r'ratings':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ReviewRatings),
          ) as ReviewRatings?;
          if (valueDes == null) continue;
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
        case r'display_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.displayName = valueDes;
          break;
        case r'moderation_state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ModerationDetailModerationStateEnum),
          ) as ModerationDetailModerationStateEnum?;
          if (valueDes == null) continue;
          result.moderationState = valueDes;
          break;
        case r'reviewer_party':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ModerationDetailReviewerPartyEnum),
          ) as ModerationDetailReviewerPartyEnum?;
          if (valueDes == null) continue;
          result.reviewerParty = valueDes;
          break;
        case r'display_name_choice':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.displayNameChoice = valueDes;
          break;
        case r'author_display_rule':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.authorDisplayRule = valueDes;
          break;
        case r'verified_purchase':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>?;
          if (valueDes == null) continue;
          result.verifiedPurchase.replace(valueDes);
          break;
        case r'related_dispute':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>?;
          if (valueDes == null) continue;
          result.relatedDispute.replace(valueDes);
          break;
        case r'revisions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)])]),
          ) as BuiltList<BuiltMap<String, JsonObject?>>?;
          if (valueDes == null) continue;
          result.revisions.replace(valueDes);
          break;
        case r'flags':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)])]),
          ) as BuiltList<BuiltMap<String, JsonObject?>>?;
          if (valueDes == null) continue;
          result.flags.replace(valueDes);
          break;
        case r'history':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)])]),
          ) as BuiltList<BuiltMap<String, JsonObject?>>?;
          if (valueDes == null) continue;
          result.history.replace(valueDes);
          break;
        case r'available_actions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(ModerationDetailAvailableActionsEnum)]),
          ) as BuiltList<ModerationDetailAvailableActionsEnum>?;
          if (valueDes == null) continue;
          result.availableActions.replace(valueDes);
          break;
        case r'media':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(ReviewMediaLink)]),
          ) as BuiltList<ReviewMediaLink>?;
          if (valueDes == null) continue;
          result.media.replace(valueDes);
          break;
        case r'lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.lockVersion = valueDes;
          break;
        case r'visibility':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ModerationDetailVisibilityEnum),
          ) as ModerationDetailVisibilityEnum?;
          if (valueDes == null) continue;
          result.visibility = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ModerationDetail deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ModerationDetailBuilder();
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


class ModerationDetailModerationStateEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'NONE')
  static const ModerationDetailModerationStateEnum NONE = _$moderationDetailModerationStateEnum_NONE;
  @BuiltValueEnumConst(wireName: r'FLAGGED')
  static const ModerationDetailModerationStateEnum FLAGGED = _$moderationDetailModerationStateEnum_FLAGGED;
  @BuiltValueEnumConst(wireName: r'HIDDEN_PENDING_REVIEW')
  static const ModerationDetailModerationStateEnum HIDDEN_PENDING_REVIEW = _$moderationDetailModerationStateEnum_HIDDEN_PENDING_REVIEW;
  @BuiltValueEnumConst(wireName: r'CORRECTION_REQUESTED')
  static const ModerationDetailModerationStateEnum CORRECTION_REQUESTED = _$moderationDetailModerationStateEnum_CORRECTION_REQUESTED;
  @BuiltValueEnumConst(wireName: r'REMOVED')
  static const ModerationDetailModerationStateEnum REMOVED = _$moderationDetailModerationStateEnum_REMOVED;

  static Serializer<ModerationDetailModerationStateEnum> get serializer => _$moderationDetailModerationStateEnumSerializer;

  const ModerationDetailModerationStateEnum._(String name): super(name);

  static BuiltSet<ModerationDetailModerationStateEnum> get values => _$moderationDetailModerationStateEnumValues;
  static ModerationDetailModerationStateEnum valueOf(String name) => _$moderationDetailModerationStateEnumValueOf(name);
}

class ModerationDetailReviewerPartyEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'BUYER')
  static const ModerationDetailReviewerPartyEnum BUYER = _$moderationDetailReviewerPartyEnum_BUYER;
  @BuiltValueEnumConst(wireName: r'VENDOR')
  static const ModerationDetailReviewerPartyEnum VENDOR = _$moderationDetailReviewerPartyEnum_VENDOR;

  static Serializer<ModerationDetailReviewerPartyEnum> get serializer => _$moderationDetailReviewerPartyEnumSerializer;

  const ModerationDetailReviewerPartyEnum._(String name): super(name);

  static BuiltSet<ModerationDetailReviewerPartyEnum> get values => _$moderationDetailReviewerPartyEnumValues;
  static ModerationDetailReviewerPartyEnum valueOf(String name) => _$moderationDetailReviewerPartyEnumValueOf(name);
}

class ModerationDetailAvailableActionsEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DISMISS_FLAG')
  static const ModerationDetailAvailableActionsEnum DISMISS_FLAG = _$moderationDetailAvailableActionsEnum_DISMISS_FLAG;
  @BuiltValueEnumConst(wireName: r'REQUEST_CORRECTION')
  static const ModerationDetailAvailableActionsEnum REQUEST_CORRECTION = _$moderationDetailAvailableActionsEnum_REQUEST_CORRECTION;
  @BuiltValueEnumConst(wireName: r'HIDE_PENDING_REVIEW')
  static const ModerationDetailAvailableActionsEnum HIDE_PENDING_REVIEW = _$moderationDetailAvailableActionsEnum_HIDE_PENDING_REVIEW;
  @BuiltValueEnumConst(wireName: r'REMOVE')
  static const ModerationDetailAvailableActionsEnum REMOVE = _$moderationDetailAvailableActionsEnum_REMOVE;
  @BuiltValueEnumConst(wireName: r'RESTORE')
  static const ModerationDetailAvailableActionsEnum RESTORE = _$moderationDetailAvailableActionsEnum_RESTORE;

  static Serializer<ModerationDetailAvailableActionsEnum> get serializer => _$moderationDetailAvailableActionsEnumSerializer;

  const ModerationDetailAvailableActionsEnum._(String name): super(name);

  static BuiltSet<ModerationDetailAvailableActionsEnum> get values => _$moderationDetailAvailableActionsEnumValues;
  static ModerationDetailAvailableActionsEnum valueOf(String name) => _$moderationDetailAvailableActionsEnumValueOf(name);
}

class ModerationDetailVisibilityEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PUBLIC')
  static const ModerationDetailVisibilityEnum PUBLIC = _$moderationDetailVisibilityEnum_PUBLIC;
  @BuiltValueEnumConst(wireName: r'HIDDEN_UNTIL_REVEAL')
  static const ModerationDetailVisibilityEnum HIDDEN_UNTIL_REVEAL = _$moderationDetailVisibilityEnum_HIDDEN_UNTIL_REVEAL;
  @BuiltValueEnumConst(wireName: r'WITHHELD_ACTIVE_DISPUTE')
  static const ModerationDetailVisibilityEnum WITHHELD_ACTIVE_DISPUTE = _$moderationDetailVisibilityEnum_WITHHELD_ACTIVE_DISPUTE;
  @BuiltValueEnumConst(wireName: r'HIDDEN_BY_MODERATION')
  static const ModerationDetailVisibilityEnum HIDDEN_BY_MODERATION = _$moderationDetailVisibilityEnum_HIDDEN_BY_MODERATION;
  @BuiltValueEnumConst(wireName: r'REMOVED')
  static const ModerationDetailVisibilityEnum REMOVED = _$moderationDetailVisibilityEnum_REMOVED;
  @BuiltValueEnumConst(wireName: r'EXCLUDED_BY_INVESTIGATION')
  static const ModerationDetailVisibilityEnum EXCLUDED_BY_INVESTIGATION = _$moderationDetailVisibilityEnum_EXCLUDED_BY_INVESTIGATION;

  static Serializer<ModerationDetailVisibilityEnum> get serializer => _$moderationDetailVisibilityEnumSerializer;

  const ModerationDetailVisibilityEnum._(String name): super(name);

  static BuiltSet<ModerationDetailVisibilityEnum> get values => _$moderationDetailVisibilityEnumValues;
  static ModerationDetailVisibilityEnum valueOf(String name) => _$moderationDetailVisibilityEnumValueOf(name);
}

