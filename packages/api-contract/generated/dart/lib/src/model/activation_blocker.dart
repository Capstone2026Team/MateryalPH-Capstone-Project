//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/activation_blocker_source.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'activation_blocker.g.dart';

/// ActivationBlocker
///
/// Properties:
/// * [key]
/// * [condition]
/// * [reason]
/// * [category]
/// * [source_]
@BuiltValue()
abstract class ActivationBlocker implements Built<ActivationBlocker, ActivationBlockerBuilder> {
  @BuiltValueField(wireName: r'key')
  String get key;

  @BuiltValueField(wireName: r'condition')
  int get condition;

  @BuiltValueField(wireName: r'reason')
  String get reason;

  @BuiltValueField(wireName: r'category')
  ActivationBlockerCategoryEnum get category;
  // enum categoryEnum {  ACCOUNT,  TERMS,  AUTHORITY,  TAX,  MEDIA,  HOURS,  SETUP,  DELIVERY,  PROVIDER_CAPABILITY,  HOLD,  VERIFICATION,  };

  @BuiltValueField(wireName: r'source')
  ActivationBlockerSource get source_;

  ActivationBlocker._();

  factory ActivationBlocker([void updates(ActivationBlockerBuilder b)]) = _$ActivationBlocker;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ActivationBlockerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ActivationBlocker> get serializer => _$ActivationBlockerSerializer();
}

class _$ActivationBlockerSerializer implements PrimitiveSerializer<ActivationBlocker> {
  @override
  final Iterable<Type> types = const [ActivationBlocker, _$ActivationBlocker];

  @override
  final String wireName = r'ActivationBlocker';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ActivationBlocker object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'key';
    yield serializers.serialize(
      object.key,
      specifiedType: const FullType(String),
    );
    yield r'condition';
    yield serializers.serialize(
      object.condition,
      specifiedType: const FullType(int),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
    yield r'category';
    yield serializers.serialize(
      object.category,
      specifiedType: const FullType(ActivationBlockerCategoryEnum),
    );
    yield r'source';
    yield serializers.serialize(
      object.source_,
      specifiedType: const FullType(ActivationBlockerSource),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ActivationBlocker object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ActivationBlockerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'key':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.key = valueDes;
          break;
        case r'condition':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.condition = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reason = valueDes;
          break;
        case r'category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ActivationBlockerCategoryEnum),
          ) as ActivationBlockerCategoryEnum;
          result.category = valueDes;
          break;
        case r'source':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ActivationBlockerSource),
          ) as ActivationBlockerSource;
          result.source_.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ActivationBlocker deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ActivationBlockerBuilder();
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


class ActivationBlockerCategoryEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ACCOUNT')
  static const ActivationBlockerCategoryEnum ACCOUNT = _$activationBlockerCategoryEnum_ACCOUNT;
  @BuiltValueEnumConst(wireName: r'TERMS')
  static const ActivationBlockerCategoryEnum TERMS = _$activationBlockerCategoryEnum_TERMS;
  @BuiltValueEnumConst(wireName: r'AUTHORITY')
  static const ActivationBlockerCategoryEnum AUTHORITY = _$activationBlockerCategoryEnum_AUTHORITY;
  @BuiltValueEnumConst(wireName: r'TAX')
  static const ActivationBlockerCategoryEnum TAX = _$activationBlockerCategoryEnum_TAX;
  @BuiltValueEnumConst(wireName: r'MEDIA')
  static const ActivationBlockerCategoryEnum MEDIA = _$activationBlockerCategoryEnum_MEDIA;
  @BuiltValueEnumConst(wireName: r'HOURS')
  static const ActivationBlockerCategoryEnum HOURS = _$activationBlockerCategoryEnum_HOURS;
  @BuiltValueEnumConst(wireName: r'SETUP')
  static const ActivationBlockerCategoryEnum SETUP = _$activationBlockerCategoryEnum_SETUP;
  @BuiltValueEnumConst(wireName: r'DELIVERY')
  static const ActivationBlockerCategoryEnum DELIVERY = _$activationBlockerCategoryEnum_DELIVERY;
  @BuiltValueEnumConst(wireName: r'PROVIDER_CAPABILITY')
  static const ActivationBlockerCategoryEnum PROVIDER_CAPABILITY = _$activationBlockerCategoryEnum_PROVIDER_CAPABILITY;
  @BuiltValueEnumConst(wireName: r'HOLD')
  static const ActivationBlockerCategoryEnum HOLD = _$activationBlockerCategoryEnum_HOLD;
  @BuiltValueEnumConst(wireName: r'VERIFICATION')
  static const ActivationBlockerCategoryEnum VERIFICATION = _$activationBlockerCategoryEnum_VERIFICATION;

  static Serializer<ActivationBlockerCategoryEnum> get serializer => _$activationBlockerCategoryEnumSerializer;

  const ActivationBlockerCategoryEnum._(String name): super(name);

  static BuiltSet<ActivationBlockerCategoryEnum> get values => _$activationBlockerCategoryEnumValues;
  static ActivationBlockerCategoryEnum valueOf(String name) => _$activationBlockerCategoryEnumValueOf(name);
}

