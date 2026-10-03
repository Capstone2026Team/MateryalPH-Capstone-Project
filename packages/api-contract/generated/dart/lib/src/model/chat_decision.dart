//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'chat_decision.g.dart';

/// ChatDecision
///
/// Properties:
/// * [budgetOverrideReason]
/// * [versionId]
/// * [contentHash]
/// * [reason]
/// * [nrpcAcknowledged]
/// * [nrpcTermsVersionId]
@BuiltValue()
abstract class ChatDecision implements Built<ChatDecision, ChatDecisionBuilder> {
  @BuiltValueField(wireName: r'budget_override_reason')
  String? get budgetOverrideReason;

  @BuiltValueField(wireName: r'version_id')
  String get versionId;

  @BuiltValueField(wireName: r'content_hash')
  String? get contentHash;

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  @BuiltValueField(wireName: r'nrpc_acknowledged')
  bool? get nrpcAcknowledged;

  @BuiltValueField(wireName: r'nrpc_terms_version_id')
  String? get nrpcTermsVersionId;

  ChatDecision._();

  factory ChatDecision([void updates(ChatDecisionBuilder b)]) = _$ChatDecision;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ChatDecisionBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ChatDecision> get serializer => _$ChatDecisionSerializer();
}

class _$ChatDecisionSerializer implements PrimitiveSerializer<ChatDecision> {
  @override
  final Iterable<Type> types = const [ChatDecision, _$ChatDecision];

  @override
  final String wireName = r'ChatDecision';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ChatDecision object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.budgetOverrideReason != null) {
      yield r'budget_override_reason';
      yield serializers.serialize(
        object.budgetOverrideReason,
        specifiedType: const FullType(String),
      );
    }
    yield r'version_id';
    yield serializers.serialize(
      object.versionId,
      specifiedType: const FullType(String),
    );
    if (object.contentHash != null) {
      yield r'content_hash';
      yield serializers.serialize(
        object.contentHash,
        specifiedType: const FullType(String),
      );
    }
    if (object.reason != null) {
      yield r'reason';
      yield serializers.serialize(
        object.reason,
        specifiedType: const FullType(String),
      );
    }
    if (object.nrpcAcknowledged != null) {
      yield r'nrpc_acknowledged';
      yield serializers.serialize(
        object.nrpcAcknowledged,
        specifiedType: const FullType(bool),
      );
    }
    if (object.nrpcTermsVersionId != null) {
      yield r'nrpc_terms_version_id';
      yield serializers.serialize(
        object.nrpcTermsVersionId,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ChatDecision object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ChatDecisionBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'budget_override_reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.budgetOverrideReason = valueDes;
          break;
        case r'version_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.versionId = valueDes;
          break;
        case r'content_hash':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.contentHash = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.reason = valueDes;
          break;
        case r'nrpc_acknowledged':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.nrpcAcknowledged = valueDes;
          break;
        case r'nrpc_terms_version_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.nrpcTermsVersionId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ChatDecision deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ChatDecisionBuilder();
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


