//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_buyer_rating_request.g.dart';

/// VendorBuyerRatingRequest
///
/// Properties:
/// * [inquirySeriousness]
/// * [communicationQuality]
/// * [paymentReliability]
/// * [comment]
@BuiltValue()
abstract class VendorBuyerRatingRequest implements Built<VendorBuyerRatingRequest, VendorBuyerRatingRequestBuilder> {
  @BuiltValueField(wireName: r'inquiry_seriousness')
  int get inquirySeriousness;

  @BuiltValueField(wireName: r'communication_quality')
  int get communicationQuality;

  @BuiltValueField(wireName: r'payment_reliability')
  int get paymentReliability;

  @BuiltValueField(wireName: r'comment')
  String? get comment;

  VendorBuyerRatingRequest._();

  factory VendorBuyerRatingRequest([void updates(VendorBuyerRatingRequestBuilder b)]) = _$VendorBuyerRatingRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorBuyerRatingRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorBuyerRatingRequest> get serializer => _$VendorBuyerRatingRequestSerializer();
}

class _$VendorBuyerRatingRequestSerializer implements PrimitiveSerializer<VendorBuyerRatingRequest> {
  @override
  final Iterable<Type> types = const [VendorBuyerRatingRequest, _$VendorBuyerRatingRequest];

  @override
  final String wireName = r'VendorBuyerRatingRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorBuyerRatingRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'inquiry_seriousness';
    yield serializers.serialize(
      object.inquirySeriousness,
      specifiedType: const FullType(int),
    );
    yield r'communication_quality';
    yield serializers.serialize(
      object.communicationQuality,
      specifiedType: const FullType(int),
    );
    yield r'payment_reliability';
    yield serializers.serialize(
      object.paymentReliability,
      specifiedType: const FullType(int),
    );
    if (object.comment != null) {
      yield r'comment';
      yield serializers.serialize(
        object.comment,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorBuyerRatingRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorBuyerRatingRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'inquiry_seriousness':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.inquirySeriousness = valueDes;
          break;
        case r'communication_quality':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.communicationQuality = valueDes;
          break;
        case r'payment_reliability':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.paymentReliability = valueDes;
          break;
        case r'comment':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.comment = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorBuyerRatingRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorBuyerRatingRequestBuilder();
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


