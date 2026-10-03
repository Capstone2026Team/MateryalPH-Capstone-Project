//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'order_payment_state.g.dart';

class OrderPaymentState extends EnumClass {

  @BuiltValueEnumConst(wireName: r'NOT_REQUIRED')
  static const OrderPaymentState NOT_REQUIRED = _$NOT_REQUIRED;
  @BuiltValueEnumConst(wireName: r'PENDING')
  static const OrderPaymentState PENDING = _$PENDING;
  @BuiltValueEnumConst(wireName: r'PAID')
  static const OrderPaymentState PAID = _$PAID;
  @BuiltValueEnumConst(wireName: r'FAILED')
  static const OrderPaymentState FAILED = _$FAILED;
  @BuiltValueEnumConst(wireName: r'EXPIRED')
  static const OrderPaymentState EXPIRED = _$EXPIRED;

  static Serializer<OrderPaymentState> get serializer => _$orderPaymentStateSerializer;

  const OrderPaymentState._(String name): super(name);

  static BuiltSet<OrderPaymentState> get values => _$values;
  static OrderPaymentState valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class OrderPaymentStateMixin = Object with _$OrderPaymentStateMixin;

