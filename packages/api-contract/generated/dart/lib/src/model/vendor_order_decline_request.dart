//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/vendor_order_decline_reason.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_order_decline_request.g.dart';

/// VendorOrderDeclineRequest
///
/// Properties:
/// * [lockVersion]
/// * [reasonCode]
/// * [reason]
@BuiltValue()
abstract class VendorOrderDeclineRequest implements Built<VendorOrderDeclineRequest, VendorOrderDeclineRequestBuilder> {
  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  @BuiltValueField(wireName: r'reason_code')
  VendorOrderDeclineReason get reasonCode;
  // enum reasonCodeEnum {  STOCK_UNAVAILABLE,  OPERATIONAL_INABILITY,  DELIVERY_INABILITY,  COMPLIANCE_RESTRICTION,  BUYER_AGREEMENT,  OTHER,  };

  @BuiltValueField(wireName: r'reason')
  String get reason;

  VendorOrderDeclineRequest._();

  factory VendorOrderDeclineRequest([void updates(VendorOrderDeclineRequestBuilder b)]) = _$VendorOrderDeclineRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorOrderDeclineRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorOrderDeclineRequest> get serializer => _$VendorOrderDeclineRequestSerializer();
}

class _$VendorOrderDeclineRequestSerializer implements PrimitiveSerializer<VendorOrderDeclineRequest> {
  @override
  final Iterable<Type> types = const [VendorOrderDeclineRequest, _$VendorOrderDeclineRequest];

  @override
  final String wireName = r'VendorOrderDeclineRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorOrderDeclineRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
    yield r'reason_code';
    yield serializers.serialize(
      object.reasonCode,
      specifiedType: const FullType(VendorOrderDeclineReason),
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
    VendorOrderDeclineRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorOrderDeclineRequestBuilder result,
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
        case r'reason_code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorOrderDeclineReason),
          ) as VendorOrderDeclineReason;
          result.reasonCode = valueDes;
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
  VendorOrderDeclineRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorOrderDeclineRequestBuilder();
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


