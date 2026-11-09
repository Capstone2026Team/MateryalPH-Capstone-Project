//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pending_order_quotation_input.g.dart';

/// PendingOrderQuotationInput
///
/// Properties:
/// * [lockVersion]
@BuiltValue()
abstract class PendingOrderQuotationInput implements Built<PendingOrderQuotationInput, PendingOrderQuotationInputBuilder> {
  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  PendingOrderQuotationInput._();

  factory PendingOrderQuotationInput([void updates(PendingOrderQuotationInputBuilder b)]) = _$PendingOrderQuotationInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PendingOrderQuotationInputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PendingOrderQuotationInput> get serializer => _$PendingOrderQuotationInputSerializer();
}

class _$PendingOrderQuotationInputSerializer implements PrimitiveSerializer<PendingOrderQuotationInput> {
  @override
  final Iterable<Type> types = const [PendingOrderQuotationInput, _$PendingOrderQuotationInput];

  @override
  final String wireName = r'PendingOrderQuotationInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PendingOrderQuotationInput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PendingOrderQuotationInput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PendingOrderQuotationInputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lockVersion = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PendingOrderQuotationInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PendingOrderQuotationInputBuilder();
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


