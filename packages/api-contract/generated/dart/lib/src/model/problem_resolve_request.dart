//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'problem_resolve_request.g.dart';

/// ProblemResolveRequest
///
/// Properties:
/// * [note]
@BuiltValue()
abstract class ProblemResolveRequest implements Built<ProblemResolveRequest, ProblemResolveRequestBuilder> {
  @BuiltValueField(wireName: r'note')
  String? get note;

  ProblemResolveRequest._();

  factory ProblemResolveRequest([void updates(ProblemResolveRequestBuilder b)]) = _$ProblemResolveRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProblemResolveRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProblemResolveRequest> get serializer => _$ProblemResolveRequestSerializer();
}

class _$ProblemResolveRequestSerializer implements PrimitiveSerializer<ProblemResolveRequest> {
  @override
  final Iterable<Type> types = const [ProblemResolveRequest, _$ProblemResolveRequest];

  @override
  final String wireName = r'ProblemResolveRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProblemResolveRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.note != null) {
      yield r'note';
      yield serializers.serialize(
        object.note,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ProblemResolveRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProblemResolveRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'note':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.note = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProblemResolveRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProblemResolveRequestBuilder();
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


