//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'audit_event.g.dart';

/// AuditEvent
///
/// Properties:
/// * [id]
/// * [createdAt]
/// * [actor]
/// * [actorRole]
/// * [action]
/// * [resourceType]
/// * [resourceId]
/// * [organization]
/// * [organizationId]
/// * [succeeded]
/// * [reason]
/// * [correlationId]
/// * [hasDetail]
@BuiltValue(instantiable: false)
abstract class AuditEvent  {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'actor')
  String get actor;

  @BuiltValueField(wireName: r'actor_role')
  String? get actorRole;

  @BuiltValueField(wireName: r'action')
  String get action;

  @BuiltValueField(wireName: r'resource_type')
  String get resourceType;

  @BuiltValueField(wireName: r'resource_id')
  String? get resourceId;

  @BuiltValueField(wireName: r'organization')
  String? get organization;

  @BuiltValueField(wireName: r'organization_id')
  String? get organizationId;

  @BuiltValueField(wireName: r'succeeded')
  bool get succeeded;

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  @BuiltValueField(wireName: r'correlation_id')
  String get correlationId;

  @BuiltValueField(wireName: r'has_detail')
  bool get hasDetail;

  @BuiltValueSerializer(custom: true)
  static Serializer<AuditEvent> get serializer => _$AuditEventSerializer();
}

class _$AuditEventSerializer implements PrimitiveSerializer<AuditEvent> {
  @override
  final Iterable<Type> types = const [AuditEvent];

  @override
  final String wireName = r'AuditEvent';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AuditEvent object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'created_at';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'actor';
    yield serializers.serialize(
      object.actor,
      specifiedType: const FullType(String),
    );
    if (object.actorRole != null) {
      yield r'actor_role';
      yield serializers.serialize(
        object.actorRole,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'action';
    yield serializers.serialize(
      object.action,
      specifiedType: const FullType(String),
    );
    yield r'resource_type';
    yield serializers.serialize(
      object.resourceType,
      specifiedType: const FullType(String),
    );
    if (object.resourceId != null) {
      yield r'resource_id';
      yield serializers.serialize(
        object.resourceId,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.organization != null) {
      yield r'organization';
      yield serializers.serialize(
        object.organization,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.organizationId != null) {
      yield r'organization_id';
      yield serializers.serialize(
        object.organizationId,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'succeeded';
    yield serializers.serialize(
      object.succeeded,
      specifiedType: const FullType(bool),
    );
    if (object.reason != null) {
      yield r'reason';
      yield serializers.serialize(
        object.reason,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'correlation_id';
    yield serializers.serialize(
      object.correlationId,
      specifiedType: const FullType(String),
    );
    yield r'has_detail';
    yield serializers.serialize(
      object.hasDetail,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AuditEvent object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  @override
  AuditEvent deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return serializers.deserialize(serialized, specifiedType: FullType($AuditEvent)) as $AuditEvent;
  }
}


/// a concrete implementation of [AuditEvent], since [AuditEvent] is not instantiable
@BuiltValue(instantiable: true)
abstract class $AuditEvent implements AuditEvent, Built<$AuditEvent, $AuditEventBuilder> {
  $AuditEvent._();

  factory $AuditEvent([void Function($AuditEventBuilder)? updates]) = _$$AuditEvent;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults($AuditEventBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<$AuditEvent> get serializer => _$$AuditEventSerializer();
}

class _$$AuditEventSerializer implements PrimitiveSerializer<$AuditEvent> {
  @override
  final Iterable<Type> types = const [$AuditEvent, _$$AuditEvent];

  @override
  final String wireName = r'$AuditEvent';

  @override
  Object serialize(
    Serializers serializers,
    $AuditEvent object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return serializers.serialize(object, specifiedType: FullType(AuditEvent))!;
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AuditEventBuilder result,
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
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'actor':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.actor = valueDes;
          break;
        case r'actor_role':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.actorRole = valueDes;
          break;
        case r'action':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.action = valueDes;
          break;
        case r'resource_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.resourceType = valueDes;
          break;
        case r'resource_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.resourceId = valueDes;
          break;
        case r'organization':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.organization = valueDes;
          break;
        case r'organization_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.organizationId = valueDes;
          break;
        case r'succeeded':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.succeeded = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.reason = valueDes;
          break;
        case r'correlation_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.correlationId = valueDes;
          break;
        case r'has_detail':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.hasDetail = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  $AuditEvent deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = $AuditEventBuilder();
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

