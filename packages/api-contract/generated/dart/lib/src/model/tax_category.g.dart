// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tax_category.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const TaxCategory _$VAT_12 = const TaxCategory._('VAT_12');
const TaxCategory _$VAT_ZERO = const TaxCategory._('VAT_ZERO');
const TaxCategory _$VAT_EXEMPT = const TaxCategory._('VAT_EXEMPT');
const TaxCategory _$NON_VAT = const TaxCategory._('NON_VAT');

TaxCategory _$valueOf(String name) {
  switch (name) {
    case 'VAT_12':
      return _$VAT_12;
    case 'VAT_ZERO':
      return _$VAT_ZERO;
    case 'VAT_EXEMPT':
      return _$VAT_EXEMPT;
    case 'NON_VAT':
      return _$NON_VAT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<TaxCategory> _$values =
    BuiltSet<TaxCategory>(const <TaxCategory>[
  _$VAT_12,
  _$VAT_ZERO,
  _$VAT_EXEMPT,
  _$NON_VAT,
]);

class _$TaxCategoryMeta {
  const _$TaxCategoryMeta();
  TaxCategory get VAT_12 => _$VAT_12;
  TaxCategory get VAT_ZERO => _$VAT_ZERO;
  TaxCategory get VAT_EXEMPT => _$VAT_EXEMPT;
  TaxCategory get NON_VAT => _$NON_VAT;
  TaxCategory valueOf(String name) => _$valueOf(name);
  BuiltSet<TaxCategory> get values => _$values;
}

abstract class _$TaxCategoryMixin {
  // ignore: non_constant_identifier_names
  _$TaxCategoryMeta get TaxCategory => const _$TaxCategoryMeta();
}

Serializer<TaxCategory> _$taxCategorySerializer = _$TaxCategorySerializer();

class _$TaxCategorySerializer implements PrimitiveSerializer<TaxCategory> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'VAT_12': 'VAT_12',
    'VAT_ZERO': 'VAT_ZERO',
    'VAT_EXEMPT': 'VAT_EXEMPT',
    'NON_VAT': 'NON_VAT',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'VAT_12': 'VAT_12',
    'VAT_ZERO': 'VAT_ZERO',
    'VAT_EXEMPT': 'VAT_EXEMPT',
    'NON_VAT': 'NON_VAT',
  };

  @override
  final Iterable<Type> types = const <Type>[TaxCategory];
  @override
  final String wireName = 'TaxCategory';

  @override
  Object serialize(Serializers serializers, TaxCategory object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  TaxCategory deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      TaxCategory.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
