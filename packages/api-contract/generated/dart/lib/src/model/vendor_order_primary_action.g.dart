// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_order_primary_action.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const VendorOrderPrimaryAction _$CONFIRM =
    const VendorOrderPrimaryAction._('CONFIRM');
const VendorOrderPrimaryAction _$WAITING_FOR_BUYER =
    const VendorOrderPrimaryAction._('WAITING_FOR_BUYER');
const VendorOrderPrimaryAction _$WAITING_FOR_PAYMENT =
    const VendorOrderPrimaryAction._('WAITING_FOR_PAYMENT');
const VendorOrderPrimaryAction _$PREPARE_WHEN_AVAILABLE =
    const VendorOrderPrimaryAction._('PREPARE_WHEN_AVAILABLE');
const VendorOrderPrimaryAction _$NONE =
    const VendorOrderPrimaryAction._('NONE');

VendorOrderPrimaryAction _$valueOf(String name) {
  switch (name) {
    case 'CONFIRM':
      return _$CONFIRM;
    case 'WAITING_FOR_BUYER':
      return _$WAITING_FOR_BUYER;
    case 'WAITING_FOR_PAYMENT':
      return _$WAITING_FOR_PAYMENT;
    case 'PREPARE_WHEN_AVAILABLE':
      return _$PREPARE_WHEN_AVAILABLE;
    case 'NONE':
      return _$NONE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<VendorOrderPrimaryAction> _$values =
    BuiltSet<VendorOrderPrimaryAction>(const <VendorOrderPrimaryAction>[
  _$CONFIRM,
  _$WAITING_FOR_BUYER,
  _$WAITING_FOR_PAYMENT,
  _$PREPARE_WHEN_AVAILABLE,
  _$NONE,
]);

class _$VendorOrderPrimaryActionMeta {
  const _$VendorOrderPrimaryActionMeta();
  VendorOrderPrimaryAction get CONFIRM => _$CONFIRM;
  VendorOrderPrimaryAction get WAITING_FOR_BUYER => _$WAITING_FOR_BUYER;
  VendorOrderPrimaryAction get WAITING_FOR_PAYMENT => _$WAITING_FOR_PAYMENT;
  VendorOrderPrimaryAction get PREPARE_WHEN_AVAILABLE =>
      _$PREPARE_WHEN_AVAILABLE;
  VendorOrderPrimaryAction get NONE => _$NONE;
  VendorOrderPrimaryAction valueOf(String name) => _$valueOf(name);
  BuiltSet<VendorOrderPrimaryAction> get values => _$values;
}

abstract class _$VendorOrderPrimaryActionMixin {
  // ignore: non_constant_identifier_names
  _$VendorOrderPrimaryActionMeta get VendorOrderPrimaryAction =>
      const _$VendorOrderPrimaryActionMeta();
}

Serializer<VendorOrderPrimaryAction> _$vendorOrderPrimaryActionSerializer =
    _$VendorOrderPrimaryActionSerializer();

class _$VendorOrderPrimaryActionSerializer
    implements PrimitiveSerializer<VendorOrderPrimaryAction> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'CONFIRM': 'CONFIRM',
    'WAITING_FOR_BUYER': 'WAITING_FOR_BUYER',
    'WAITING_FOR_PAYMENT': 'WAITING_FOR_PAYMENT',
    'PREPARE_WHEN_AVAILABLE': 'PREPARE_WHEN_AVAILABLE',
    'NONE': 'NONE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'CONFIRM': 'CONFIRM',
    'WAITING_FOR_BUYER': 'WAITING_FOR_BUYER',
    'WAITING_FOR_PAYMENT': 'WAITING_FOR_PAYMENT',
    'PREPARE_WHEN_AVAILABLE': 'PREPARE_WHEN_AVAILABLE',
    'NONE': 'NONE',
  };

  @override
  final Iterable<Type> types = const <Type>[VendorOrderPrimaryAction];
  @override
  final String wireName = 'VendorOrderPrimaryAction';

  @override
  Object serialize(Serializers serializers, VendorOrderPrimaryAction object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  VendorOrderPrimaryAction deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      VendorOrderPrimaryAction.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
