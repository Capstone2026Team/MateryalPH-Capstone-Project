//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'withholding_accumulator_detail.g.dart';

/// WithholdingAccumulatorDetail
///
/// Properties:
/// * [id]
/// * [vendor]
/// * [environment]
/// * [taxpayerKeySuffix]
/// * [taxableYear]
/// * [thresholdCentavos]
/// * [gAccumulatedCentavos]
/// * [gExternalDeclaredCentavos]
/// * [gExternalOverlapCentavos]
/// * [gEffectiveCentavos]
/// * [remainingAllowanceCentavos]
/// * [externalOverlapState]
/// * [status]
/// * [statusLabel]
/// * [reasonCode]
/// * [breached]
/// * [crossedAt]
/// * [priorYearTotalCentavos]
/// * [lockVersion]
/// * [demo]
/// * [taxProfile]
/// * [events]
/// * [assessments]
@BuiltValue()
abstract class WithholdingAccumulatorDetail implements Built<WithholdingAccumulatorDetail, WithholdingAccumulatorDetailBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'vendor')
  BuiltMap<String, JsonObject?> get vendor;

  @BuiltValueField(wireName: r'environment')
  String get environment;

  @BuiltValueField(wireName: r'taxpayer_key_suffix')
  String get taxpayerKeySuffix;

  @BuiltValueField(wireName: r'taxable_year')
  int get taxableYear;

  @BuiltValueField(wireName: r'threshold_centavos')
  int get thresholdCentavos;

  @BuiltValueField(wireName: r'g_accumulated_centavos')
  int get gAccumulatedCentavos;

  @BuiltValueField(wireName: r'g_external_declared_centavos')
  int get gExternalDeclaredCentavos;

  @BuiltValueField(wireName: r'g_external_overlap_centavos')
  int get gExternalOverlapCentavos;

  @BuiltValueField(wireName: r'g_effective_centavos')
  int get gEffectiveCentavos;

  @BuiltValueField(wireName: r'remaining_allowance_centavos')
  int get remainingAllowanceCentavos;

  @BuiltValueField(wireName: r'external_overlap_state')
  String get externalOverlapState;

  @BuiltValueField(wireName: r'status')
  WithholdingAccumulatorDetailStatusEnum get status;
  // enum statusEnum {  RELIEF_ACTIVE,  SUBJECT_STANDARD,  SUBJECT_THRESHOLD_BREACHED,  SUBJECT_PRIOR_YEAR,  UNDER_REVIEW,  };

  @BuiltValueField(wireName: r'status_label')
  String get statusLabel;

  @BuiltValueField(wireName: r'reason_code')
  String get reasonCode;

  @BuiltValueField(wireName: r'breached')
  bool get breached;

  @BuiltValueField(wireName: r'crossed_at')
  DateTime? get crossedAt;

  @BuiltValueField(wireName: r'prior_year_total_centavos')
  int? get priorYearTotalCentavos;

  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  @BuiltValueField(wireName: r'demo')
  bool get demo;

  @BuiltValueField(wireName: r'tax_profile')
  BuiltMap<String, JsonObject?> get taxProfile;

  @BuiltValueField(wireName: r'events')
  BuiltList<BuiltMap<String, JsonObject?>> get events;

  @BuiltValueField(wireName: r'assessments')
  BuiltList<BuiltMap<String, JsonObject?>> get assessments;

  WithholdingAccumulatorDetail._();

  factory WithholdingAccumulatorDetail([void updates(WithholdingAccumulatorDetailBuilder b)]) = _$WithholdingAccumulatorDetail;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(WithholdingAccumulatorDetailBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<WithholdingAccumulatorDetail> get serializer => _$WithholdingAccumulatorDetailSerializer();
}

class _$WithholdingAccumulatorDetailSerializer implements PrimitiveSerializer<WithholdingAccumulatorDetail> {
  @override
  final Iterable<Type> types = const [WithholdingAccumulatorDetail, _$WithholdingAccumulatorDetail];

  @override
  final String wireName = r'WithholdingAccumulatorDetail';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    WithholdingAccumulatorDetail object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'vendor';
    yield serializers.serialize(
      object.vendor,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
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
    yield r'taxable_year';
    yield serializers.serialize(
      object.taxableYear,
      specifiedType: const FullType(int),
    );
    yield r'threshold_centavos';
    yield serializers.serialize(
      object.thresholdCentavos,
      specifiedType: const FullType(int),
    );
    yield r'g_accumulated_centavos';
    yield serializers.serialize(
      object.gAccumulatedCentavos,
      specifiedType: const FullType(int),
    );
    yield r'g_external_declared_centavos';
    yield serializers.serialize(
      object.gExternalDeclaredCentavos,
      specifiedType: const FullType(int),
    );
    yield r'g_external_overlap_centavos';
    yield serializers.serialize(
      object.gExternalOverlapCentavos,
      specifiedType: const FullType(int),
    );
    yield r'g_effective_centavos';
    yield serializers.serialize(
      object.gEffectiveCentavos,
      specifiedType: const FullType(int),
    );
    yield r'remaining_allowance_centavos';
    yield serializers.serialize(
      object.remainingAllowanceCentavos,
      specifiedType: const FullType(int),
    );
    yield r'external_overlap_state';
    yield serializers.serialize(
      object.externalOverlapState,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(WithholdingAccumulatorDetailStatusEnum),
    );
    yield r'status_label';
    yield serializers.serialize(
      object.statusLabel,
      specifiedType: const FullType(String),
    );
    yield r'reason_code';
    yield serializers.serialize(
      object.reasonCode,
      specifiedType: const FullType(String),
    );
    yield r'breached';
    yield serializers.serialize(
      object.breached,
      specifiedType: const FullType(bool),
    );
    if (object.crossedAt != null) {
      yield r'crossed_at';
      yield serializers.serialize(
        object.crossedAt,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.priorYearTotalCentavos != null) {
      yield r'prior_year_total_centavos';
      yield serializers.serialize(
        object.priorYearTotalCentavos,
        specifiedType: const FullType(int),
      );
    }
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
    yield r'demo';
    yield serializers.serialize(
      object.demo,
      specifiedType: const FullType(bool),
    );
    yield r'tax_profile';
    yield serializers.serialize(
      object.taxProfile,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
    yield r'events';
    yield serializers.serialize(
      object.events,
      specifiedType: const FullType(BuiltList, [FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)])]),
    );
    yield r'assessments';
    yield serializers.serialize(
      object.assessments,
      specifiedType: const FullType(BuiltList, [FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)])]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    WithholdingAccumulatorDetail object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required WithholdingAccumulatorDetailBuilder result,
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
        case r'vendor':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.vendor.replace(valueDes);
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
        case r'taxable_year':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.taxableYear = valueDes;
          break;
        case r'threshold_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.thresholdCentavos = valueDes;
          break;
        case r'g_accumulated_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.gAccumulatedCentavos = valueDes;
          break;
        case r'g_external_declared_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.gExternalDeclaredCentavos = valueDes;
          break;
        case r'g_external_overlap_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.gExternalOverlapCentavos = valueDes;
          break;
        case r'g_effective_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.gEffectiveCentavos = valueDes;
          break;
        case r'remaining_allowance_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.remainingAllowanceCentavos = valueDes;
          break;
        case r'external_overlap_state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.externalOverlapState = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(WithholdingAccumulatorDetailStatusEnum),
          ) as WithholdingAccumulatorDetailStatusEnum;
          result.status = valueDes;
          break;
        case r'status_label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.statusLabel = valueDes;
          break;
        case r'reason_code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reasonCode = valueDes;
          break;
        case r'breached':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.breached = valueDes;
          break;
        case r'crossed_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.crossedAt = valueDes;
          break;
        case r'prior_year_total_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.priorYearTotalCentavos = valueDes;
          break;
        case r'lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lockVersion = valueDes;
          break;
        case r'demo':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.demo = valueDes;
          break;
        case r'tax_profile':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.taxProfile.replace(valueDes);
          break;
        case r'events':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)])]),
          ) as BuiltList<BuiltMap<String, JsonObject?>>;
          result.events.replace(valueDes);
          break;
        case r'assessments':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)])]),
          ) as BuiltList<BuiltMap<String, JsonObject?>>;
          result.assessments.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  WithholdingAccumulatorDetail deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = WithholdingAccumulatorDetailBuilder();
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


class WithholdingAccumulatorDetailStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'RELIEF_ACTIVE')
  static const WithholdingAccumulatorDetailStatusEnum RELIEF_ACTIVE = _$withholdingAccumulatorDetailStatusEnum_RELIEF_ACTIVE;
  @BuiltValueEnumConst(wireName: r'SUBJECT_STANDARD')
  static const WithholdingAccumulatorDetailStatusEnum SUBJECT_STANDARD = _$withholdingAccumulatorDetailStatusEnum_SUBJECT_STANDARD;
  @BuiltValueEnumConst(wireName: r'SUBJECT_THRESHOLD_BREACHED')
  static const WithholdingAccumulatorDetailStatusEnum SUBJECT_THRESHOLD_BREACHED = _$withholdingAccumulatorDetailStatusEnum_SUBJECT_THRESHOLD_BREACHED;
  @BuiltValueEnumConst(wireName: r'SUBJECT_PRIOR_YEAR')
  static const WithholdingAccumulatorDetailStatusEnum SUBJECT_PRIOR_YEAR = _$withholdingAccumulatorDetailStatusEnum_SUBJECT_PRIOR_YEAR;
  @BuiltValueEnumConst(wireName: r'UNDER_REVIEW')
  static const WithholdingAccumulatorDetailStatusEnum UNDER_REVIEW = _$withholdingAccumulatorDetailStatusEnum_UNDER_REVIEW;

  static Serializer<WithholdingAccumulatorDetailStatusEnum> get serializer => _$withholdingAccumulatorDetailStatusEnumSerializer;

  const WithholdingAccumulatorDetailStatusEnum._(String name): super(name);

  static BuiltSet<WithholdingAccumulatorDetailStatusEnum> get values => _$withholdingAccumulatorDetailStatusEnumValues;
  static WithholdingAccumulatorDetailStatusEnum valueOf(String name) => _$withholdingAccumulatorDetailStatusEnumValueOf(name);
}

