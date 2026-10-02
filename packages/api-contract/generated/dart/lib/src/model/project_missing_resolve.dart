//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'project_missing_resolve.g.dart';

/// ProjectMissingResolve
///
/// Properties:
/// * [lockVersion]
/// * [orderId]
/// * [reason]
/// * [budgetOverrideReason]
@BuiltValue()
abstract class ProjectMissingResolve implements Built<ProjectMissingResolve, ProjectMissingResolveBuilder> {
  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  @BuiltValueField(wireName: r'order_id')
  String? get orderId;

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  @BuiltValueField(wireName: r'budget_override_reason')
  String? get budgetOverrideReason;

  ProjectMissingResolve._();

  factory ProjectMissingResolve([void updates(ProjectMissingResolveBuilder b)]) = _$ProjectMissingResolve;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProjectMissingResolveBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProjectMissingResolve> get serializer => _$ProjectMissingResolveSerializer();
}

class _$ProjectMissingResolveSerializer implements PrimitiveSerializer<ProjectMissingResolve> {
  @override
  final Iterable<Type> types = const [ProjectMissingResolve, _$ProjectMissingResolve];

  @override
  final String wireName = r'ProjectMissingResolve';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProjectMissingResolve object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
    if (object.orderId != null) {
      yield r'order_id';
      yield serializers.serialize(
        object.orderId,
        specifiedType: const FullType(String),
      );
    }
    if (object.reason != null) {
      yield r'reason';
      yield serializers.serialize(
        object.reason,
        specifiedType: const FullType(String),
      );
    }
    if (object.budgetOverrideReason != null) {
      yield r'budget_override_reason';
      yield serializers.serialize(
        object.budgetOverrideReason,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ProjectMissingResolve object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProjectMissingResolveBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lockVersion = valueDes;
          break;
        case r'order_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.orderId = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.reason = valueDes;
          break;
        case r'budget_override_reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.budgetOverrideReason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProjectMissingResolve deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProjectMissingResolveBuilder();
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


