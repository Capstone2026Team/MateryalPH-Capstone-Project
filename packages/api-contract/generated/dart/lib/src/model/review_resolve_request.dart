//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'review_resolve_request.g.dart';

/// ReviewResolveRequest
///
/// Properties:
/// * [resolution]
@BuiltValue()
abstract class ReviewResolveRequest implements Built<ReviewResolveRequest, ReviewResolveRequestBuilder> {
  @BuiltValueField(wireName: r'resolution')
  String get resolution;

  ReviewResolveRequest._();

  factory ReviewResolveRequest([void updates(ReviewResolveRequestBuilder b)]) = _$ReviewResolveRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ReviewResolveRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ReviewResolveRequest> get serializer => _$ReviewResolveRequestSerializer();
}

class _$ReviewResolveRequestSerializer implements PrimitiveSerializer<ReviewResolveRequest> {
  @override
  final Iterable<Type> types = const [ReviewResolveRequest, _$ReviewResolveRequest];

  @override
  final String wireName = r'ReviewResolveRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ReviewResolveRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'resolution';
    yield serializers.serialize(
      object.resolution,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ReviewResolveRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ReviewResolveRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'resolution':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.resolution = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ReviewResolveRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ReviewResolveRequestBuilder();
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


