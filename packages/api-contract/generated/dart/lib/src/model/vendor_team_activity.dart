//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_team_activity.g.dart';

/// VendorTeamActivity
///
/// Properties:
/// * [id]
/// * [actorName]
/// * [actorRole]
/// * [action]
/// * [resourceType]
/// * [resourceId]
/// * [createdAt]
/// * [succeeded]
/// * [before]
/// * [after]
@BuiltValue()
abstract class VendorTeamActivity implements Built<VendorTeamActivity, VendorTeamActivityBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'actor_name')
  String? get actorName;

  @BuiltValueField(wireName: r'actor_role')
  String get actorRole;

  @BuiltValueField(wireName: r'action')
  String get action;

  @BuiltValueField(wireName: r'resource_type')
  String get resourceType;

  @BuiltValueField(wireName: r'resource_id')
  String? get resourceId;

  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'succeeded')
  bool get succeeded;

  @BuiltValueField(wireName: r'before')
  BuiltMap<String, JsonObject?> get before;

  @BuiltValueField(wireName: r'after')
  BuiltMap<String, JsonObject?> get after;

  VendorTeamActivity._();

  factory VendorTeamActivity([void updates(VendorTeamActivityBuilder b)]) = _$VendorTeamActivity;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorTeamActivityBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorTeamActivity> get serializer => _$VendorTeamActivitySerializer();
}

class _$VendorTeamActivitySerializer implements PrimitiveSerializer<VendorTeamActivity> {
  @override
  final Iterable<Type> types = const [VendorTeamActivity, _$VendorTeamActivity];

  @override
  final String wireName = r'VendorTeamActivity';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorTeamActivity object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    if (object.actorName != null) {
      yield r'actor_name';
      yield serializers.serialize(
        object.actorName,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'actor_role';
    yield serializers.serialize(
      object.actorRole,
      specifiedType: const FullType(String),
    );
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
    yield r'created_at';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'succeeded';
    yield serializers.serialize(
      object.succeeded,
      specifiedType: const FullType(bool),
    );
    yield r'before';
    yield serializers.serialize(
      object.before,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
    yield r'after';
    yield serializers.serialize(
      object.after,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorTeamActivity object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorTeamActivityBuilder result,
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
        case r'actor_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.actorName = valueDes;
          break;
        case r'actor_role':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
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
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'succeeded':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.succeeded = valueDes;
          break;
        case r'before':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.before.replace(valueDes);
          break;
        case r'after':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.after.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorTeamActivity deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorTeamActivityBuilder();
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


