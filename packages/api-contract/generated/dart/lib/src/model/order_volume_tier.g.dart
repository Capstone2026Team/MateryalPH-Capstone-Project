// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_volume_tier.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$OrderVolumeTier extends OrderVolumeTier {
  @override
  final String priceVersionId;
  @override
  final String minimumQuantity;
  @override
  final int amountCentavos;

  factory _$OrderVolumeTier([void Function(OrderVolumeTierBuilder)? updates]) =>
      (OrderVolumeTierBuilder()..update(updates))._build();

  _$OrderVolumeTier._(
      {required this.priceVersionId,
      required this.minimumQuantity,
      required this.amountCentavos})
      : super._();
  @override
  OrderVolumeTier rebuild(void Function(OrderVolumeTierBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OrderVolumeTierBuilder toBuilder() => OrderVolumeTierBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OrderVolumeTier &&
        priceVersionId == other.priceVersionId &&
        minimumQuantity == other.minimumQuantity &&
        amountCentavos == other.amountCentavos;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, priceVersionId.hashCode);
    _$hash = $jc(_$hash, minimumQuantity.hashCode);
    _$hash = $jc(_$hash, amountCentavos.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OrderVolumeTier')
          ..add('priceVersionId', priceVersionId)
          ..add('minimumQuantity', minimumQuantity)
          ..add('amountCentavos', amountCentavos))
        .toString();
  }
}

class OrderVolumeTierBuilder
    implements Builder<OrderVolumeTier, OrderVolumeTierBuilder> {
  _$OrderVolumeTier? _$v;

  String? _priceVersionId;
  String? get priceVersionId => _$this._priceVersionId;
  set priceVersionId(String? priceVersionId) =>
      _$this._priceVersionId = priceVersionId;

  String? _minimumQuantity;
  String? get minimumQuantity => _$this._minimumQuantity;
  set minimumQuantity(String? minimumQuantity) =>
      _$this._minimumQuantity = minimumQuantity;

  int? _amountCentavos;
  int? get amountCentavos => _$this._amountCentavos;
  set amountCentavos(int? amountCentavos) =>
      _$this._amountCentavos = amountCentavos;

  OrderVolumeTierBuilder() {
    OrderVolumeTier._defaults(this);
  }

  OrderVolumeTierBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _priceVersionId = $v.priceVersionId;
      _minimumQuantity = $v.minimumQuantity;
      _amountCentavos = $v.amountCentavos;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OrderVolumeTier other) {
    _$v = other as _$OrderVolumeTier;
  }

  @override
  void update(void Function(OrderVolumeTierBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OrderVolumeTier build() => _build();

  _$OrderVolumeTier _build() {
    final _$result = _$v ??
        _$OrderVolumeTier._(
          priceVersionId: BuiltValueNullFieldError.checkNotNull(
              priceVersionId, r'OrderVolumeTier', 'priceVersionId'),
          minimumQuantity: BuiltValueNullFieldError.checkNotNull(
              minimumQuantity, r'OrderVolumeTier', 'minimumQuantity'),
          amountCentavos: BuiltValueNullFieldError.checkNotNull(
              amountCentavos, r'OrderVolumeTier', 'amountCentavos'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
