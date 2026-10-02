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
/// * [radiusKm]
@BuiltValue()
abstract class ProjectCompile implements Built<ProjectCompile, ProjectCompileBuilder> {
  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  @BuiltValueField(wireName: r'radius_km')
  ProjectCompileRadiusKmEnum get radiusKm;
  // enum radiusKmEnum {  5,  10,  20,  30,  40,  50,  };

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
    yield r'radius_km';
    yield serializers.serialize(
      object.radiusKm,
      specifiedType: const FullType(ProjectCompileRadiusKmEnum),
    );
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
            specifiedType: const FullType(ProjectCompileRadiusKmEnum),
          ) as ProjectCompileRadiusKmEnum;
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


class ProjectCompileRadiusKmEnum extends EnumClass {

  @BuiltValueEnumConst(wireNumber: 5)
  static const ProjectCompileRadiusKmEnum number5 = _$projectCompileRadiusKmEnum_number5;
  @BuiltValueEnumConst(wireNumber: 10)
  static const ProjectCompileRadiusKmEnum number10 = _$projectCompileRadiusKmEnum_number10;
  @BuiltValueEnumConst(wireNumber: 20)
  static const ProjectCompileRadiusKmEnum number20 = _$projectCompileRadiusKmEnum_number20;
  @BuiltValueEnumConst(wireNumber: 30)
  static const ProjectCompileRadiusKmEnum number30 = _$projectCompileRadiusKmEnum_number30;
  @BuiltValueEnumConst(wireNumber: 40)
  static const ProjectCompileRadiusKmEnum number40 = _$projectCompileRadiusKmEnum_number40;
  @BuiltValueEnumConst(wireNumber: 50)
  static const ProjectCompileRadiusKmEnum number50 = _$projectCompileRadiusKmEnum_number50;

  static Serializer<ProjectCompileRadiusKmEnum> get serializer => _$projectCompileRadiusKmEnumSerializer;

  const ProjectCompileRadiusKmEnum._(String name): super(name);

  static BuiltSet<ProjectCompileRadiusKmEnum> get values => _$projectCompileRadiusKmEnumValues;
  static ProjectCompileRadiusKmEnum valueOf(String name) => _$projectCompileRadiusKmEnumValueOf(name);
}

