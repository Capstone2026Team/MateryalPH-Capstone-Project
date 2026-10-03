//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_cancel_request.g.dart';

/// VendorCancelRequest
///
/// Properties:
/// * [lockVersion]
/// * [reasonCode]
/// * [reason]
@BuiltValue()
abstract class VendorCancelRequest implements Built<VendorCancelRequest, VendorCancelRequestBuilder> {
  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  @BuiltValueField(wireName: r'reason_code')
  VendorCancelRequestReasonCodeEnum get reasonCode;
  // enum reasonCodeEnum {  STOCK_FAILURE,  OPERATIONAL_INABILITY,  DELIVERY_INABILITY,  COMPLIANCE_RESTRICTION,  ACCOUNT_RESTRICTION,  BUYER_AGREEMENT,  OTHER,  };

  @BuiltValueField(wireName: r'reason')
  String get reason;

  VendorCancelRequest._();

  factory VendorCancelRequest([void updates(VendorCancelRequestBuilder b)]) = _$VendorCancelRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorCancelRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorCancelRequest> get serializer => _$VendorCancelRequestSerializer();
}

class _$VendorCancelRequestSerializer implements PrimitiveSerializer<VendorCancelRequest> {
  @override
  final Iterable<Type> types = const [VendorCancelRequest, _$VendorCancelRequest];

  @override
  final String wireName = r'VendorCancelRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorCancelRequest object, {
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
      specifiedType: const FullType(VendorCancelRequestReasonCodeEnum),
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
    VendorCancelRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorCancelRequestBuilder result,
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
            specifiedType: const FullType(VendorCancelRequestReasonCodeEnum),
          ) as VendorCancelRequestReasonCodeEnum;
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
  VendorCancelRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorCancelRequestBuilder();
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


class VendorCancelRequestReasonCodeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'STOCK_FAILURE')
  static const VendorCancelRequestReasonCodeEnum STOCK_FAILURE = _$vendorCancelRequestReasonCodeEnum_STOCK_FAILURE;
  @BuiltValueEnumConst(wireName: r'OPERATIONAL_INABILITY')
  static const VendorCancelRequestReasonCodeEnum OPERATIONAL_INABILITY = _$vendorCancelRequestReasonCodeEnum_OPERATIONAL_INABILITY;
  @BuiltValueEnumConst(wireName: r'DELIVERY_INABILITY')
  static const VendorCancelRequestReasonCodeEnum DELIVERY_INABILITY = _$vendorCancelRequestReasonCodeEnum_DELIVERY_INABILITY;
  @BuiltValueEnumConst(wireName: r'COMPLIANCE_RESTRICTION')
  static const VendorCancelRequestReasonCodeEnum COMPLIANCE_RESTRICTION = _$vendorCancelRequestReasonCodeEnum_COMPLIANCE_RESTRICTION;
  @BuiltValueEnumConst(wireName: r'ACCOUNT_RESTRICTION')
  static const VendorCancelRequestReasonCodeEnum ACCOUNT_RESTRICTION = _$vendorCancelRequestReasonCodeEnum_ACCOUNT_RESTRICTION;
  @BuiltValueEnumConst(wireName: r'BUYER_AGREEMENT')
  static const VendorCancelRequestReasonCodeEnum BUYER_AGREEMENT = _$vendorCancelRequestReasonCodeEnum_BUYER_AGREEMENT;
  @BuiltValueEnumConst(wireName: r'OTHER')
  static const VendorCancelRequestReasonCodeEnum OTHER = _$vendorCancelRequestReasonCodeEnum_OTHER;

  static Serializer<VendorCancelRequestReasonCodeEnum> get serializer => _$vendorCancelRequestReasonCodeEnumSerializer;

  const VendorCancelRequestReasonCodeEnum._(String name): super(name);

  static BuiltSet<VendorCancelRequestReasonCodeEnum> get values => _$vendorCancelRequestReasonCodeEnumValues;
  static VendorCancelRequestReasonCodeEnum valueOf(String name) => _$vendorCancelRequestReasonCodeEnumValueOf(name);
}

