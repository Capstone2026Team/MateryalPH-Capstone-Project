// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_label.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const StockLabel _$IN_STOCK = const StockLabel._('IN_STOCK');
const StockLabel _$LIMITED_STOCK = const StockLabel._('LIMITED_STOCK');
const StockLabel _$OUT_OF_STOCK = const StockLabel._('OUT_OF_STOCK');

StockLabel _$valueOf(String name) {
  switch (name) {
    case 'IN_STOCK':
      return _$IN_STOCK;
    case 'LIMITED_STOCK':
      return _$LIMITED_STOCK;
    case 'OUT_OF_STOCK':
      return _$OUT_OF_STOCK;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<StockLabel> _$values = BuiltSet<StockLabel>(const <StockLabel>[
  _$IN_STOCK,
  _$LIMITED_STOCK,
  _$OUT_OF_STOCK,
]);

class _$StockLabelMeta {
  const _$StockLabelMeta();
  StockLabel get IN_STOCK => _$IN_STOCK;
  StockLabel get LIMITED_STOCK => _$LIMITED_STOCK;
  StockLabel get OUT_OF_STOCK => _$OUT_OF_STOCK;
  StockLabel valueOf(String name) => _$valueOf(name);
  BuiltSet<StockLabel> get values => _$values;
}

abstract class _$StockLabelMixin {
  // ignore: non_constant_identifier_names
  _$StockLabelMeta get StockLabel => const _$StockLabelMeta();
}

Serializer<StockLabel> _$stockLabelSerializer = _$StockLabelSerializer();

class _$StockLabelSerializer implements PrimitiveSerializer<StockLabel> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'IN_STOCK': 'IN_STOCK',
    'LIMITED_STOCK': 'LIMITED_STOCK',
    'OUT_OF_STOCK': 'OUT_OF_STOCK',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'IN_STOCK': 'IN_STOCK',
    'LIMITED_STOCK': 'LIMITED_STOCK',
    'OUT_OF_STOCK': 'OUT_OF_STOCK',
  };

  @override
  final Iterable<Type> types = const <Type>[StockLabel];
  @override
  final String wireName = 'StockLabel';

  @override
  Object serialize(Serializers serializers, StockLabel object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  StockLabel deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      StockLabel.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
