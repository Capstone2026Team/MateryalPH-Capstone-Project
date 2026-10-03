//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'chat_attachment.g.dart';

/// ChatAttachment
///
/// Properties:
/// * [id]
/// * [displayName]
/// * [mediaType]
/// * [sizeBytes]
/// * [scanState]
@BuiltValue()
abstract class ChatAttachment implements Built<ChatAttachment, ChatAttachmentBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'display_name')
  String get displayName;

  @BuiltValueField(wireName: r'media_type')
  String get mediaType;

  @BuiltValueField(wireName: r'size_bytes')
  int get sizeBytes;

  @BuiltValueField(wireName: r'scan_state')
  ChatAttachmentScanStateEnum get scanState;
  // enum scanStateEnum {  PENDING,  CLEAN,  REJECTED,  FAILED,  };

  ChatAttachment._();

  factory ChatAttachment([void updates(ChatAttachmentBuilder b)]) = _$ChatAttachment;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ChatAttachmentBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ChatAttachment> get serializer => _$ChatAttachmentSerializer();
}

class _$ChatAttachmentSerializer implements PrimitiveSerializer<ChatAttachment> {
  @override
  final Iterable<Type> types = const [ChatAttachment, _$ChatAttachment];

  @override
  final String wireName = r'ChatAttachment';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ChatAttachment object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'display_name';
    yield serializers.serialize(
      object.displayName,
      specifiedType: const FullType(String),
    );
    yield r'media_type';
    yield serializers.serialize(
      object.mediaType,
      specifiedType: const FullType(String),
    );
    yield r'size_bytes';
    yield serializers.serialize(
      object.sizeBytes,
      specifiedType: const FullType(int),
    );
    yield r'scan_state';
    yield serializers.serialize(
      object.scanState,
      specifiedType: const FullType(ChatAttachmentScanStateEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ChatAttachment object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ChatAttachmentBuilder result,
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
        case r'display_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.displayName = valueDes;
          break;
        case r'media_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.mediaType = valueDes;
          break;
        case r'size_bytes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.sizeBytes = valueDes;
          break;
        case r'scan_state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ChatAttachmentScanStateEnum),
          ) as ChatAttachmentScanStateEnum;
          result.scanState = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ChatAttachment deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ChatAttachmentBuilder();
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


class ChatAttachmentScanStateEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PENDING')
  static const ChatAttachmentScanStateEnum PENDING = _$chatAttachmentScanStateEnum_PENDING;
  @BuiltValueEnumConst(wireName: r'CLEAN')
  static const ChatAttachmentScanStateEnum CLEAN = _$chatAttachmentScanStateEnum_CLEAN;
  @BuiltValueEnumConst(wireName: r'REJECTED')
  static const ChatAttachmentScanStateEnum REJECTED = _$chatAttachmentScanStateEnum_REJECTED;
  @BuiltValueEnumConst(wireName: r'FAILED')
  static const ChatAttachmentScanStateEnum FAILED = _$chatAttachmentScanStateEnum_FAILED;

  static Serializer<ChatAttachmentScanStateEnum> get serializer => _$chatAttachmentScanStateEnumSerializer;

  const ChatAttachmentScanStateEnum._(String name): super(name);

  static BuiltSet<ChatAttachmentScanStateEnum> get values => _$chatAttachmentScanStateEnumValues;
  static ChatAttachmentScanStateEnum valueOf(String name) => _$chatAttachmentScanStateEnumValueOf(name);
}

