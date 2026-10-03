//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/project_site.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/project_budget.dart';
import 'package:materyalph_api_client/src/model/work_package_page.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'project_view.g.dart';

/// ProjectView
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
/// * [sites]
/// * [packages]
@BuiltValue()
abstract class ProjectView implements Built<ProjectView, ProjectViewBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'status')
  String get status;

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

  @BuiltValueField(wireName: r'sites')
  BuiltList<ProjectSite> get sites;

  @BuiltValueField(wireName: r'packages')
  WorkPackagePage get packages;

  ProjectView._();

  factory ProjectView([void updates(ProjectViewBuilder b)]) = _$ProjectView;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProjectViewBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProjectView> get serializer => _$ProjectViewSerializer();
}

class _$ProjectViewSerializer implements PrimitiveSerializer<ProjectView> {
  @override
  final Iterable<Type> types = const [ProjectView, _$ProjectView];

  @override
  final String wireName = r'ProjectView';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProjectView object, {
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
      specifiedType: const FullType(String),
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
    yield r'sites';
    yield serializers.serialize(
      object.sites,
      specifiedType: const FullType(BuiltList, [FullType(ProjectSite)]),
    );
    yield r'packages';
    yield serializers.serialize(
      object.packages,
      specifiedType: const FullType(WorkPackagePage),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ProjectView object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProjectViewBuilder result,
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
        case r'sites':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ProjectSite)]),
          ) as BuiltList<ProjectSite>;
          result.sites.replace(valueDes);
          break;
        case r'packages':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(WorkPackagePage),
          ) as WorkPackagePage;
          result.packages.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProjectView deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProjectViewBuilder();
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


