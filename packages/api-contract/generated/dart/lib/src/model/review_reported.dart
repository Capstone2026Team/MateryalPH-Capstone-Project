//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'review_reported.g.dart';

/// ReviewReported
///
/// Properties:
/// * [reported]
@BuiltValue()
abstract class ReviewReported implements Built<ReviewReported, ReviewReportedBuilder> {
  @BuiltValueField(wireName: r'reported')
  bool get reported;

  ReviewReported._();

  factory ReviewReported([void updates(ReviewReportedBuilder b)]) = _$ReviewReported;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ReviewReportedBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ReviewReported> get serializer => _$ReviewReportedSerializer();
}

class _$ReviewReportedSerializer implements PrimitiveSerializer<ReviewReported> {
  @override
  final Iterable<Type> types = const [ReviewReported, _$ReviewReported];

  @override
  final String wireName = r'ReviewReported';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ReviewReported object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'reported';
    yield serializers.serialize(
      object.reported,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ReviewReported object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ReviewReportedBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'reported':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.reported = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ReviewReported deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ReviewReportedBuilder();
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


