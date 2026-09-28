// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supplier_tier.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const SupplierTier _$VERIFIED_VENDOR = const SupplierTier._('VERIFIED_VENDOR');
const SupplierTier _$DIRECTORY_SUPPLIER =
    const SupplierTier._('DIRECTORY_SUPPLIER');

SupplierTier _$valueOf(String name) {
  switch (name) {
    case 'VERIFIED_VENDOR':
      return _$VERIFIED_VENDOR;
    case 'DIRECTORY_SUPPLIER':
      return _$DIRECTORY_SUPPLIER;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<SupplierTier> _$values =
    BuiltSet<SupplierTier>(const <SupplierTier>[
  _$VERIFIED_VENDOR,
  _$DIRECTORY_SUPPLIER,
]);

class _$SupplierTierMeta {
  const _$SupplierTierMeta();
  SupplierTier get VERIFIED_VENDOR => _$VERIFIED_VENDOR;
  SupplierTier get DIRECTORY_SUPPLIER => _$DIRECTORY_SUPPLIER;
  SupplierTier valueOf(String name) => _$valueOf(name);
  BuiltSet<SupplierTier> get values => _$values;
}

abstract class _$SupplierTierMixin {
  // ignore: non_constant_identifier_names
  _$SupplierTierMeta get SupplierTier => const _$SupplierTierMeta();
}

Serializer<SupplierTier> _$supplierTierSerializer = _$SupplierTierSerializer();

class _$SupplierTierSerializer implements PrimitiveSerializer<SupplierTier> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'VERIFIED_VENDOR': 'VERIFIED_VENDOR',
    'DIRECTORY_SUPPLIER': 'DIRECTORY_SUPPLIER',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'VERIFIED_VENDOR': 'VERIFIED_VENDOR',
    'DIRECTORY_SUPPLIER': 'DIRECTORY_SUPPLIER',
  };

  @override
  final Iterable<Type> types = const <Type>[SupplierTier];
  @override
  final String wireName = 'SupplierTier';

  @override
  Object serialize(Serializers serializers, SupplierTier object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  SupplierTier deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      SupplierTier.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
