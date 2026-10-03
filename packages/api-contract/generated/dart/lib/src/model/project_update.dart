//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'project_update.g.dart';

/// ProjectUpdate
///
/// Properties:
/// * [lockVersion]
/// * [name]
/// * [budgetCentavos]
/// * [startsOn]
/// * [endsOn]
/// * [locationId]
/// * [status]
@BuiltValue()
abstract class ProjectUpdate implements Built<ProjectUpdate, ProjectUpdateBuilder> {
  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  @BuiltValueField(wireName: r'name')
  String? get name;

  @BuiltValueField(wireName: r'budget_centavos')
  int? get budgetCentavos;

  @BuiltValueField(wireName: r'starts_on')
  String? get startsOn;

  @BuiltValueField(wireName: r'ends_on')
  String? get endsOn;

  @BuiltValueField(wireName: r'location_id')
  String? get locationId;

  @BuiltValueField(wireName: r'status')
  ProjectUpdateStatusEnum? get status;
  // enum statusEnum {  ACTIVE,  COMPLETED,  ARCHIVED,  };

  ProjectUpdate._();

  factory ProjectUpdate([void updates(ProjectUpdateBuilder b)]) = _$ProjectUpdate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProjectUpdateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProjectUpdate> get serializer => _$ProjectUpdateSerializer();
}

class _$ProjectUpdateSerializer implements PrimitiveSerializer<ProjectUpdate> {
  @override
  final Iterable<Type> types = const [ProjectUpdate, _$ProjectUpdate];

  @override
  final String wireName = r'ProjectUpdate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProjectUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
    if (object.name != null) {
      yield r'name';
      yield serializers.serialize(
        object.name,
        specifiedType: const FullType(String),
      );
    }
    if (object.budgetCentavos != null) {
      yield r'budget_centavos';
      yield serializers.serialize(
        object.budgetCentavos,
        specifiedType: const FullType(int),
      );
    }
    if (object.startsOn != null) {
      yield r'starts_on';
      yield serializers.serialize(
        object.startsOn,
        specifiedType: const FullType(String),
      );
    }
    if (object.endsOn != null) {
      yield r'ends_on';
      yield serializers.serialize(
        object.endsOn,
        specifiedType: const FullType(String),
      );
    }
    if (object.locationId != null) {
      yield r'location_id';
      yield serializers.serialize(
        object.locationId,
        specifiedType: const FullType(String),
      );
    }
    if (object.status != null) {
      yield r'status';
      yield serializers.serialize(
        object.status,
        specifiedType: const FullType(ProjectUpdateStatusEnum),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ProjectUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProjectUpdateBuilder result,
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
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.name = valueDes;
          break;
        case r'budget_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.budgetCentavos = valueDes;
          break;
        case r'starts_on':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.startsOn = valueDes;
          break;
        case r'ends_on':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.endsOn = valueDes;
          break;
        case r'location_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.locationId = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ProjectUpdateStatusEnum),
          ) as ProjectUpdateStatusEnum?;
          if (valueDes == null) continue;
          result.status = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProjectUpdate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProjectUpdateBuilder();
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


class ProjectUpdateStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ACTIVE')
  static const ProjectUpdateStatusEnum ACTIVE = _$projectUpdateStatusEnum_ACTIVE;
  @BuiltValueEnumConst(wireName: r'COMPLETED')
  static const ProjectUpdateStatusEnum COMPLETED = _$projectUpdateStatusEnum_COMPLETED;
  @BuiltValueEnumConst(wireName: r'ARCHIVED')
  static const ProjectUpdateStatusEnum ARCHIVED = _$projectUpdateStatusEnum_ARCHIVED;

  static Serializer<ProjectUpdateStatusEnum> get serializer => _$projectUpdateStatusEnumSerializer;

  const ProjectUpdateStatusEnum._(String name): super(name);

  static BuiltSet<ProjectUpdateStatusEnum> get values => _$projectUpdateStatusEnumValues;
  static ProjectUpdateStatusEnum valueOf(String name) => _$projectUpdateStatusEnumValueOf(name);
}

