//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'account_agreement_acceptance.g.dart';

/// AccountAgreementAcceptance
///
/// Properties:
/// * [versionIds]
@BuiltValue()
abstract class AccountAgreementAcceptance implements Built<AccountAgreementAcceptance, AccountAgreementAcceptanceBuilder> {
  @BuiltValueField(wireName: r'version_ids')
  BuiltList<String> get versionIds;

  AccountAgreementAcceptance._();

  factory AccountAgreementAcceptance([void updates(AccountAgreementAcceptanceBuilder b)]) = _$AccountAgreementAcceptance;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AccountAgreementAcceptanceBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AccountAgreementAcceptance> get serializer => _$AccountAgreementAcceptanceSerializer();
}

class _$AccountAgreementAcceptanceSerializer implements PrimitiveSerializer<AccountAgreementAcceptance> {
  @override
  final Iterable<Type> types = const [AccountAgreementAcceptance, _$AccountAgreementAcceptance];

  @override
  final String wireName = r'AccountAgreementAcceptance';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AccountAgreementAcceptance object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'version_ids';
    yield serializers.serialize(
      object.versionIds,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AccountAgreementAcceptance object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AccountAgreementAcceptanceBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'version_ids':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.versionIds.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AccountAgreementAcceptance deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AccountAgreementAcceptanceBuilder();
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


