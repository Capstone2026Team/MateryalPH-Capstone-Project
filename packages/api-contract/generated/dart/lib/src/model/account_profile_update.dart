//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'account_profile_update.g.dart';

/// AccountProfileUpdate
///
/// Properties:
/// * [fullName]
/// * [lockVersion]
/// * [buyerType]
/// * [companyName]
@BuiltValue()
abstract class AccountProfileUpdate implements Built<AccountProfileUpdate, AccountProfileUpdateBuilder> {
  @BuiltValueField(wireName: r'full_name')
  String get fullName;

  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  @BuiltValueField(wireName: r'buyer_type')
  AccountProfileUpdateBuyerTypeEnum? get buyerType;
  // enum buyerTypeEnum {  INDIVIDUAL,  BUSINESS,  };

  @BuiltValueField(wireName: r'company_name')
  String? get companyName;

  AccountProfileUpdate._();

  factory AccountProfileUpdate([void updates(AccountProfileUpdateBuilder b)]) = _$AccountProfileUpdate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AccountProfileUpdateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AccountProfileUpdate> get serializer => _$AccountProfileUpdateSerializer();
}

class _$AccountProfileUpdateSerializer implements PrimitiveSerializer<AccountProfileUpdate> {
  @override
  final Iterable<Type> types = const [AccountProfileUpdate, _$AccountProfileUpdate];

  @override
  final String wireName = r'AccountProfileUpdate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AccountProfileUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'full_name';
    yield serializers.serialize(
      object.fullName,
      specifiedType: const FullType(String),
    );
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
    if (object.buyerType != null) {
      yield r'buyer_type';
      yield serializers.serialize(
        object.buyerType,
        specifiedType: const FullType(AccountProfileUpdateBuyerTypeEnum),
      );
    }
    if (object.companyName != null) {
      yield r'company_name';
      yield serializers.serialize(
        object.companyName,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    AccountProfileUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AccountProfileUpdateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'full_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.fullName = valueDes;
          break;
        case r'lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lockVersion = valueDes;
          break;
        case r'buyer_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(AccountProfileUpdateBuyerTypeEnum),
          ) as AccountProfileUpdateBuyerTypeEnum?;
          if (valueDes == null) continue;
          result.buyerType = valueDes;
          break;
        case r'company_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.companyName = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AccountProfileUpdate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AccountProfileUpdateBuilder();
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


class AccountProfileUpdateBuyerTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'INDIVIDUAL')
  static const AccountProfileUpdateBuyerTypeEnum INDIVIDUAL = _$accountProfileUpdateBuyerTypeEnum_INDIVIDUAL;
  @BuiltValueEnumConst(wireName: r'BUSINESS')
  static const AccountProfileUpdateBuyerTypeEnum BUSINESS = _$accountProfileUpdateBuyerTypeEnum_BUSINESS;

  static Serializer<AccountProfileUpdateBuyerTypeEnum> get serializer => _$accountProfileUpdateBuyerTypeEnumSerializer;

  const AccountProfileUpdateBuyerTypeEnum._(String name): super(name);

  static BuiltSet<AccountProfileUpdateBuyerTypeEnum> get values => _$accountProfileUpdateBuyerTypeEnumValues;
  static AccountProfileUpdateBuyerTypeEnum valueOf(String name) => _$accountProfileUpdateBuyerTypeEnumValueOf(name);
}

