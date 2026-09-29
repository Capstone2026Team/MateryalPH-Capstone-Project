//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/store_next_opening.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'store_open_now.g.dart';

/// Informational label from the saved schedule and server time in Asia/Manila; not staff presence, stock or a response promise.
///
/// Properties:
/// * [status]
/// * [closesAt]
/// * [nextOpening]
/// * [basis]
@BuiltValue()
abstract class StoreOpenNow implements Built<StoreOpenNow, StoreOpenNowBuilder> {
  @BuiltValueField(wireName: r'status')
  StoreOpenNowStatusEnum get status;
  // enum statusEnum {  OPEN,  CLOSED,  UNAVAILABLE,  };

  @BuiltValueField(wireName: r'closes_at')
  String? get closesAt;

  @BuiltValueField(wireName: r'next_opening')
  StoreNextOpening? get nextOpening;

  @BuiltValueField(wireName: r'basis')
  StoreOpenNowBasisEnum get basis;
  // enum basisEnum {  SAVED_SCHEDULE,  DATE_OVERRIDE,  };

  StoreOpenNow._();

  factory StoreOpenNow([void updates(StoreOpenNowBuilder b)]) = _$StoreOpenNow;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(StoreOpenNowBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<StoreOpenNow> get serializer => _$StoreOpenNowSerializer();
}

class _$StoreOpenNowSerializer implements PrimitiveSerializer<StoreOpenNow> {
  @override
  final Iterable<Type> types = const [StoreOpenNow, _$StoreOpenNow];

  @override
  final String wireName = r'StoreOpenNow';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    StoreOpenNow object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(StoreOpenNowStatusEnum),
    );
    yield r'closes_at';
    yield object.closesAt == null ? null : serializers.serialize(
      object.closesAt,
      specifiedType: const FullType.nullable(String),
    );
    yield r'next_opening';
    yield object.nextOpening == null ? null : serializers.serialize(
      object.nextOpening,
      specifiedType: const FullType.nullable(StoreNextOpening),
    );
    yield r'basis';
    yield serializers.serialize(
      object.basis,
      specifiedType: const FullType(StoreOpenNowBasisEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    StoreOpenNow object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required StoreOpenNowBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(StoreOpenNowStatusEnum),
          ) as StoreOpenNowStatusEnum;
          result.status = valueDes;
          break;
        case r'closes_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.closesAt = valueDes;
          break;
        case r'next_opening':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(StoreNextOpening),
          ) as StoreNextOpening?;
          if (valueDes == null) continue;
          result.nextOpening.replace(valueDes);
          break;
        case r'basis':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(StoreOpenNowBasisEnum),
          ) as StoreOpenNowBasisEnum;
          result.basis = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  StoreOpenNow deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = StoreOpenNowBuilder();
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


class StoreOpenNowStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'OPEN')
  static const StoreOpenNowStatusEnum OPEN = _$storeOpenNowStatusEnum_OPEN;
  @BuiltValueEnumConst(wireName: r'CLOSED')
  static const StoreOpenNowStatusEnum CLOSED = _$storeOpenNowStatusEnum_CLOSED;
  @BuiltValueEnumConst(wireName: r'UNAVAILABLE')
  static const StoreOpenNowStatusEnum UNAVAILABLE = _$storeOpenNowStatusEnum_UNAVAILABLE;

  static Serializer<StoreOpenNowStatusEnum> get serializer => _$storeOpenNowStatusEnumSerializer;

  const StoreOpenNowStatusEnum._(String name): super(name);

  static BuiltSet<StoreOpenNowStatusEnum> get values => _$storeOpenNowStatusEnumValues;
  static StoreOpenNowStatusEnum valueOf(String name) => _$storeOpenNowStatusEnumValueOf(name);
}

class StoreOpenNowBasisEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'SAVED_SCHEDULE')
  static const StoreOpenNowBasisEnum SAVED_SCHEDULE = _$storeOpenNowBasisEnum_SAVED_SCHEDULE;
  @BuiltValueEnumConst(wireName: r'DATE_OVERRIDE')
  static const StoreOpenNowBasisEnum DATE_OVERRIDE = _$storeOpenNowBasisEnum_DATE_OVERRIDE;

  static Serializer<StoreOpenNowBasisEnum> get serializer => _$storeOpenNowBasisEnumSerializer;

  const StoreOpenNowBasisEnum._(String name): super(name);

  static BuiltSet<StoreOpenNowBasisEnum> get values => _$storeOpenNowBasisEnumValues;
  static StoreOpenNowBasisEnum valueOf(String name) => _$storeOpenNowBasisEnumValueOf(name);
}

