//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/auto_accept_status.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'auto_accept_policy.g.dart';

/// AutoAcceptPolicy
///
/// Properties:
/// * [status]
/// * [enabled]
/// * [paused]
/// * [pauseReason]
/// * [pausedAt]
/// * [allotmentQuantity] - Whole-number allotment last set.
/// * [remainingAllotmentQuantity] - Whole units still available to auto-accept.
/// * [maxUnitCount] - Independent per-order unit safeguard; null means no unit cap.
/// * [maxOrderAmountCentavos] - Independent Buyer commercial total safeguard; null means no amount cap.
/// * [currentVersion]
/// * [lockVersion]
/// * [updatedAt]
/// * [lastEditor]
@BuiltValue()
abstract class AutoAcceptPolicy implements Built<AutoAcceptPolicy, AutoAcceptPolicyBuilder> {
  @BuiltValueField(wireName: r'status')
  AutoAcceptStatus get status;
  // enum statusEnum {  DISABLED,  ACTIVE,  PAUSED,  };

  @BuiltValueField(wireName: r'enabled')
  bool get enabled;

  @BuiltValueField(wireName: r'paused')
  bool get paused;

  @BuiltValueField(wireName: r'pause_reason')
  AutoAcceptPolicyPauseReasonEnum? get pauseReason;
  // enum pauseReasonEnum {  ALLOTMENT_EXHAUSTED,  MANUAL,  ,  };

  @BuiltValueField(wireName: r'paused_at')
  String? get pausedAt;

  /// Whole-number allotment last set.
  @BuiltValueField(wireName: r'allotment_quantity')
  String get allotmentQuantity;

  /// Whole units still available to auto-accept.
  @BuiltValueField(wireName: r'remaining_allotment_quantity')
  String get remainingAllotmentQuantity;

  /// Independent per-order unit safeguard; null means no unit cap.
  @BuiltValueField(wireName: r'max_unit_count')
  String? get maxUnitCount;

  /// Independent Buyer commercial total safeguard; null means no amount cap.
  @BuiltValueField(wireName: r'max_order_amount_centavos')
  int? get maxOrderAmountCentavos;

  @BuiltValueField(wireName: r'current_version')
  int get currentVersion;

  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  @BuiltValueField(wireName: r'updated_at')
  String? get updatedAt;

  @BuiltValueField(wireName: r'last_editor')
  String? get lastEditor;

  AutoAcceptPolicy._();

  factory AutoAcceptPolicy([void updates(AutoAcceptPolicyBuilder b)]) = _$AutoAcceptPolicy;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AutoAcceptPolicyBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AutoAcceptPolicy> get serializer => _$AutoAcceptPolicySerializer();
}

class _$AutoAcceptPolicySerializer implements PrimitiveSerializer<AutoAcceptPolicy> {
  @override
  final Iterable<Type> types = const [AutoAcceptPolicy, _$AutoAcceptPolicy];

  @override
  final String wireName = r'AutoAcceptPolicy';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AutoAcceptPolicy object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(AutoAcceptStatus),
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
      specifiedType: const FullType.nullable(AutoAcceptPolicyPauseReasonEnum),
    );
    yield r'paused_at';
    yield object.pausedAt == null ? null : serializers.serialize(
      object.pausedAt,
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
    yield r'current_version';
    yield serializers.serialize(
      object.currentVersion,
      specifiedType: const FullType(int),
    );
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
    yield r'updated_at';
    yield object.updatedAt == null ? null : serializers.serialize(
      object.updatedAt,
      specifiedType: const FullType.nullable(String),
    );
    if (object.lastEditor != null) {
      yield r'last_editor';
      yield serializers.serialize(
        object.lastEditor,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    AutoAcceptPolicy object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AutoAcceptPolicyBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AutoAcceptStatus),
          ) as AutoAcceptStatus;
          result.status = valueDes;
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
            specifiedType: const FullType.nullable(AutoAcceptPolicyPauseReasonEnum),
          ) as AutoAcceptPolicyPauseReasonEnum?;
          if (valueDes == null) continue;
          result.pauseReason = valueDes;
          break;
        case r'paused_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.pausedAt = valueDes;
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
        case r'current_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.currentVersion = valueDes;
          break;
        case r'lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lockVersion = valueDes;
          break;
        case r'updated_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.updatedAt = valueDes;
          break;
        case r'last_editor':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.lastEditor = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AutoAcceptPolicy deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AutoAcceptPolicyBuilder();
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


class AutoAcceptPolicyPauseReasonEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ALLOTMENT_EXHAUSTED')
  static const AutoAcceptPolicyPauseReasonEnum ALLOTMENT_EXHAUSTED = _$autoAcceptPolicyPauseReasonEnum_ALLOTMENT_EXHAUSTED;
  @BuiltValueEnumConst(wireName: r'MANUAL')
  static const AutoAcceptPolicyPauseReasonEnum MANUAL = _$autoAcceptPolicyPauseReasonEnum_MANUAL;

  static Serializer<AutoAcceptPolicyPauseReasonEnum> get serializer => _$autoAcceptPolicyPauseReasonEnumSerializer;

  const AutoAcceptPolicyPauseReasonEnum._(String name): super(name);

  static BuiltSet<AutoAcceptPolicyPauseReasonEnum> get values => _$autoAcceptPolicyPauseReasonEnumValues;
  static AutoAcceptPolicyPauseReasonEnum valueOf(String name) => _$autoAcceptPolicyPauseReasonEnumValueOf(name);
}

