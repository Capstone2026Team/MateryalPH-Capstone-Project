//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'account_code_confirmation.g.dart';

/// AccountCodeConfirmation
///
/// Properties:
/// * [id]
/// * [code]
@BuiltValue()
abstract class AccountCodeConfirmation implements Built<AccountCodeConfirmation, AccountCodeConfirmationBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'code')
  String get code;

  AccountCodeConfirmation._();

  factory AccountCodeConfirmation([void updates(AccountCodeConfirmationBuilder b)]) = _$AccountCodeConfirmation;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AccountCodeConfirmationBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AccountCodeConfirmation> get serializer => _$AccountCodeConfirmationSerializer();
}

class _$AccountCodeConfirmationSerializer implements PrimitiveSerializer<AccountCodeConfirmation> {
  @override
  final Iterable<Type> types = const [AccountCodeConfirmation, _$AccountCodeConfirmation];

  @override
  final String wireName = r'AccountCodeConfirmation';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AccountCodeConfirmation object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AccountCodeConfirmation object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AccountCodeConfirmationBuilder result,
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
  AccountCodeConfirmation deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AccountCodeConfirmationBuilder();
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


