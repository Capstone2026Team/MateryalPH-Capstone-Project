//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'buyer_two_factor_disable.g.dart';

/// Exactly one of code or recovery_code.
///
/// Properties:
/// * [code]
/// * [recoveryCode]
@BuiltValue()
abstract class BuyerTwoFactorDisable implements Built<BuyerTwoFactorDisable, BuyerTwoFactorDisableBuilder> {
  @BuiltValueField(wireName: r'code')
  String? get code;

  @BuiltValueField(wireName: r'recovery_code')
  String? get recoveryCode;

  BuyerTwoFactorDisable._();

  factory BuyerTwoFactorDisable([void updates(BuyerTwoFactorDisableBuilder b)]) = _$BuyerTwoFactorDisable;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BuyerTwoFactorDisableBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BuyerTwoFactorDisable> get serializer => _$BuyerTwoFactorDisableSerializer();
}

class _$BuyerTwoFactorDisableSerializer implements PrimitiveSerializer<BuyerTwoFactorDisable> {
  @override
  final Iterable<Type> types = const [BuyerTwoFactorDisable, _$BuyerTwoFactorDisable];

  @override
  final String wireName = r'BuyerTwoFactorDisable';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BuyerTwoFactorDisable object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.code != null) {
      yield r'code';
      yield serializers.serialize(
        object.code,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.recoveryCode != null) {
      yield r'recovery_code';
      yield serializers.serialize(
        object.recoveryCode,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    BuyerTwoFactorDisable object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BuyerTwoFactorDisableBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.code = valueDes;
          break;
        case r'recovery_code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.recoveryCode = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BuyerTwoFactorDisable deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BuyerTwoFactorDisableBuilder();
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


