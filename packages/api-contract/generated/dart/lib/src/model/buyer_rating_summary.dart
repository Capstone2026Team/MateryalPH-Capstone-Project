//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'buyer_rating_summary.g.dart';

/// BuyerRatingSummary
///
/// Properties:
/// * [score] - CCS = (Inquiry Seriousness + Communication Quality + Payment Reliability) / 3, rounded half-up to two decimals. Null below the sample gate.
/// * [count]
/// * [minimumCount]
/// * [windowDays]
/// * [inquirySeriousness]
/// * [communicationQuality]
/// * [paymentReliability]
@BuiltValue()
abstract class BuyerRatingSummary implements Built<BuyerRatingSummary, BuyerRatingSummaryBuilder> {
  /// CCS = (Inquiry Seriousness + Communication Quality + Payment Reliability) / 3, rounded half-up to two decimals. Null below the sample gate.
  @BuiltValueField(wireName: r'score')
  num? get score;

  @BuiltValueField(wireName: r'count')
  int get count;

  @BuiltValueField(wireName: r'minimum_count')
  int get minimumCount;

  @BuiltValueField(wireName: r'window_days')
  int get windowDays;

  @BuiltValueField(wireName: r'inquiry_seriousness')
  num? get inquirySeriousness;

  @BuiltValueField(wireName: r'communication_quality')
  num? get communicationQuality;

  @BuiltValueField(wireName: r'payment_reliability')
  num? get paymentReliability;

  BuyerRatingSummary._();

  factory BuyerRatingSummary([void updates(BuyerRatingSummaryBuilder b)]) = _$BuyerRatingSummary;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BuyerRatingSummaryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BuyerRatingSummary> get serializer => _$BuyerRatingSummarySerializer();
}

class _$BuyerRatingSummarySerializer implements PrimitiveSerializer<BuyerRatingSummary> {
  @override
  final Iterable<Type> types = const [BuyerRatingSummary, _$BuyerRatingSummary];

  @override
  final String wireName = r'BuyerRatingSummary';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BuyerRatingSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'score';
    yield object.score == null ? null : serializers.serialize(
      object.score,
      specifiedType: const FullType.nullable(num),
    );
    yield r'count';
    yield serializers.serialize(
      object.count,
      specifiedType: const FullType(int),
    );
    yield r'minimum_count';
    yield serializers.serialize(
      object.minimumCount,
      specifiedType: const FullType(int),
    );
    yield r'window_days';
    yield serializers.serialize(
      object.windowDays,
      specifiedType: const FullType(int),
    );
    yield r'inquiry_seriousness';
    yield object.inquirySeriousness == null ? null : serializers.serialize(
      object.inquirySeriousness,
      specifiedType: const FullType.nullable(num),
    );
    yield r'communication_quality';
    yield object.communicationQuality == null ? null : serializers.serialize(
      object.communicationQuality,
      specifiedType: const FullType.nullable(num),
    );
    yield r'payment_reliability';
    yield object.paymentReliability == null ? null : serializers.serialize(
      object.paymentReliability,
      specifiedType: const FullType.nullable(num),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    BuyerRatingSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BuyerRatingSummaryBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'score':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.score = valueDes;
          break;
        case r'count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.count = valueDes;
          break;
        case r'minimum_count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.minimumCount = valueDes;
          break;
        case r'window_days':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.windowDays = valueDes;
          break;
        case r'inquiry_seriousness':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.inquirySeriousness = valueDes;
          break;
        case r'communication_quality':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.communicationQuality = valueDes;
          break;
        case r'payment_reliability':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.paymentReliability = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BuyerRatingSummary deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BuyerRatingSummaryBuilder();
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


