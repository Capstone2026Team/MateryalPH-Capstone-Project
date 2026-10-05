//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/date.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'analytics_trend.g.dart';

/// Endpoints are exact dates; a missing or insufficient endpoint returns a null percentage with its reason — never zero.
///
/// Properties:
/// * [changePercent] - ((end − start) / start) × 100 from unrounded means, half-up to 2 dp
/// * [direction]
/// * [reason]
/// * [compositionChanged]
/// * [startDate]
/// * [endDate]
/// * [label]
/// * [compositionNote]
@BuiltValue()
abstract class AnalyticsTrend implements Built<AnalyticsTrend, AnalyticsTrendBuilder> {
  /// ((end − start) / start) × 100 from unrounded means, half-up to 2 dp
  @BuiltValueField(wireName: r'change_percent')
  String? get changePercent;

  @BuiltValueField(wireName: r'direction')
  AnalyticsTrendDirectionEnum? get direction;
  // enum directionEnum {  INCREASING,  DECREASING,  NO_MATERIAL_CHANGE,  };

  @BuiltValueField(wireName: r'reason')
  AnalyticsTrendReasonEnum? get reason;
  // enum reasonEnum {  INSUFFICIENT_LOCAL_DATA,  INSUFFICIENT_COMPETITOR_DATA,  MISSING_ENDPOINT_SNAPSHOT,  ZERO_BASELINE,  NO_PUBLISHED_HISTORY,  };

  @BuiltValueField(wireName: r'composition_changed')
  bool? get compositionChanged;

  @BuiltValueField(wireName: r'start_date')
  Date? get startDate;

  @BuiltValueField(wireName: r'end_date')
  Date? get endDate;

  @BuiltValueField(wireName: r'label')
  String? get label;

  @BuiltValueField(wireName: r'composition_note')
  String? get compositionNote;

  AnalyticsTrend._();

  factory AnalyticsTrend([void updates(AnalyticsTrendBuilder b)]) = _$AnalyticsTrend;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AnalyticsTrendBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AnalyticsTrend> get serializer => _$AnalyticsTrendSerializer();
}

class _$AnalyticsTrendSerializer implements PrimitiveSerializer<AnalyticsTrend> {
  @override
  final Iterable<Type> types = const [AnalyticsTrend, _$AnalyticsTrend];

  @override
  final String wireName = r'AnalyticsTrend';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AnalyticsTrend object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.changePercent != null) {
      yield r'change_percent';
      yield serializers.serialize(
        object.changePercent,
        specifiedType: const FullType(String),
      );
    }
    if (object.direction != null) {
      yield r'direction';
      yield serializers.serialize(
        object.direction,
        specifiedType: const FullType(AnalyticsTrendDirectionEnum),
      );
    }
    if (object.reason != null) {
      yield r'reason';
      yield serializers.serialize(
        object.reason,
        specifiedType: const FullType(AnalyticsTrendReasonEnum),
      );
    }
    if (object.compositionChanged != null) {
      yield r'composition_changed';
      yield serializers.serialize(
        object.compositionChanged,
        specifiedType: const FullType(bool),
      );
    }
    if (object.startDate != null) {
      yield r'start_date';
      yield serializers.serialize(
        object.startDate,
        specifiedType: const FullType(Date),
      );
    }
    if (object.endDate != null) {
      yield r'end_date';
      yield serializers.serialize(
        object.endDate,
        specifiedType: const FullType(Date),
      );
    }
    if (object.label != null) {
      yield r'label';
      yield serializers.serialize(
        object.label,
        specifiedType: const FullType(String),
      );
    }
    if (object.compositionNote != null) {
      yield r'composition_note';
      yield serializers.serialize(
        object.compositionNote,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    AnalyticsTrend object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AnalyticsTrendBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'change_percent':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.changePercent = valueDes;
          break;
        case r'direction':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(AnalyticsTrendDirectionEnum),
          ) as AnalyticsTrendDirectionEnum?;
          if (valueDes == null) continue;
          result.direction = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(AnalyticsTrendReasonEnum),
          ) as AnalyticsTrendReasonEnum?;
          if (valueDes == null) continue;
          result.reason = valueDes;
          break;
        case r'composition_changed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.compositionChanged = valueDes;
          break;
        case r'start_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Date),
          ) as Date?;
          if (valueDes == null) continue;
          result.startDate = valueDes;
          break;
        case r'end_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Date),
          ) as Date?;
          if (valueDes == null) continue;
          result.endDate = valueDes;
          break;
        case r'label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.label = valueDes;
          break;
        case r'composition_note':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.compositionNote = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AnalyticsTrend deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AnalyticsTrendBuilder();
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


class AnalyticsTrendDirectionEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'INCREASING')
  static const AnalyticsTrendDirectionEnum INCREASING = _$analyticsTrendDirectionEnum_INCREASING;
  @BuiltValueEnumConst(wireName: r'DECREASING')
  static const AnalyticsTrendDirectionEnum DECREASING = _$analyticsTrendDirectionEnum_DECREASING;
  @BuiltValueEnumConst(wireName: r'NO_MATERIAL_CHANGE')
  static const AnalyticsTrendDirectionEnum NO_MATERIAL_CHANGE = _$analyticsTrendDirectionEnum_NO_MATERIAL_CHANGE;

  static Serializer<AnalyticsTrendDirectionEnum> get serializer => _$analyticsTrendDirectionEnumSerializer;

  const AnalyticsTrendDirectionEnum._(String name): super(name);

  static BuiltSet<AnalyticsTrendDirectionEnum> get values => _$analyticsTrendDirectionEnumValues;
  static AnalyticsTrendDirectionEnum valueOf(String name) => _$analyticsTrendDirectionEnumValueOf(name);
}

class AnalyticsTrendReasonEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'INSUFFICIENT_LOCAL_DATA')
  static const AnalyticsTrendReasonEnum INSUFFICIENT_LOCAL_DATA = _$analyticsTrendReasonEnum_INSUFFICIENT_LOCAL_DATA;
  @BuiltValueEnumConst(wireName: r'INSUFFICIENT_COMPETITOR_DATA')
  static const AnalyticsTrendReasonEnum INSUFFICIENT_COMPETITOR_DATA = _$analyticsTrendReasonEnum_INSUFFICIENT_COMPETITOR_DATA;
  @BuiltValueEnumConst(wireName: r'MISSING_ENDPOINT_SNAPSHOT')
  static const AnalyticsTrendReasonEnum MISSING_ENDPOINT_SNAPSHOT = _$analyticsTrendReasonEnum_MISSING_ENDPOINT_SNAPSHOT;
  @BuiltValueEnumConst(wireName: r'ZERO_BASELINE')
  static const AnalyticsTrendReasonEnum ZERO_BASELINE = _$analyticsTrendReasonEnum_ZERO_BASELINE;
  @BuiltValueEnumConst(wireName: r'NO_PUBLISHED_HISTORY')
  static const AnalyticsTrendReasonEnum NO_PUBLISHED_HISTORY = _$analyticsTrendReasonEnum_NO_PUBLISHED_HISTORY;

  static Serializer<AnalyticsTrendReasonEnum> get serializer => _$analyticsTrendReasonEnumSerializer;

  const AnalyticsTrendReasonEnum._(String name): super(name);

  static BuiltSet<AnalyticsTrendReasonEnum> get values => _$analyticsTrendReasonEnumValues;
  static AnalyticsTrendReasonEnum valueOf(String name) => _$analyticsTrendReasonEnumValueOf(name);
}

