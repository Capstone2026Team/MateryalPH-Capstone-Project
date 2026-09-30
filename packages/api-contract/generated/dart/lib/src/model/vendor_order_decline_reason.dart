//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_order_decline_reason.g.dart';

class VendorOrderDeclineReason extends EnumClass {

  @BuiltValueEnumConst(wireName: r'STOCK_UNAVAILABLE')
  static const VendorOrderDeclineReason STOCK_UNAVAILABLE = _$STOCK_UNAVAILABLE;
  @BuiltValueEnumConst(wireName: r'OPERATIONAL_INABILITY')
  static const VendorOrderDeclineReason OPERATIONAL_INABILITY = _$OPERATIONAL_INABILITY;
  @BuiltValueEnumConst(wireName: r'DELIVERY_INABILITY')
  static const VendorOrderDeclineReason DELIVERY_INABILITY = _$DELIVERY_INABILITY;
  @BuiltValueEnumConst(wireName: r'COMPLIANCE_RESTRICTION')
  static const VendorOrderDeclineReason COMPLIANCE_RESTRICTION = _$COMPLIANCE_RESTRICTION;
  @BuiltValueEnumConst(wireName: r'BUYER_AGREEMENT')
  static const VendorOrderDeclineReason BUYER_AGREEMENT = _$BUYER_AGREEMENT;
  @BuiltValueEnumConst(wireName: r'OTHER')
  static const VendorOrderDeclineReason OTHER = _$OTHER;

  static Serializer<VendorOrderDeclineReason> get serializer => _$vendorOrderDeclineReasonSerializer;

  const VendorOrderDeclineReason._(String name): super(name);

  static BuiltSet<VendorOrderDeclineReason> get values => _$values;
  static VendorOrderDeclineReason valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class VendorOrderDeclineReasonMixin = Object with _$VendorOrderDeclineReasonMixin;

