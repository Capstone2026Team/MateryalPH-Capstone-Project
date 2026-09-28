//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'radius_km.g.dart';

/// Approved Buyer/Vendor radius allowlist; 5 km is the Buyer default and 50 km the platform maximum.
class RadiusKm extends EnumClass {

  @BuiltValueEnumConst(wireNumber: 5)
  static const RadiusKm number5 = _$number5;
  @BuiltValueEnumConst(wireNumber: 10)
  static const RadiusKm number10 = _$number10;
  @BuiltValueEnumConst(wireNumber: 20)
  static const RadiusKm number20 = _$number20;
  @BuiltValueEnumConst(wireNumber: 30)
  static const RadiusKm number30 = _$number30;
  @BuiltValueEnumConst(wireNumber: 40)
  static const RadiusKm number40 = _$number40;
  @BuiltValueEnumConst(wireNumber: 50)
  static const RadiusKm number50 = _$number50;

  static Serializer<RadiusKm> get serializer => _$radiusKmSerializer;

  const RadiusKm._(String name): super(name);

  static BuiltSet<RadiusKm> get values => _$values;
  static RadiusKm valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class RadiusKmMixin = Object with _$RadiusKmMixin;

