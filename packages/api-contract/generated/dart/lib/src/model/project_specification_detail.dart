//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'project_specification_detail.g.dart';

/// ProjectSpecificationDetail
///
/// Properties:
/// * [code]
/// * [label] - The category's name for the detail.
/// * [value]
/// * [unitCode] - Measurement unit, or null for unitless specifications such as steel grade.
@BuiltValue()
abstract class ProjectSpecificationDetail implements Built<ProjectSpecificationDetail, ProjectSpecificationDetailBuilder> {
  @BuiltValueField(wireName: r'code')
  String get code;

  /// The category's name for the detail.
  @BuiltValueField(wireName: r'label')
  String get label;

  @BuiltValueField(wireName: r'value')
  String get value;

  /// Measurement unit, or null for unitless specifications such as steel grade.
  @BuiltValueField(wireName: r'unit_code')
  String? get unitCode;

  ProjectSpecificationDetail._();

  factory ProjectSpecificationDetail([void updates(ProjectSpecificationDetailBuilder b)]) = _$ProjectSpecificationDetail;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProjectSpecificationDetailBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProjectSpecificationDetail> get serializer => _$ProjectSpecificationDetailSerializer();
}

class _$ProjectSpecificationDetailSerializer implements PrimitiveSerializer<ProjectSpecificationDetail> {
  @override
  final Iterable<Type> types = const [ProjectSpecificationDetail, _$ProjectSpecificationDetail];

  @override
  final String wireName = r'ProjectSpecificationDetail';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProjectSpecificationDetail object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(String),
    );
    yield r'label';
    yield serializers.serialize(
      object.label,
      specifiedType: const FullType(String),
    );
    yield r'value';
    yield serializers.serialize(
      object.value,
      specifiedType: const FullType(String),
    );
    yield r'unit_code';
    yield object.unitCode == null ? null : serializers.serialize(
      object.unitCode,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ProjectSpecificationDetail object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProjectSpecificationDetailBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.code = valueDes;
          break;
        case r'label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.label = valueDes;
          break;
        case r'value':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.value = valueDes;
          break;
        case r'unit_code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.unitCode = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProjectSpecificationDetail deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProjectSpecificationDetailBuilder();
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


