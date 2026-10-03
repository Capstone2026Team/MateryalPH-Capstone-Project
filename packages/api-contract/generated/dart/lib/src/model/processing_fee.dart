//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'processing_fee.g.dart';

/// ProcessingFee
///
/// Properties:
/// * [status]
/// * [amountCentavos]
@BuiltValue()
abstract class ProcessingFee implements Built<ProcessingFee, ProcessingFeeBuilder> {
  @BuiltValueField(wireName: r'status')
  ProcessingFeeStatusEnum get status;
  // enum statusEnum {  PENDING_PAYMENT_CHANNEL,  QUOTED,  NOT_APPLICABLE,  PAID,  };

  @BuiltValueField(wireName: r'amount_centavos')
  int? get amountCentavos;

  ProcessingFee._();

  factory ProcessingFee([void updates(ProcessingFeeBuilder b)]) = _$ProcessingFee;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProcessingFeeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProcessingFee> get serializer => _$ProcessingFeeSerializer();
}

class _$ProcessingFeeSerializer implements PrimitiveSerializer<ProcessingFee> {
  @override
  final Iterable<Type> types = const [ProcessingFee, _$ProcessingFee];

  @override
  final String wireName = r'ProcessingFee';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProcessingFee object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(ProcessingFeeStatusEnum),
    );
    yield r'amount_centavos';
    yield object.amountCentavos == null ? null : serializers.serialize(
      object.amountCentavos,
      specifiedType: const FullType.nullable(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ProcessingFee object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProcessingFeeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ProcessingFeeStatusEnum),
          ) as ProcessingFeeStatusEnum;
          result.status = valueDes;
          break;
        case r'amount_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.amountCentavos = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProcessingFee deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProcessingFeeBuilder();
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


class ProcessingFeeStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PENDING_PAYMENT_CHANNEL')
  static const ProcessingFeeStatusEnum PENDING_PAYMENT_CHANNEL = _$processingFeeStatusEnum_PENDING_PAYMENT_CHANNEL;
  @BuiltValueEnumConst(wireName: r'QUOTED')
  static const ProcessingFeeStatusEnum QUOTED = _$processingFeeStatusEnum_QUOTED;
  @BuiltValueEnumConst(wireName: r'NOT_APPLICABLE')
  static const ProcessingFeeStatusEnum NOT_APPLICABLE = _$processingFeeStatusEnum_NOT_APPLICABLE;
  @BuiltValueEnumConst(wireName: r'PAID')
  static const ProcessingFeeStatusEnum PAID = _$processingFeeStatusEnum_PAID;

  static Serializer<ProcessingFeeStatusEnum> get serializer => _$processingFeeStatusEnumSerializer;

  const ProcessingFeeStatusEnum._(String name): super(name);

  static BuiltSet<ProcessingFeeStatusEnum> get values => _$processingFeeStatusEnumValues;
  static ProcessingFeeStatusEnum valueOf(String name) => _$processingFeeStatusEnumValueOf(name);
}

