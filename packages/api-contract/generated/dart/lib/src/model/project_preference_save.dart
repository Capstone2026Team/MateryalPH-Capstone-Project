//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'project_preference_save.g.dart';

/// ProjectPreferenceSave
///
/// Properties:
/// * [version]
/// * [weights]
@BuiltValue()
abstract class ProjectPreferenceSave implements Built<ProjectPreferenceSave, ProjectPreferenceSaveBuilder> {
  @BuiltValueField(wireName: r'version')
  int get version;

  @BuiltValueField(wireName: r'weights')
  BuiltMap<String, JsonObject?> get weights;

  ProjectPreferenceSave._();

  factory ProjectPreferenceSave([void updates(ProjectPreferenceSaveBuilder b)]) = _$ProjectPreferenceSave;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProjectPreferenceSaveBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProjectPreferenceSave> get serializer => _$ProjectPreferenceSaveSerializer();
}

class _$ProjectPreferenceSaveSerializer implements PrimitiveSerializer<ProjectPreferenceSave> {
  @override
  final Iterable<Type> types = const [ProjectPreferenceSave, _$ProjectPreferenceSave];

  @override
  final String wireName = r'ProjectPreferenceSave';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProjectPreferenceSave object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'version';
    yield serializers.serialize(
      object.version,
      specifiedType: const FullType(int),
    );
    yield r'weights';
    yield serializers.serialize(
      object.weights,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ProjectPreferenceSave object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProjectPreferenceSaveBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.version = valueDes;
          break;
        case r'weights':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.weights.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProjectPreferenceSave deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProjectPreferenceSaveBuilder();
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


