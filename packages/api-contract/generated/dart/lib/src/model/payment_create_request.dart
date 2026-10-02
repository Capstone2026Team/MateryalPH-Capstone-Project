//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'payment_create_request.g.dart';

/// PaymentCreateRequest
///
/// Properties:
/// * [channelCode]
/// * [expectedTotalCentavos]
@BuiltValue()
abstract class PaymentCreateRequest implements Built<PaymentCreateRequest, PaymentCreateRequestBuilder> {
  @BuiltValueField(wireName: r'channel_code')
  String get channelCode;

  @BuiltValueField(wireName: r'expected_total_centavos')
  int get expectedTotalCentavos;

  PaymentCreateRequest._();

  factory PaymentCreateRequest([void updates(PaymentCreateRequestBuilder b)]) = _$PaymentCreateRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PaymentCreateRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PaymentCreateRequest> get serializer => _$PaymentCreateRequestSerializer();
}

class _$PaymentCreateRequestSerializer implements PrimitiveSerializer<PaymentCreateRequest> {
  @override
  final Iterable<Type> types = const [PaymentCreateRequest, _$PaymentCreateRequest];

  @override
  final String wireName = r'PaymentCreateRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PaymentCreateRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'channel_code';
    yield serializers.serialize(
      object.channelCode,
      specifiedType: const FullType(String),
    );
    yield r'expected_total_centavos';
    yield serializers.serialize(
      object.expectedTotalCentavos,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PaymentCreateRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PaymentCreateRequestBuilder result,
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
        case r'expected_total_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.expectedTotalCentavos = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PaymentCreateRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PaymentCreateRequestBuilder();
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


