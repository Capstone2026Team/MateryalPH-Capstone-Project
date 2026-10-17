//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dispute_refundable.g.dart';

/// DisputeRefundable
///
/// Properties:
/// * [onlineCentavos]
/// * [cashCentavos]
@BuiltValue()
abstract class DisputeRefundable implements Built<DisputeRefundable, DisputeRefundableBuilder> {
  @BuiltValueField(wireName: r'online_centavos')
  int get onlineCentavos;

  @BuiltValueField(wireName: r'cash_centavos')
  int get cashCentavos;

  DisputeRefundable._();

  factory DisputeRefundable([void updates(DisputeRefundableBuilder b)]) = _$DisputeRefundable;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DisputeRefundableBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DisputeRefundable> get serializer => _$DisputeRefundableSerializer();
}

class _$DisputeRefundableSerializer implements PrimitiveSerializer<DisputeRefundable> {
  @override
  final Iterable<Type> types = const [DisputeRefundable, _$DisputeRefundable];

  @override
  final String wireName = r'DisputeRefundable';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DisputeRefundable object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'online_centavos';
    yield serializers.serialize(
      object.onlineCentavos,
      specifiedType: const FullType(int),
    );
    yield r'cash_centavos';
    yield serializers.serialize(
      object.cashCentavos,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DisputeRefundable object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DisputeRefundableBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'online_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.onlineCentavos = valueDes;
          break;
        case r'cash_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.cashCentavos = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DisputeRefundable deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DisputeRefundableBuilder();
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


