//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'operation_retry_request.g.dart';

/// OperationRetryRequest
///
/// Properties:
/// * [targetType]
/// * [reference]
/// * [reason]
@BuiltValue()
abstract class OperationRetryRequest implements Built<OperationRetryRequest, OperationRetryRequestBuilder> {
  @BuiltValueField(wireName: r'target_type')
  OperationRetryRequestTargetTypeEnum get targetType;
  // enum targetTypeEnum {  FAILED_JOB,  OUTBOX_EVENT,  GEO_FACTS_RUN,  MATERIAL_SNAPSHOT,  };

  @BuiltValueField(wireName: r'reference')
  String get reference;

  @BuiltValueField(wireName: r'reason')
  String get reason;

  OperationRetryRequest._();

  factory OperationRetryRequest([void updates(OperationRetryRequestBuilder b)]) = _$OperationRetryRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OperationRetryRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OperationRetryRequest> get serializer => _$OperationRetryRequestSerializer();
}

class _$OperationRetryRequestSerializer implements PrimitiveSerializer<OperationRetryRequest> {
  @override
  final Iterable<Type> types = const [OperationRetryRequest, _$OperationRetryRequest];

  @override
  final String wireName = r'OperationRetryRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OperationRetryRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'target_type';
    yield serializers.serialize(
      object.targetType,
      specifiedType: const FullType(OperationRetryRequestTargetTypeEnum),
    );
    yield r'reference';
    yield serializers.serialize(
      object.reference,
      specifiedType: const FullType(String),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    OperationRetryRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OperationRetryRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'target_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(OperationRetryRequestTargetTypeEnum),
          ) as OperationRetryRequestTargetTypeEnum;
          result.targetType = valueDes;
          break;
        case r'reference':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reference = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  OperationRetryRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OperationRetryRequestBuilder();
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


class OperationRetryRequestTargetTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'FAILED_JOB')
  static const OperationRetryRequestTargetTypeEnum FAILED_JOB = _$operationRetryRequestTargetTypeEnum_FAILED_JOB;
  @BuiltValueEnumConst(wireName: r'OUTBOX_EVENT')
  static const OperationRetryRequestTargetTypeEnum OUTBOX_EVENT = _$operationRetryRequestTargetTypeEnum_OUTBOX_EVENT;
  @BuiltValueEnumConst(wireName: r'GEO_FACTS_RUN')
  static const OperationRetryRequestTargetTypeEnum GEO_FACTS_RUN = _$operationRetryRequestTargetTypeEnum_GEO_FACTS_RUN;
  @BuiltValueEnumConst(wireName: r'MATERIAL_SNAPSHOT')
  static const OperationRetryRequestTargetTypeEnum MATERIAL_SNAPSHOT = _$operationRetryRequestTargetTypeEnum_MATERIAL_SNAPSHOT;

  static Serializer<OperationRetryRequestTargetTypeEnum> get serializer => _$operationRetryRequestTargetTypeEnumSerializer;

  const OperationRetryRequestTargetTypeEnum._(String name): super(name);

  static BuiltSet<OperationRetryRequestTargetTypeEnum> get values => _$operationRetryRequestTargetTypeEnumValues;
  static OperationRetryRequestTargetTypeEnum valueOf(String name) => _$operationRetryRequestTargetTypeEnumValueOf(name);
}

