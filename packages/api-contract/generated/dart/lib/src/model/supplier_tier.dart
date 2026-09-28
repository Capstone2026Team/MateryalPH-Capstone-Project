//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'supplier_tier.g.dart';

class SupplierTier extends EnumClass {

  @BuiltValueEnumConst(wireName: r'VERIFIED_VENDOR')
  static const SupplierTier VERIFIED_VENDOR = _$VERIFIED_VENDOR;
  @BuiltValueEnumConst(wireName: r'DIRECTORY_SUPPLIER')
  static const SupplierTier DIRECTORY_SUPPLIER = _$DIRECTORY_SUPPLIER;

  static Serializer<SupplierTier> get serializer => _$supplierTierSerializer;

  const SupplierTier._(String name): super(name);

  static BuiltSet<SupplierTier> get values => _$values;
  static SupplierTier valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class SupplierTierMixin = Object with _$SupplierTierMixin;

