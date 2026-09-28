// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_price.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$InventoryPrice extends InventoryPrice {
  @override
  final String priceVersionId;
  @override
  final int version;
  @override
  final int amountCentavos;
  @override
  final TaxCategory taxCategory;
  @override
  final String? effectiveAt;

  factory _$InventoryPrice([void Function(InventoryPriceBuilder)? updates]) =>
      (InventoryPriceBuilder()..update(updates))._build();

  _$InventoryPrice._(
      {required this.priceVersionId,
      required this.version,
      required this.amountCentavos,
      required this.taxCategory,
      this.effectiveAt})
      : super._();
  @override
  InventoryPrice rebuild(void Function(InventoryPriceBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InventoryPriceBuilder toBuilder() => InventoryPriceBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InventoryPrice &&
        priceVersionId == other.priceVersionId &&
        version == other.version &&
        amountCentavos == other.amountCentavos &&
        taxCategory == other.taxCategory &&
        effectiveAt == other.effectiveAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, priceVersionId.hashCode);
    _$hash = $jc(_$hash, version.hashCode);
    _$hash = $jc(_$hash, amountCentavos.hashCode);
    _$hash = $jc(_$hash, taxCategory.hashCode);
    _$hash = $jc(_$hash, effectiveAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'InventoryPrice')
          ..add('priceVersionId', priceVersionId)
          ..add('version', version)
          ..add('amountCentavos', amountCentavos)
          ..add('taxCategory', taxCategory)
          ..add('effectiveAt', effectiveAt))
        .toString();
  }
}

class InventoryPriceBuilder
    implements Builder<InventoryPrice, InventoryPriceBuilder> {
  _$InventoryPrice? _$v;

  String? _priceVersionId;
  String? get priceVersionId => _$this._priceVersionId;
  set priceVersionId(String? priceVersionId) =>
      _$this._priceVersionId = priceVersionId;

  int? _version;
  int? get version => _$this._version;
  set version(int? version) => _$this._version = version;

  int? _amountCentavos;
  int? get amountCentavos => _$this._amountCentavos;
  set amountCentavos(int? amountCentavos) =>
      _$this._amountCentavos = amountCentavos;

  TaxCategory? _taxCategory;
  TaxCategory? get taxCategory => _$this._taxCategory;
  set taxCategory(TaxCategory? taxCategory) =>
      _$this._taxCategory = taxCategory;

  String? _effectiveAt;
  String? get effectiveAt => _$this._effectiveAt;
  set effectiveAt(String? effectiveAt) => _$this._effectiveAt = effectiveAt;

  InventoryPriceBuilder() {
    InventoryPrice._defaults(this);
  }

  InventoryPriceBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _priceVersionId = $v.priceVersionId;
      _version = $v.version;
      _amountCentavos = $v.amountCentavos;
      _taxCategory = $v.taxCategory;
      _effectiveAt = $v.effectiveAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(InventoryPrice other) {
    _$v = other as _$InventoryPrice;
  }

  @override
  void update(void Function(InventoryPriceBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  InventoryPrice build() => _build();

  _$InventoryPrice _build() {
    final _$result = _$v ??
        _$InventoryPrice._(
          priceVersionId: BuiltValueNullFieldError.checkNotNull(
              priceVersionId, r'InventoryPrice', 'priceVersionId'),
          version: BuiltValueNullFieldError.checkNotNull(
              version, r'InventoryPrice', 'version'),
          amountCentavos: BuiltValueNullFieldError.checkNotNull(
              amountCentavos, r'InventoryPrice', 'amountCentavos'),
          taxCategory: BuiltValueNullFieldError.checkNotNull(
              taxCategory, r'InventoryPrice', 'taxCategory'),
          effectiveAt: effectiveAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
