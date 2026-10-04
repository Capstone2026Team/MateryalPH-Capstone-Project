//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'invoice_request_answer.g.dart';

/// InvoiceRequestAnswer
///
/// Properties:
/// * [action]
/// * [reason]
@BuiltValue()
abstract class InvoiceRequestAnswer implements Built<InvoiceRequestAnswer, InvoiceRequestAnswerBuilder> {
  @BuiltValueField(wireName: r'action')
  InvoiceRequestAnswerActionEnum get action;
  // enum actionEnum {  RETURN,  CLOSE,  };

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  InvoiceRequestAnswer._();

  factory InvoiceRequestAnswer([void updates(InvoiceRequestAnswerBuilder b)]) = _$InvoiceRequestAnswer;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(InvoiceRequestAnswerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<InvoiceRequestAnswer> get serializer => _$InvoiceRequestAnswerSerializer();
}

class _$InvoiceRequestAnswerSerializer implements PrimitiveSerializer<InvoiceRequestAnswer> {
  @override
  final Iterable<Type> types = const [InvoiceRequestAnswer, _$InvoiceRequestAnswer];

  @override
  final String wireName = r'InvoiceRequestAnswer';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    InvoiceRequestAnswer object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'action';
    yield serializers.serialize(
      object.action,
      specifiedType: const FullType(InvoiceRequestAnswerActionEnum),
    );
    if (object.reason != null) {
      yield r'reason';
      yield serializers.serialize(
        object.reason,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    InvoiceRequestAnswer object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required InvoiceRequestAnswerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'action':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(InvoiceRequestAnswerActionEnum),
          ) as InvoiceRequestAnswerActionEnum;
          result.action = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
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
  InvoiceRequestAnswer deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = InvoiceRequestAnswerBuilder();
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


class InvoiceRequestAnswerActionEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'RETURN')
  static const InvoiceRequestAnswerActionEnum RETURN = _$invoiceRequestAnswerActionEnum_RETURN;
  @BuiltValueEnumConst(wireName: r'CLOSE')
  static const InvoiceRequestAnswerActionEnum CLOSE = _$invoiceRequestAnswerActionEnum_CLOSE;

  static Serializer<InvoiceRequestAnswerActionEnum> get serializer => _$invoiceRequestAnswerActionEnumSerializer;

  const InvoiceRequestAnswerActionEnum._(String name): super(name);

  static BuiltSet<InvoiceRequestAnswerActionEnum> get values => _$invoiceRequestAnswerActionEnumValues;
  static InvoiceRequestAnswerActionEnum valueOf(String name) => _$invoiceRequestAnswerActionEnumValueOf(name);
}

