//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'support_access_exchange.g.dart';

/// SupportAccessExchange
///
/// Properties:
/// * [token] - Single-use secret received by email. Never log or persist on the client.
@BuiltValue()
abstract class SupportAccessExchange implements Built<SupportAccessExchange, SupportAccessExchangeBuilder> {
  /// Single-use secret received by email. Never log or persist on the client.
  @BuiltValueField(wireName: r'token')
  String get token;

  SupportAccessExchange._();

  factory SupportAccessExchange([void updates(SupportAccessExchangeBuilder b)]) = _$SupportAccessExchange;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SupportAccessExchangeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SupportAccessExchange> get serializer => _$SupportAccessExchangeSerializer();
}

class _$SupportAccessExchangeSerializer implements PrimitiveSerializer<SupportAccessExchange> {
  @override
  final Iterable<Type> types = const [SupportAccessExchange, _$SupportAccessExchange];

  @override
  final String wireName = r'SupportAccessExchange';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SupportAccessExchange object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'token';
    yield serializers.serialize(
      object.token,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SupportAccessExchange object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SupportAccessExchangeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'token':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.token = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SupportAccessExchange deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SupportAccessExchangeBuilder();
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


