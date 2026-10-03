//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/work_package_version.dart';
import 'package:materyalph_api_client/src/model/project_budget.dart';
import 'package:materyalph_api_client/src/model/work_package_version_page.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'work_package_view.g.dart';

/// WorkPackageView
///
/// Properties:
/// * [id]
/// * [projectId]
/// * [projectStatus]
/// * [name]
/// * [status]
/// * [budgetCentavos]
/// * [lockVersion]
/// * [currentVersionId]
/// * [selectedVendorId]
/// * [orderId]
/// * [version]
/// * [versions]
/// * [budget]
/// * [missingLines]
/// * [document]
@BuiltValue()
abstract class WorkPackageView implements Built<WorkPackageView, WorkPackageViewBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'project_id')
  String get projectId;

  @BuiltValueField(wireName: r'project_status')
  WorkPackageViewProjectStatusEnum get projectStatus;
  // enum projectStatusEnum {  ACTIVE,  COMPLETED,  ARCHIVED,  };

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'status')
  String get status;

  @BuiltValueField(wireName: r'budget_centavos')
  int get budgetCentavos;

  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  @BuiltValueField(wireName: r'current_version_id')
  String? get currentVersionId;

  @BuiltValueField(wireName: r'selected_vendor_id')
  String? get selectedVendorId;

  @BuiltValueField(wireName: r'order_id')
  String? get orderId;

  @BuiltValueField(wireName: r'version')
  WorkPackageVersion? get version;

  @BuiltValueField(wireName: r'versions')
  WorkPackageVersionPage get versions;

  @BuiltValueField(wireName: r'budget')
  ProjectBudget get budget;

  @BuiltValueField(wireName: r'missing_lines')
  BuiltList<BuiltMap<String, JsonObject?>> get missingLines;

  @BuiltValueField(wireName: r'document')
  BuiltMap<String, JsonObject?> get document;

  WorkPackageView._();

  factory WorkPackageView([void updates(WorkPackageViewBuilder b)]) = _$WorkPackageView;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(WorkPackageViewBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<WorkPackageView> get serializer => _$WorkPackageViewSerializer();
}

class _$WorkPackageViewSerializer implements PrimitiveSerializer<WorkPackageView> {
  @override
  final Iterable<Type> types = const [WorkPackageView, _$WorkPackageView];

  @override
  final String wireName = r'WorkPackageView';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    WorkPackageView object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'project_id';
    yield serializers.serialize(
      object.projectId,
      specifiedType: const FullType(String),
    );
    yield r'project_status';
    yield serializers.serialize(
      object.projectStatus,
      specifiedType: const FullType(WorkPackageViewProjectStatusEnum),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
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
    if (object.currentVersionId != null) {
      yield r'current_version_id';
      yield serializers.serialize(
        object.currentVersionId,
        specifiedType: const FullType(String),
      );
    }
    if (object.selectedVendorId != null) {
      yield r'selected_vendor_id';
      yield serializers.serialize(
        object.selectedVendorId,
        specifiedType: const FullType(String),
      );
    }
    if (object.orderId != null) {
      yield r'order_id';
      yield serializers.serialize(
        object.orderId,
        specifiedType: const FullType(String),
      );
    }
    if (object.version != null) {
      yield r'version';
      yield serializers.serialize(
        object.version,
        specifiedType: const FullType(WorkPackageVersion),
      );
    }
    yield r'versions';
    yield serializers.serialize(
      object.versions,
      specifiedType: const FullType(WorkPackageVersionPage),
    );
    yield r'budget';
    yield serializers.serialize(
      object.budget,
      specifiedType: const FullType(ProjectBudget),
    );
    yield r'missing_lines';
    yield serializers.serialize(
      object.missingLines,
      specifiedType: const FullType(BuiltList, [FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)])]),
    );
    yield r'document';
    yield serializers.serialize(
      object.document,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    WorkPackageView object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required WorkPackageViewBuilder result,
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
        case r'project_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.projectId = valueDes;
          break;
        case r'project_status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(WorkPackageViewProjectStatusEnum),
          ) as WorkPackageViewProjectStatusEnum;
          result.projectStatus = valueDes;
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
            specifiedType: const FullType(String),
          ) as String;
          result.status = valueDes;
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
        case r'current_version_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.currentVersionId = valueDes;
          break;
        case r'selected_vendor_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.selectedVendorId = valueDes;
          break;
        case r'order_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.orderId = valueDes;
          break;
        case r'version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(WorkPackageVersion),
          ) as WorkPackageVersion?;
          if (valueDes == null) continue;
          result.version.replace(valueDes);
          break;
        case r'versions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(WorkPackageVersionPage),
          ) as WorkPackageVersionPage;
          result.versions.replace(valueDes);
          break;
        case r'budget':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ProjectBudget),
          ) as ProjectBudget;
          result.budget.replace(valueDes);
          break;
        case r'missing_lines':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)])]),
          ) as BuiltList<BuiltMap<String, JsonObject?>>;
          result.missingLines.replace(valueDes);
          break;
        case r'document':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.document.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  WorkPackageView deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = WorkPackageViewBuilder();
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


class WorkPackageViewProjectStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ACTIVE')
  static const WorkPackageViewProjectStatusEnum ACTIVE = _$workPackageViewProjectStatusEnum_ACTIVE;
  @BuiltValueEnumConst(wireName: r'COMPLETED')
  static const WorkPackageViewProjectStatusEnum COMPLETED = _$workPackageViewProjectStatusEnum_COMPLETED;
  @BuiltValueEnumConst(wireName: r'ARCHIVED')
  static const WorkPackageViewProjectStatusEnum ARCHIVED = _$workPackageViewProjectStatusEnum_ARCHIVED;

  static Serializer<WorkPackageViewProjectStatusEnum> get serializer => _$workPackageViewProjectStatusEnumSerializer;

  const WorkPackageViewProjectStatusEnum._(String name): super(name);

  static BuiltSet<WorkPackageViewProjectStatusEnum> get values => _$workPackageViewProjectStatusEnumValues;
  static WorkPackageViewProjectStatusEnum valueOf(String name) => _$workPackageViewProjectStatusEnumValueOf(name);
}

