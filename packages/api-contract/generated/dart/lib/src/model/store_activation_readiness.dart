//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/store_activation_blocker.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'store_activation_readiness.g.dart';

/// StoreActivationReadiness
///
/// Properties:
/// * [ready]
/// * [status]
/// * [ruleVersion]
/// * [blockers]
@BuiltValue()
abstract class StoreActivationReadiness implements Built<StoreActivationReadiness, StoreActivationReadinessBuilder> {
  @BuiltValueField(wireName: r'ready')
  bool get ready;

  @BuiltValueField(wireName: r'status')
  StoreActivationReadinessStatusEnum get status;
  // enum statusEnum {  READY,  NOT_READY,  };

  @BuiltValueField(wireName: r'rule_version')
  String get ruleVersion;

  @BuiltValueField(wireName: r'blockers')
  BuiltList<StoreActivationBlocker> get blockers;

  StoreActivationReadiness._();

  factory StoreActivationReadiness([void updates(StoreActivationReadinessBuilder b)]) = _$StoreActivationReadiness;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(StoreActivationReadinessBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<StoreActivationReadiness> get serializer => _$StoreActivationReadinessSerializer();
}

class _$StoreActivationReadinessSerializer implements PrimitiveSerializer<StoreActivationReadiness> {
  @override
  final Iterable<Type> types = const [StoreActivationReadiness, _$StoreActivationReadiness];

  @override
  final String wireName = r'StoreActivationReadiness';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    StoreActivationReadiness object, {
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
      specifiedType: const FullType(StoreActivationReadinessStatusEnum),
    );
    yield r'rule_version';
    yield serializers.serialize(
      object.ruleVersion,
      specifiedType: const FullType(String),
    );
    yield r'blockers';
    yield serializers.serialize(
      object.blockers,
      specifiedType: const FullType(BuiltList, [FullType(StoreActivationBlocker)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    StoreActivationReadiness object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required StoreActivationReadinessBuilder result,
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
            specifiedType: const FullType(StoreActivationReadinessStatusEnum),
          ) as StoreActivationReadinessStatusEnum;
          result.status = valueDes;
          break;
        case r'rule_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.ruleVersion = valueDes;
          break;
        case r'blockers':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(StoreActivationBlocker)]),
          ) as BuiltList<StoreActivationBlocker>;
          result.blockers.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  StoreActivationReadiness deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = StoreActivationReadinessBuilder();
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


class StoreActivationReadinessStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'READY')
  static const StoreActivationReadinessStatusEnum READY = _$storeActivationReadinessStatusEnum_READY;
  @BuiltValueEnumConst(wireName: r'NOT_READY')
  static const StoreActivationReadinessStatusEnum NOT_READY = _$storeActivationReadinessStatusEnum_NOT_READY;

  static Serializer<StoreActivationReadinessStatusEnum> get serializer => _$storeActivationReadinessStatusEnumSerializer;

  const StoreActivationReadinessStatusEnum._(String name): super(name);

  static BuiltSet<StoreActivationReadinessStatusEnum> get values => _$storeActivationReadinessStatusEnumValues;
  static StoreActivationReadinessStatusEnum valueOf(String name) => _$storeActivationReadinessStatusEnumValueOf(name);
}

