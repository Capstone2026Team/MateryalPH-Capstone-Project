//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/work_package_line_input.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'project_import_preview.g.dart';

/// ProjectImportPreview
///
/// Properties:
/// * [lines]
/// * [validationErrors]
/// * [valid]
@BuiltValue()
abstract class ProjectImportPreview implements Built<ProjectImportPreview, ProjectImportPreviewBuilder> {
  @BuiltValueField(wireName: r'lines')
  BuiltList<WorkPackageLineInput> get lines;

  @BuiltValueField(wireName: r'validation_errors')
  BuiltList<BuiltMap<String, JsonObject?>> get validationErrors;

  @BuiltValueField(wireName: r'valid')
  bool get valid;

  ProjectImportPreview._();

  factory ProjectImportPreview([void updates(ProjectImportPreviewBuilder b)]) = _$ProjectImportPreview;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProjectImportPreviewBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProjectImportPreview> get serializer => _$ProjectImportPreviewSerializer();
}

class _$ProjectImportPreviewSerializer implements PrimitiveSerializer<ProjectImportPreview> {
  @override
  final Iterable<Type> types = const [ProjectImportPreview, _$ProjectImportPreview];

  @override
  final String wireName = r'ProjectImportPreview';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProjectImportPreview object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'lines';
    yield serializers.serialize(
      object.lines,
      specifiedType: const FullType(BuiltList, [FullType(WorkPackageLineInput)]),
    );
    yield r'validation_errors';
    yield serializers.serialize(
      object.validationErrors,
      specifiedType: const FullType(BuiltList, [FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)])]),
    );
    yield r'valid';
    yield serializers.serialize(
      object.valid,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ProjectImportPreview object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProjectImportPreviewBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'lines':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(WorkPackageLineInput)]),
          ) as BuiltList<WorkPackageLineInput>;
          result.lines.replace(valueDes);
          break;
        case r'validation_errors':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)])]),
          ) as BuiltList<BuiltMap<String, JsonObject?>>;
          result.validationErrors.replace(valueDes);
          break;
        case r'valid':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.valid = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProjectImportPreview deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProjectImportPreviewBuilder();
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


