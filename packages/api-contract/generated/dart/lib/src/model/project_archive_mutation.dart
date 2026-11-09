//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'project_archive_mutation.g.dart';

/// ProjectArchiveMutation
///
/// Properties:
/// * [id]
@BuiltValue()
abstract class ProjectArchiveMutation implements Built<ProjectArchiveMutation, ProjectArchiveMutationBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  ProjectArchiveMutation._();

  factory ProjectArchiveMutation([void updates(ProjectArchiveMutationBuilder b)]) = _$ProjectArchiveMutation;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProjectArchiveMutationBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProjectArchiveMutation> get serializer => _$ProjectArchiveMutationSerializer();
}

class _$ProjectArchiveMutationSerializer implements PrimitiveSerializer<ProjectArchiveMutation> {
  @override
  final Iterable<Type> types = const [ProjectArchiveMutation, _$ProjectArchiveMutation];

  @override
  final String wireName = r'ProjectArchiveMutation';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProjectArchiveMutation object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ProjectArchiveMutation object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProjectArchiveMutationBuilder result,
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProjectArchiveMutation deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProjectArchiveMutationBuilder();
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


