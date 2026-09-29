//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'checkout_preview_request.g.dart';

/// CheckoutPreviewRequest
///
/// Properties:
/// * [requestVersion] - Echoed so the client discards stale previews.
@BuiltValue()
abstract class CheckoutPreviewRequest implements Built<CheckoutPreviewRequest, CheckoutPreviewRequestBuilder> {
  /// Echoed so the client discards stale previews.
  @BuiltValueField(wireName: r'request_version')
  String? get requestVersion;

  CheckoutPreviewRequest._();

  factory CheckoutPreviewRequest([void updates(CheckoutPreviewRequestBuilder b)]) = _$CheckoutPreviewRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CheckoutPreviewRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CheckoutPreviewRequest> get serializer => _$CheckoutPreviewRequestSerializer();
}

class _$CheckoutPreviewRequestSerializer implements PrimitiveSerializer<CheckoutPreviewRequest> {
  @override
  final Iterable<Type> types = const [CheckoutPreviewRequest, _$CheckoutPreviewRequest];

  @override
  final String wireName = r'CheckoutPreviewRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CheckoutPreviewRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.requestVersion != null) {
      yield r'request_version';
      yield serializers.serialize(
        object.requestVersion,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CheckoutPreviewRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CheckoutPreviewRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'request_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.requestVersion = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CheckoutPreviewRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CheckoutPreviewRequestBuilder();
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


