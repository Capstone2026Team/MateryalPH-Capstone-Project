//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'directory_buyer_profile_ratings_received.g.dart';

/// DirectoryBuyerProfileRatingsReceived
///
/// Properties:
/// * [count]
/// * [inquirySeriousness]
/// * [communicationQuality]
/// * [paymentReliability]
@BuiltValue()
abstract class DirectoryBuyerProfileRatingsReceived implements Built<DirectoryBuyerProfileRatingsReceived, DirectoryBuyerProfileRatingsReceivedBuilder> {
  @BuiltValueField(wireName: r'count')
  int get count;

  @BuiltValueField(wireName: r'inquiry_seriousness')
  String? get inquirySeriousness;

  @BuiltValueField(wireName: r'communication_quality')
  String? get communicationQuality;

  @BuiltValueField(wireName: r'payment_reliability')
  String? get paymentReliability;

  DirectoryBuyerProfileRatingsReceived._();

  factory DirectoryBuyerProfileRatingsReceived([void updates(DirectoryBuyerProfileRatingsReceivedBuilder b)]) = _$DirectoryBuyerProfileRatingsReceived;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DirectoryBuyerProfileRatingsReceivedBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DirectoryBuyerProfileRatingsReceived> get serializer => _$DirectoryBuyerProfileRatingsReceivedSerializer();
}

class _$DirectoryBuyerProfileRatingsReceivedSerializer implements PrimitiveSerializer<DirectoryBuyerProfileRatingsReceived> {
  @override
  final Iterable<Type> types = const [DirectoryBuyerProfileRatingsReceived, _$DirectoryBuyerProfileRatingsReceived];

  @override
  final String wireName = r'DirectoryBuyerProfileRatingsReceived';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DirectoryBuyerProfileRatingsReceived object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'count';
    yield serializers.serialize(
      object.count,
      specifiedType: const FullType(int),
    );
    yield r'inquiry_seriousness';
    yield object.inquirySeriousness == null ? null : serializers.serialize(
      object.inquirySeriousness,
      specifiedType: const FullType.nullable(String),
    );
    yield r'communication_quality';
    yield object.communicationQuality == null ? null : serializers.serialize(
      object.communicationQuality,
      specifiedType: const FullType.nullable(String),
    );
    yield r'payment_reliability';
    yield object.paymentReliability == null ? null : serializers.serialize(
      object.paymentReliability,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DirectoryBuyerProfileRatingsReceived object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DirectoryBuyerProfileRatingsReceivedBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.count = valueDes;
          break;
        case r'inquiry_seriousness':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.inquirySeriousness = valueDes;
          break;
        case r'communication_quality':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.communicationQuality = valueDes;
          break;
        case r'payment_reliability':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
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
  DirectoryBuyerProfileRatingsReceived deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DirectoryBuyerProfileRatingsReceivedBuilder();
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


