// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_volume_tier.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CatalogVolumeTier extends CatalogVolumeTier {
  @override
  final String priceVersionId;
  @override
  final int version;
  @override
  final String minimumQuantity;
  @override
  final int amountCentavos;
  @override
  final int includedVatCentavos;

  factory _$CatalogVolumeTier(
          [void Function(CatalogVolumeTierBuilder)? updates]) =>
      (CatalogVolumeTierBuilder()..update(updates))._build();

  _$CatalogVolumeTier._(
      {required this.priceVersionId,
      required this.version,
      required this.minimumQuantity,
      required this.amountCentavos,
      required this.includedVatCentavos})
      : super._();
  @override
  CatalogVolumeTier rebuild(void Function(CatalogVolumeTierBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CatalogVolumeTierBuilder toBuilder() =>
      CatalogVolumeTierBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CatalogVolumeTier &&
        priceVersionId == other.priceVersionId &&
        version == other.version &&
        minimumQuantity == other.minimumQuantity &&
        amountCentavos == other.amountCentavos &&
        includedVatCentavos == other.includedVatCentavos;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, priceVersionId.hashCode);
    _$hash = $jc(_$hash, version.hashCode);
    _$hash = $jc(_$hash, minimumQuantity.hashCode);
    _$hash = $jc(_$hash, amountCentavos.hashCode);
    _$hash = $jc(_$hash, includedVatCentavos.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CatalogVolumeTier')
          ..add('priceVersionId', priceVersionId)
          ..add('version', version)
          ..add('minimumQuantity', minimumQuantity)
          ..add('amountCentavos', amountCentavos)
          ..add('includedVatCentavos', includedVatCentavos))
        .toString();
  }
}

class CatalogVolumeTierBuilder
    implements Builder<CatalogVolumeTier, CatalogVolumeTierBuilder> {
  _$CatalogVolumeTier? _$v;

  String? _priceVersionId;
  String? get priceVersionId => _$this._priceVersionId;
  set priceVersionId(String? priceVersionId) =>
      _$this._priceVersionId = priceVersionId;

  int? _version;
  int? get version => _$this._version;
  set version(int? version) => _$this._version = version;

  String? _minimumQuantity;
  String? get minimumQuantity => _$this._minimumQuantity;
  set minimumQuantity(String? minimumQuantity) =>
      _$this._minimumQuantity = minimumQuantity;

  int? _amountCentavos;
  int? get amountCentavos => _$this._amountCentavos;
  set amountCentavos(int? amountCentavos) =>
      _$this._amountCentavos = amountCentavos;

  int? _includedVatCentavos;
  int? get includedVatCentavos => _$this._includedVatCentavos;
  set includedVatCentavos(int? includedVatCentavos) =>
      _$this._includedVatCentavos = includedVatCentavos;

  CatalogVolumeTierBuilder() {
    CatalogVolumeTier._defaults(this);
  }

  CatalogVolumeTierBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _priceVersionId = $v.priceVersionId;
      _version = $v.version;
      _minimumQuantity = $v.minimumQuantity;
      _amountCentavos = $v.amountCentavos;
      _includedVatCentavos = $v.includedVatCentavos;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CatalogVolumeTier other) {
    _$v = other as _$CatalogVolumeTier;
  }

  @override
  void update(void Function(CatalogVolumeTierBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CatalogVolumeTier build() => _build();

  _$CatalogVolumeTier _build() {
    final _$result = _$v ??
        _$CatalogVolumeTier._(
          priceVersionId: BuiltValueNullFieldError.checkNotNull(
              priceVersionId, r'CatalogVolumeTier', 'priceVersionId'),
          version: BuiltValueNullFieldError.checkNotNull(
              version, r'CatalogVolumeTier', 'version'),
          minimumQuantity: BuiltValueNullFieldError.checkNotNull(
              minimumQuantity, r'CatalogVolumeTier', 'minimumQuantity'),
          amountCentavos: BuiltValueNullFieldError.checkNotNull(
              amountCentavos, r'CatalogVolumeTier', 'amountCentavos'),
          includedVatCentavos: BuiltValueNullFieldError.checkNotNull(
              includedVatCentavos, r'CatalogVolumeTier', 'includedVatCentavos'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
