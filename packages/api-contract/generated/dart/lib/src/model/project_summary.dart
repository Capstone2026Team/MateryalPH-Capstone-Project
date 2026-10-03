//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/project_budget.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'project_summary.g.dart';

/// ProjectSummary
///
/// Properties:
/// * [id]
/// * [name]
/// * [status]
/// * [budgetCentavos]
/// * [startsOn]
/// * [endsOn]
/// * [lockVersion]
/// * [budget]
@BuiltValue()
abstract class ProjectSummary implements Built<ProjectSummary, ProjectSummaryBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'status')
  ProjectSummaryStatusEnum get status;
  // enum statusEnum {  ACTIVE,  COMPLETED,  ARCHIVED,  };

  @BuiltValueField(wireName: r'budget_centavos')
  int get budgetCentavos;

  @BuiltValueField(wireName: r'starts_on')
  String? get startsOn;

  @BuiltValueField(wireName: r'ends_on')
  String? get endsOn;

  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  @BuiltValueField(wireName: r'budget')
  ProjectBudget get budget;

  ProjectSummary._();

  factory ProjectSummary([void updates(ProjectSummaryBuilder b)]) = _$ProjectSummary;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProjectSummaryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProjectSummary> get serializer => _$ProjectSummarySerializer();
}

class _$ProjectSummarySerializer implements PrimitiveSerializer<ProjectSummary> {
  @override
  final Iterable<Type> types = const [ProjectSummary, _$ProjectSummary];

  @override
  final String wireName = r'ProjectSummary';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProjectSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(ProjectSummaryStatusEnum),
    );
    yield r'budget_centavos';
    yield serializers.serialize(
      object.budgetCentavos,
      specifiedType: const FullType(int),
    );
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
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
    yield r'budget';
    yield serializers.serialize(
      object.budget,
      specifiedType: const FullType(ProjectBudget),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ProjectSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProjectSummaryBuilder result,
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
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ProjectSummaryStatusEnum),
          ) as ProjectSummaryStatusEnum;
          result.status = valueDes;
          break;
        case r'budget_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
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
        case r'lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lockVersion = valueDes;
          break;
        case r'budget':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ProjectBudget),
          ) as ProjectBudget;
          result.budget.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProjectSummary deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProjectSummaryBuilder();
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


class ProjectSummaryStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ACTIVE')
  static const ProjectSummaryStatusEnum ACTIVE = _$projectSummaryStatusEnum_ACTIVE;
  @BuiltValueEnumConst(wireName: r'COMPLETED')
  static const ProjectSummaryStatusEnum COMPLETED = _$projectSummaryStatusEnum_COMPLETED;
  @BuiltValueEnumConst(wireName: r'ARCHIVED')
  static const ProjectSummaryStatusEnum ARCHIVED = _$projectSummaryStatusEnum_ARCHIVED;

  static Serializer<ProjectSummaryStatusEnum> get serializer => _$projectSummaryStatusEnumSerializer;

  const ProjectSummaryStatusEnum._(String name): super(name);

  static BuiltSet<ProjectSummaryStatusEnum> get values => _$projectSummaryStatusEnumValues;
  static ProjectSummaryStatusEnum valueOf(String name) => _$projectSummaryStatusEnumValueOf(name);
}

