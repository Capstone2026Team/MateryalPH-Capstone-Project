//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'withholding_payment_calculation.g.dart';

/// One immutable POSTED merchant tax assessment belonging to the current store. No provider identifiers or other-store order references.
///
/// Properties:
/// * [id]
/// * [orderReference]
/// * [grossBasisCentavos]
/// * [rateBasisPoints] - Saved effective rate. 50 basis points means 0.5%; zero may reflect approved relief.
/// * [withheldCentavos] - Original tax amount rounded half-up per assessment; never recomputed after later refunds.
@BuiltValue()
abstract class WithholdingPaymentCalculation implements Built<WithholdingPaymentCalculation, WithholdingPaymentCalculationBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'order_reference')
  String get orderReference;

  @BuiltValueField(wireName: r'gross_basis_centavos')
  int get grossBasisCentavos;

  /// Saved effective rate. 50 basis points means 0.5%; zero may reflect approved relief.
  @BuiltValueField(wireName: r'rate_basis_points')
  int get rateBasisPoints;

  /// Original tax amount rounded half-up per assessment; never recomputed after later refunds.
  @BuiltValueField(wireName: r'withheld_centavos')
  int get withheldCentavos;

  WithholdingPaymentCalculation._();

  factory WithholdingPaymentCalculation([void updates(WithholdingPaymentCalculationBuilder b)]) = _$WithholdingPaymentCalculation;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(WithholdingPaymentCalculationBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<WithholdingPaymentCalculation> get serializer => _$WithholdingPaymentCalculationSerializer();
}

class _$WithholdingPaymentCalculationSerializer implements PrimitiveSerializer<WithholdingPaymentCalculation> {
  @override
  final Iterable<Type> types = const [WithholdingPaymentCalculation, _$WithholdingPaymentCalculation];

  @override
  final String wireName = r'WithholdingPaymentCalculation';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    WithholdingPaymentCalculation object, {
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
    yield r'gross_basis_centavos';
    yield serializers.serialize(
      object.grossBasisCentavos,
      specifiedType: const FullType(int),
    );
    yield r'rate_basis_points';
    yield serializers.serialize(
      object.rateBasisPoints,
      specifiedType: const FullType(int),
    );
    yield r'withheld_centavos';
    yield serializers.serialize(
      object.withheldCentavos,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    WithholdingPaymentCalculation object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required WithholdingPaymentCalculationBuilder result,
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
        case r'gross_basis_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.grossBasisCentavos = valueDes;
          break;
        case r'rate_basis_points':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.rateBasisPoints = valueDes;
          break;
        case r'withheld_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.withheldCentavos = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  WithholdingPaymentCalculation deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = WithholdingPaymentCalculationBuilder();
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


