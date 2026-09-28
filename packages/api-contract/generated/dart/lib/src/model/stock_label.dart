//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'stock_label.g.dart';

/// The only stock vocabulary a Buyer receives. OUT_OF_STOCK when available_to_sell is zero or less; LIMITED_STOCK when available_to_sell is at or below the Vendor reorder level; IN_STOCK otherwise.
class StockLabel extends EnumClass {

  @BuiltValueEnumConst(wireName: r'IN_STOCK')
  static const StockLabel IN_STOCK = _$IN_STOCK;
  @BuiltValueEnumConst(wireName: r'LIMITED_STOCK')
  static const StockLabel LIMITED_STOCK = _$LIMITED_STOCK;
  @BuiltValueEnumConst(wireName: r'OUT_OF_STOCK')
  static const StockLabel OUT_OF_STOCK = _$OUT_OF_STOCK;

  static Serializer<StockLabel> get serializer => _$stockLabelSerializer;

  const StockLabel._(String name): super(name);

  static BuiltSet<StockLabel> get values => _$values;
  static StockLabel valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class StockLabelMixin = Object with _$StockLabelMixin;

