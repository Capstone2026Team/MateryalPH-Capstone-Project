//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'remittance_reconciliation_decision.g.dart';

/// RemittanceReconciliationDecision
///
/// Properties:
/// * [id]
/// * [assessmentId]
/// * [environment]
/// * [origin]
/// * [method]
/// * [actorRole]
/// * [reason]
/// * [reconciledAt]
@BuiltValue()
abstract class RemittanceReconciliationDecision implements Built<RemittanceReconciliationDecision, RemittanceReconciliationDecisionBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'assessment_id')
  String get assessmentId;

  @BuiltValueField(wireName: r'environment')
  RemittanceReconciliationDecisionEnvironmentEnum get environment;
  // enum environmentEnum {  TEST,  };

  @BuiltValueField(wireName: r'origin')
  RemittanceReconciliationDecisionOriginEnum get origin;
  // enum originEnum {  SIMULATED,  };

  @BuiltValueField(wireName: r'method')
  RemittanceReconciliationDecisionMethodEnum get method;
  // enum methodEnum {  AUTOMATIC,  BACKUP_APPROVAL,  };

  @BuiltValueField(wireName: r'actor_role')
  RemittanceReconciliationDecisionActorRoleEnum get actorRole;
  // enum actorRoleEnum {  SYSTEM,  ADMIN_SUPERADMIN,  ADMIN_FINANCE,  };

  @BuiltValueField(wireName: r'reason')
  String get reason;

  @BuiltValueField(wireName: r'reconciled_at')
  DateTime get reconciledAt;

  RemittanceReconciliationDecision._();

  factory RemittanceReconciliationDecision([void updates(RemittanceReconciliationDecisionBuilder b)]) = _$RemittanceReconciliationDecision;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RemittanceReconciliationDecisionBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RemittanceReconciliationDecision> get serializer => _$RemittanceReconciliationDecisionSerializer();
}

class _$RemittanceReconciliationDecisionSerializer implements PrimitiveSerializer<RemittanceReconciliationDecision> {
  @override
  final Iterable<Type> types = const [RemittanceReconciliationDecision, _$RemittanceReconciliationDecision];

  @override
  final String wireName = r'RemittanceReconciliationDecision';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RemittanceReconciliationDecision object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'assessment_id';
    yield serializers.serialize(
      object.assessmentId,
      specifiedType: const FullType(String),
    );
    yield r'environment';
    yield serializers.serialize(
      object.environment,
      specifiedType: const FullType(RemittanceReconciliationDecisionEnvironmentEnum),
    );
    yield r'origin';
    yield serializers.serialize(
      object.origin,
      specifiedType: const FullType(RemittanceReconciliationDecisionOriginEnum),
    );
    yield r'method';
    yield serializers.serialize(
      object.method,
      specifiedType: const FullType(RemittanceReconciliationDecisionMethodEnum),
    );
    yield r'actor_role';
    yield serializers.serialize(
      object.actorRole,
      specifiedType: const FullType(RemittanceReconciliationDecisionActorRoleEnum),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
    yield r'reconciled_at';
    yield serializers.serialize(
      object.reconciledAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    RemittanceReconciliationDecision object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RemittanceReconciliationDecisionBuilder result,
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
        case r'assessment_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.assessmentId = valueDes;
          break;
        case r'environment':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(RemittanceReconciliationDecisionEnvironmentEnum),
          ) as RemittanceReconciliationDecisionEnvironmentEnum;
          result.environment = valueDes;
          break;
        case r'origin':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(RemittanceReconciliationDecisionOriginEnum),
          ) as RemittanceReconciliationDecisionOriginEnum;
          result.origin = valueDes;
          break;
        case r'method':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(RemittanceReconciliationDecisionMethodEnum),
          ) as RemittanceReconciliationDecisionMethodEnum;
          result.method = valueDes;
          break;
        case r'actor_role':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(RemittanceReconciliationDecisionActorRoleEnum),
          ) as RemittanceReconciliationDecisionActorRoleEnum;
          result.actorRole = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reason = valueDes;
          break;
        case r'reconciled_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.reconciledAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RemittanceReconciliationDecision deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RemittanceReconciliationDecisionBuilder();
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


class RemittanceReconciliationDecisionEnvironmentEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'TEST')
  static const RemittanceReconciliationDecisionEnvironmentEnum TEST = _$remittanceReconciliationDecisionEnvironmentEnum_TEST;

  static Serializer<RemittanceReconciliationDecisionEnvironmentEnum> get serializer => _$remittanceReconciliationDecisionEnvironmentEnumSerializer;

  const RemittanceReconciliationDecisionEnvironmentEnum._(String name): super(name);

  static BuiltSet<RemittanceReconciliationDecisionEnvironmentEnum> get values => _$remittanceReconciliationDecisionEnvironmentEnumValues;
  static RemittanceReconciliationDecisionEnvironmentEnum valueOf(String name) => _$remittanceReconciliationDecisionEnvironmentEnumValueOf(name);
}

class RemittanceReconciliationDecisionOriginEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'SIMULATED')
  static const RemittanceReconciliationDecisionOriginEnum SIMULATED = _$remittanceReconciliationDecisionOriginEnum_SIMULATED;

  static Serializer<RemittanceReconciliationDecisionOriginEnum> get serializer => _$remittanceReconciliationDecisionOriginEnumSerializer;

  const RemittanceReconciliationDecisionOriginEnum._(String name): super(name);

  static BuiltSet<RemittanceReconciliationDecisionOriginEnum> get values => _$remittanceReconciliationDecisionOriginEnumValues;
  static RemittanceReconciliationDecisionOriginEnum valueOf(String name) => _$remittanceReconciliationDecisionOriginEnumValueOf(name);
}

class RemittanceReconciliationDecisionMethodEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'AUTOMATIC')
  static const RemittanceReconciliationDecisionMethodEnum AUTOMATIC = _$remittanceReconciliationDecisionMethodEnum_AUTOMATIC;
  @BuiltValueEnumConst(wireName: r'BACKUP_APPROVAL')
  static const RemittanceReconciliationDecisionMethodEnum BACKUP_APPROVAL = _$remittanceReconciliationDecisionMethodEnum_BACKUP_APPROVAL;

  static Serializer<RemittanceReconciliationDecisionMethodEnum> get serializer => _$remittanceReconciliationDecisionMethodEnumSerializer;

  const RemittanceReconciliationDecisionMethodEnum._(String name): super(name);

  static BuiltSet<RemittanceReconciliationDecisionMethodEnum> get values => _$remittanceReconciliationDecisionMethodEnumValues;
  static RemittanceReconciliationDecisionMethodEnum valueOf(String name) => _$remittanceReconciliationDecisionMethodEnumValueOf(name);
}

class RemittanceReconciliationDecisionActorRoleEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'SYSTEM')
  static const RemittanceReconciliationDecisionActorRoleEnum SYSTEM = _$remittanceReconciliationDecisionActorRoleEnum_SYSTEM;
  @BuiltValueEnumConst(wireName: r'ADMIN_SUPERADMIN')
  static const RemittanceReconciliationDecisionActorRoleEnum ADMIN_SUPERADMIN = _$remittanceReconciliationDecisionActorRoleEnum_ADMIN_SUPERADMIN;
  @BuiltValueEnumConst(wireName: r'ADMIN_FINANCE')
  static const RemittanceReconciliationDecisionActorRoleEnum ADMIN_FINANCE = _$remittanceReconciliationDecisionActorRoleEnum_ADMIN_FINANCE;

  static Serializer<RemittanceReconciliationDecisionActorRoleEnum> get serializer => _$remittanceReconciliationDecisionActorRoleEnumSerializer;

  const RemittanceReconciliationDecisionActorRoleEnum._(String name): super(name);

  static BuiltSet<RemittanceReconciliationDecisionActorRoleEnum> get values => _$remittanceReconciliationDecisionActorRoleEnumValues;
  static RemittanceReconciliationDecisionActorRoleEnum valueOf(String name) => _$remittanceReconciliationDecisionActorRoleEnumValueOf(name);
}

