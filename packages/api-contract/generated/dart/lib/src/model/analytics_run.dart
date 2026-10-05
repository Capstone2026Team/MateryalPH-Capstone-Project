//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/date.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'analytics_run.g.dart';

/// AnalyticsRun
///
/// Properties:
/// * [id]
/// * [snapshotDate]
/// * [revision]
/// * [state]
/// * [errorCode]
/// * [observedAt]
/// * [publishedAt]
/// * [observations]
/// * [selected]
/// * [vendors]
/// * [delayed]
/// * [reviewerReason]
@BuiltValue()
abstract class AnalyticsRun implements Built<AnalyticsRun, AnalyticsRunBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'snapshot_date')
  Date get snapshotDate;

  @BuiltValueField(wireName: r'revision')
  int get revision;

  @BuiltValueField(wireName: r'state')
  AnalyticsRunStateEnum get state;
  // enum stateEnum {  RUNNING,  VALIDATED,  PUBLISHED,  FAILED,  SUPERSEDED,  };

  @BuiltValueField(wireName: r'error_code')
  String? get errorCode;

  @BuiltValueField(wireName: r'observed_at')
  DateTime? get observedAt;

  @BuiltValueField(wireName: r'published_at')
  DateTime? get publishedAt;

  @BuiltValueField(wireName: r'observations')
  int get observations;

  @BuiltValueField(wireName: r'selected')
  int get selected;

  @BuiltValueField(wireName: r'vendors')
  int get vendors;

  @BuiltValueField(wireName: r'delayed')
  bool get delayed;

  @BuiltValueField(wireName: r'reviewer_reason')
  String? get reviewerReason;

  AnalyticsRun._();

  factory AnalyticsRun([void updates(AnalyticsRunBuilder b)]) = _$AnalyticsRun;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AnalyticsRunBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AnalyticsRun> get serializer => _$AnalyticsRunSerializer();
}

class _$AnalyticsRunSerializer implements PrimitiveSerializer<AnalyticsRun> {
  @override
  final Iterable<Type> types = const [AnalyticsRun, _$AnalyticsRun];

  @override
  final String wireName = r'AnalyticsRun';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AnalyticsRun object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'snapshot_date';
    yield serializers.serialize(
      object.snapshotDate,
      specifiedType: const FullType(Date),
    );
    yield r'revision';
    yield serializers.serialize(
      object.revision,
      specifiedType: const FullType(int),
    );
    yield r'state';
    yield serializers.serialize(
      object.state,
      specifiedType: const FullType(AnalyticsRunStateEnum),
    );
    if (object.errorCode != null) {
      yield r'error_code';
      yield serializers.serialize(
        object.errorCode,
        specifiedType: const FullType(String),
      );
    }
    if (object.observedAt != null) {
      yield r'observed_at';
      yield serializers.serialize(
        object.observedAt,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.publishedAt != null) {
      yield r'published_at';
      yield serializers.serialize(
        object.publishedAt,
        specifiedType: const FullType(DateTime),
      );
    }
    yield r'observations';
    yield serializers.serialize(
      object.observations,
      specifiedType: const FullType(int),
    );
    yield r'selected';
    yield serializers.serialize(
      object.selected,
      specifiedType: const FullType(int),
    );
    yield r'vendors';
    yield serializers.serialize(
      object.vendors,
      specifiedType: const FullType(int),
    );
    yield r'delayed';
    yield serializers.serialize(
      object.delayed,
      specifiedType: const FullType(bool),
    );
    if (object.reviewerReason != null) {
      yield r'reviewer_reason';
      yield serializers.serialize(
        object.reviewerReason,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    AnalyticsRun object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AnalyticsRunBuilder result,
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
        case r'snapshot_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.snapshotDate = valueDes;
          break;
        case r'revision':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.revision = valueDes;
          break;
        case r'state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AnalyticsRunStateEnum),
          ) as AnalyticsRunStateEnum;
          result.state = valueDes;
          break;
        case r'error_code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.errorCode = valueDes;
          break;
        case r'observed_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.observedAt = valueDes;
          break;
        case r'published_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.publishedAt = valueDes;
          break;
        case r'observations':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.observations = valueDes;
          break;
        case r'selected':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.selected = valueDes;
          break;
        case r'vendors':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.vendors = valueDes;
          break;
        case r'delayed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.delayed = valueDes;
          break;
        case r'reviewer_reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.reviewerReason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AnalyticsRun deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AnalyticsRunBuilder();
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


class AnalyticsRunStateEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'RUNNING')
  static const AnalyticsRunStateEnum RUNNING = _$analyticsRunStateEnum_RUNNING;
  @BuiltValueEnumConst(wireName: r'VALIDATED')
  static const AnalyticsRunStateEnum VALIDATED = _$analyticsRunStateEnum_VALIDATED;
  @BuiltValueEnumConst(wireName: r'PUBLISHED')
  static const AnalyticsRunStateEnum PUBLISHED = _$analyticsRunStateEnum_PUBLISHED;
  @BuiltValueEnumConst(wireName: r'FAILED')
  static const AnalyticsRunStateEnum FAILED = _$analyticsRunStateEnum_FAILED;
  @BuiltValueEnumConst(wireName: r'SUPERSEDED')
  static const AnalyticsRunStateEnum SUPERSEDED = _$analyticsRunStateEnum_SUPERSEDED;

  static Serializer<AnalyticsRunStateEnum> get serializer => _$analyticsRunStateEnumSerializer;

  const AnalyticsRunStateEnum._(String name): super(name);

  static BuiltSet<AnalyticsRunStateEnum> get values => _$analyticsRunStateEnumValues;
  static AnalyticsRunStateEnum valueOf(String name) => _$analyticsRunStateEnumValueOf(name);
}

