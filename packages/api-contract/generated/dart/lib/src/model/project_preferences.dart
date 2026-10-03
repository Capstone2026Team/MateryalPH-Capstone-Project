//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'project_preferences.g.dart';

/// ProjectPreferences
///
/// Properties:
/// * [weights]
/// * [defaultWeights]
/// * [personalized]
/// * [version]
/// * [defaultsVersion]
/// * [algorithmVersion]
@BuiltValue()
abstract class ProjectPreferences implements Built<ProjectPreferences, ProjectPreferencesBuilder> {
  @BuiltValueField(wireName: r'weights')
  BuiltMap<String, JsonObject?> get weights;

  @BuiltValueField(wireName: r'default_weights')
  BuiltMap<String, JsonObject?> get defaultWeights;

  @BuiltValueField(wireName: r'personalized')
  bool get personalized;

  @BuiltValueField(wireName: r'version')
  int get version;

  @BuiltValueField(wireName: r'defaults_version')
  int get defaultsVersion;

  @BuiltValueField(wireName: r'algorithm_version')
  String get algorithmVersion;

  ProjectPreferences._();

  factory ProjectPreferences([void updates(ProjectPreferencesBuilder b)]) = _$ProjectPreferences;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProjectPreferencesBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProjectPreferences> get serializer => _$ProjectPreferencesSerializer();
}

class _$ProjectPreferencesSerializer implements PrimitiveSerializer<ProjectPreferences> {
  @override
  final Iterable<Type> types = const [ProjectPreferences, _$ProjectPreferences];

  @override
  final String wireName = r'ProjectPreferences';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProjectPreferences object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'weights';
    yield serializers.serialize(
      object.weights,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
    yield r'default_weights';
    yield serializers.serialize(
      object.defaultWeights,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
    yield r'personalized';
    yield serializers.serialize(
      object.personalized,
      specifiedType: const FullType(bool),
    );
    yield r'version';
    yield serializers.serialize(
      object.version,
      specifiedType: const FullType(int),
    );
    yield r'defaults_version';
    yield serializers.serialize(
      object.defaultsVersion,
      specifiedType: const FullType(int),
    );
    yield r'algorithm_version';
    yield serializers.serialize(
      object.algorithmVersion,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ProjectPreferences object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProjectPreferencesBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'weights':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.weights.replace(valueDes);
          break;
        case r'default_weights':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.defaultWeights.replace(valueDes);
          break;
        case r'personalized':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.personalized = valueDes;
          break;
        case r'version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.version = valueDes;
          break;
        case r'defaults_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.defaultsVersion = valueDes;
          break;
        case r'algorithm_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.algorithmVersion = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProjectPreferences deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProjectPreferencesBuilder();
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


