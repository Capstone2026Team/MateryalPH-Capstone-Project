//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_review_edit_request.g.dart';

/// VendorReviewEditRequest
///
/// Properties:
/// * [lockVersion]
/// * [inquirySeriousness]
/// * [communicationQuality]
/// * [paymentReliability]
/// * [comment]
@BuiltValue()
abstract class VendorReviewEditRequest implements Built<VendorReviewEditRequest, VendorReviewEditRequestBuilder> {
  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  @BuiltValueField(wireName: r'inquiry_seriousness')
  int? get inquirySeriousness;

  @BuiltValueField(wireName: r'communication_quality')
  int? get communicationQuality;

  @BuiltValueField(wireName: r'payment_reliability')
  int? get paymentReliability;

  @BuiltValueField(wireName: r'comment')
  String? get comment;

  VendorReviewEditRequest._();

  factory VendorReviewEditRequest([void updates(VendorReviewEditRequestBuilder b)]) = _$VendorReviewEditRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorReviewEditRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorReviewEditRequest> get serializer => _$VendorReviewEditRequestSerializer();
}

class _$VendorReviewEditRequestSerializer implements PrimitiveSerializer<VendorReviewEditRequest> {
  @override
  final Iterable<Type> types = const [VendorReviewEditRequest, _$VendorReviewEditRequest];

  @override
  final String wireName = r'VendorReviewEditRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorReviewEditRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
    if (object.inquirySeriousness != null) {
      yield r'inquiry_seriousness';
      yield serializers.serialize(
        object.inquirySeriousness,
        specifiedType: const FullType(int),
      );
    }
    if (object.communicationQuality != null) {
      yield r'communication_quality';
      yield serializers.serialize(
        object.communicationQuality,
        specifiedType: const FullType(int),
      );
    }
    if (object.paymentReliability != null) {
      yield r'payment_reliability';
      yield serializers.serialize(
        object.paymentReliability,
        specifiedType: const FullType(int),
      );
    }
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
    VendorReviewEditRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorReviewEditRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lockVersion = valueDes;
          break;
        case r'inquiry_seriousness':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.inquirySeriousness = valueDes;
          break;
        case r'communication_quality':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.communicationQuality = valueDes;
          break;
        case r'payment_reliability':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
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
  VendorReviewEditRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorReviewEditRequestBuilder();
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


