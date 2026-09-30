//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_order_primary_action.g.dart';

class VendorOrderPrimaryAction extends EnumClass {

  @BuiltValueEnumConst(wireName: r'CONFIRM')
  static const VendorOrderPrimaryAction CONFIRM = _$CONFIRM;
  @BuiltValueEnumConst(wireName: r'WAITING_FOR_BUYER')
  static const VendorOrderPrimaryAction WAITING_FOR_BUYER = _$WAITING_FOR_BUYER;
  @BuiltValueEnumConst(wireName: r'WAITING_FOR_PAYMENT')
  static const VendorOrderPrimaryAction WAITING_FOR_PAYMENT = _$WAITING_FOR_PAYMENT;
  @BuiltValueEnumConst(wireName: r'PREPARE_WHEN_AVAILABLE')
  static const VendorOrderPrimaryAction PREPARE_WHEN_AVAILABLE = _$PREPARE_WHEN_AVAILABLE;
  @BuiltValueEnumConst(wireName: r'NONE')
  static const VendorOrderPrimaryAction NONE = _$NONE;

  static Serializer<VendorOrderPrimaryAction> get serializer => _$vendorOrderPrimaryActionSerializer;

  const VendorOrderPrimaryAction._(String name): super(name);

  static BuiltSet<VendorOrderPrimaryAction> get values => _$values;
  static VendorOrderPrimaryAction valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class VendorOrderPrimaryActionMixin = Object with _$VendorOrderPrimaryActionMixin;

