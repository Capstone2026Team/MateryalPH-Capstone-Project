//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/quantity_policy.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'project_material_unit.g.dart';

/// ProjectMaterialUnit
///
/// Properties:
/// * [quantityPolicy]
/// * [id]
/// * [code]
/// * [name]
/// * [precision]
@BuiltValue()
abstract class ProjectMaterialUnit implements Built<ProjectMaterialUnit, ProjectMaterialUnitBuilder> {
  @BuiltValueField(wireName: r'quantity_policy')
  QuantityPolicy? get quantityPolicy;

  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'precision')
  int get precision;

  ProjectMaterialUnit._();

  factory ProjectMaterialUnit([void updates(ProjectMaterialUnitBuilder b)]) = _$ProjectMaterialUnit;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProjectMaterialUnitBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProjectMaterialUnit> get serializer => _$ProjectMaterialUnitSerializer();
}

class _$ProjectMaterialUnitSerializer implements PrimitiveSerializer<ProjectMaterialUnit> {
  @override
  final Iterable<Type> types = const [ProjectMaterialUnit, _$ProjectMaterialUnit];

  @override
  final String wireName = r'ProjectMaterialUnit';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProjectMaterialUnit object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.quantityPolicy != null) {
      yield r'quantity_policy';
      yield serializers.serialize(
        object.quantityPolicy,
        specifiedType: const FullType(QuantityPolicy),
      );
    }
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'precision';
    yield serializers.serialize(
      object.precision,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ProjectMaterialUnit object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProjectMaterialUnitBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'quantity_policy':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(QuantityPolicy),
          ) as QuantityPolicy?;
          if (valueDes == null) continue;
          result.quantityPolicy.replace(valueDes);
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.code = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'precision':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.precision = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProjectMaterialUnit deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProjectMaterialUnitBuilder();
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


