//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'account_session_revocation.g.dart';

/// AccountSessionRevocation
///
/// Properties:
/// * [scope]
@BuiltValue()
abstract class AccountSessionRevocation implements Built<AccountSessionRevocation, AccountSessionRevocationBuilder> {
  @BuiltValueField(wireName: r'scope')
  AccountSessionRevocationScopeEnum get scope;
  // enum scopeEnum {  OTHERS,  ALL,  };

  AccountSessionRevocation._();

  factory AccountSessionRevocation([void updates(AccountSessionRevocationBuilder b)]) = _$AccountSessionRevocation;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AccountSessionRevocationBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AccountSessionRevocation> get serializer => _$AccountSessionRevocationSerializer();
}

class _$AccountSessionRevocationSerializer implements PrimitiveSerializer<AccountSessionRevocation> {
  @override
  final Iterable<Type> types = const [AccountSessionRevocation, _$AccountSessionRevocation];

  @override
  final String wireName = r'AccountSessionRevocation';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AccountSessionRevocation object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'scope';
    yield serializers.serialize(
      object.scope,
      specifiedType: const FullType(AccountSessionRevocationScopeEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AccountSessionRevocation object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AccountSessionRevocationBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'scope':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AccountSessionRevocationScopeEnum),
          ) as AccountSessionRevocationScopeEnum;
          result.scope = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AccountSessionRevocation deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AccountSessionRevocationBuilder();
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


class AccountSessionRevocationScopeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'OTHERS')
  static const AccountSessionRevocationScopeEnum OTHERS = _$accountSessionRevocationScopeEnum_OTHERS;
  @BuiltValueEnumConst(wireName: r'ALL')
  static const AccountSessionRevocationScopeEnum ALL = _$accountSessionRevocationScopeEnum_ALL;

  static Serializer<AccountSessionRevocationScopeEnum> get serializer => _$accountSessionRevocationScopeEnumSerializer;

  const AccountSessionRevocationScopeEnum._(String name): super(name);

  static BuiltSet<AccountSessionRevocationScopeEnum> get values => _$accountSessionRevocationScopeEnumValues;
  static AccountSessionRevocationScopeEnum valueOf(String name) => _$accountSessionRevocationScopeEnumValueOf(name);
}

