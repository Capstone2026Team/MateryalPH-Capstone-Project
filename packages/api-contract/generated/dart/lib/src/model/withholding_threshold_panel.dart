//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/threshold_status_event.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'withholding_threshold_panel.g.dart';

/// FIN-04A panel. Status never uses EXEMPT/SUBJECT_TO_WITHHOLDING; remaining allowance is floored at zero; every figure is DEMO.
///
/// Properties:
/// * [demo]
/// * [taxableYear]
/// * [yearStartAt]
/// * [yearEndAt]
/// * [thresholdCentavos]
/// * [cumulativeGrossCentavos]
/// * [remainingAllowanceCentavos]
/// * [localGrossCentavos]
/// * [externalDeclaredCentavos]
/// * [externalOverlapCentavos]
/// * [externalOverlapState]
/// * [percentOfThreshold]
/// * [advisory]
/// * [status]
/// * [statusLabel]
/// * [statusIcon]
/// * [reasonCode]
/// * [crossedAt]
/// * [crossedAtManila]
/// * [priorYearTotalCentavos]
/// * [finalForYearNotice]
/// * [events]
@BuiltValue()
abstract class WithholdingThresholdPanel implements Built<WithholdingThresholdPanel, WithholdingThresholdPanelBuilder> {
  @BuiltValueField(wireName: r'demo')
  bool get demo;

  @BuiltValueField(wireName: r'taxable_year')
  int get taxableYear;

  @BuiltValueField(wireName: r'year_start_at')
  DateTime get yearStartAt;

  @BuiltValueField(wireName: r'year_end_at')
  DateTime get yearEndAt;

  @BuiltValueField(wireName: r'threshold_centavos')
  int get thresholdCentavos;

  @BuiltValueField(wireName: r'cumulative_gross_centavos')
  int get cumulativeGrossCentavos;

  @BuiltValueField(wireName: r'remaining_allowance_centavos')
  int get remainingAllowanceCentavos;

  @BuiltValueField(wireName: r'local_gross_centavos')
  int get localGrossCentavos;

  @BuiltValueField(wireName: r'external_declared_centavos')
  int get externalDeclaredCentavos;

  @BuiltValueField(wireName: r'external_overlap_centavos')
  int get externalOverlapCentavos;

  @BuiltValueField(wireName: r'external_overlap_state')
  WithholdingThresholdPanelExternalOverlapStateEnum get externalOverlapState;
  // enum externalOverlapStateEnum {  NONE,  UNRESOLVED,  RESOLVED,  };

  @BuiltValueField(wireName: r'percent_of_threshold')
  int get percentOfThreshold;

  @BuiltValueField(wireName: r'advisory')
  bool get advisory;

  @BuiltValueField(wireName: r'status')
  WithholdingThresholdPanelStatusEnum get status;
  // enum statusEnum {  RELIEF_ACTIVE,  SUBJECT_STANDARD,  SUBJECT_THRESHOLD_BREACHED,  SUBJECT_PRIOR_YEAR,  UNDER_REVIEW,  NOT_STARTED,  };

  @BuiltValueField(wireName: r'status_label')
  String get statusLabel;

  @BuiltValueField(wireName: r'status_icon')
  String get statusIcon;

  @BuiltValueField(wireName: r'reason_code')
  String? get reasonCode;

  @BuiltValueField(wireName: r'crossed_at')
  DateTime? get crossedAt;

  @BuiltValueField(wireName: r'crossed_at_manila')
  String? get crossedAtManila;

  @BuiltValueField(wireName: r'prior_year_total_centavos')
  int? get priorYearTotalCentavos;

  @BuiltValueField(wireName: r'final_for_year_notice')
  String get finalForYearNotice;

  @BuiltValueField(wireName: r'events')
  BuiltList<ThresholdStatusEvent> get events;

  WithholdingThresholdPanel._();

  factory WithholdingThresholdPanel([void updates(WithholdingThresholdPanelBuilder b)]) = _$WithholdingThresholdPanel;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(WithholdingThresholdPanelBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<WithholdingThresholdPanel> get serializer => _$WithholdingThresholdPanelSerializer();
}

class _$WithholdingThresholdPanelSerializer implements PrimitiveSerializer<WithholdingThresholdPanel> {
  @override
  final Iterable<Type> types = const [WithholdingThresholdPanel, _$WithholdingThresholdPanel];

  @override
  final String wireName = r'WithholdingThresholdPanel';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    WithholdingThresholdPanel object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'demo';
    yield serializers.serialize(
      object.demo,
      specifiedType: const FullType(bool),
    );
    yield r'taxable_year';
    yield serializers.serialize(
      object.taxableYear,
      specifiedType: const FullType(int),
    );
    yield r'year_start_at';
    yield serializers.serialize(
      object.yearStartAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'year_end_at';
    yield serializers.serialize(
      object.yearEndAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'threshold_centavos';
    yield serializers.serialize(
      object.thresholdCentavos,
      specifiedType: const FullType(int),
    );
    yield r'cumulative_gross_centavos';
    yield serializers.serialize(
      object.cumulativeGrossCentavos,
      specifiedType: const FullType(int),
    );
    yield r'remaining_allowance_centavos';
    yield serializers.serialize(
      object.remainingAllowanceCentavos,
      specifiedType: const FullType(int),
    );
    yield r'local_gross_centavos';
    yield serializers.serialize(
      object.localGrossCentavos,
      specifiedType: const FullType(int),
    );
    yield r'external_declared_centavos';
    yield serializers.serialize(
      object.externalDeclaredCentavos,
      specifiedType: const FullType(int),
    );
    yield r'external_overlap_centavos';
    yield serializers.serialize(
      object.externalOverlapCentavos,
      specifiedType: const FullType(int),
    );
    yield r'external_overlap_state';
    yield serializers.serialize(
      object.externalOverlapState,
      specifiedType: const FullType(WithholdingThresholdPanelExternalOverlapStateEnum),
    );
    yield r'percent_of_threshold';
    yield serializers.serialize(
      object.percentOfThreshold,
      specifiedType: const FullType(int),
    );
    yield r'advisory';
    yield serializers.serialize(
      object.advisory,
      specifiedType: const FullType(bool),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(WithholdingThresholdPanelStatusEnum),
    );
    yield r'status_label';
    yield serializers.serialize(
      object.statusLabel,
      specifiedType: const FullType(String),
    );
    yield r'status_icon';
    yield serializers.serialize(
      object.statusIcon,
      specifiedType: const FullType(String),
    );
    if (object.reasonCode != null) {
      yield r'reason_code';
      yield serializers.serialize(
        object.reasonCode,
        specifiedType: const FullType(String),
      );
    }
    if (object.crossedAt != null) {
      yield r'crossed_at';
      yield serializers.serialize(
        object.crossedAt,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.crossedAtManila != null) {
      yield r'crossed_at_manila';
      yield serializers.serialize(
        object.crossedAtManila,
        specifiedType: const FullType(String),
      );
    }
    if (object.priorYearTotalCentavos != null) {
      yield r'prior_year_total_centavos';
      yield serializers.serialize(
        object.priorYearTotalCentavos,
        specifiedType: const FullType(int),
      );
    }
    yield r'final_for_year_notice';
    yield serializers.serialize(
      object.finalForYearNotice,
      specifiedType: const FullType(String),
    );
    yield r'events';
    yield serializers.serialize(
      object.events,
      specifiedType: const FullType(BuiltList, [FullType(ThresholdStatusEvent)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    WithholdingThresholdPanel object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required WithholdingThresholdPanelBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'demo':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.demo = valueDes;
          break;
        case r'taxable_year':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.taxableYear = valueDes;
          break;
        case r'year_start_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.yearStartAt = valueDes;
          break;
        case r'year_end_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.yearEndAt = valueDes;
          break;
        case r'threshold_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.thresholdCentavos = valueDes;
          break;
        case r'cumulative_gross_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.cumulativeGrossCentavos = valueDes;
          break;
        case r'remaining_allowance_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.remainingAllowanceCentavos = valueDes;
          break;
        case r'local_gross_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.localGrossCentavos = valueDes;
          break;
        case r'external_declared_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.externalDeclaredCentavos = valueDes;
          break;
        case r'external_overlap_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.externalOverlapCentavos = valueDes;
          break;
        case r'external_overlap_state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(WithholdingThresholdPanelExternalOverlapStateEnum),
          ) as WithholdingThresholdPanelExternalOverlapStateEnum;
          result.externalOverlapState = valueDes;
          break;
        case r'percent_of_threshold':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.percentOfThreshold = valueDes;
          break;
        case r'advisory':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.advisory = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(WithholdingThresholdPanelStatusEnum),
          ) as WithholdingThresholdPanelStatusEnum;
          result.status = valueDes;
          break;
        case r'status_label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.statusLabel = valueDes;
          break;
        case r'status_icon':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.statusIcon = valueDes;
          break;
        case r'reason_code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.reasonCode = valueDes;
          break;
        case r'crossed_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.crossedAt = valueDes;
          break;
        case r'crossed_at_manila':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.crossedAtManila = valueDes;
          break;
        case r'prior_year_total_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.priorYearTotalCentavos = valueDes;
          break;
        case r'final_for_year_notice':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.finalForYearNotice = valueDes;
          break;
        case r'events':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ThresholdStatusEvent)]),
          ) as BuiltList<ThresholdStatusEvent>;
          result.events.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  WithholdingThresholdPanel deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = WithholdingThresholdPanelBuilder();
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


class WithholdingThresholdPanelExternalOverlapStateEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'NONE')
  static const WithholdingThresholdPanelExternalOverlapStateEnum NONE = _$withholdingThresholdPanelExternalOverlapStateEnum_NONE;
  @BuiltValueEnumConst(wireName: r'UNRESOLVED')
  static const WithholdingThresholdPanelExternalOverlapStateEnum UNRESOLVED = _$withholdingThresholdPanelExternalOverlapStateEnum_UNRESOLVED;
  @BuiltValueEnumConst(wireName: r'RESOLVED')
  static const WithholdingThresholdPanelExternalOverlapStateEnum RESOLVED = _$withholdingThresholdPanelExternalOverlapStateEnum_RESOLVED;

  static Serializer<WithholdingThresholdPanelExternalOverlapStateEnum> get serializer => _$withholdingThresholdPanelExternalOverlapStateEnumSerializer;

  const WithholdingThresholdPanelExternalOverlapStateEnum._(String name): super(name);

  static BuiltSet<WithholdingThresholdPanelExternalOverlapStateEnum> get values => _$withholdingThresholdPanelExternalOverlapStateEnumValues;
  static WithholdingThresholdPanelExternalOverlapStateEnum valueOf(String name) => _$withholdingThresholdPanelExternalOverlapStateEnumValueOf(name);
}

class WithholdingThresholdPanelStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'RELIEF_ACTIVE')
  static const WithholdingThresholdPanelStatusEnum RELIEF_ACTIVE = _$withholdingThresholdPanelStatusEnum_RELIEF_ACTIVE;
  @BuiltValueEnumConst(wireName: r'SUBJECT_STANDARD')
  static const WithholdingThresholdPanelStatusEnum SUBJECT_STANDARD = _$withholdingThresholdPanelStatusEnum_SUBJECT_STANDARD;
  @BuiltValueEnumConst(wireName: r'SUBJECT_THRESHOLD_BREACHED')
  static const WithholdingThresholdPanelStatusEnum SUBJECT_THRESHOLD_BREACHED = _$withholdingThresholdPanelStatusEnum_SUBJECT_THRESHOLD_BREACHED;
  @BuiltValueEnumConst(wireName: r'SUBJECT_PRIOR_YEAR')
  static const WithholdingThresholdPanelStatusEnum SUBJECT_PRIOR_YEAR = _$withholdingThresholdPanelStatusEnum_SUBJECT_PRIOR_YEAR;
  @BuiltValueEnumConst(wireName: r'UNDER_REVIEW')
  static const WithholdingThresholdPanelStatusEnum UNDER_REVIEW = _$withholdingThresholdPanelStatusEnum_UNDER_REVIEW;
  @BuiltValueEnumConst(wireName: r'NOT_STARTED')
  static const WithholdingThresholdPanelStatusEnum NOT_STARTED = _$withholdingThresholdPanelStatusEnum_NOT_STARTED;

  static Serializer<WithholdingThresholdPanelStatusEnum> get serializer => _$withholdingThresholdPanelStatusEnumSerializer;

  const WithholdingThresholdPanelStatusEnum._(String name): super(name);

  static BuiltSet<WithholdingThresholdPanelStatusEnum> get values => _$withholdingThresholdPanelStatusEnumValues;
  static WithholdingThresholdPanelStatusEnum valueOf(String name) => _$withholdingThresholdPanelStatusEnumValueOf(name);
}

