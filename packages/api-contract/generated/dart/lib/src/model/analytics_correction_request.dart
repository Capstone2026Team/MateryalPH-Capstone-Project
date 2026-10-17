//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'analytics_correction_request.g.dart';

/// AnalyticsCorrectionRequest
///
/// Properties:
/// * [excludedObservationIds]
/// * [reason]
@BuiltValue()
abstract class AnalyticsCorrectionRequest implements Built<AnalyticsCorrectionRequest, AnalyticsCorrectionRequestBuilder> {
  @BuiltValueField(wireName: r'excluded_observation_ids')
  BuiltList<String> get excludedObservationIds;

  @BuiltValueField(wireName: r'reason')
  String get reason;

  AnalyticsCorrectionRequest._();

  factory AnalyticsCorrectionRequest([void updates(AnalyticsCorrectionRequestBuilder b)]) = _$AnalyticsCorrectionRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AnalyticsCorrectionRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AnalyticsCorrectionRequest> get serializer => _$AnalyticsCorrectionRequestSerializer();
}

class _$AnalyticsCorrectionRequestSerializer implements PrimitiveSerializer<AnalyticsCorrectionRequest> {
  @override
  final Iterable<Type> types = const [AnalyticsCorrectionRequest, _$AnalyticsCorrectionRequest];

  @override
  final String wireName = r'AnalyticsCorrectionRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AnalyticsCorrectionRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'excluded_observation_ids';
    yield serializers.serialize(
      object.excludedObservationIds,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AnalyticsCorrectionRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AnalyticsCorrectionRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'excluded_observation_ids':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.excludedObservationIds.replace(valueDes);
          break;
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
  AnalyticsCorrectionRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AnalyticsCorrectionRequestBuilder();
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


