//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'auto_accept_policy_version.g.dart';

/// AutoAcceptPolicyVersion
///
/// Properties:
/// * [version]
/// * [changeKind]
/// * [enabled]
/// * [paused]
/// * [pauseReason]
/// * [allotmentQuantity]
/// * [remainingAllotmentQuantity]
/// * [maxUnitCount]
/// * [maxOrderAmountCentavos]
/// * [createdAt]
/// * [automated]
/// * [actor]
@BuiltValue()
abstract class AutoAcceptPolicyVersion implements Built<AutoAcceptPolicyVersion, AutoAcceptPolicyVersionBuilder> {
  @BuiltValueField(wireName: r'version')
  int get version;

  @BuiltValueField(wireName: r'change_kind')
  AutoAcceptPolicyVersionChangeKindEnum get changeKind;
  // enum changeKindEnum {  CONFIGURED,  ALLOTMENT_UPDATED,  PAUSED,  RESUMED,  EXHAUSTED,  DISABLED,  };

  @BuiltValueField(wireName: r'enabled')
  bool get enabled;

  @BuiltValueField(wireName: r'paused')
  bool get paused;

  @BuiltValueField(wireName: r'pause_reason')
  String? get pauseReason;

  @BuiltValueField(wireName: r'allotment_quantity')
  String get allotmentQuantity;

  @BuiltValueField(wireName: r'remaining_allotment_quantity')
  String get remainingAllotmentQuantity;

  @BuiltValueField(wireName: r'max_unit_count')
  String? get maxUnitCount;

  @BuiltValueField(wireName: r'max_order_amount_centavos')
  int? get maxOrderAmountCentavos;

  @BuiltValueField(wireName: r'created_at')
  String? get createdAt;

  @BuiltValueField(wireName: r'automated')
  bool get automated;

  @BuiltValueField(wireName: r'actor')
  String get actor;

  AutoAcceptPolicyVersion._();

  factory AutoAcceptPolicyVersion([void updates(AutoAcceptPolicyVersionBuilder b)]) = _$AutoAcceptPolicyVersion;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AutoAcceptPolicyVersionBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AutoAcceptPolicyVersion> get serializer => _$AutoAcceptPolicyVersionSerializer();
}

class _$AutoAcceptPolicyVersionSerializer implements PrimitiveSerializer<AutoAcceptPolicyVersion> {
  @override
  final Iterable<Type> types = const [AutoAcceptPolicyVersion, _$AutoAcceptPolicyVersion];

  @override
  final String wireName = r'AutoAcceptPolicyVersion';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AutoAcceptPolicyVersion object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'version';
    yield serializers.serialize(
      object.version,
      specifiedType: const FullType(int),
    );
    yield r'change_kind';
    yield serializers.serialize(
      object.changeKind,
      specifiedType: const FullType(AutoAcceptPolicyVersionChangeKindEnum),
    );
    yield r'enabled';
    yield serializers.serialize(
      object.enabled,
      specifiedType: const FullType(bool),
    );
    yield r'paused';
    yield serializers.serialize(
      object.paused,
      specifiedType: const FullType(bool),
    );
    yield r'pause_reason';
    yield object.pauseReason == null ? null : serializers.serialize(
      object.pauseReason,
      specifiedType: const FullType.nullable(String),
    );
    yield r'allotment_quantity';
    yield serializers.serialize(
      object.allotmentQuantity,
      specifiedType: const FullType(String),
    );
    yield r'remaining_allotment_quantity';
    yield serializers.serialize(
      object.remainingAllotmentQuantity,
      specifiedType: const FullType(String),
    );
    yield r'max_unit_count';
    yield object.maxUnitCount == null ? null : serializers.serialize(
      object.maxUnitCount,
      specifiedType: const FullType.nullable(String),
    );
    yield r'max_order_amount_centavos';
    yield object.maxOrderAmountCentavos == null ? null : serializers.serialize(
      object.maxOrderAmountCentavos,
      specifiedType: const FullType.nullable(int),
    );
    yield r'created_at';
    yield object.createdAt == null ? null : serializers.serialize(
      object.createdAt,
      specifiedType: const FullType.nullable(String),
    );
    yield r'automated';
    yield serializers.serialize(
      object.automated,
      specifiedType: const FullType(bool),
    );
    yield r'actor';
    yield serializers.serialize(
      object.actor,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AutoAcceptPolicyVersion object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AutoAcceptPolicyVersionBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.version = valueDes;
          break;
        case r'change_kind':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AutoAcceptPolicyVersionChangeKindEnum),
          ) as AutoAcceptPolicyVersionChangeKindEnum;
          result.changeKind = valueDes;
          break;
        case r'enabled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.enabled = valueDes;
          break;
        case r'paused':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.paused = valueDes;
          break;
        case r'pause_reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.pauseReason = valueDes;
          break;
        case r'allotment_quantity':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.allotmentQuantity = valueDes;
          break;
        case r'remaining_allotment_quantity':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.remainingAllotmentQuantity = valueDes;
          break;
        case r'max_unit_count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.maxUnitCount = valueDes;
          break;
        case r'max_order_amount_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.maxOrderAmountCentavos = valueDes;
          break;
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.createdAt = valueDes;
          break;
        case r'automated':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.automated = valueDes;
          break;
        case r'actor':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.actor = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AutoAcceptPolicyVersion deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AutoAcceptPolicyVersionBuilder();
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


class AutoAcceptPolicyVersionChangeKindEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'CONFIGURED')
  static const AutoAcceptPolicyVersionChangeKindEnum CONFIGURED = _$autoAcceptPolicyVersionChangeKindEnum_CONFIGURED;
  @BuiltValueEnumConst(wireName: r'ALLOTMENT_UPDATED')
  static const AutoAcceptPolicyVersionChangeKindEnum ALLOTMENT_UPDATED = _$autoAcceptPolicyVersionChangeKindEnum_ALLOTMENT_UPDATED;
  @BuiltValueEnumConst(wireName: r'PAUSED')
  static const AutoAcceptPolicyVersionChangeKindEnum PAUSED = _$autoAcceptPolicyVersionChangeKindEnum_PAUSED;
  @BuiltValueEnumConst(wireName: r'RESUMED')
  static const AutoAcceptPolicyVersionChangeKindEnum RESUMED = _$autoAcceptPolicyVersionChangeKindEnum_RESUMED;
  @BuiltValueEnumConst(wireName: r'EXHAUSTED')
  static const AutoAcceptPolicyVersionChangeKindEnum EXHAUSTED = _$autoAcceptPolicyVersionChangeKindEnum_EXHAUSTED;
  @BuiltValueEnumConst(wireName: r'DISABLED')
  static const AutoAcceptPolicyVersionChangeKindEnum DISABLED = _$autoAcceptPolicyVersionChangeKindEnum_DISABLED;

  static Serializer<AutoAcceptPolicyVersionChangeKindEnum> get serializer => _$autoAcceptPolicyVersionChangeKindEnumSerializer;

  const AutoAcceptPolicyVersionChangeKindEnum._(String name): super(name);

  static BuiltSet<AutoAcceptPolicyVersionChangeKindEnum> get values => _$autoAcceptPolicyVersionChangeKindEnumValues;
  static AutoAcceptPolicyVersionChangeKindEnum valueOf(String name) => _$autoAcceptPolicyVersionChangeKindEnumValueOf(name);
}

