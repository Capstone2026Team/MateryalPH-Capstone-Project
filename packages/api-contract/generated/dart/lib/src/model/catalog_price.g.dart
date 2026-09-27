// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_price.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CatalogPrice extends CatalogPrice {
  @override
  final String priceVersionId;
  @override
  final int version;
  @override
  final int amountCentavos;
  @override
  final TaxCategory taxCategory;
  @override
  final String? taxBasis;
  @override
  final int includedVatCentavos;
  @override
  final String? effectiveAt;

  factory _$CatalogPrice([void Function(CatalogPriceBuilder)? updates]) =>
      (CatalogPriceBuilder()..update(updates))._build();

  _$CatalogPrice._(
      {required this.priceVersionId,
      required this.version,
      required this.amountCentavos,
      required this.taxCategory,
      this.taxBasis,
      required this.includedVatCentavos,
      this.effectiveAt})
      : super._();
  @override
  CatalogPrice rebuild(void Function(CatalogPriceBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CatalogPriceBuilder toBuilder() => CatalogPriceBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CatalogPrice &&
        priceVersionId == other.priceVersionId &&
        version == other.version &&
        amountCentavos == other.amountCentavos &&
        taxCategory == other.taxCategory &&
        taxBasis == other.taxBasis &&
        includedVatCentavos == other.includedVatCentavos &&
        effectiveAt == other.effectiveAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, priceVersionId.hashCode);
    _$hash = $jc(_$hash, version.hashCode);
    _$hash = $jc(_$hash, amountCentavos.hashCode);
    _$hash = $jc(_$hash, taxCategory.hashCode);
    _$hash = $jc(_$hash, taxBasis.hashCode);
    _$hash = $jc(_$hash, includedVatCentavos.hashCode);
    _$hash = $jc(_$hash, effectiveAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CatalogPrice')
          ..add('priceVersionId', priceVersionId)
          ..add('version', version)
          ..add('amountCentavos', amountCentavos)
          ..add('taxCategory', taxCategory)
          ..add('taxBasis', taxBasis)
          ..add('includedVatCentavos', includedVatCentavos)
          ..add('effectiveAt', effectiveAt))
        .toString();
  }
}

class CatalogPriceBuilder
    implements Builder<CatalogPrice, CatalogPriceBuilder> {
  _$CatalogPrice? _$v;

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

  String? _taxBasis;
  String? get taxBasis => _$this._taxBasis;
  set taxBasis(String? taxBasis) => _$this._taxBasis = taxBasis;

  int? _includedVatCentavos;
  int? get includedVatCentavos => _$this._includedVatCentavos;
  set includedVatCentavos(int? includedVatCentavos) =>
      _$this._includedVatCentavos = includedVatCentavos;

  String? _effectiveAt;
  String? get effectiveAt => _$this._effectiveAt;
  set effectiveAt(String? effectiveAt) => _$this._effectiveAt = effectiveAt;

  CatalogPriceBuilder() {
    CatalogPrice._defaults(this);
  }

  CatalogPriceBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _priceVersionId = $v.priceVersionId;
      _version = $v.version;
      _amountCentavos = $v.amountCentavos;
      _taxCategory = $v.taxCategory;
      _taxBasis = $v.taxBasis;
      _includedVatCentavos = $v.includedVatCentavos;
      _effectiveAt = $v.effectiveAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CatalogPrice other) {
    _$v = other as _$CatalogPrice;
  }

  @override
  void update(void Function(CatalogPriceBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CatalogPrice build() => _build();

  _$CatalogPrice _build() {
    final _$result = _$v ??
        _$CatalogPrice._(
          priceVersionId: BuiltValueNullFieldError.checkNotNull(
              priceVersionId, r'CatalogPrice', 'priceVersionId'),
          version: BuiltValueNullFieldError.checkNotNull(
              version, r'CatalogPrice', 'version'),
          amountCentavos: BuiltValueNullFieldError.checkNotNull(
              amountCentavos, r'CatalogPrice', 'amountCentavos'),
          taxCategory: BuiltValueNullFieldError.checkNotNull(
              taxCategory, r'CatalogPrice', 'taxCategory'),
          taxBasis: taxBasis,
          includedVatCentavos: BuiltValueNullFieldError.checkNotNull(
              includedVatCentavos, r'CatalogPrice', 'includedVatCentavos'),
          effectiveAt: effectiveAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
