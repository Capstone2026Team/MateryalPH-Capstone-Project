//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/scheduled_task_health.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/integration_status.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'integration_overview.g.dart';

/// Configuration presence and masked labels only; credentials, payloads, recipients and exception messages never appear.
///
/// Properties:
/// * [generatedAt]
/// * [environment]
/// * [integrations]
/// * [queues]
/// * [scheduledTasks]
/// * [analytics]
/// * [canRetry]
@BuiltValue()
abstract class IntegrationOverview implements Built<IntegrationOverview, IntegrationOverviewBuilder> {
  @BuiltValueField(wireName: r'generated_at')
  DateTime get generatedAt;

  @BuiltValueField(wireName: r'environment')
  BuiltMap<String, JsonObject?> get environment;

  @BuiltValueField(wireName: r'integrations')
  BuiltList<IntegrationStatus> get integrations;

  @BuiltValueField(wireName: r'queues')
  BuiltMap<String, JsonObject?> get queues;

  @BuiltValueField(wireName: r'scheduled_tasks')
  BuiltList<ScheduledTaskHealth> get scheduledTasks;

  @BuiltValueField(wireName: r'analytics')
  BuiltMap<String, JsonObject?> get analytics;

  @BuiltValueField(wireName: r'can_retry')
  bool get canRetry;

  IntegrationOverview._();

  factory IntegrationOverview([void updates(IntegrationOverviewBuilder b)]) = _$IntegrationOverview;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(IntegrationOverviewBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<IntegrationOverview> get serializer => _$IntegrationOverviewSerializer();
}

class _$IntegrationOverviewSerializer implements PrimitiveSerializer<IntegrationOverview> {
  @override
  final Iterable<Type> types = const [IntegrationOverview, _$IntegrationOverview];

  @override
  final String wireName = r'IntegrationOverview';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    IntegrationOverview object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'generated_at';
    yield serializers.serialize(
      object.generatedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'environment';
    yield serializers.serialize(
      object.environment,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
    yield r'integrations';
    yield serializers.serialize(
      object.integrations,
      specifiedType: const FullType(BuiltList, [FullType(IntegrationStatus)]),
    );
    yield r'queues';
    yield serializers.serialize(
      object.queues,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
    yield r'scheduled_tasks';
    yield serializers.serialize(
      object.scheduledTasks,
      specifiedType: const FullType(BuiltList, [FullType(ScheduledTaskHealth)]),
    );
    yield r'analytics';
    yield serializers.serialize(
      object.analytics,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
    yield r'can_retry';
    yield serializers.serialize(
      object.canRetry,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    IntegrationOverview object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required IntegrationOverviewBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'generated_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.generatedAt = valueDes;
          break;
        case r'environment':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.environment.replace(valueDes);
          break;
        case r'integrations':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(IntegrationStatus)]),
          ) as BuiltList<IntegrationStatus>;
          result.integrations.replace(valueDes);
          break;
        case r'queues':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.queues.replace(valueDes);
          break;
        case r'scheduled_tasks':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ScheduledTaskHealth)]),
          ) as BuiltList<ScheduledTaskHealth>;
          result.scheduledTasks.replace(valueDes);
          break;
        case r'analytics':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.analytics.replace(valueDes);
          break;
        case r'can_retry':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.canRetry = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  IntegrationOverview deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = IntegrationOverviewBuilder();
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


