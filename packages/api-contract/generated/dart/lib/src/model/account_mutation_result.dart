//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'account_mutation_result.g.dart';

/// AccountMutationResult
///
/// Properties:
/// * [changed]
/// * [verified]
/// * [revoked]
/// * [accepted]
/// * [queued]
/// * [signInRequired]
/// * [next]
@BuiltValue()
abstract class AccountMutationResult implements Built<AccountMutationResult, AccountMutationResultBuilder> {
  @BuiltValueField(wireName: r'changed')
  bool? get changed;

  @BuiltValueField(wireName: r'verified')
  bool? get verified;

  @BuiltValueField(wireName: r'revoked')
  bool? get revoked;

  @BuiltValueField(wireName: r'accepted')
  bool? get accepted;

  @BuiltValueField(wireName: r'queued')
  bool? get queued;

  @BuiltValueField(wireName: r'sign_in_required')
  bool? get signInRequired;

  @BuiltValueField(wireName: r'next')
  String? get next;

  AccountMutationResult._();

  factory AccountMutationResult([void updates(AccountMutationResultBuilder b)]) = _$AccountMutationResult;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AccountMutationResultBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AccountMutationResult> get serializer => _$AccountMutationResultSerializer();
}

class _$AccountMutationResultSerializer implements PrimitiveSerializer<AccountMutationResult> {
  @override
  final Iterable<Type> types = const [AccountMutationResult, _$AccountMutationResult];

  @override
  final String wireName = r'AccountMutationResult';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AccountMutationResult object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.changed != null) {
      yield r'changed';
      yield serializers.serialize(
        object.changed,
        specifiedType: const FullType(bool),
      );
    }
    if (object.verified != null) {
      yield r'verified';
      yield serializers.serialize(
        object.verified,
        specifiedType: const FullType(bool),
      );
    }
    if (object.revoked != null) {
      yield r'revoked';
      yield serializers.serialize(
        object.revoked,
        specifiedType: const FullType(bool),
      );
    }
    if (object.accepted != null) {
      yield r'accepted';
      yield serializers.serialize(
        object.accepted,
        specifiedType: const FullType(bool),
      );
    }
    if (object.queued != null) {
      yield r'queued';
      yield serializers.serialize(
        object.queued,
        specifiedType: const FullType(bool),
      );
    }
    if (object.signInRequired != null) {
      yield r'sign_in_required';
      yield serializers.serialize(
        object.signInRequired,
        specifiedType: const FullType(bool),
      );
    }
    if (object.next != null) {
      yield r'next';
      yield serializers.serialize(
        object.next,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    AccountMutationResult object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AccountMutationResultBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'changed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.changed = valueDes;
          break;
        case r'verified':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.verified = valueDes;
          break;
        case r'revoked':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.revoked = valueDes;
          break;
        case r'accepted':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.accepted = valueDes;
          break;
        case r'queued':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.queued = valueDes;
          break;
        case r'sign_in_required':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.signInRequired = valueDes;
          break;
        case r'next':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.next = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AccountMutationResult deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AccountMutationResultBuilder();
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


