//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'order_state.g.dart';

class OrderState extends EnumClass {

  @BuiltValueEnumConst(wireName: r'AWAITING_VENDOR_CONFIRMATION')
  static const OrderState AWAITING_VENDOR_CONFIRMATION = _$AWAITING_VENDOR_CONFIRMATION;
  @BuiltValueEnumConst(wireName: r'AWAITING_BUYER_APPROVAL')
  static const OrderState AWAITING_BUYER_APPROVAL = _$AWAITING_BUYER_APPROVAL;
  @BuiltValueEnumConst(wireName: r'AWAITING_NRPC_ACCEPTANCE')
  static const OrderState AWAITING_NRPC_ACCEPTANCE = _$AWAITING_NRPC_ACCEPTANCE;
  @BuiltValueEnumConst(wireName: r'AWAITING_PAYMENT')
  static const OrderState AWAITING_PAYMENT = _$AWAITING_PAYMENT;
  @BuiltValueEnumConst(wireName: r'CONFIRMED')
  static const OrderState CONFIRMED = _$CONFIRMED;
  @BuiltValueEnumConst(wireName: r'PROCESSING')
  static const OrderState PROCESSING = _$PROCESSING;
  @BuiltValueEnumConst(wireName: r'READY_FOR_PICKUP')
  static const OrderState READY_FOR_PICKUP = _$READY_FOR_PICKUP;
  @BuiltValueEnumConst(wireName: r'OUT_FOR_DELIVERY')
  static const OrderState OUT_FOR_DELIVERY = _$OUT_FOR_DELIVERY;
  @BuiltValueEnumConst(wireName: r'DELIVERED')
  static const OrderState DELIVERED = _$DELIVERED;
  @BuiltValueEnumConst(wireName: r'PICKED_UP')
  static const OrderState PICKED_UP = _$PICKED_UP;
  @BuiltValueEnumConst(wireName: r'COMPLETED')
  static const OrderState COMPLETED = _$COMPLETED;
  @BuiltValueEnumConst(wireName: r'CANCELLATION_REQUESTED')
  static const OrderState CANCELLATION_REQUESTED = _$CANCELLATION_REQUESTED;
  @BuiltValueEnumConst(wireName: r'DECLINED')
  static const OrderState DECLINED = _$DECLINED;
  @BuiltValueEnumConst(wireName: r'EXPIRED')
  static const OrderState EXPIRED = _$EXPIRED;
  @BuiltValueEnumConst(wireName: r'CANCELLED')
  static const OrderState CANCELLED = _$CANCELLED;
  @BuiltValueEnumConst(wireName: r'DISPUTED')
  static const OrderState DISPUTED = _$DISPUTED;

  static Serializer<OrderState> get serializer => _$orderStateSerializer;

  const OrderState._(String name): super(name);

  static BuiltSet<OrderState> get values => _$values;
  static OrderState valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class OrderStateMixin = Object with _$OrderStateMixin;

