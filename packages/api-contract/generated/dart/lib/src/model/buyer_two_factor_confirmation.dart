//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'buyer_two_factor_confirmation.g.dart';

/// BuyerTwoFactorConfirmation
///
/// Properties:
/// * [code]
@BuiltValue()
abstract class BuyerTwoFactorConfirmation implements Built<BuyerTwoFactorConfirmation, BuyerTwoFactorConfirmationBuilder> {
  @BuiltValueField(wireName: r'code')
  String get code;

  BuyerTwoFactorConfirmation._();

  factory BuyerTwoFactorConfirmation([void updates(BuyerTwoFactorConfirmationBuilder b)]) = _$BuyerTwoFactorConfirmation;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BuyerTwoFactorConfirmationBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BuyerTwoFactorConfirmation> get serializer => _$BuyerTwoFactorConfirmationSerializer();
}

class _$BuyerTwoFactorConfirmationSerializer implements PrimitiveSerializer<BuyerTwoFactorConfirmation> {
  @override
  final Iterable<Type> types = const [BuyerTwoFactorConfirmation, _$BuyerTwoFactorConfirmation];

  @override
  final String wireName = r'BuyerTwoFactorConfirmation';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BuyerTwoFactorConfirmation object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    BuyerTwoFactorConfirmation object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BuyerTwoFactorConfirmationBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.code = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BuyerTwoFactorConfirmation deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BuyerTwoFactorConfirmationBuilder();
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


