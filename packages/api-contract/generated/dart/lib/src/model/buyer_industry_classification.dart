//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'buyer_industry_classification.g.dart';

/// Approved by the project owner on 2026-09-28.
class BuyerIndustryClassification extends EnumClass {

  @BuiltValueEnumConst(wireName: r'GENERAL_CONTRACTOR')
  static const BuyerIndustryClassification GENERAL_CONTRACTOR = _$GENERAL_CONTRACTOR;
  @BuiltValueEnumConst(wireName: r'SUBCONTRACTOR_TRADE')
  static const BuyerIndustryClassification SUBCONTRACTOR_TRADE = _$SUBCONTRACTOR_TRADE;
  @BuiltValueEnumConst(wireName: r'INDEPENDENT_BUILDER')
  static const BuyerIndustryClassification INDEPENDENT_BUILDER = _$INDEPENDENT_BUILDER;
  @BuiltValueEnumConst(wireName: r'DIY_HOMEOWNER')
  static const BuyerIndustryClassification DIY_HOMEOWNER = _$DIY_HOMEOWNER;
  @BuiltValueEnumConst(wireName: r'OTHER')
  static const BuyerIndustryClassification OTHER = _$OTHER;

  static Serializer<BuyerIndustryClassification> get serializer => _$buyerIndustryClassificationSerializer;

  const BuyerIndustryClassification._(String name): super(name);

  static BuiltSet<BuyerIndustryClassification> get values => _$values;
  static BuyerIndustryClassification valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class BuyerIndustryClassificationMixin = Object with _$BuyerIndustryClassificationMixin;

