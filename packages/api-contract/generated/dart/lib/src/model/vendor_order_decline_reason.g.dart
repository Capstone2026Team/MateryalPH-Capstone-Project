// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_order_decline_reason.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const VendorOrderDeclineReason _$STOCK_UNAVAILABLE =
    const VendorOrderDeclineReason._('STOCK_UNAVAILABLE');
const VendorOrderDeclineReason _$OPERATIONAL_INABILITY =
    const VendorOrderDeclineReason._('OPERATIONAL_INABILITY');
const VendorOrderDeclineReason _$DELIVERY_INABILITY =
    const VendorOrderDeclineReason._('DELIVERY_INABILITY');
const VendorOrderDeclineReason _$COMPLIANCE_RESTRICTION =
    const VendorOrderDeclineReason._('COMPLIANCE_RESTRICTION');
const VendorOrderDeclineReason _$BUYER_AGREEMENT =
    const VendorOrderDeclineReason._('BUYER_AGREEMENT');
const VendorOrderDeclineReason _$OTHER =
    const VendorOrderDeclineReason._('OTHER');

VendorOrderDeclineReason _$valueOf(String name) {
  switch (name) {
    case 'STOCK_UNAVAILABLE':
      return _$STOCK_UNAVAILABLE;
    case 'OPERATIONAL_INABILITY':
      return _$OPERATIONAL_INABILITY;
    case 'DELIVERY_INABILITY':
      return _$DELIVERY_INABILITY;
    case 'COMPLIANCE_RESTRICTION':
      return _$COMPLIANCE_RESTRICTION;
    case 'BUYER_AGREEMENT':
      return _$BUYER_AGREEMENT;
    case 'OTHER':
      return _$OTHER;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<VendorOrderDeclineReason> _$values =
    BuiltSet<VendorOrderDeclineReason>(const <VendorOrderDeclineReason>[
  _$STOCK_UNAVAILABLE,
  _$OPERATIONAL_INABILITY,
  _$DELIVERY_INABILITY,
  _$COMPLIANCE_RESTRICTION,
  _$BUYER_AGREEMENT,
  _$OTHER,
]);

class _$VendorOrderDeclineReasonMeta {
  const _$VendorOrderDeclineReasonMeta();
  VendorOrderDeclineReason get STOCK_UNAVAILABLE => _$STOCK_UNAVAILABLE;
  VendorOrderDeclineReason get OPERATIONAL_INABILITY => _$OPERATIONAL_INABILITY;
  VendorOrderDeclineReason get DELIVERY_INABILITY => _$DELIVERY_INABILITY;
  VendorOrderDeclineReason get COMPLIANCE_RESTRICTION =>
      _$COMPLIANCE_RESTRICTION;
  VendorOrderDeclineReason get BUYER_AGREEMENT => _$BUYER_AGREEMENT;
  VendorOrderDeclineReason get OTHER => _$OTHER;
  VendorOrderDeclineReason valueOf(String name) => _$valueOf(name);
  BuiltSet<VendorOrderDeclineReason> get values => _$values;
}

abstract class _$VendorOrderDeclineReasonMixin {
  // ignore: non_constant_identifier_names
  _$VendorOrderDeclineReasonMeta get VendorOrderDeclineReason =>
      const _$VendorOrderDeclineReasonMeta();
}

Serializer<VendorOrderDeclineReason> _$vendorOrderDeclineReasonSerializer =
    _$VendorOrderDeclineReasonSerializer();

class _$VendorOrderDeclineReasonSerializer
    implements PrimitiveSerializer<VendorOrderDeclineReason> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'STOCK_UNAVAILABLE': 'STOCK_UNAVAILABLE',
    'OPERATIONAL_INABILITY': 'OPERATIONAL_INABILITY',
    'DELIVERY_INABILITY': 'DELIVERY_INABILITY',
    'COMPLIANCE_RESTRICTION': 'COMPLIANCE_RESTRICTION',
    'BUYER_AGREEMENT': 'BUYER_AGREEMENT',
    'OTHER': 'OTHER',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'STOCK_UNAVAILABLE': 'STOCK_UNAVAILABLE',
    'OPERATIONAL_INABILITY': 'OPERATIONAL_INABILITY',
    'DELIVERY_INABILITY': 'DELIVERY_INABILITY',
    'COMPLIANCE_RESTRICTION': 'COMPLIANCE_RESTRICTION',
    'BUYER_AGREEMENT': 'BUYER_AGREEMENT',
    'OTHER': 'OTHER',
  };

  @override
  final Iterable<Type> types = const <Type>[VendorOrderDeclineReason];
  @override
  final String wireName = 'VendorOrderDeclineReason';

  @override
  Object serialize(Serializers serializers, VendorOrderDeclineReason object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  VendorOrderDeclineReason deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      VendorOrderDeclineReason.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
