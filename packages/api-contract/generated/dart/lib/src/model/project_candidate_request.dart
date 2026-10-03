//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'project_candidate_request.g.dart';

/// ProjectCandidateRequest
///
/// Properties:
/// * [lockVersion]
/// * [candidateId]
/// * [note]
/// * [budgetOverrideReason]
@BuiltValue()
abstract class ProjectCandidateRequest implements Built<ProjectCandidateRequest, ProjectCandidateRequestBuilder> {
  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  @BuiltValueField(wireName: r'candidate_id')
  String get candidateId;

  @BuiltValueField(wireName: r'note')
  String? get note;

  @BuiltValueField(wireName: r'budget_override_reason')
  String? get budgetOverrideReason;

  ProjectCandidateRequest._();

  factory ProjectCandidateRequest([void updates(ProjectCandidateRequestBuilder b)]) = _$ProjectCandidateRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProjectCandidateRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProjectCandidateRequest> get serializer => _$ProjectCandidateRequestSerializer();
}

class _$ProjectCandidateRequestSerializer implements PrimitiveSerializer<ProjectCandidateRequest> {
  @override
  final Iterable<Type> types = const [ProjectCandidateRequest, _$ProjectCandidateRequest];

  @override
  final String wireName = r'ProjectCandidateRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProjectCandidateRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
    yield r'candidate_id';
    yield serializers.serialize(
      object.candidateId,
      specifiedType: const FullType(String),
    );
    if (object.note != null) {
      yield r'note';
      yield serializers.serialize(
        object.note,
        specifiedType: const FullType(String),
      );
    }
    if (object.budgetOverrideReason != null) {
      yield r'budget_override_reason';
      yield serializers.serialize(
        object.budgetOverrideReason,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ProjectCandidateRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProjectCandidateRequestBuilder result,
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
        case r'candidate_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.candidateId = valueDes;
          break;
        case r'note':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.note = valueDes;
          break;
        case r'budget_override_reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.budgetOverrideReason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProjectCandidateRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProjectCandidateRequestBuilder();
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


