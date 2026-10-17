//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/activation_blocker.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'activation_restrictions.g.dart';

/// StoreActivationGate result explained by source revision. There is no override; teams and products never block.
///
/// Properties:
/// * [ready]
/// * [status]
/// * [ruleVersion]
/// * [evaluatedAt]
/// * [blockers]
/// * [categories]
/// * [notBlocking]
/// * [overrideAvailable]
@BuiltValue()
abstract class ActivationRestrictions implements Built<ActivationRestrictions, ActivationRestrictionsBuilder> {
  @BuiltValueField(wireName: r'ready')
  bool get ready;

  @BuiltValueField(wireName: r'status')
  String get status;

  @BuiltValueField(wireName: r'rule_version')
  String get ruleVersion;

  @BuiltValueField(wireName: r'evaluated_at')
  DateTime get evaluatedAt;

  @BuiltValueField(wireName: r'blockers')
  BuiltList<ActivationBlocker> get blockers;

  @BuiltValueField(wireName: r'categories')
  BuiltList<ActivationRestrictionsCategoriesEnum> get categories;
  // enum categoriesEnum {  ACCOUNT,  TERMS,  AUTHORITY,  TAX,  MEDIA,  HOURS,  SETUP,  DELIVERY,  PROVIDER_CAPABILITY,  HOLD,  VERIFICATION,  };

  @BuiltValueField(wireName: r'not_blocking')
  BuiltList<String> get notBlocking;

  @BuiltValueField(wireName: r'override_available')
  ActivationRestrictionsOverrideAvailableEnum get overrideAvailable;
  // enum overrideAvailableEnum {  false,  };

  ActivationRestrictions._();

  factory ActivationRestrictions([void updates(ActivationRestrictionsBuilder b)]) = _$ActivationRestrictions;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ActivationRestrictionsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ActivationRestrictions> get serializer => _$ActivationRestrictionsSerializer();
}

class _$ActivationRestrictionsSerializer implements PrimitiveSerializer<ActivationRestrictions> {
  @override
  final Iterable<Type> types = const [ActivationRestrictions, _$ActivationRestrictions];

  @override
  final String wireName = r'ActivationRestrictions';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ActivationRestrictions object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'ready';
    yield serializers.serialize(
      object.ready,
      specifiedType: const FullType(bool),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(String),
    );
    yield r'rule_version';
    yield serializers.serialize(
      object.ruleVersion,
      specifiedType: const FullType(String),
    );
    yield r'evaluated_at';
    yield serializers.serialize(
      object.evaluatedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'blockers';
    yield serializers.serialize(
      object.blockers,
      specifiedType: const FullType(BuiltList, [FullType(ActivationBlocker)]),
    );
    yield r'categories';
    yield serializers.serialize(
      object.categories,
      specifiedType: const FullType(BuiltList, [FullType(ActivationRestrictionsCategoriesEnum)]),
    );
    yield r'not_blocking';
    yield serializers.serialize(
      object.notBlocking,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'override_available';
    yield serializers.serialize(
      object.overrideAvailable,
      specifiedType: const FullType(ActivationRestrictionsOverrideAvailableEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ActivationRestrictions object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ActivationRestrictionsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'ready':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.ready = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.status = valueDes;
          break;
        case r'rule_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.ruleVersion = valueDes;
          break;
        case r'evaluated_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.evaluatedAt = valueDes;
          break;
        case r'blockers':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ActivationBlocker)]),
          ) as BuiltList<ActivationBlocker>;
          result.blockers.replace(valueDes);
          break;
        case r'categories':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ActivationRestrictionsCategoriesEnum)]),
          ) as BuiltList<ActivationRestrictionsCategoriesEnum>;
          result.categories.replace(valueDes);
          break;
        case r'not_blocking':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.notBlocking.replace(valueDes);
          break;
        case r'override_available':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ActivationRestrictionsOverrideAvailableEnum),
          ) as ActivationRestrictionsOverrideAvailableEnum;
          result.overrideAvailable = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ActivationRestrictions deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ActivationRestrictionsBuilder();
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


class ActivationRestrictionsCategoriesEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ACCOUNT')
  static const ActivationRestrictionsCategoriesEnum ACCOUNT = _$activationRestrictionsCategoriesEnum_ACCOUNT;
  @BuiltValueEnumConst(wireName: r'TERMS')
  static const ActivationRestrictionsCategoriesEnum TERMS = _$activationRestrictionsCategoriesEnum_TERMS;
  @BuiltValueEnumConst(wireName: r'AUTHORITY')
  static const ActivationRestrictionsCategoriesEnum AUTHORITY = _$activationRestrictionsCategoriesEnum_AUTHORITY;
  @BuiltValueEnumConst(wireName: r'TAX')
  static const ActivationRestrictionsCategoriesEnum TAX = _$activationRestrictionsCategoriesEnum_TAX;
  @BuiltValueEnumConst(wireName: r'MEDIA')
  static const ActivationRestrictionsCategoriesEnum MEDIA = _$activationRestrictionsCategoriesEnum_MEDIA;
  @BuiltValueEnumConst(wireName: r'HOURS')
  static const ActivationRestrictionsCategoriesEnum HOURS = _$activationRestrictionsCategoriesEnum_HOURS;
  @BuiltValueEnumConst(wireName: r'SETUP')
  static const ActivationRestrictionsCategoriesEnum SETUP = _$activationRestrictionsCategoriesEnum_SETUP;
  @BuiltValueEnumConst(wireName: r'DELIVERY')
  static const ActivationRestrictionsCategoriesEnum DELIVERY = _$activationRestrictionsCategoriesEnum_DELIVERY;
  @BuiltValueEnumConst(wireName: r'PROVIDER_CAPABILITY')
  static const ActivationRestrictionsCategoriesEnum PROVIDER_CAPABILITY = _$activationRestrictionsCategoriesEnum_PROVIDER_CAPABILITY;
  @BuiltValueEnumConst(wireName: r'HOLD')
  static const ActivationRestrictionsCategoriesEnum HOLD = _$activationRestrictionsCategoriesEnum_HOLD;
  @BuiltValueEnumConst(wireName: r'VERIFICATION')
  static const ActivationRestrictionsCategoriesEnum VERIFICATION = _$activationRestrictionsCategoriesEnum_VERIFICATION;

  static Serializer<ActivationRestrictionsCategoriesEnum> get serializer => _$activationRestrictionsCategoriesEnumSerializer;

  const ActivationRestrictionsCategoriesEnum._(String name): super(name);

  static BuiltSet<ActivationRestrictionsCategoriesEnum> get values => _$activationRestrictionsCategoriesEnumValues;
  static ActivationRestrictionsCategoriesEnum valueOf(String name) => _$activationRestrictionsCategoriesEnumValueOf(name);
}

class ActivationRestrictionsOverrideAvailableEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'false')
  static const ActivationRestrictionsOverrideAvailableEnum false_ = _$activationRestrictionsOverrideAvailableEnum_false_;

  static Serializer<ActivationRestrictionsOverrideAvailableEnum> get serializer => _$activationRestrictionsOverrideAvailableEnumSerializer;

  const ActivationRestrictionsOverrideAvailableEnum._(String name): super(name);

  static BuiltSet<ActivationRestrictionsOverrideAvailableEnum> get values => _$activationRestrictionsOverrideAvailableEnumValues;
  static ActivationRestrictionsOverrideAvailableEnum valueOf(String name) => _$activationRestrictionsOverrideAvailableEnumValueOf(name);
}

