//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'integration_status.g.dart';

/// IntegrationStatus
///
/// Properties:
/// * [key]
/// * [label]
/// * [status]
/// * [detail]
/// * [environment]
/// * [lastEventAt]
@BuiltValue()
abstract class IntegrationStatus implements Built<IntegrationStatus, IntegrationStatusBuilder> {
  @BuiltValueField(wireName: r'key')
  String get key;

  @BuiltValueField(wireName: r'label')
  String get label;

  @BuiltValueField(wireName: r'status')
  IntegrationStatusStatusEnum get status;
  // enum statusEnum {  HEALTHY,  DEGRADED,  NOT_CONFIGURED,  SIMULATED,  };

  @BuiltValueField(wireName: r'detail')
  String get detail;

  @BuiltValueField(wireName: r'environment')
  String? get environment;

  @BuiltValueField(wireName: r'last_event_at')
  DateTime? get lastEventAt;

  IntegrationStatus._();

  factory IntegrationStatus([void updates(IntegrationStatusBuilder b)]) = _$IntegrationStatus;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(IntegrationStatusBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<IntegrationStatus> get serializer => _$IntegrationStatusSerializer();
}

class _$IntegrationStatusSerializer implements PrimitiveSerializer<IntegrationStatus> {
  @override
  final Iterable<Type> types = const [IntegrationStatus, _$IntegrationStatus];

  @override
  final String wireName = r'IntegrationStatus';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    IntegrationStatus object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'key';
    yield serializers.serialize(
      object.key,
      specifiedType: const FullType(String),
    );
    yield r'label';
    yield serializers.serialize(
      object.label,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(IntegrationStatusStatusEnum),
    );
    yield r'detail';
    yield serializers.serialize(
      object.detail,
      specifiedType: const FullType(String),
    );
    if (object.environment != null) {
      yield r'environment';
      yield serializers.serialize(
        object.environment,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.lastEventAt != null) {
      yield r'last_event_at';
      yield serializers.serialize(
        object.lastEventAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    IntegrationStatus object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required IntegrationStatusBuilder result,
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
        case r'label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.label = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(IntegrationStatusStatusEnum),
          ) as IntegrationStatusStatusEnum;
          result.status = valueDes;
          break;
        case r'detail':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.detail = valueDes;
          break;
        case r'environment':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.environment = valueDes;
          break;
        case r'last_event_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.lastEventAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  IntegrationStatus deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = IntegrationStatusBuilder();
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


class IntegrationStatusStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'HEALTHY')
  static const IntegrationStatusStatusEnum HEALTHY = _$integrationStatusStatusEnum_HEALTHY;
  @BuiltValueEnumConst(wireName: r'DEGRADED')
  static const IntegrationStatusStatusEnum DEGRADED = _$integrationStatusStatusEnum_DEGRADED;
  @BuiltValueEnumConst(wireName: r'NOT_CONFIGURED')
  static const IntegrationStatusStatusEnum NOT_CONFIGURED = _$integrationStatusStatusEnum_NOT_CONFIGURED;
  @BuiltValueEnumConst(wireName: r'SIMULATED')
  static const IntegrationStatusStatusEnum SIMULATED = _$integrationStatusStatusEnum_SIMULATED;

  static Serializer<IntegrationStatusStatusEnum> get serializer => _$integrationStatusStatusEnumSerializer;

  const IntegrationStatusStatusEnum._(String name): super(name);

  static BuiltSet<IntegrationStatusStatusEnum> get values => _$integrationStatusStatusEnumValues;
  static IntegrationStatusStatusEnum valueOf(String name) => _$integrationStatusStatusEnumValueOf(name);
}

