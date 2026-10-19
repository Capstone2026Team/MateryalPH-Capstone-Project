//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'project_arrangement_create.g.dart';

/// ProjectArrangementCreate
///
/// Properties:
/// * [proposalToken] - The selected option's opaque proposal, preserving its exact supplier/product allocations. Server verifies ownership, Work Package version, current stock, specifications, prices and delivery before saving the draft. Omit only for the legacy candidate preview.
/// * [sourceCandidateId]
@BuiltValue()
abstract class ProjectArrangementCreate implements Built<ProjectArrangementCreate, ProjectArrangementCreateBuilder> {
  /// The selected option's opaque proposal, preserving its exact supplier/product allocations. Server verifies ownership, Work Package version, current stock, specifications, prices and delivery before saving the draft. Omit only for the legacy candidate preview.
  @BuiltValueField(wireName: r'proposal_token')
  String? get proposalToken;

  @BuiltValueField(wireName: r'source_candidate_id')
  String get sourceCandidateId;

  ProjectArrangementCreate._();

  factory ProjectArrangementCreate([void updates(ProjectArrangementCreateBuilder b)]) = _$ProjectArrangementCreate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProjectArrangementCreateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProjectArrangementCreate> get serializer => _$ProjectArrangementCreateSerializer();
}

class _$ProjectArrangementCreateSerializer implements PrimitiveSerializer<ProjectArrangementCreate> {
  @override
  final Iterable<Type> types = const [ProjectArrangementCreate, _$ProjectArrangementCreate];

  @override
  final String wireName = r'ProjectArrangementCreate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProjectArrangementCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.proposalToken != null) {
      yield r'proposal_token';
      yield serializers.serialize(
        object.proposalToken,
        specifiedType: const FullType(String),
      );
    }
    yield r'source_candidate_id';
    yield serializers.serialize(
      object.sourceCandidateId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ProjectArrangementCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProjectArrangementCreateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'proposal_token':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.proposalToken = valueDes;
          break;
        case r'source_candidate_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.sourceCandidateId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProjectArrangementCreate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProjectArrangementCreateBuilder();
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


