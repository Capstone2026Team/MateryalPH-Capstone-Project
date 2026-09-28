// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buyer_industry_classification.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const BuyerIndustryClassification _$GENERAL_CONTRACTOR =
    const BuyerIndustryClassification._('GENERAL_CONTRACTOR');
const BuyerIndustryClassification _$SUBCONTRACTOR_TRADE =
    const BuyerIndustryClassification._('SUBCONTRACTOR_TRADE');
const BuyerIndustryClassification _$INDEPENDENT_BUILDER =
    const BuyerIndustryClassification._('INDEPENDENT_BUILDER');
const BuyerIndustryClassification _$DIY_HOMEOWNER =
    const BuyerIndustryClassification._('DIY_HOMEOWNER');
const BuyerIndustryClassification _$OTHER =
    const BuyerIndustryClassification._('OTHER');

BuyerIndustryClassification _$valueOf(String name) {
  switch (name) {
    case 'GENERAL_CONTRACTOR':
      return _$GENERAL_CONTRACTOR;
    case 'SUBCONTRACTOR_TRADE':
      return _$SUBCONTRACTOR_TRADE;
    case 'INDEPENDENT_BUILDER':
      return _$INDEPENDENT_BUILDER;
    case 'DIY_HOMEOWNER':
      return _$DIY_HOMEOWNER;
    case 'OTHER':
      return _$OTHER;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<BuyerIndustryClassification> _$values =
    BuiltSet<BuyerIndustryClassification>(const <BuyerIndustryClassification>[
  _$GENERAL_CONTRACTOR,
  _$SUBCONTRACTOR_TRADE,
  _$INDEPENDENT_BUILDER,
  _$DIY_HOMEOWNER,
  _$OTHER,
]);

class _$BuyerIndustryClassificationMeta {
  const _$BuyerIndustryClassificationMeta();
  BuyerIndustryClassification get GENERAL_CONTRACTOR => _$GENERAL_CONTRACTOR;
  BuyerIndustryClassification get SUBCONTRACTOR_TRADE => _$SUBCONTRACTOR_TRADE;
  BuyerIndustryClassification get INDEPENDENT_BUILDER => _$INDEPENDENT_BUILDER;
  BuyerIndustryClassification get DIY_HOMEOWNER => _$DIY_HOMEOWNER;
  BuyerIndustryClassification get OTHER => _$OTHER;
  BuyerIndustryClassification valueOf(String name) => _$valueOf(name);
  BuiltSet<BuyerIndustryClassification> get values => _$values;
}

abstract class _$BuyerIndustryClassificationMixin {
  // ignore: non_constant_identifier_names
  _$BuyerIndustryClassificationMeta get BuyerIndustryClassification =>
      const _$BuyerIndustryClassificationMeta();
}

Serializer<BuyerIndustryClassification>
    _$buyerIndustryClassificationSerializer =
    _$BuyerIndustryClassificationSerializer();

class _$BuyerIndustryClassificationSerializer
    implements PrimitiveSerializer<BuyerIndustryClassification> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'GENERAL_CONTRACTOR': 'GENERAL_CONTRACTOR',
    'SUBCONTRACTOR_TRADE': 'SUBCONTRACTOR_TRADE',
    'INDEPENDENT_BUILDER': 'INDEPENDENT_BUILDER',
    'DIY_HOMEOWNER': 'DIY_HOMEOWNER',
    'OTHER': 'OTHER',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'GENERAL_CONTRACTOR': 'GENERAL_CONTRACTOR',
    'SUBCONTRACTOR_TRADE': 'SUBCONTRACTOR_TRADE',
    'INDEPENDENT_BUILDER': 'INDEPENDENT_BUILDER',
    'DIY_HOMEOWNER': 'DIY_HOMEOWNER',
    'OTHER': 'OTHER',
  };

  @override
  final Iterable<Type> types = const <Type>[BuyerIndustryClassification];
  @override
  final String wireName = 'BuyerIndustryClassification';

  @override
  Object serialize(Serializers serializers, BuyerIndustryClassification object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  BuyerIndustryClassification deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      BuyerIndustryClassification.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
