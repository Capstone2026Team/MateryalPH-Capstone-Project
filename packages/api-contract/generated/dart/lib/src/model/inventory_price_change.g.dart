// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_price_change.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$InventoryPriceChange extends InventoryPriceChange {
  @override
  final String expectedPriceVersionId;
  @override
  final int amountCentavos;

  factory _$InventoryPriceChange(
          [void Function(InventoryPriceChangeBuilder)? updates]) =>
      (InventoryPriceChangeBuilder()..update(updates))._build();

  _$InventoryPriceChange._(
      {required this.expectedPriceVersionId, required this.amountCentavos})
      : super._();
  @override
  InventoryPriceChange rebuild(
          void Function(InventoryPriceChangeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InventoryPriceChangeBuilder toBuilder() =>
      InventoryPriceChangeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InventoryPriceChange &&
        expectedPriceVersionId == other.expectedPriceVersionId &&
        amountCentavos == other.amountCentavos;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, expectedPriceVersionId.hashCode);
    _$hash = $jc(_$hash, amountCentavos.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'InventoryPriceChange')
          ..add('expectedPriceVersionId', expectedPriceVersionId)
          ..add('amountCentavos', amountCentavos))
        .toString();
  }
}

class InventoryPriceChangeBuilder
    implements Builder<InventoryPriceChange, InventoryPriceChangeBuilder> {
  _$InventoryPriceChange? _$v;

  String? _expectedPriceVersionId;
  String? get expectedPriceVersionId => _$this._expectedPriceVersionId;
  set expectedPriceVersionId(String? expectedPriceVersionId) =>
      _$this._expectedPriceVersionId = expectedPriceVersionId;

  int? _amountCentavos;
  int? get amountCentavos => _$this._amountCentavos;
  set amountCentavos(int? amountCentavos) =>
      _$this._amountCentavos = amountCentavos;

  InventoryPriceChangeBuilder() {
    InventoryPriceChange._defaults(this);
  }

  InventoryPriceChangeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _expectedPriceVersionId = $v.expectedPriceVersionId;
      _amountCentavos = $v.amountCentavos;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(InventoryPriceChange other) {
    _$v = other as _$InventoryPriceChange;
  }

  @override
  void update(void Function(InventoryPriceChangeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  InventoryPriceChange build() => _build();

  _$InventoryPriceChange _build() {
    final _$result = _$v ??
        _$InventoryPriceChange._(
          expectedPriceVersionId: BuiltValueNullFieldError.checkNotNull(
              expectedPriceVersionId,
              r'InventoryPriceChange',
              'expectedPriceVersionId'),
          amountCentavos: BuiltValueNullFieldError.checkNotNull(
              amountCentavos, r'InventoryPriceChange', 'amountCentavos'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
