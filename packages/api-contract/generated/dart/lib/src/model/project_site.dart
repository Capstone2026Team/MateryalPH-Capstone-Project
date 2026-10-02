//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'project_site.g.dart';

/// ProjectSite
///
/// Properties:
/// * [id]
/// * [name]
/// * [discoveryOrigin]
/// * [point]
@BuiltValue()
abstract class ProjectSite implements Built<ProjectSite, ProjectSiteBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'discovery_origin')
  String get discoveryOrigin;

  @BuiltValueField(wireName: r'point')
  BuiltMap<String, JsonObject?> get point;

  ProjectSite._();

  factory ProjectSite([void updates(ProjectSiteBuilder b)]) = _$ProjectSite;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProjectSiteBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProjectSite> get serializer => _$ProjectSiteSerializer();
}

class _$ProjectSiteSerializer implements PrimitiveSerializer<ProjectSite> {
  @override
  final Iterable<Type> types = const [ProjectSite, _$ProjectSite];

  @override
  final String wireName = r'ProjectSite';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProjectSite object, {
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
    yield r'discovery_origin';
    yield serializers.serialize(
      object.discoveryOrigin,
      specifiedType: const FullType(String),
    );
    yield r'point';
    yield serializers.serialize(
      object.point,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ProjectSite object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProjectSiteBuilder result,
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
        case r'discovery_origin':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.discoveryOrigin = valueDes;
          break;
        case r'point':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.point.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProjectSite deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProjectSiteBuilder();
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


