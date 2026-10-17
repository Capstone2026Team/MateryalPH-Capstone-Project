//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/review_ratings.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/review_media_link.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'own_review.g.dart';

/// OwnReview
///
/// Properties:
/// * [id]
/// * [type]
/// * [ratings]
/// * [comment]
/// * [displayName]
/// * [submittedAt]
/// * [editableUntil]
/// * [editableUntilLabel]
/// * [canEdit]
/// * [correctionRequested]
/// * [correctionDueAt]
/// * [visibility]
/// * [revision]
/// * [lockVersion]
/// * [media]
@BuiltValue()
abstract class OwnReview implements Built<OwnReview, OwnReviewBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'type')
  OwnReviewTypeEnum get type;
  // enum typeEnum {  VENDOR,  PRODUCT,  BUYER,  };

  @BuiltValueField(wireName: r'ratings')
  ReviewRatings get ratings;

  @BuiltValueField(wireName: r'comment')
  String? get comment;

  @BuiltValueField(wireName: r'display_name')
  String get displayName;

  @BuiltValueField(wireName: r'submitted_at')
  DateTime? get submittedAt;

  @BuiltValueField(wireName: r'editable_until')
  DateTime? get editableUntil;

  @BuiltValueField(wireName: r'editable_until_label')
  String? get editableUntilLabel;

  @BuiltValueField(wireName: r'can_edit')
  bool get canEdit;

  @BuiltValueField(wireName: r'correction_requested')
  bool get correctionRequested;

  @BuiltValueField(wireName: r'correction_due_at')
  DateTime? get correctionDueAt;

  @BuiltValueField(wireName: r'visibility')
  OwnReviewVisibilityEnum get visibility;
  // enum visibilityEnum {  PUBLIC,  HIDDEN_UNTIL_REVEAL,  WITHHELD_ACTIVE_DISPUTE,  HIDDEN_BY_MODERATION,  REMOVED,  EXCLUDED_BY_INVESTIGATION,  };

  @BuiltValueField(wireName: r'revision')
  int get revision;

  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  @BuiltValueField(wireName: r'media')
  BuiltList<ReviewMediaLink> get media;

  OwnReview._();

  factory OwnReview([void updates(OwnReviewBuilder b)]) = _$OwnReview;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OwnReviewBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OwnReview> get serializer => _$OwnReviewSerializer();
}

class _$OwnReviewSerializer implements PrimitiveSerializer<OwnReview> {
  @override
  final Iterable<Type> types = const [OwnReview, _$OwnReview];

  @override
  final String wireName = r'OwnReview';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OwnReview object, {
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
      specifiedType: const FullType(OwnReviewTypeEnum),
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
    yield r'display_name';
    yield serializers.serialize(
      object.displayName,
      specifiedType: const FullType(String),
    );
    if (object.submittedAt != null) {
      yield r'submitted_at';
      yield serializers.serialize(
        object.submittedAt,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.editableUntil != null) {
      yield r'editable_until';
      yield serializers.serialize(
        object.editableUntil,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.editableUntilLabel != null) {
      yield r'editable_until_label';
      yield serializers.serialize(
        object.editableUntilLabel,
        specifiedType: const FullType(String),
      );
    }
    yield r'can_edit';
    yield serializers.serialize(
      object.canEdit,
      specifiedType: const FullType(bool),
    );
    yield r'correction_requested';
    yield serializers.serialize(
      object.correctionRequested,
      specifiedType: const FullType(bool),
    );
    if (object.correctionDueAt != null) {
      yield r'correction_due_at';
      yield serializers.serialize(
        object.correctionDueAt,
        specifiedType: const FullType(DateTime),
      );
    }
    yield r'visibility';
    yield serializers.serialize(
      object.visibility,
      specifiedType: const FullType(OwnReviewVisibilityEnum),
    );
    yield r'revision';
    yield serializers.serialize(
      object.revision,
      specifiedType: const FullType(int),
    );
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
    yield r'media';
    yield serializers.serialize(
      object.media,
      specifiedType: const FullType(BuiltList, [FullType(ReviewMediaLink)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    OwnReview object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OwnReviewBuilder result,
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
            specifiedType: const FullType(OwnReviewTypeEnum),
          ) as OwnReviewTypeEnum;
          result.type = valueDes;
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
        case r'display_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.displayName = valueDes;
          break;
        case r'submitted_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.submittedAt = valueDes;
          break;
        case r'editable_until':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.editableUntil = valueDes;
          break;
        case r'editable_until_label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.editableUntilLabel = valueDes;
          break;
        case r'can_edit':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.canEdit = valueDes;
          break;
        case r'correction_requested':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.correctionRequested = valueDes;
          break;
        case r'correction_due_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.correctionDueAt = valueDes;
          break;
        case r'visibility':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(OwnReviewVisibilityEnum),
          ) as OwnReviewVisibilityEnum;
          result.visibility = valueDes;
          break;
        case r'revision':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.revision = valueDes;
          break;
        case r'lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lockVersion = valueDes;
          break;
        case r'media':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ReviewMediaLink)]),
          ) as BuiltList<ReviewMediaLink>;
          result.media.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  OwnReview deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OwnReviewBuilder();
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


class OwnReviewTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'VENDOR')
  static const OwnReviewTypeEnum VENDOR = _$ownReviewTypeEnum_VENDOR;
  @BuiltValueEnumConst(wireName: r'PRODUCT')
  static const OwnReviewTypeEnum PRODUCT = _$ownReviewTypeEnum_PRODUCT;
  @BuiltValueEnumConst(wireName: r'BUYER')
  static const OwnReviewTypeEnum BUYER = _$ownReviewTypeEnum_BUYER;

  static Serializer<OwnReviewTypeEnum> get serializer => _$ownReviewTypeEnumSerializer;

  const OwnReviewTypeEnum._(String name): super(name);

  static BuiltSet<OwnReviewTypeEnum> get values => _$ownReviewTypeEnumValues;
  static OwnReviewTypeEnum valueOf(String name) => _$ownReviewTypeEnumValueOf(name);
}

class OwnReviewVisibilityEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PUBLIC')
  static const OwnReviewVisibilityEnum PUBLIC = _$ownReviewVisibilityEnum_PUBLIC;
  @BuiltValueEnumConst(wireName: r'HIDDEN_UNTIL_REVEAL')
  static const OwnReviewVisibilityEnum HIDDEN_UNTIL_REVEAL = _$ownReviewVisibilityEnum_HIDDEN_UNTIL_REVEAL;
  @BuiltValueEnumConst(wireName: r'WITHHELD_ACTIVE_DISPUTE')
  static const OwnReviewVisibilityEnum WITHHELD_ACTIVE_DISPUTE = _$ownReviewVisibilityEnum_WITHHELD_ACTIVE_DISPUTE;
  @BuiltValueEnumConst(wireName: r'HIDDEN_BY_MODERATION')
  static const OwnReviewVisibilityEnum HIDDEN_BY_MODERATION = _$ownReviewVisibilityEnum_HIDDEN_BY_MODERATION;
  @BuiltValueEnumConst(wireName: r'REMOVED')
  static const OwnReviewVisibilityEnum REMOVED = _$ownReviewVisibilityEnum_REMOVED;
  @BuiltValueEnumConst(wireName: r'EXCLUDED_BY_INVESTIGATION')
  static const OwnReviewVisibilityEnum EXCLUDED_BY_INVESTIGATION = _$ownReviewVisibilityEnum_EXCLUDED_BY_INVESTIGATION;

  static Serializer<OwnReviewVisibilityEnum> get serializer => _$ownReviewVisibilityEnumSerializer;

  const OwnReviewVisibilityEnum._(String name): super(name);

  static BuiltSet<OwnReviewVisibilityEnum> get values => _$ownReviewVisibilityEnumValues;
  static OwnReviewVisibilityEnum valueOf(String name) => _$ownReviewVisibilityEnumValueOf(name);
}

