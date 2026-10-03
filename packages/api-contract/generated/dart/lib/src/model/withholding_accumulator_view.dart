//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'withholding_accumulator_view.g.dart';

/// WithholdingAccumulatorView
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
@BuiltValue()
abstract class WithholdingAccumulatorView implements Built<WithholdingAccumulatorView, WithholdingAccumulatorViewBuilder> {
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
  WithholdingAccumulatorViewStatusEnum get status;
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

  WithholdingAccumulatorView._();

  factory WithholdingAccumulatorView([void updates(WithholdingAccumulatorViewBuilder b)]) = _$WithholdingAccumulatorView;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(WithholdingAccumulatorViewBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<WithholdingAccumulatorView> get serializer => _$WithholdingAccumulatorViewSerializer();
}

class _$WithholdingAccumulatorViewSerializer implements PrimitiveSerializer<WithholdingAccumulatorView> {
  @override
  final Iterable<Type> types = const [WithholdingAccumulatorView, _$WithholdingAccumulatorView];

  @override
  final String wireName = r'WithholdingAccumulatorView';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    WithholdingAccumulatorView object, {
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
      specifiedType: const FullType(WithholdingAccumulatorViewStatusEnum),
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
  }

  @override
  Object serialize(
    Serializers serializers,
    WithholdingAccumulatorView object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required WithholdingAccumulatorViewBuilder result,
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
            specifiedType: const FullType(WithholdingAccumulatorViewStatusEnum),
          ) as WithholdingAccumulatorViewStatusEnum;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  WithholdingAccumulatorView deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = WithholdingAccumulatorViewBuilder();
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


class WithholdingAccumulatorViewStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'RELIEF_ACTIVE')
  static const WithholdingAccumulatorViewStatusEnum RELIEF_ACTIVE = _$withholdingAccumulatorViewStatusEnum_RELIEF_ACTIVE;
  @BuiltValueEnumConst(wireName: r'SUBJECT_STANDARD')
  static const WithholdingAccumulatorViewStatusEnum SUBJECT_STANDARD = _$withholdingAccumulatorViewStatusEnum_SUBJECT_STANDARD;
  @BuiltValueEnumConst(wireName: r'SUBJECT_THRESHOLD_BREACHED')
  static const WithholdingAccumulatorViewStatusEnum SUBJECT_THRESHOLD_BREACHED = _$withholdingAccumulatorViewStatusEnum_SUBJECT_THRESHOLD_BREACHED;
  @BuiltValueEnumConst(wireName: r'SUBJECT_PRIOR_YEAR')
  static const WithholdingAccumulatorViewStatusEnum SUBJECT_PRIOR_YEAR = _$withholdingAccumulatorViewStatusEnum_SUBJECT_PRIOR_YEAR;
  @BuiltValueEnumConst(wireName: r'UNDER_REVIEW')
  static const WithholdingAccumulatorViewStatusEnum UNDER_REVIEW = _$withholdingAccumulatorViewStatusEnum_UNDER_REVIEW;

  static Serializer<WithholdingAccumulatorViewStatusEnum> get serializer => _$withholdingAccumulatorViewStatusEnumSerializer;

  const WithholdingAccumulatorViewStatusEnum._(String name): super(name);

  static BuiltSet<WithholdingAccumulatorViewStatusEnum> get values => _$withholdingAccumulatorViewStatusEnumValues;
  static WithholdingAccumulatorViewStatusEnum valueOf(String name) => _$withholdingAccumulatorViewStatusEnumValueOf(name);
}

