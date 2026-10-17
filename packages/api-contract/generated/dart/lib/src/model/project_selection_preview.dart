//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/project_specification_selection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'project_selection_preview.g.dart';

/// ProjectSelectionPreview
///
/// Properties:
/// * [selections]
@BuiltValue()
abstract class ProjectSelectionPreview implements Built<ProjectSelectionPreview, ProjectSelectionPreviewBuilder> {
  @BuiltValueField(wireName: r'selections')
  BuiltList<ProjectSpecificationSelection>? get selections;

  ProjectSelectionPreview._();

  factory ProjectSelectionPreview([void updates(ProjectSelectionPreviewBuilder b)]) = _$ProjectSelectionPreview;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProjectSelectionPreviewBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProjectSelectionPreview> get serializer => _$ProjectSelectionPreviewSerializer();
}

class _$ProjectSelectionPreviewSerializer implements PrimitiveSerializer<ProjectSelectionPreview> {
  @override
  final Iterable<Type> types = const [ProjectSelectionPreview, _$ProjectSelectionPreview];

  @override
  final String wireName = r'ProjectSelectionPreview';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProjectSelectionPreview object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.selections != null) {
      yield r'selections';
      yield serializers.serialize(
        object.selections,
        specifiedType: const FullType(BuiltList, [FullType(ProjectSpecificationSelection)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ProjectSelectionPreview object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProjectSelectionPreviewBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'selections':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(ProjectSpecificationSelection)]),
          ) as BuiltList<ProjectSpecificationSelection>?;
          if (valueDes == null) continue;
          result.selections.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProjectSelectionPreview deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProjectSelectionPreviewBuilder();
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


