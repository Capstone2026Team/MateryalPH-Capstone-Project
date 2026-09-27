//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'tax_category.g.dart';

/// FIN-02 line classification. Zero-rated and exempt lines require a tax basis.
class TaxCategory extends EnumClass {

  @BuiltValueEnumConst(wireName: r'VAT_12')
  static const TaxCategory VAT_12 = _$VAT_12;
  @BuiltValueEnumConst(wireName: r'VAT_ZERO')
  static const TaxCategory VAT_ZERO = _$VAT_ZERO;
  @BuiltValueEnumConst(wireName: r'VAT_EXEMPT')
  static const TaxCategory VAT_EXEMPT = _$VAT_EXEMPT;
  @BuiltValueEnumConst(wireName: r'NON_VAT')
  static const TaxCategory NON_VAT = _$NON_VAT;

  static Serializer<TaxCategory> get serializer => _$taxCategorySerializer;

  const TaxCategory._(String name): super(name);

  static BuiltSet<TaxCategory> get values => _$values;
  static TaxCategory valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class TaxCategoryMixin = Object with _$TaxCategoryMixin;

