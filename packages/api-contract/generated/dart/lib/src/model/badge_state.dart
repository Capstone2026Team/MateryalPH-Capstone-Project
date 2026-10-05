//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/badge_state_scopes_inner.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'badge_state.g.dart';

/// BadgeState
///
/// Properties:
/// * [code]
/// * [name]
/// * [description]
/// * [status]
/// * [scopes]
/// * [suppression]
@BuiltValue()
abstract class BadgeState implements Built<BadgeState, BadgeStateBuilder> {
  @BuiltValueField(wireName: r'code')
  BadgeStateCodeEnum get code;
  // enum codeEnum {  FAST_RESPONDER,  ON_TIME,  MOST_ORDERED,  HIGHLY_RATED,  HIGH_QUALITY_MATERIALS,  TRUSTED_SUPPLIER,  };

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'description')
  String get description;

  @BuiltValueField(wireName: r'status')
  BadgeStateStatusEnum get status;
  // enum statusEnum {  EARNED,  NOT_EARNED,  SUPPRESSED,  };

  @BuiltValueField(wireName: r'scopes')
  BuiltList<BadgeStateScopesInner> get scopes;

  @BuiltValueField(wireName: r'suppression')
  BuiltMap<String, JsonObject?>? get suppression;

  BadgeState._();

  factory BadgeState([void updates(BadgeStateBuilder b)]) = _$BadgeState;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BadgeStateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BadgeState> get serializer => _$BadgeStateSerializer();
}

class _$BadgeStateSerializer implements PrimitiveSerializer<BadgeState> {
  @override
  final Iterable<Type> types = const [BadgeState, _$BadgeState];

  @override
  final String wireName = r'BadgeState';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BadgeState object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(BadgeStateCodeEnum),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'description';
    yield serializers.serialize(
      object.description,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(BadgeStateStatusEnum),
    );
    yield r'scopes';
    yield serializers.serialize(
      object.scopes,
      specifiedType: const FullType(BuiltList, [FullType(BadgeStateScopesInner)]),
    );
    if (object.suppression != null) {
      yield r'suppression';
      yield serializers.serialize(
        object.suppression,
        specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    BadgeState object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BadgeStateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BadgeStateCodeEnum),
          ) as BadgeStateCodeEnum;
          result.code = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.description = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BadgeStateStatusEnum),
          ) as BadgeStateStatusEnum;
          result.status = valueDes;
          break;
        case r'scopes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(BadgeStateScopesInner)]),
          ) as BuiltList<BadgeStateScopesInner>;
          result.scopes.replace(valueDes);
          break;
        case r'suppression':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>?;
          if (valueDes == null) continue;
          result.suppression.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BadgeState deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BadgeStateBuilder();
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


class BadgeStateCodeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'FAST_RESPONDER')
  static const BadgeStateCodeEnum FAST_RESPONDER = _$badgeStateCodeEnum_FAST_RESPONDER;
  @BuiltValueEnumConst(wireName: r'ON_TIME')
  static const BadgeStateCodeEnum ON_TIME = _$badgeStateCodeEnum_ON_TIME;
  @BuiltValueEnumConst(wireName: r'MOST_ORDERED')
  static const BadgeStateCodeEnum MOST_ORDERED = _$badgeStateCodeEnum_MOST_ORDERED;
  @BuiltValueEnumConst(wireName: r'HIGHLY_RATED')
  static const BadgeStateCodeEnum HIGHLY_RATED = _$badgeStateCodeEnum_HIGHLY_RATED;
  @BuiltValueEnumConst(wireName: r'HIGH_QUALITY_MATERIALS')
  static const BadgeStateCodeEnum HIGH_QUALITY_MATERIALS = _$badgeStateCodeEnum_HIGH_QUALITY_MATERIALS;
  @BuiltValueEnumConst(wireName: r'TRUSTED_SUPPLIER')
  static const BadgeStateCodeEnum TRUSTED_SUPPLIER = _$badgeStateCodeEnum_TRUSTED_SUPPLIER;

  static Serializer<BadgeStateCodeEnum> get serializer => _$badgeStateCodeEnumSerializer;

  const BadgeStateCodeEnum._(String name): super(name);

  static BuiltSet<BadgeStateCodeEnum> get values => _$badgeStateCodeEnumValues;
  static BadgeStateCodeEnum valueOf(String name) => _$badgeStateCodeEnumValueOf(name);
}

class BadgeStateStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'EARNED')
  static const BadgeStateStatusEnum EARNED = _$badgeStateStatusEnum_EARNED;
  @BuiltValueEnumConst(wireName: r'NOT_EARNED')
  static const BadgeStateStatusEnum NOT_EARNED = _$badgeStateStatusEnum_NOT_EARNED;
  @BuiltValueEnumConst(wireName: r'SUPPRESSED')
  static const BadgeStateStatusEnum SUPPRESSED = _$badgeStateStatusEnum_SUPPRESSED;

  static Serializer<BadgeStateStatusEnum> get serializer => _$badgeStateStatusEnumSerializer;

  const BadgeStateStatusEnum._(String name): super(name);

  static BuiltSet<BadgeStateStatusEnum> get values => _$badgeStateStatusEnumValues;
  static BadgeStateStatusEnum valueOf(String name) => _$badgeStateStatusEnumValueOf(name);
}

