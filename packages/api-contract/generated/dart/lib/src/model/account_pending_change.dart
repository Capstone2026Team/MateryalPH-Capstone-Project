//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'account_pending_change.g.dart';

/// AccountPendingChange
///
/// Properties:
/// * [id]
/// * [expiresAt]
@BuiltValue()
abstract class AccountPendingChange implements Built<AccountPendingChange, AccountPendingChangeBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'expires_at')
  String get expiresAt;

  AccountPendingChange._();

  factory AccountPendingChange([void updates(AccountPendingChangeBuilder b)]) = _$AccountPendingChange;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AccountPendingChangeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AccountPendingChange> get serializer => _$AccountPendingChangeSerializer();
}

class _$AccountPendingChangeSerializer implements PrimitiveSerializer<AccountPendingChange> {
  @override
  final Iterable<Type> types = const [AccountPendingChange, _$AccountPendingChange];

  @override
  final String wireName = r'AccountPendingChange';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AccountPendingChange object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'expires_at';
    yield serializers.serialize(
      object.expiresAt,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AccountPendingChange object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AccountPendingChangeBuilder result,
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
        case r'expires_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.expiresAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AccountPendingChange deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AccountPendingChangeBuilder();
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


