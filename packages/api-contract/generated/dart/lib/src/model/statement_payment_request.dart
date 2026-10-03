//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'statement_payment_request.g.dart';

/// StatementPaymentRequest
///
/// Properties:
/// * [channelCode]
/// * [amountCentavos]
@BuiltValue()
abstract class StatementPaymentRequest implements Built<StatementPaymentRequest, StatementPaymentRequestBuilder> {
  @BuiltValueField(wireName: r'channel_code')
  String get channelCode;

  @BuiltValueField(wireName: r'amount_centavos')
  int? get amountCentavos;

  StatementPaymentRequest._();

  factory StatementPaymentRequest([void updates(StatementPaymentRequestBuilder b)]) = _$StatementPaymentRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(StatementPaymentRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<StatementPaymentRequest> get serializer => _$StatementPaymentRequestSerializer();
}

class _$StatementPaymentRequestSerializer implements PrimitiveSerializer<StatementPaymentRequest> {
  @override
  final Iterable<Type> types = const [StatementPaymentRequest, _$StatementPaymentRequest];

  @override
  final String wireName = r'StatementPaymentRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    StatementPaymentRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'channel_code';
    yield serializers.serialize(
      object.channelCode,
      specifiedType: const FullType(String),
    );
    if (object.amountCentavos != null) {
      yield r'amount_centavos';
      yield serializers.serialize(
        object.amountCentavos,
        specifiedType: const FullType(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    StatementPaymentRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required StatementPaymentRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'channel_code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.channelCode = valueDes;
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
  StatementPaymentRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = StatementPaymentRequestBuilder();
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


