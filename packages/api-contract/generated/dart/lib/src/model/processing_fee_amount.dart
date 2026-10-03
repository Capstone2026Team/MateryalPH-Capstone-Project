//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'processing_fee_amount.g.dart';

/// ProcessingFeeAmount
///
/// Properties:
/// * [status]
/// * [amountCentavos]
@BuiltValue()
abstract class ProcessingFeeAmount implements Built<ProcessingFeeAmount, ProcessingFeeAmountBuilder> {
  @BuiltValueField(wireName: r'status')
  ProcessingFeeAmountStatusEnum get status;
  // enum statusEnum {  PENDING_PAYMENT_CHANNEL,  };

  @BuiltValueField(wireName: r'amount_centavos')
  int? get amountCentavos;

  ProcessingFeeAmount._();

  factory ProcessingFeeAmount([void updates(ProcessingFeeAmountBuilder b)]) = _$ProcessingFeeAmount;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProcessingFeeAmountBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProcessingFeeAmount> get serializer => _$ProcessingFeeAmountSerializer();
}

class _$ProcessingFeeAmountSerializer implements PrimitiveSerializer<ProcessingFeeAmount> {
  @override
  final Iterable<Type> types = const [ProcessingFeeAmount, _$ProcessingFeeAmount];

  @override
  final String wireName = r'ProcessingFeeAmount';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProcessingFeeAmount object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(ProcessingFeeAmountStatusEnum),
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
    ProcessingFeeAmount object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProcessingFeeAmountBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ProcessingFeeAmountStatusEnum),
          ) as ProcessingFeeAmountStatusEnum;
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
  ProcessingFeeAmount deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProcessingFeeAmountBuilder();
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


class ProcessingFeeAmountStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PENDING_PAYMENT_CHANNEL')
  static const ProcessingFeeAmountStatusEnum PENDING_PAYMENT_CHANNEL = _$processingFeeAmountStatusEnum_PENDING_PAYMENT_CHANNEL;

  static Serializer<ProcessingFeeAmountStatusEnum> get serializer => _$processingFeeAmountStatusEnumSerializer;

  const ProcessingFeeAmountStatusEnum._(String name): super(name);

  static BuiltSet<ProcessingFeeAmountStatusEnum> get values => _$processingFeeAmountStatusEnumValues;
  static ProcessingFeeAmountStatusEnum valueOf(String name) => _$processingFeeAmountStatusEnumValueOf(name);
}

