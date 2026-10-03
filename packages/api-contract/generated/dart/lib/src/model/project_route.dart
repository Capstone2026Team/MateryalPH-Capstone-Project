//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'project_route.g.dart';

/// ProjectRoute
///
/// Properties:
/// * [candidateId]
/// * [versionId]
/// * [origin]
/// * [distanceMeters]
/// * [durationSeconds]
/// * [encodedPolyline]
/// * [durationBasis]
/// * [computedAt]
@BuiltValue()
abstract class ProjectRoute implements Built<ProjectRoute, ProjectRouteBuilder> {
  @BuiltValueField(wireName: r'candidate_id')
  String get candidateId;

  @BuiltValueField(wireName: r'version_id')
  String get versionId;

  @BuiltValueField(wireName: r'origin')
  ProjectRouteOriginEnum get origin;
  // enum originEnum {  PROJECT_SITE,  };

  @BuiltValueField(wireName: r'distance_meters')
  int get distanceMeters;

  @BuiltValueField(wireName: r'duration_seconds')
  int get durationSeconds;

  @BuiltValueField(wireName: r'encoded_polyline')
  String get encodedPolyline;

  @BuiltValueField(wireName: r'duration_basis')
  String get durationBasis;

  @BuiltValueField(wireName: r'computed_at')
  String get computedAt;

  ProjectRoute._();

  factory ProjectRoute([void updates(ProjectRouteBuilder b)]) = _$ProjectRoute;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProjectRouteBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProjectRoute> get serializer => _$ProjectRouteSerializer();
}

class _$ProjectRouteSerializer implements PrimitiveSerializer<ProjectRoute> {
  @override
  final Iterable<Type> types = const [ProjectRoute, _$ProjectRoute];

  @override
  final String wireName = r'ProjectRoute';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProjectRoute object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'candidate_id';
    yield serializers.serialize(
      object.candidateId,
      specifiedType: const FullType(String),
    );
    yield r'version_id';
    yield serializers.serialize(
      object.versionId,
      specifiedType: const FullType(String),
    );
    yield r'origin';
    yield serializers.serialize(
      object.origin,
      specifiedType: const FullType(ProjectRouteOriginEnum),
    );
    yield r'distance_meters';
    yield serializers.serialize(
      object.distanceMeters,
      specifiedType: const FullType(int),
    );
    yield r'duration_seconds';
    yield serializers.serialize(
      object.durationSeconds,
      specifiedType: const FullType(int),
    );
    yield r'encoded_polyline';
    yield serializers.serialize(
      object.encodedPolyline,
      specifiedType: const FullType(String),
    );
    yield r'duration_basis';
    yield serializers.serialize(
      object.durationBasis,
      specifiedType: const FullType(String),
    );
    yield r'computed_at';
    yield serializers.serialize(
      object.computedAt,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ProjectRoute object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProjectRouteBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'candidate_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.candidateId = valueDes;
          break;
        case r'version_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.versionId = valueDes;
          break;
        case r'origin':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ProjectRouteOriginEnum),
          ) as ProjectRouteOriginEnum;
          result.origin = valueDes;
          break;
        case r'distance_meters':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.distanceMeters = valueDes;
          break;
        case r'duration_seconds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.durationSeconds = valueDes;
          break;
        case r'encoded_polyline':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.encodedPolyline = valueDes;
          break;
        case r'duration_basis':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.durationBasis = valueDes;
          break;
        case r'computed_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.computedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProjectRoute deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProjectRouteBuilder();
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


class ProjectRouteOriginEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PROJECT_SITE')
  static const ProjectRouteOriginEnum PROJECT_SITE = _$projectRouteOriginEnum_PROJECT_SITE;

  static Serializer<ProjectRouteOriginEnum> get serializer => _$projectRouteOriginEnumSerializer;

  const ProjectRouteOriginEnum._(String name): super(name);

  static BuiltSet<ProjectRouteOriginEnum> get values => _$projectRouteOriginEnumValues;
  static ProjectRouteOriginEnum valueOf(String name) => _$projectRouteOriginEnumValueOf(name);
}

