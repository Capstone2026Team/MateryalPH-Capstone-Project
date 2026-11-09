//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'withholding_recorded_payment.g.dart';

/// WithholdingRecordedPayment
///
/// Properties:
/// * [id]
/// * [orderReference]
/// * [collectedAt]
/// * [amountCentavos]
/// * [taxableCentavos]
/// * [taxCentavos]
@BuiltValue()
abstract class WithholdingRecordedPayment implements Built<WithholdingRecordedPayment, WithholdingRecordedPaymentBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'order_reference')
  String get orderReference;

  @BuiltValueField(wireName: r'collected_at')
  String get collectedAt;

  @BuiltValueField(wireName: r'amount_centavos')
  int get amountCentavos;

  @BuiltValueField(wireName: r'taxable_centavos')
  int? get taxableCentavos;

  @BuiltValueField(wireName: r'tax_centavos')
  int? get taxCentavos;

  WithholdingRecordedPayment._();

  factory WithholdingRecordedPayment([void updates(WithholdingRecordedPaymentBuilder b)]) = _$WithholdingRecordedPayment;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(WithholdingRecordedPaymentBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<WithholdingRecordedPayment> get serializer => _$WithholdingRecordedPaymentSerializer();
}

class _$WithholdingRecordedPaymentSerializer implements PrimitiveSerializer<WithholdingRecordedPayment> {
  @override
  final Iterable<Type> types = const [WithholdingRecordedPayment, _$WithholdingRecordedPayment];

  @override
  final String wireName = r'WithholdingRecordedPayment';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    WithholdingRecordedPayment object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'order_reference';
    yield serializers.serialize(
      object.orderReference,
      specifiedType: const FullType(String),
    );
    yield r'collected_at';
    yield serializers.serialize(
      object.collectedAt,
      specifiedType: const FullType(String),
    );
    yield r'amount_centavos';
    yield serializers.serialize(
      object.amountCentavos,
      specifiedType: const FullType(int),
    );
    yield r'taxable_centavos';
    yield object.taxableCentavos == null ? null : serializers.serialize(
      object.taxableCentavos,
      specifiedType: const FullType.nullable(int),
    );
    yield r'tax_centavos';
    yield object.taxCentavos == null ? null : serializers.serialize(
      object.taxCentavos,
      specifiedType: const FullType.nullable(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    WithholdingRecordedPayment object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required WithholdingRecordedPaymentBuilder result,
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
        case r'order_reference':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.orderReference = valueDes;
          break;
        case r'collected_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.collectedAt = valueDes;
          break;
        case r'amount_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.amountCentavos = valueDes;
          break;
        case r'taxable_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.taxableCentavos = valueDes;
          break;
        case r'tax_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.taxCentavos = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  WithholdingRecordedPayment deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = WithholdingRecordedPaymentBuilder();
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


