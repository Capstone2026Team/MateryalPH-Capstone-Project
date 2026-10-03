// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_summary.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CartSummaryReservesStockEnum _$cartSummaryReservesStockEnum_false_ =
    const CartSummaryReservesStockEnum._('false_');

CartSummaryReservesStockEnum _$cartSummaryReservesStockEnumValueOf(
    String name) {
  switch (name) {
    case 'false_':
      return _$cartSummaryReservesStockEnum_false_;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CartSummaryReservesStockEnum>
    _$cartSummaryReservesStockEnumValues =
    BuiltSet<CartSummaryReservesStockEnum>(const <CartSummaryReservesStockEnum>[
  _$cartSummaryReservesStockEnum_false_,
]);

Serializer<CartSummaryReservesStockEnum>
    _$cartSummaryReservesStockEnumSerializer =
    _$CartSummaryReservesStockEnumSerializer();

class _$CartSummaryReservesStockEnumSerializer
    implements PrimitiveSerializer<CartSummaryReservesStockEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'false_': 'false',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'false': 'false_',
  };

  @override
  final Iterable<Type> types = const <Type>[CartSummaryReservesStockEnum];
  @override
  final String wireName = 'CartSummaryReservesStockEnum';

  @override
  Object serialize(Serializers serializers, CartSummaryReservesStockEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CartSummaryReservesStockEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CartSummaryReservesStockEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CartSummary extends CartSummary {
  @override
  final int lineCount;
  @override
  final int vendorCount;
  @override
  final int materialsSubtotalCentavos;
  @override
  final String notice;
  @override
  final CartSummaryReservesStockEnum reservesStock;

  factory _$CartSummary([void Function(CartSummaryBuilder)? updates]) =>
      (CartSummaryBuilder()..update(updates))._build();

  _$CartSummary._(
      {required this.lineCount,
      required this.vendorCount,
      required this.materialsSubtotalCentavos,
      required this.notice,
      required this.reservesStock})
      : super._();
  @override
  CartSummary rebuild(void Function(CartSummaryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CartSummaryBuilder toBuilder() => CartSummaryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CartSummary &&
        lineCount == other.lineCount &&
        vendorCount == other.vendorCount &&
        materialsSubtotalCentavos == other.materialsSubtotalCentavos &&
        notice == other.notice &&
        reservesStock == other.reservesStock;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, lineCount.hashCode);
    _$hash = $jc(_$hash, vendorCount.hashCode);
    _$hash = $jc(_$hash, materialsSubtotalCentavos.hashCode);
    _$hash = $jc(_$hash, notice.hashCode);
    _$hash = $jc(_$hash, reservesStock.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CartSummary')
          ..add('lineCount', lineCount)
          ..add('vendorCount', vendorCount)
          ..add('materialsSubtotalCentavos', materialsSubtotalCentavos)
          ..add('notice', notice)
          ..add('reservesStock', reservesStock))
        .toString();
  }
}

class CartSummaryBuilder implements Builder<CartSummary, CartSummaryBuilder> {
  _$CartSummary? _$v;

  int? _lineCount;
  int? get lineCount => _$this._lineCount;
  set lineCount(int? lineCount) => _$this._lineCount = lineCount;

  int? _vendorCount;
  int? get vendorCount => _$this._vendorCount;
  set vendorCount(int? vendorCount) => _$this._vendorCount = vendorCount;

  int? _materialsSubtotalCentavos;
  int? get materialsSubtotalCentavos => _$this._materialsSubtotalCentavos;
  set materialsSubtotalCentavos(int? materialsSubtotalCentavos) =>
      _$this._materialsSubtotalCentavos = materialsSubtotalCentavos;

  String? _notice;
  String? get notice => _$this._notice;
  set notice(String? notice) => _$this._notice = notice;

  CartSummaryReservesStockEnum? _reservesStock;
  CartSummaryReservesStockEnum? get reservesStock => _$this._reservesStock;
  set reservesStock(CartSummaryReservesStockEnum? reservesStock) =>
      _$this._reservesStock = reservesStock;

  CartSummaryBuilder() {
    CartSummary._defaults(this);
  }

  CartSummaryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _lineCount = $v.lineCount;
      _vendorCount = $v.vendorCount;
      _materialsSubtotalCentavos = $v.materialsSubtotalCentavos;
      _notice = $v.notice;
      _reservesStock = $v.reservesStock;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CartSummary other) {
    _$v = other as _$CartSummary;
  }

  @override
  void update(void Function(CartSummaryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CartSummary build() => _build();

  _$CartSummary _build() {
    final _$result = _$v ??
        _$CartSummary._(
          lineCount: BuiltValueNullFieldError.checkNotNull(
              lineCount, r'CartSummary', 'lineCount'),
          vendorCount: BuiltValueNullFieldError.checkNotNull(
              vendorCount, r'CartSummary', 'vendorCount'),
          materialsSubtotalCentavos: BuiltValueNullFieldError.checkNotNull(
              materialsSubtotalCentavos,
              r'CartSummary',
              'materialsSubtotalCentavos'),
          notice: BuiltValueNullFieldError.checkNotNull(
              notice, r'CartSummary', 'notice'),
          reservesStock: BuiltValueNullFieldError.checkNotNull(
              reservesStock, r'CartSummary', 'reservesStock'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
