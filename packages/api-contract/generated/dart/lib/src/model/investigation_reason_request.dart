//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'investigation_reason_request.g.dart';

/// InvestigationReasonRequest
///
/// Properties:
/// * [reason]
@BuiltValue()
abstract class InvestigationReasonRequest implements Built<InvestigationReasonRequest, InvestigationReasonRequestBuilder> {
  @BuiltValueField(wireName: r'reason')
  String get reason;

  InvestigationReasonRequest._();

  factory InvestigationReasonRequest([void updates(InvestigationReasonRequestBuilder b)]) = _$InvestigationReasonRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(InvestigationReasonRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<InvestigationReasonRequest> get serializer => _$InvestigationReasonRequestSerializer();
}

class _$InvestigationReasonRequestSerializer implements PrimitiveSerializer<InvestigationReasonRequest> {
  @override
  final Iterable<Type> types = const [InvestigationReasonRequest, _$InvestigationReasonRequest];

  @override
  final String wireName = r'InvestigationReasonRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    InvestigationReasonRequest object, {
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
    InvestigationReasonRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required InvestigationReasonRequestBuilder result,
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
  InvestigationReasonRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = InvestigationReasonRequestBuilder();
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


