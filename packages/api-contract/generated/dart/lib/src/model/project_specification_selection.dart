//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'project_specification_selection.g.dart';

/// ProjectSpecificationSelection
///
/// Properties:
/// * [lineId]
/// * [optionId] - An `option_id` from that line's `options`.
@BuiltValue()
abstract class ProjectSpecificationSelection implements Built<ProjectSpecificationSelection, ProjectSpecificationSelectionBuilder> {
  @BuiltValueField(wireName: r'line_id')
  String get lineId;

  /// An `option_id` from that line's `options`.
  @BuiltValueField(wireName: r'option_id')
  String get optionId;

  ProjectSpecificationSelection._();

  factory ProjectSpecificationSelection([void updates(ProjectSpecificationSelectionBuilder b)]) = _$ProjectSpecificationSelection;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProjectSpecificationSelectionBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProjectSpecificationSelection> get serializer => _$ProjectSpecificationSelectionSerializer();
}

class _$ProjectSpecificationSelectionSerializer implements PrimitiveSerializer<ProjectSpecificationSelection> {
  @override
  final Iterable<Type> types = const [ProjectSpecificationSelection, _$ProjectSpecificationSelection];

  @override
  final String wireName = r'ProjectSpecificationSelection';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProjectSpecificationSelection object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'line_id';
    yield serializers.serialize(
      object.lineId,
      specifiedType: const FullType(String),
    );
    yield r'option_id';
    yield serializers.serialize(
      object.optionId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ProjectSpecificationSelection object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProjectSpecificationSelectionBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'line_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.lineId = valueDes;
          break;
        case r'option_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.optionId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProjectSpecificationSelection deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProjectSpecificationSelectionBuilder();
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


