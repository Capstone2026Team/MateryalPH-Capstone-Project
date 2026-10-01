//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/chat_quotation_content.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'chat_quotation_version.g.dart';

/// ChatQuotationVersion
///
/// Properties:
/// * [id]
/// * [version]
/// * [latest]
/// * [state]
/// * [publishedAt]
/// * [expiresAt]
/// * [contentHash]
/// * [content]
/// * [viewed]
/// * [actions]
@BuiltValue()
abstract class ChatQuotationVersion implements Built<ChatQuotationVersion, ChatQuotationVersionBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'version')
  int get version;

  @BuiltValueField(wireName: r'latest')
  bool get latest;

  @BuiltValueField(wireName: r'state')
  String get state;

  @BuiltValueField(wireName: r'published_at')
  String get publishedAt;

  @BuiltValueField(wireName: r'expires_at')
  String get expiresAt;

  @BuiltValueField(wireName: r'content_hash')
  String get contentHash;

  @BuiltValueField(wireName: r'content')
  ChatQuotationContent get content;

  @BuiltValueField(wireName: r'viewed')
  bool get viewed;

  @BuiltValueField(wireName: r'actions')
  BuiltList<String> get actions;

  ChatQuotationVersion._();

  factory ChatQuotationVersion([void updates(ChatQuotationVersionBuilder b)]) = _$ChatQuotationVersion;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ChatQuotationVersionBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ChatQuotationVersion> get serializer => _$ChatQuotationVersionSerializer();
}

class _$ChatQuotationVersionSerializer implements PrimitiveSerializer<ChatQuotationVersion> {
  @override
  final Iterable<Type> types = const [ChatQuotationVersion, _$ChatQuotationVersion];

  @override
  final String wireName = r'ChatQuotationVersion';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ChatQuotationVersion object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'version';
    yield serializers.serialize(
      object.version,
      specifiedType: const FullType(int),
    );
    yield r'latest';
    yield serializers.serialize(
      object.latest,
      specifiedType: const FullType(bool),
    );
    yield r'state';
    yield serializers.serialize(
      object.state,
      specifiedType: const FullType(String),
    );
    yield r'published_at';
    yield serializers.serialize(
      object.publishedAt,
      specifiedType: const FullType(String),
    );
    yield r'expires_at';
    yield serializers.serialize(
      object.expiresAt,
      specifiedType: const FullType(String),
    );
    yield r'content_hash';
    yield serializers.serialize(
      object.contentHash,
      specifiedType: const FullType(String),
    );
    yield r'content';
    yield serializers.serialize(
      object.content,
      specifiedType: const FullType(ChatQuotationContent),
    );
    yield r'viewed';
    yield serializers.serialize(
      object.viewed,
      specifiedType: const FullType(bool),
    );
    yield r'actions';
    yield serializers.serialize(
      object.actions,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ChatQuotationVersion object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ChatQuotationVersionBuilder result,
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
        case r'version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.version = valueDes;
          break;
        case r'latest':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.latest = valueDes;
          break;
        case r'state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.state = valueDes;
          break;
        case r'published_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.publishedAt = valueDes;
          break;
        case r'expires_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.expiresAt = valueDes;
          break;
        case r'content_hash':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.contentHash = valueDes;
          break;
        case r'content':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ChatQuotationContent),
          ) as ChatQuotationContent;
          result.content.replace(valueDes);
          break;
        case r'viewed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.viewed = valueDes;
          break;
        case r'actions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.actions.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ChatQuotationVersion deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ChatQuotationVersionBuilder();
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


