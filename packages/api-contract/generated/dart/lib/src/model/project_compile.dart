//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'project_compile.g.dart';

/// ProjectCompile
///
/// Properties:
/// * [lockVersion]
/// * [radiusKm] - Optional. The scan always uses the fixed 50 km Project-Based radius around the locked Project site.
@BuiltValue()
abstract class ProjectCompile implements Built<ProjectCompile, ProjectCompileBuilder> {
  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  /// Optional. The scan always uses the fixed 50 km Project-Based radius around the locked Project site.
  @BuiltValueField(wireName: r'radius_km')
  ProjectCompileRadiusKmEnum? get radiusKm;
  // enum radiusKmEnum {  50,  };

  ProjectCompile._();

  factory ProjectCompile([void updates(ProjectCompileBuilder b)]) = _$ProjectCompile;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProjectCompileBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProjectCompile> get serializer => _$ProjectCompileSerializer();
}

class _$ProjectCompileSerializer implements PrimitiveSerializer<ProjectCompile> {
  @override
  final Iterable<Type> types = const [ProjectCompile, _$ProjectCompile];

  @override
  final String wireName = r'ProjectCompile';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProjectCompile object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
    if (object.radiusKm != null) {
      yield r'radius_km';
      yield serializers.serialize(
        object.radiusKm,
        specifiedType: const FullType(ProjectCompileRadiusKmEnum),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ProjectCompile object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProjectCompileBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lockVersion = valueDes;
          break;
        case r'radius_km':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ProjectCompileRadiusKmEnum),
          ) as ProjectCompileRadiusKmEnum?;
          if (valueDes == null) continue;
          result.radiusKm = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProjectCompile deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProjectCompileBuilder();
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


/// Optional. The scan always uses the fixed 50 km Project-Based radius around the locked Project site.
class ProjectCompileRadiusKmEnum extends EnumClass {

  @BuiltValueEnumConst(wireNumber: 50)
  static const ProjectCompileRadiusKmEnum number50 = _$projectCompileRadiusKmEnum_number50;

  static Serializer<ProjectCompileRadiusKmEnum> get serializer => _$projectCompileRadiusKmEnumSerializer;

  const ProjectCompileRadiusKmEnum._(String name): super(name);

  static BuiltSet<ProjectCompileRadiusKmEnum> get values => _$projectCompileRadiusKmEnumValues;
  static ProjectCompileRadiusKmEnum valueOf(String name) => _$projectCompileRadiusKmEnumValueOf(name);
}

