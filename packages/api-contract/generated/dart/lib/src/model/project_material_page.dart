//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/project_material.dart';
import 'package:materyalph_api_client/src/model/project_material_unit.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'project_material_page.g.dart';

/// ProjectMaterialPage
///
/// Properties:
/// * [items]
/// * [units] - Every normalized unit, for an unlisted material.
@BuiltValue()
abstract class ProjectMaterialPage implements Built<ProjectMaterialPage, ProjectMaterialPageBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<ProjectMaterial> get items;

  /// Every normalized unit, for an unlisted material.
  @BuiltValueField(wireName: r'units')
  BuiltList<ProjectMaterialUnit> get units;

  ProjectMaterialPage._();

  factory ProjectMaterialPage([void updates(ProjectMaterialPageBuilder b)]) = _$ProjectMaterialPage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProjectMaterialPageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProjectMaterialPage> get serializer => _$ProjectMaterialPageSerializer();
}

class _$ProjectMaterialPageSerializer implements PrimitiveSerializer<ProjectMaterialPage> {
  @override
  final Iterable<Type> types = const [ProjectMaterialPage, _$ProjectMaterialPage];

  @override
  final String wireName = r'ProjectMaterialPage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProjectMaterialPage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(ProjectMaterial)]),
    );
    yield r'units';
    yield serializers.serialize(
      object.units,
      specifiedType: const FullType(BuiltList, [FullType(ProjectMaterialUnit)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ProjectMaterialPage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProjectMaterialPageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ProjectMaterial)]),
          ) as BuiltList<ProjectMaterial>;
          result.items.replace(valueDes);
          break;
        case r'units':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ProjectMaterialUnit)]),
          ) as BuiltList<ProjectMaterialUnit>;
          result.units.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProjectMaterialPage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProjectMaterialPageBuilder();
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


