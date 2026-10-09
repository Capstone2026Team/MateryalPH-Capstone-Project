//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'operation_retry_record.g.dart';

/// OperationRetryRecord
///
/// Properties:
/// * [targetType]
/// * [label]
/// * [reason]
/// * [outcome]
/// * [actor]
/// * [actorRole]
/// * [correlationId]
/// * [createdAt]
@BuiltValue()
abstract class OperationRetryRecord implements Built<OperationRetryRecord, OperationRetryRecordBuilder> {
  @BuiltValueField(wireName: r'target_type')
  String get targetType;

  @BuiltValueField(wireName: r'label')
  String get label;

  @BuiltValueField(wireName: r'reason')
  String get reason;

  @BuiltValueField(wireName: r'outcome')
  String get outcome;

  @BuiltValueField(wireName: r'actor')
  String get actor;

  @BuiltValueField(wireName: r'actor_role')
  String get actorRole;

  @BuiltValueField(wireName: r'correlation_id')
  String get correlationId;

  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  OperationRetryRecord._();

  factory OperationRetryRecord([void updates(OperationRetryRecordBuilder b)]) = _$OperationRetryRecord;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OperationRetryRecordBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OperationRetryRecord> get serializer => _$OperationRetryRecordSerializer();
}

class _$OperationRetryRecordSerializer implements PrimitiveSerializer<OperationRetryRecord> {
  @override
  final Iterable<Type> types = const [OperationRetryRecord, _$OperationRetryRecord];

  @override
  final String wireName = r'OperationRetryRecord';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OperationRetryRecord object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'target_type';
    yield serializers.serialize(
      object.targetType,
      specifiedType: const FullType(String),
    );
    yield r'label';
    yield serializers.serialize(
      object.label,
      specifiedType: const FullType(String),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
    yield r'outcome';
    yield serializers.serialize(
      object.outcome,
      specifiedType: const FullType(String),
    );
    yield r'actor';
    yield serializers.serialize(
      object.actor,
      specifiedType: const FullType(String),
    );
    yield r'actor_role';
    yield serializers.serialize(
      object.actorRole,
      specifiedType: const FullType(String),
    );
    yield r'correlation_id';
    yield serializers.serialize(
      object.correlationId,
      specifiedType: const FullType(String),
    );
    yield r'created_at';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    OperationRetryRecord object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OperationRetryRecordBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'target_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.targetType = valueDes;
          break;
        case r'label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.label = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reason = valueDes;
          break;
        case r'outcome':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.outcome = valueDes;
          break;
        case r'actor':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.actor = valueDes;
          break;
        case r'actor_role':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.actorRole = valueDes;
          break;
        case r'correlation_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.correlationId = valueDes;
          break;
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  OperationRetryRecord deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OperationRetryRecordBuilder();
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


