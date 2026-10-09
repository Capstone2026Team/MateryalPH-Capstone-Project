//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'review_media_link.g.dart';

/// A five-minute signed link; the fetch re-authorizes the caller.
///
/// Properties:
/// * [id]
/// * [url]
/// * [expiresAt]
/// * [contentType]
/// * [byteSize]
@BuiltValue()
abstract class ReviewMediaLink implements Built<ReviewMediaLink, ReviewMediaLinkBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'url')
  String get url;

  @BuiltValueField(wireName: r'expires_at')
  DateTime get expiresAt;

  @BuiltValueField(wireName: r'content_type')
  ReviewMediaLinkContentTypeEnum? get contentType;
  // enum contentTypeEnum {  image/jpeg,  image/png,  video/mp4,  video/quicktime,  };

  @BuiltValueField(wireName: r'byte_size')
  int? get byteSize;

  ReviewMediaLink._();

  factory ReviewMediaLink([void updates(ReviewMediaLinkBuilder b)]) = _$ReviewMediaLink;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ReviewMediaLinkBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ReviewMediaLink> get serializer => _$ReviewMediaLinkSerializer();
}

class _$ReviewMediaLinkSerializer implements PrimitiveSerializer<ReviewMediaLink> {
  @override
  final Iterable<Type> types = const [ReviewMediaLink, _$ReviewMediaLink];

  @override
  final String wireName = r'ReviewMediaLink';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ReviewMediaLink object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'url';
    yield serializers.serialize(
      object.url,
      specifiedType: const FullType(String),
    );
    yield r'expires_at';
    yield serializers.serialize(
      object.expiresAt,
      specifiedType: const FullType(DateTime),
    );
    if (object.contentType != null) {
      yield r'content_type';
      yield serializers.serialize(
        object.contentType,
        specifiedType: const FullType(ReviewMediaLinkContentTypeEnum),
      );
    }
    if (object.byteSize != null) {
      yield r'byte_size';
      yield serializers.serialize(
        object.byteSize,
        specifiedType: const FullType(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ReviewMediaLink object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ReviewMediaLinkBuilder result,
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
        case r'url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.url = valueDes;
          break;
        case r'expires_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.expiresAt = valueDes;
          break;
        case r'content_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ReviewMediaLinkContentTypeEnum),
          ) as ReviewMediaLinkContentTypeEnum?;
          if (valueDes == null) continue;
          result.contentType = valueDes;
          break;
        case r'byte_size':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.byteSize = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ReviewMediaLink deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ReviewMediaLinkBuilder();
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


class ReviewMediaLinkContentTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'image/jpeg')
  static const ReviewMediaLinkContentTypeEnum imageSlashJpeg = _$reviewMediaLinkContentTypeEnum_imageSlashJpeg;
  @BuiltValueEnumConst(wireName: r'image/png')
  static const ReviewMediaLinkContentTypeEnum imageSlashPng = _$reviewMediaLinkContentTypeEnum_imageSlashPng;
  @BuiltValueEnumConst(wireName: r'video/mp4')
  static const ReviewMediaLinkContentTypeEnum videoSlashMp4 = _$reviewMediaLinkContentTypeEnum_videoSlashMp4;
  @BuiltValueEnumConst(wireName: r'video/quicktime')
  static const ReviewMediaLinkContentTypeEnum videoSlashQuicktime = _$reviewMediaLinkContentTypeEnum_videoSlashQuicktime;

  static Serializer<ReviewMediaLinkContentTypeEnum> get serializer => _$reviewMediaLinkContentTypeEnumSerializer;

  const ReviewMediaLinkContentTypeEnum._(String name): super(name);

  static BuiltSet<ReviewMediaLinkContentTypeEnum> get values => _$reviewMediaLinkContentTypeEnumValues;
  static ReviewMediaLinkContentTypeEnum valueOf(String name) => _$reviewMediaLinkContentTypeEnumValueOf(name);
}

