//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'operation_retry_result.g.dart';

/// OperationRetryResult
///
/// Properties:
/// * [targetType]
/// * [reference]
/// * [label]
/// * [outcome]
/// * [correlationId]
@BuiltValue()
abstract class OperationRetryResult implements Built<OperationRetryResult, OperationRetryResultBuilder> {
  @BuiltValueField(wireName: r'target_type')
  String get targetType;

  @BuiltValueField(wireName: r'reference')
  String get reference;

  @BuiltValueField(wireName: r'label')
  String get label;

  @BuiltValueField(wireName: r'outcome')
  OperationRetryResultOutcomeEnum get outcome;
  // enum outcomeEnum {  QUEUED,  };

  @BuiltValueField(wireName: r'correlation_id')
  String get correlationId;

  OperationRetryResult._();

  factory OperationRetryResult([void updates(OperationRetryResultBuilder b)]) = _$OperationRetryResult;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OperationRetryResultBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OperationRetryResult> get serializer => _$OperationRetryResultSerializer();
}

class _$OperationRetryResultSerializer implements PrimitiveSerializer<OperationRetryResult> {
  @override
  final Iterable<Type> types = const [OperationRetryResult, _$OperationRetryResult];

  @override
  final String wireName = r'OperationRetryResult';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OperationRetryResult object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'target_type';
    yield serializers.serialize(
      object.targetType,
      specifiedType: const FullType(String),
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
    yield r'outcome';
    yield serializers.serialize(
      object.outcome,
      specifiedType: const FullType(OperationRetryResultOutcomeEnum),
    );
    yield r'correlation_id';
    yield serializers.serialize(
      object.correlationId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    OperationRetryResult object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OperationRetryResultBuilder result,
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
        case r'outcome':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(OperationRetryResultOutcomeEnum),
          ) as OperationRetryResultOutcomeEnum;
          result.outcome = valueDes;
          break;
        case r'correlation_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.correlationId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  OperationRetryResult deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OperationRetryResultBuilder();
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


class OperationRetryResultOutcomeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'QUEUED')
  static const OperationRetryResultOutcomeEnum QUEUED = _$operationRetryResultOutcomeEnum_QUEUED;

  static Serializer<OperationRetryResultOutcomeEnum> get serializer => _$operationRetryResultOutcomeEnumSerializer;

  const OperationRetryResultOutcomeEnum._(String name): super(name);

  static BuiltSet<OperationRetryResultOutcomeEnum> get values => _$operationRetryResultOutcomeEnumValues;
  static OperationRetryResultOutcomeEnum valueOf(String name) => _$operationRetryResultOutcomeEnumValueOf(name);
}

