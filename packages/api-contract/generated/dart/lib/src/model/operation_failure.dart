//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'operation_failure.g.dart';

/// OperationFailure
///
/// Properties:
/// * [kind]
/// * [reference]
/// * [label]
/// * [queue]
/// * [failure]
/// * [attempts]
/// * [failedAt]
/// * [retryable]
/// * [retryNote]
@BuiltValue()
abstract class OperationFailure implements Built<OperationFailure, OperationFailureBuilder> {
  @BuiltValueField(wireName: r'kind')
  OperationFailureKindEnum get kind;
  // enum kindEnum {  FAILED_JOB,  OUTBOX_EVENT,  };

  @BuiltValueField(wireName: r'reference')
  String get reference;

  @BuiltValueField(wireName: r'label')
  String get label;

  @BuiltValueField(wireName: r'queue')
  String get queue;

  @BuiltValueField(wireName: r'failure')
  String get failure;

  @BuiltValueField(wireName: r'attempts')
  int? get attempts;

  @BuiltValueField(wireName: r'failed_at')
  DateTime get failedAt;

  @BuiltValueField(wireName: r'retryable')
  bool get retryable;

  @BuiltValueField(wireName: r'retry_note')
  String? get retryNote;

  OperationFailure._();

  factory OperationFailure([void updates(OperationFailureBuilder b)]) = _$OperationFailure;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OperationFailureBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OperationFailure> get serializer => _$OperationFailureSerializer();
}

class _$OperationFailureSerializer implements PrimitiveSerializer<OperationFailure> {
  @override
  final Iterable<Type> types = const [OperationFailure, _$OperationFailure];

  @override
  final String wireName = r'OperationFailure';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OperationFailure object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(OperationFailureKindEnum),
    );
    yield r'reference';
    yield serializers.serialize(
      object.reference,
      specifiedType: const FullType(String),
    );
    yield r'label';
    yield serializers.serialize(
      object.label,
      specifiedType: const FullType(String),
    );
    yield r'queue';
    yield serializers.serialize(
      object.queue,
      specifiedType: const FullType(String),
    );
    yield r'failure';
    yield serializers.serialize(
      object.failure,
      specifiedType: const FullType(String),
    );
    if (object.attempts != null) {
      yield r'attempts';
      yield serializers.serialize(
        object.attempts,
        specifiedType: const FullType.nullable(int),
      );
    }
    yield r'failed_at';
    yield serializers.serialize(
      object.failedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'retryable';
    yield serializers.serialize(
      object.retryable,
      specifiedType: const FullType(bool),
    );
    if (object.retryNote != null) {
      yield r'retry_note';
      yield serializers.serialize(
        object.retryNote,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    OperationFailure object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OperationFailureBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'kind':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(OperationFailureKindEnum),
          ) as OperationFailureKindEnum;
          result.kind = valueDes;
          break;
        case r'reference':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reference = valueDes;
          break;
        case r'label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.label = valueDes;
          break;
        case r'queue':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.queue = valueDes;
          break;
        case r'failure':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.failure = valueDes;
          break;
        case r'attempts':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.attempts = valueDes;
          break;
        case r'failed_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.failedAt = valueDes;
          break;
        case r'retryable':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.retryable = valueDes;
          break;
        case r'retry_note':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.retryNote = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  OperationFailure deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OperationFailureBuilder();
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


class OperationFailureKindEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'FAILED_JOB')
  static const OperationFailureKindEnum FAILED_JOB = _$operationFailureKindEnum_FAILED_JOB;
  @BuiltValueEnumConst(wireName: r'OUTBOX_EVENT')
  static const OperationFailureKindEnum OUTBOX_EVENT = _$operationFailureKindEnum_OUTBOX_EVENT;

  static Serializer<OperationFailureKindEnum> get serializer => _$operationFailureKindEnumSerializer;

  const OperationFailureKindEnum._(String name): super(name);

  static BuiltSet<OperationFailureKindEnum> get values => _$operationFailureKindEnumValues;
  static OperationFailureKindEnum valueOf(String name) => _$operationFailureKindEnumValueOf(name);
}

