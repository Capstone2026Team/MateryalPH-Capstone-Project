//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'remittance_queue_row.g.dart';

/// RemittanceQueueRow
///
/// Properties:
/// * [id]
/// * [orderReference]
/// * [vendorName]
/// * [environment]
/// * [taxpayerKeySuffix]
/// * [scenario]
/// * [components]
/// * [thresholdStatusBefore]
/// * [thresholdStatusAfter]
/// * [gEffectiveBeforeCentavos]
/// * [gEffectiveAfterCentavos]
/// * [calculationState]
/// * [deductionEvidenceState]
/// * [reconciliationState]
/// * [reviewItemId]
/// * [reason]
/// * [createdAt]
@BuiltValue()
abstract class RemittanceQueueRow implements Built<RemittanceQueueRow, RemittanceQueueRowBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'order_reference')
  String get orderReference;

  @BuiltValueField(wireName: r'vendor_name')
  String get vendorName;

  @BuiltValueField(wireName: r'environment')
  String get environment;

  @BuiltValueField(wireName: r'taxpayer_key_suffix')
  String get taxpayerKeySuffix;

  @BuiltValueField(wireName: r'scenario')
  String? get scenario;

  @BuiltValueField(wireName: r'components')
  BuiltMap<String, JsonObject?> get components;

  @BuiltValueField(wireName: r'threshold_status_before')
  String? get thresholdStatusBefore;

  @BuiltValueField(wireName: r'threshold_status_after')
  String? get thresholdStatusAfter;

  @BuiltValueField(wireName: r'g_effective_before_centavos')
  int? get gEffectiveBeforeCentavos;

  @BuiltValueField(wireName: r'g_effective_after_centavos')
  int? get gEffectiveAfterCentavos;

  @BuiltValueField(wireName: r'calculation_state')
  String get calculationState;

  @BuiltValueField(wireName: r'deduction_evidence_state')
  String get deductionEvidenceState;

  @BuiltValueField(wireName: r'reconciliation_state')
  String get reconciliationState;

  @BuiltValueField(wireName: r'review_item_id')
  String? get reviewItemId;

  @BuiltValueField(wireName: r'reason')
  String get reason;

  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  RemittanceQueueRow._();

  factory RemittanceQueueRow([void updates(RemittanceQueueRowBuilder b)]) = _$RemittanceQueueRow;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RemittanceQueueRowBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RemittanceQueueRow> get serializer => _$RemittanceQueueRowSerializer();
}

class _$RemittanceQueueRowSerializer implements PrimitiveSerializer<RemittanceQueueRow> {
  @override
  final Iterable<Type> types = const [RemittanceQueueRow, _$RemittanceQueueRow];

  @override
  final String wireName = r'RemittanceQueueRow';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RemittanceQueueRow object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'order_reference';
    yield serializers.serialize(
      object.orderReference,
      specifiedType: const FullType(String),
    );
    yield r'vendor_name';
    yield serializers.serialize(
      object.vendorName,
      specifiedType: const FullType(String),
    );
    yield r'environment';
    yield serializers.serialize(
      object.environment,
      specifiedType: const FullType(String),
    );
    yield r'taxpayer_key_suffix';
    yield serializers.serialize(
      object.taxpayerKeySuffix,
      specifiedType: const FullType(String),
    );
    if (object.scenario != null) {
      yield r'scenario';
      yield serializers.serialize(
        object.scenario,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'components';
    yield serializers.serialize(
      object.components,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
    if (object.thresholdStatusBefore != null) {
      yield r'threshold_status_before';
      yield serializers.serialize(
        object.thresholdStatusBefore,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.thresholdStatusAfter != null) {
      yield r'threshold_status_after';
      yield serializers.serialize(
        object.thresholdStatusAfter,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.gEffectiveBeforeCentavos != null) {
      yield r'g_effective_before_centavos';
      yield serializers.serialize(
        object.gEffectiveBeforeCentavos,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.gEffectiveAfterCentavos != null) {
      yield r'g_effective_after_centavos';
      yield serializers.serialize(
        object.gEffectiveAfterCentavos,
        specifiedType: const FullType.nullable(int),
      );
    }
    yield r'calculation_state';
    yield serializers.serialize(
      object.calculationState,
      specifiedType: const FullType(String),
    );
    yield r'deduction_evidence_state';
    yield serializers.serialize(
      object.deductionEvidenceState,
      specifiedType: const FullType(String),
    );
    yield r'reconciliation_state';
    yield serializers.serialize(
      object.reconciliationState,
      specifiedType: const FullType(String),
    );
    if (object.reviewItemId != null) {
      yield r'review_item_id';
      yield serializers.serialize(
        object.reviewItemId,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
    yield r'created_at';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    RemittanceQueueRow object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RemittanceQueueRowBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'order_reference':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.orderReference = valueDes;
          break;
        case r'vendor_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.vendorName = valueDes;
          break;
        case r'environment':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.environment = valueDes;
          break;
        case r'taxpayer_key_suffix':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.taxpayerKeySuffix = valueDes;
          break;
        case r'scenario':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.scenario = valueDes;
          break;
        case r'components':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.components.replace(valueDes);
          break;
        case r'threshold_status_before':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.thresholdStatusBefore = valueDes;
          break;
        case r'threshold_status_after':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.thresholdStatusAfter = valueDes;
          break;
        case r'g_effective_before_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.gEffectiveBeforeCentavos = valueDes;
          break;
        case r'g_effective_after_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.gEffectiveAfterCentavos = valueDes;
          break;
        case r'calculation_state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.calculationState = valueDes;
          break;
        case r'deduction_evidence_state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.deductionEvidenceState = valueDes;
          break;
        case r'reconciliation_state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reconciliationState = valueDes;
          break;
        case r'review_item_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.reviewItemId = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reason = valueDes;
          break;
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RemittanceQueueRow deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RemittanceQueueRowBuilder();
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


