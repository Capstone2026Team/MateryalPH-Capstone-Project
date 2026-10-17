//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'ready_mixed_concrete_open_inspection.g.dart';

/// ReadyMixedConcreteOpenInspection
///
/// Properties:
/// * [id]
/// * [status]
/// * [conversationId]
@BuiltValue()
abstract class ReadyMixedConcreteOpenInspection implements Built<ReadyMixedConcreteOpenInspection, ReadyMixedConcreteOpenInspectionBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'status')
  ReadyMixedConcreteOpenInspectionStatusEnum get status;
  // enum statusEnum {  REQUESTED,  SCHEDULED,  };

  @BuiltValueField(wireName: r'conversation_id')
  String get conversationId;

  ReadyMixedConcreteOpenInspection._();

  factory ReadyMixedConcreteOpenInspection([void updates(ReadyMixedConcreteOpenInspectionBuilder b)]) = _$ReadyMixedConcreteOpenInspection;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ReadyMixedConcreteOpenInspectionBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ReadyMixedConcreteOpenInspection> get serializer => _$ReadyMixedConcreteOpenInspectionSerializer();
}

class _$ReadyMixedConcreteOpenInspectionSerializer implements PrimitiveSerializer<ReadyMixedConcreteOpenInspection> {
  @override
  final Iterable<Type> types = const [ReadyMixedConcreteOpenInspection, _$ReadyMixedConcreteOpenInspection];

  @override
  final String wireName = r'ReadyMixedConcreteOpenInspection';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ReadyMixedConcreteOpenInspection object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(ReadyMixedConcreteOpenInspectionStatusEnum),
    );
    yield r'conversation_id';
    yield serializers.serialize(
      object.conversationId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ReadyMixedConcreteOpenInspection object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ReadyMixedConcreteOpenInspectionBuilder result,
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
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ReadyMixedConcreteOpenInspectionStatusEnum),
          ) as ReadyMixedConcreteOpenInspectionStatusEnum;
          result.status = valueDes;
          break;
        case r'conversation_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.conversationId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ReadyMixedConcreteOpenInspection deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ReadyMixedConcreteOpenInspectionBuilder();
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


class ReadyMixedConcreteOpenInspectionStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'REQUESTED')
  static const ReadyMixedConcreteOpenInspectionStatusEnum REQUESTED = _$readyMixedConcreteOpenInspectionStatusEnum_REQUESTED;
  @BuiltValueEnumConst(wireName: r'SCHEDULED')
  static const ReadyMixedConcreteOpenInspectionStatusEnum SCHEDULED = _$readyMixedConcreteOpenInspectionStatusEnum_SCHEDULED;

  static Serializer<ReadyMixedConcreteOpenInspectionStatusEnum> get serializer => _$readyMixedConcreteOpenInspectionStatusEnumSerializer;

  const ReadyMixedConcreteOpenInspectionStatusEnum._(String name): super(name);

  static BuiltSet<ReadyMixedConcreteOpenInspectionStatusEnum> get values => _$readyMixedConcreteOpenInspectionStatusEnumValues;
  static ReadyMixedConcreteOpenInspectionStatusEnum valueOf(String name) => _$readyMixedConcreteOpenInspectionStatusEnumValueOf(name);
}

