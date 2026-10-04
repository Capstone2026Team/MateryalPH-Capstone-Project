//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dispute_remedy_confirm_request.g.dart';

/// DisputeRemedyConfirmRequest
///
/// Properties:
/// * [reason]
@BuiltValue()
abstract class DisputeRemedyConfirmRequest implements Built<DisputeRemedyConfirmRequest, DisputeRemedyConfirmRequestBuilder> {
  @BuiltValueField(wireName: r'reason')
  String get reason;

  DisputeRemedyConfirmRequest._();

  factory DisputeRemedyConfirmRequest([void updates(DisputeRemedyConfirmRequestBuilder b)]) = _$DisputeRemedyConfirmRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DisputeRemedyConfirmRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DisputeRemedyConfirmRequest> get serializer => _$DisputeRemedyConfirmRequestSerializer();
}

class _$DisputeRemedyConfirmRequestSerializer implements PrimitiveSerializer<DisputeRemedyConfirmRequest> {
  @override
  final Iterable<Type> types = const [DisputeRemedyConfirmRequest, _$DisputeRemedyConfirmRequest];

  @override
  final String wireName = r'DisputeRemedyConfirmRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DisputeRemedyConfirmRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DisputeRemedyConfirmRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DisputeRemedyConfirmRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DisputeRemedyConfirmRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DisputeRemedyConfirmRequestBuilder();
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


