//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/cancellation_remedy.dart';
import 'package:materyalph_api_client/src/model/vendor_cancellation_request_ref.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'order_cancellation.g.dart';

/// Buyer responses carry mode, availability, reason codes and remedies; Vendor responses carry the explanation, Vendor reason codes and any open Buyer request. Unavailability is always explained in text.
///
/// Properties:
/// * [mode]
/// * [available]
/// * [explanation]
/// * [requiresReason]
/// * [reasonCodes]
/// * [nrpcRetainableCentavos]
/// * [canWithdrawRequest]
/// * [responseDueAt]
/// * [remedies]
/// * [openRequest]
@BuiltValue()
abstract class OrderCancellation implements Built<OrderCancellation, OrderCancellationBuilder> {
  @BuiltValueField(wireName: r'mode')
  OrderCancellationModeEnum? get mode;
  // enum modeEnum {  WITHDRAW,  USE_REJECT,  CANCEL_BEFORE_PAYMENT,  CANCEL_NOW,  REQUEST,  REQUEST_OPEN,  UNAVAILABLE,  CLOSED,  };

  @BuiltValueField(wireName: r'available')
  bool? get available;

  @BuiltValueField(wireName: r'explanation')
  String get explanation;

  @BuiltValueField(wireName: r'requires_reason')
  bool? get requiresReason;

  @BuiltValueField(wireName: r'reason_codes')
  BuiltList<String>? get reasonCodes;

  @BuiltValueField(wireName: r'nrpc_retainable_centavos')
  int? get nrpcRetainableCentavos;

  @BuiltValueField(wireName: r'can_withdraw_request')
  bool? get canWithdrawRequest;

  @BuiltValueField(wireName: r'response_due_at')
  DateTime? get responseDueAt;

  @BuiltValueField(wireName: r'remedies')
  BuiltList<CancellationRemedy>? get remedies;

  @BuiltValueField(wireName: r'open_request')
  VendorCancellationRequestRef? get openRequest;

  OrderCancellation._();

  factory OrderCancellation([void updates(OrderCancellationBuilder b)]) = _$OrderCancellation;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OrderCancellationBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OrderCancellation> get serializer => _$OrderCancellationSerializer();
}

class _$OrderCancellationSerializer implements PrimitiveSerializer<OrderCancellation> {
  @override
  final Iterable<Type> types = const [OrderCancellation, _$OrderCancellation];

  @override
  final String wireName = r'OrderCancellation';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OrderCancellation object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.mode != null) {
      yield r'mode';
      yield serializers.serialize(
        object.mode,
        specifiedType: const FullType(OrderCancellationModeEnum),
      );
    }
    if (object.available != null) {
      yield r'available';
      yield serializers.serialize(
        object.available,
        specifiedType: const FullType(bool),
      );
    }
    yield r'explanation';
    yield serializers.serialize(
      object.explanation,
      specifiedType: const FullType(String),
    );
    if (object.requiresReason != null) {
      yield r'requires_reason';
      yield serializers.serialize(
        object.requiresReason,
        specifiedType: const FullType(bool),
      );
    }
    if (object.reasonCodes != null) {
      yield r'reason_codes';
      yield serializers.serialize(
        object.reasonCodes,
        specifiedType: const FullType(BuiltList, [FullType(String)]),
      );
    }
    if (object.nrpcRetainableCentavos != null) {
      yield r'nrpc_retainable_centavos';
      yield serializers.serialize(
        object.nrpcRetainableCentavos,
        specifiedType: const FullType(int),
      );
    }
    if (object.canWithdrawRequest != null) {
      yield r'can_withdraw_request';
      yield serializers.serialize(
        object.canWithdrawRequest,
        specifiedType: const FullType(bool),
      );
    }
    if (object.responseDueAt != null) {
      yield r'response_due_at';
      yield serializers.serialize(
        object.responseDueAt,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.remedies != null) {
      yield r'remedies';
      yield serializers.serialize(
        object.remedies,
        specifiedType: const FullType(BuiltList, [FullType(CancellationRemedy)]),
      );
    }
    if (object.openRequest != null) {
      yield r'open_request';
      yield serializers.serialize(
        object.openRequest,
        specifiedType: const FullType.nullable(VendorCancellationRequestRef),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    OrderCancellation object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OrderCancellationBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'mode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(OrderCancellationModeEnum),
          ) as OrderCancellationModeEnum?;
          if (valueDes == null) continue;
          result.mode = valueDes;
          break;
        case r'available':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.available = valueDes;
          break;
        case r'explanation':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.explanation = valueDes;
          break;
        case r'requires_reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.requiresReason = valueDes;
          break;
        case r'reason_codes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(String)]),
          ) as BuiltList<String>?;
          if (valueDes == null) continue;
          result.reasonCodes.replace(valueDes);
          break;
        case r'nrpc_retainable_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.nrpcRetainableCentavos = valueDes;
          break;
        case r'can_withdraw_request':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.canWithdrawRequest = valueDes;
          break;
        case r'response_due_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.responseDueAt = valueDes;
          break;
        case r'remedies':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(CancellationRemedy)]),
          ) as BuiltList<CancellationRemedy>?;
          if (valueDes == null) continue;
          result.remedies.replace(valueDes);
          break;
        case r'open_request':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(VendorCancellationRequestRef),
          ) as VendorCancellationRequestRef?;
          if (valueDes == null) continue;
          result.openRequest.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  OrderCancellation deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OrderCancellationBuilder();
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


class OrderCancellationModeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'WITHDRAW')
  static const OrderCancellationModeEnum WITHDRAW = _$orderCancellationModeEnum_WITHDRAW;
  @BuiltValueEnumConst(wireName: r'USE_REJECT')
  static const OrderCancellationModeEnum USE_REJECT = _$orderCancellationModeEnum_USE_REJECT;
  @BuiltValueEnumConst(wireName: r'CANCEL_BEFORE_PAYMENT')
  static const OrderCancellationModeEnum CANCEL_BEFORE_PAYMENT = _$orderCancellationModeEnum_CANCEL_BEFORE_PAYMENT;
  @BuiltValueEnumConst(wireName: r'CANCEL_NOW')
  static const OrderCancellationModeEnum CANCEL_NOW = _$orderCancellationModeEnum_CANCEL_NOW;
  @BuiltValueEnumConst(wireName: r'REQUEST')
  static const OrderCancellationModeEnum REQUEST = _$orderCancellationModeEnum_REQUEST;
  @BuiltValueEnumConst(wireName: r'REQUEST_OPEN')
  static const OrderCancellationModeEnum REQUEST_OPEN = _$orderCancellationModeEnum_REQUEST_OPEN;
  @BuiltValueEnumConst(wireName: r'UNAVAILABLE')
  static const OrderCancellationModeEnum UNAVAILABLE = _$orderCancellationModeEnum_UNAVAILABLE;
  @BuiltValueEnumConst(wireName: r'CLOSED')
  static const OrderCancellationModeEnum CLOSED = _$orderCancellationModeEnum_CLOSED;

  static Serializer<OrderCancellationModeEnum> get serializer => _$orderCancellationModeEnumSerializer;

  const OrderCancellationModeEnum._(String name): super(name);

  static BuiltSet<OrderCancellationModeEnum> get values => _$orderCancellationModeEnumValues;
  static OrderCancellationModeEnum valueOf(String name) => _$orderCancellationModeEnumValueOf(name);
}

