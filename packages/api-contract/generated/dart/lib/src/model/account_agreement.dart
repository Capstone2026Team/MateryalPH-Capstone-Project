//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'account_agreement.g.dart';

/// AccountAgreement
///
/// Properties:
/// * [id]
/// * [code]
/// * [title]
/// * [version]
/// * [content]
/// * [contentAvailable]
/// * [acceptedAt]
/// * [requiresAcceptance]
@BuiltValue()
abstract class AccountAgreement implements Built<AccountAgreement, AccountAgreementBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'title')
  String get title;

  @BuiltValueField(wireName: r'version')
  int get version;

  @BuiltValueField(wireName: r'content')
  String? get content;

  @BuiltValueField(wireName: r'content_available')
  bool get contentAvailable;

  @BuiltValueField(wireName: r'accepted_at')
  String? get acceptedAt;

  @BuiltValueField(wireName: r'requires_acceptance')
  bool get requiresAcceptance;

  AccountAgreement._();

  factory AccountAgreement([void updates(AccountAgreementBuilder b)]) = _$AccountAgreement;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AccountAgreementBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AccountAgreement> get serializer => _$AccountAgreementSerializer();
}

class _$AccountAgreementSerializer implements PrimitiveSerializer<AccountAgreement> {
  @override
  final Iterable<Type> types = const [AccountAgreement, _$AccountAgreement];

  @override
  final String wireName = r'AccountAgreement';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AccountAgreement object, {
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
    yield r'title';
    yield serializers.serialize(
      object.title,
      specifiedType: const FullType(String),
    );
    yield r'version';
    yield serializers.serialize(
      object.version,
      specifiedType: const FullType(int),
    );
    yield r'content';
    yield object.content == null ? null : serializers.serialize(
      object.content,
      specifiedType: const FullType.nullable(String),
    );
    yield r'content_available';
    yield serializers.serialize(
      object.contentAvailable,
      specifiedType: const FullType(bool),
    );
    yield r'accepted_at';
    yield object.acceptedAt == null ? null : serializers.serialize(
      object.acceptedAt,
      specifiedType: const FullType.nullable(String),
    );
    yield r'requires_acceptance';
    yield serializers.serialize(
      object.requiresAcceptance,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AccountAgreement object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AccountAgreementBuilder result,
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
        case r'title':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.title = valueDes;
          break;
        case r'version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.version = valueDes;
          break;
        case r'content':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.content = valueDes;
          break;
        case r'content_available':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.contentAvailable = valueDes;
          break;
        case r'accepted_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.acceptedAt = valueDes;
          break;
        case r'requires_acceptance':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.requiresAcceptance = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AccountAgreement deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AccountAgreementBuilder();
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


