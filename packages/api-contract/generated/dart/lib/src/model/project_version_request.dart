//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'project_version_request.g.dart';

/// ProjectVersionRequest
///
/// Properties:
/// * [lockVersion]
@BuiltValue()
abstract class ProjectVersionRequest implements Built<ProjectVersionRequest, ProjectVersionRequestBuilder> {
  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  ProjectVersionRequest._();

  factory ProjectVersionRequest([void updates(ProjectVersionRequestBuilder b)]) = _$ProjectVersionRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProjectVersionRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProjectVersionRequest> get serializer => _$ProjectVersionRequestSerializer();
}

class _$ProjectVersionRequestSerializer implements PrimitiveSerializer<ProjectVersionRequest> {
  @override
  final Iterable<Type> types = const [ProjectVersionRequest, _$ProjectVersionRequest];

  @override
  final String wireName = r'ProjectVersionRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProjectVersionRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ProjectVersionRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProjectVersionRequestBuilder result,
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProjectVersionRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProjectVersionRequestBuilder();
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


