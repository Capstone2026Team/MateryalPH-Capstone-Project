//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'buyer_cancel_request.g.dart';

/// Withdrawal and cancel-before-payment need no reason; CONFIRMED and PROCESSING need a reason code, and OTHER needs text.
///
/// Properties:
/// * [lockVersion]
/// * [reasonCode]
/// * [reason]
@BuiltValue()
abstract class BuyerCancelRequest implements Built<BuyerCancelRequest, BuyerCancelRequestBuilder> {
  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  @BuiltValueField(wireName: r'reason_code')
  BuyerCancelRequestReasonCodeEnum? get reasonCode;
  // enum reasonCodeEnum {  CHANGE_OF_REQUIREMENT,  DUPLICATE_ORDER,  BUDGET_CHANGE,  PROJECT_DELAY,  SCHEDULE_CONFLICT,  VENDOR_AGREEMENT,  OTHER,  };

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  BuyerCancelRequest._();

  factory BuyerCancelRequest([void updates(BuyerCancelRequestBuilder b)]) = _$BuyerCancelRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BuyerCancelRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BuyerCancelRequest> get serializer => _$BuyerCancelRequestSerializer();
}

class _$BuyerCancelRequestSerializer implements PrimitiveSerializer<BuyerCancelRequest> {
  @override
  final Iterable<Type> types = const [BuyerCancelRequest, _$BuyerCancelRequest];

  @override
  final String wireName = r'BuyerCancelRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BuyerCancelRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
    if (object.reasonCode != null) {
      yield r'reason_code';
      yield serializers.serialize(
        object.reasonCode,
        specifiedType: const FullType(BuyerCancelRequestReasonCodeEnum),
      );
    }
    if (object.reason != null) {
      yield r'reason';
      yield serializers.serialize(
        object.reason,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    BuyerCancelRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BuyerCancelRequestBuilder result,
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
            specifiedType: const FullType.nullable(BuyerCancelRequestReasonCodeEnum),
          ) as BuyerCancelRequestReasonCodeEnum?;
          if (valueDes == null) continue;
          result.reasonCode = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
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
  BuyerCancelRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BuyerCancelRequestBuilder();
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


class BuyerCancelRequestReasonCodeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'CHANGE_OF_REQUIREMENT')
  static const BuyerCancelRequestReasonCodeEnum CHANGE_OF_REQUIREMENT = _$buyerCancelRequestReasonCodeEnum_CHANGE_OF_REQUIREMENT;
  @BuiltValueEnumConst(wireName: r'DUPLICATE_ORDER')
  static const BuyerCancelRequestReasonCodeEnum DUPLICATE_ORDER = _$buyerCancelRequestReasonCodeEnum_DUPLICATE_ORDER;
  @BuiltValueEnumConst(wireName: r'BUDGET_CHANGE')
  static const BuyerCancelRequestReasonCodeEnum BUDGET_CHANGE = _$buyerCancelRequestReasonCodeEnum_BUDGET_CHANGE;
  @BuiltValueEnumConst(wireName: r'PROJECT_DELAY')
  static const BuyerCancelRequestReasonCodeEnum PROJECT_DELAY = _$buyerCancelRequestReasonCodeEnum_PROJECT_DELAY;
  @BuiltValueEnumConst(wireName: r'SCHEDULE_CONFLICT')
  static const BuyerCancelRequestReasonCodeEnum SCHEDULE_CONFLICT = _$buyerCancelRequestReasonCodeEnum_SCHEDULE_CONFLICT;
  @BuiltValueEnumConst(wireName: r'VENDOR_AGREEMENT')
  static const BuyerCancelRequestReasonCodeEnum VENDOR_AGREEMENT = _$buyerCancelRequestReasonCodeEnum_VENDOR_AGREEMENT;
  @BuiltValueEnumConst(wireName: r'OTHER')
  static const BuyerCancelRequestReasonCodeEnum OTHER = _$buyerCancelRequestReasonCodeEnum_OTHER;

  static Serializer<BuyerCancelRequestReasonCodeEnum> get serializer => _$buyerCancelRequestReasonCodeEnumSerializer;

  const BuyerCancelRequestReasonCodeEnum._(String name): super(name);

  static BuiltSet<BuyerCancelRequestReasonCodeEnum> get values => _$buyerCancelRequestReasonCodeEnumValues;
  static BuyerCancelRequestReasonCodeEnum valueOf(String name) => _$buyerCancelRequestReasonCodeEnumValueOf(name);
}

