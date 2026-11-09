//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'project_archive_item.g.dart';

/// ProjectArchiveItem
///
/// Properties:
/// * [id]
/// * [type]
/// * [name]
/// * [budgetCentavos]
/// * [lockVersion]
/// * [projectId]
/// * [projectName]
/// * [parentArchived]
/// * [archivedAt]
/// * [deleteAfter]
/// * [remainingDays]
/// * [canRestore]
/// * [canDelete]
@BuiltValue()
abstract class ProjectArchiveItem implements Built<ProjectArchiveItem, ProjectArchiveItemBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'type')
  ProjectArchiveItemTypeEnum get type;
  // enum typeEnum {  PROJECT,  WORK_PACKAGE,  };

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'budget_centavos')
  int get budgetCentavos;

  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  @BuiltValueField(wireName: r'project_id')
  String get projectId;

  @BuiltValueField(wireName: r'project_name')
  String? get projectName;

  @BuiltValueField(wireName: r'parent_archived')
  bool get parentArchived;

  @BuiltValueField(wireName: r'archived_at')
  DateTime get archivedAt;

  @BuiltValueField(wireName: r'delete_after')
  DateTime get deleteAfter;

  @BuiltValueField(wireName: r'remaining_days')
  int get remainingDays;

  @BuiltValueField(wireName: r'can_restore')
  bool get canRestore;

  @BuiltValueField(wireName: r'can_delete')
  bool get canDelete;

  ProjectArchiveItem._();

  factory ProjectArchiveItem([void updates(ProjectArchiveItemBuilder b)]) = _$ProjectArchiveItem;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProjectArchiveItemBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProjectArchiveItem> get serializer => _$ProjectArchiveItemSerializer();
}

class _$ProjectArchiveItemSerializer implements PrimitiveSerializer<ProjectArchiveItem> {
  @override
  final Iterable<Type> types = const [ProjectArchiveItem, _$ProjectArchiveItem];

  @override
  final String wireName = r'ProjectArchiveItem';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProjectArchiveItem object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(ProjectArchiveItemTypeEnum),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'budget_centavos';
    yield serializers.serialize(
      object.budgetCentavos,
      specifiedType: const FullType(int),
    );
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
    yield r'project_id';
    yield serializers.serialize(
      object.projectId,
      specifiedType: const FullType(String),
    );
    if (object.projectName != null) {
      yield r'project_name';
      yield serializers.serialize(
        object.projectName,
        specifiedType: const FullType(String),
      );
    }
    yield r'parent_archived';
    yield serializers.serialize(
      object.parentArchived,
      specifiedType: const FullType(bool),
    );
    yield r'archived_at';
    yield serializers.serialize(
      object.archivedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'delete_after';
    yield serializers.serialize(
      object.deleteAfter,
      specifiedType: const FullType(DateTime),
    );
    yield r'remaining_days';
    yield serializers.serialize(
      object.remainingDays,
      specifiedType: const FullType(int),
    );
    yield r'can_restore';
    yield serializers.serialize(
      object.canRestore,
      specifiedType: const FullType(bool),
    );
    yield r'can_delete';
    yield serializers.serialize(
      object.canDelete,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ProjectArchiveItem object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProjectArchiveItemBuilder result,
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
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ProjectArchiveItemTypeEnum),
          ) as ProjectArchiveItemTypeEnum;
          result.type = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'budget_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.budgetCentavos = valueDes;
          break;
        case r'lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lockVersion = valueDes;
          break;
        case r'project_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.projectId = valueDes;
          break;
        case r'project_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.projectName = valueDes;
          break;
        case r'parent_archived':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.parentArchived = valueDes;
          break;
        case r'archived_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.archivedAt = valueDes;
          break;
        case r'delete_after':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.deleteAfter = valueDes;
          break;
        case r'remaining_days':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.remainingDays = valueDes;
          break;
        case r'can_restore':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.canRestore = valueDes;
          break;
        case r'can_delete':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.canDelete = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProjectArchiveItem deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProjectArchiveItemBuilder();
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


class ProjectArchiveItemTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PROJECT')
  static const ProjectArchiveItemTypeEnum PROJECT = _$projectArchiveItemTypeEnum_PROJECT;
  @BuiltValueEnumConst(wireName: r'WORK_PACKAGE')
  static const ProjectArchiveItemTypeEnum WORK_PACKAGE = _$projectArchiveItemTypeEnum_WORK_PACKAGE;

  static Serializer<ProjectArchiveItemTypeEnum> get serializer => _$projectArchiveItemTypeEnumSerializer;

  const ProjectArchiveItemTypeEnum._(String name): super(name);

  static BuiltSet<ProjectArchiveItemTypeEnum> get values => _$projectArchiveItemTypeEnumValues;
  static ProjectArchiveItemTypeEnum valueOf(String name) => _$projectArchiveItemTypeEnumValueOf(name);
}

