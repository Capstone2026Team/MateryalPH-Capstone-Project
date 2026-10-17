//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'delivery_assignment_history.g.dart';

/// DeliveryAssignmentHistory
///
/// Properties:
/// * [event]
/// * [at]
/// * [actorRole]
/// * [reason]
/// * [displayName]
/// * [vehicleName]
@BuiltValue()
abstract class DeliveryAssignmentHistory implements Built<DeliveryAssignmentHistory, DeliveryAssignmentHistoryBuilder> {
  @BuiltValueField(wireName: r'event')
  String get event;

  @BuiltValueField(wireName: r'at')
  DateTime? get at;

  @BuiltValueField(wireName: r'actor_role')
  String? get actorRole;

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  @BuiltValueField(wireName: r'display_name')
  String? get displayName;

  @BuiltValueField(wireName: r'vehicle_name')
  String? get vehicleName;

  DeliveryAssignmentHistory._();

  factory DeliveryAssignmentHistory([void updates(DeliveryAssignmentHistoryBuilder b)]) = _$DeliveryAssignmentHistory;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DeliveryAssignmentHistoryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DeliveryAssignmentHistory> get serializer => _$DeliveryAssignmentHistorySerializer();
}

class _$DeliveryAssignmentHistorySerializer implements PrimitiveSerializer<DeliveryAssignmentHistory> {
  @override
  final Iterable<Type> types = const [DeliveryAssignmentHistory, _$DeliveryAssignmentHistory];

  @override
  final String wireName = r'DeliveryAssignmentHistory';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DeliveryAssignmentHistory object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'event';
    yield serializers.serialize(
      object.event,
      specifiedType: const FullType(String),
    );
    if (object.at != null) {
      yield r'at';
      yield serializers.serialize(
        object.at,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.actorRole != null) {
      yield r'actor_role';
      yield serializers.serialize(
        object.actorRole,
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
    if (object.displayName != null) {
      yield r'display_name';
      yield serializers.serialize(
        object.displayName,
        specifiedType: const FullType(String),
      );
    }
    if (object.vehicleName != null) {
      yield r'vehicle_name';
      yield serializers.serialize(
        object.vehicleName,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    DeliveryAssignmentHistory object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DeliveryAssignmentHistoryBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'event':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.event = valueDes;
          break;
        case r'at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.at = valueDes;
          break;
        case r'actor_role':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.actorRole = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.reason = valueDes;
          break;
        case r'display_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.displayName = valueDes;
          break;
        case r'vehicle_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.vehicleName = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DeliveryAssignmentHistory deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DeliveryAssignmentHistoryBuilder();
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


