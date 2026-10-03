//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'project_import_request.g.dart';

/// ProjectImportRequest
///
/// Properties:
/// * [csv]
@BuiltValue()
abstract class ProjectImportRequest implements Built<ProjectImportRequest, ProjectImportRequestBuilder> {
  @BuiltValueField(wireName: r'csv')
  String get csv;

  ProjectImportRequest._();

  factory ProjectImportRequest([void updates(ProjectImportRequestBuilder b)]) = _$ProjectImportRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProjectImportRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProjectImportRequest> get serializer => _$ProjectImportRequestSerializer();
}

class _$ProjectImportRequestSerializer implements PrimitiveSerializer<ProjectImportRequest> {
  @override
  final Iterable<Type> types = const [ProjectImportRequest, _$ProjectImportRequest];

  @override
  final String wireName = r'ProjectImportRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProjectImportRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'csv';
    yield serializers.serialize(
      object.csv,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ProjectImportRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProjectImportRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'csv':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.csv = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProjectImportRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProjectImportRequestBuilder();
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


