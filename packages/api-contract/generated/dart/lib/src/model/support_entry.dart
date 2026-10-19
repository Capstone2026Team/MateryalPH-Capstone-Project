//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/support_attachment.dart';
import 'package:materyalph_api_client/src/model/support_entry_details.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'support_entry.g.dart';

/// SupportEntry
///
/// Properties:
/// * [id]
/// * [kind]
/// * [actorName]
/// * [actorRole]
/// * [body]
/// * [details]
/// * [createdAt]
/// * [attachments]
@BuiltValue()
abstract class SupportEntry implements Built<SupportEntry, SupportEntryBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'kind')
  SupportEntryKindEnum get kind;
  // enum kindEnum {  MESSAGE,  STATUS_CHANGED,  ASSIGNED,  };

  @BuiltValueField(wireName: r'actor_name')
  String get actorName;

  @BuiltValueField(wireName: r'actor_role')
  String get actorRole;

  @BuiltValueField(wireName: r'body')
  String get body;

  @BuiltValueField(wireName: r'details')
  SupportEntryDetails get details;

  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'attachments')
  BuiltList<SupportAttachment> get attachments;

  SupportEntry._();

  factory SupportEntry([void updates(SupportEntryBuilder b)]) = _$SupportEntry;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SupportEntryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SupportEntry> get serializer => _$SupportEntrySerializer();
}

class _$SupportEntrySerializer implements PrimitiveSerializer<SupportEntry> {
  @override
  final Iterable<Type> types = const [SupportEntry, _$SupportEntry];

  @override
  final String wireName = r'SupportEntry';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SupportEntry object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(SupportEntryKindEnum),
    );
    yield r'actor_name';
    yield serializers.serialize(
      object.actorName,
      specifiedType: const FullType(String),
    );
    yield r'actor_role';
    yield serializers.serialize(
      object.actorRole,
      specifiedType: const FullType(String),
    );
    yield r'body';
    yield serializers.serialize(
      object.body,
      specifiedType: const FullType(String),
    );
    yield r'details';
    yield serializers.serialize(
      object.details,
      specifiedType: const FullType(SupportEntryDetails),
    );
    yield r'created_at';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'attachments';
    yield serializers.serialize(
      object.attachments,
      specifiedType: const FullType(BuiltList, [FullType(SupportAttachment)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SupportEntry object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SupportEntryBuilder result,
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
        case r'kind':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SupportEntryKindEnum),
          ) as SupportEntryKindEnum;
          result.kind = valueDes;
          break;
        case r'actor_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.actorName = valueDes;
          break;
        case r'actor_role':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.actorRole = valueDes;
          break;
        case r'body':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.body = valueDes;
          break;
        case r'details':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SupportEntryDetails),
          ) as SupportEntryDetails;
          result.details.replace(valueDes);
          break;
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'attachments':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(SupportAttachment)]),
          ) as BuiltList<SupportAttachment>;
          result.attachments.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SupportEntry deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SupportEntryBuilder();
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


class SupportEntryKindEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'MESSAGE')
  static const SupportEntryKindEnum MESSAGE = _$supportEntryKindEnum_MESSAGE;
  @BuiltValueEnumConst(wireName: r'STATUS_CHANGED')
  static const SupportEntryKindEnum STATUS_CHANGED = _$supportEntryKindEnum_STATUS_CHANGED;
  @BuiltValueEnumConst(wireName: r'ASSIGNED')
  static const SupportEntryKindEnum ASSIGNED = _$supportEntryKindEnum_ASSIGNED;

  static Serializer<SupportEntryKindEnum> get serializer => _$supportEntryKindEnumSerializer;

  const SupportEntryKindEnum._(String name): super(name);

  static BuiltSet<SupportEntryKindEnum> get values => _$supportEntryKindEnumValues;
  static SupportEntryKindEnum valueOf(String name) => _$supportEntryKindEnumValueOf(name);
}

