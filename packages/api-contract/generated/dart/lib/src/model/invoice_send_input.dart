//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'invoice_send_input.g.dart';

/// InvoiceSendInput
///
/// Properties:
/// * [lockVersion]
@BuiltValue()
abstract class InvoiceSendInput implements Built<InvoiceSendInput, InvoiceSendInputBuilder> {
  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  InvoiceSendInput._();

  factory InvoiceSendInput([void updates(InvoiceSendInputBuilder b)]) = _$InvoiceSendInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(InvoiceSendInputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<InvoiceSendInput> get serializer => _$InvoiceSendInputSerializer();
}

class _$InvoiceSendInputSerializer implements PrimitiveSerializer<InvoiceSendInput> {
  @override
  final Iterable<Type> types = const [InvoiceSendInput, _$InvoiceSendInput];

  @override
  final String wireName = r'InvoiceSendInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    InvoiceSendInput object, {
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
    InvoiceSendInput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required InvoiceSendInputBuilder result,
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
  InvoiceSendInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = InvoiceSendInputBuilder();
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


