//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'analytics_correction_result.g.dart';

/// AnalyticsCorrectionResult
///
/// Properties:
/// * [state]
/// * [snapshotDate]
/// * [runId]
/// * [revision]
/// * [observations]
/// * [selected]
/// * [vendors]
@BuiltValue()
abstract class AnalyticsCorrectionResult implements Built<AnalyticsCorrectionResult, AnalyticsCorrectionResultBuilder> {
  @BuiltValueField(wireName: r'state')
  String? get state;

  @BuiltValueField(wireName: r'snapshot_date')
  Date? get snapshotDate;

  @BuiltValueField(wireName: r'run_id')
  String? get runId;

  @BuiltValueField(wireName: r'revision')
  int? get revision;

  @BuiltValueField(wireName: r'observations')
  int? get observations;

  @BuiltValueField(wireName: r'selected')
  int? get selected;

  @BuiltValueField(wireName: r'vendors')
  int? get vendors;

  AnalyticsCorrectionResult._();

  factory AnalyticsCorrectionResult([void updates(AnalyticsCorrectionResultBuilder b)]) = _$AnalyticsCorrectionResult;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AnalyticsCorrectionResultBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AnalyticsCorrectionResult> get serializer => _$AnalyticsCorrectionResultSerializer();
}

class _$AnalyticsCorrectionResultSerializer implements PrimitiveSerializer<AnalyticsCorrectionResult> {
  @override
  final Iterable<Type> types = const [AnalyticsCorrectionResult, _$AnalyticsCorrectionResult];

  @override
  final String wireName = r'AnalyticsCorrectionResult';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AnalyticsCorrectionResult object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.state != null) {
      yield r'state';
      yield serializers.serialize(
        object.state,
        specifiedType: const FullType(String),
      );
    }
    if (object.snapshotDate != null) {
      yield r'snapshot_date';
      yield serializers.serialize(
        object.snapshotDate,
        specifiedType: const FullType(Date),
      );
    }
    if (object.runId != null) {
      yield r'run_id';
      yield serializers.serialize(
        object.runId,
        specifiedType: const FullType(String),
      );
    }
    if (object.revision != null) {
      yield r'revision';
      yield serializers.serialize(
        object.revision,
        specifiedType: const FullType(int),
      );
    }
    if (object.observations != null) {
      yield r'observations';
      yield serializers.serialize(
        object.observations,
        specifiedType: const FullType(int),
      );
    }
    if (object.selected != null) {
      yield r'selected';
      yield serializers.serialize(
        object.selected,
        specifiedType: const FullType(int),
      );
    }
    if (object.vendors != null) {
      yield r'vendors';
      yield serializers.serialize(
        object.vendors,
        specifiedType: const FullType(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    AnalyticsCorrectionResult object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AnalyticsCorrectionResultBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.state = valueDes;
          break;
        case r'snapshot_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Date),
          ) as Date?;
          if (valueDes == null) continue;
          result.snapshotDate = valueDes;
          break;
        case r'run_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.runId = valueDes;
          break;
        case r'revision':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.revision = valueDes;
          break;
        case r'observations':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.observations = valueDes;
          break;
        case r'selected':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.selected = valueDes;
          break;
        case r'vendors':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.vendors = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AnalyticsCorrectionResult deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AnalyticsCorrectionResultBuilder();
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


