// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_volume_tier_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CatalogVolumeTierInput extends CatalogVolumeTierInput {
  @override
  final String minimumQuantity;
  @override
  final int priceCentavos;

  factory _$CatalogVolumeTierInput(
          [void Function(CatalogVolumeTierInputBuilder)? updates]) =>
      (CatalogVolumeTierInputBuilder()..update(updates))._build();

  _$CatalogVolumeTierInput._(
      {required this.minimumQuantity, required this.priceCentavos})
      : super._();
  @override
  CatalogVolumeTierInput rebuild(
          void Function(CatalogVolumeTierInputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CatalogVolumeTierInputBuilder toBuilder() =>
      CatalogVolumeTierInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CatalogVolumeTierInput &&
        minimumQuantity == other.minimumQuantity &&
        priceCentavos == other.priceCentavos;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, minimumQuantity.hashCode);
    _$hash = $jc(_$hash, priceCentavos.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CatalogVolumeTierInput')
          ..add('minimumQuantity', minimumQuantity)
          ..add('priceCentavos', priceCentavos))
        .toString();
  }
}

class CatalogVolumeTierInputBuilder
    implements Builder<CatalogVolumeTierInput, CatalogVolumeTierInputBuilder> {
  _$CatalogVolumeTierInput? _$v;

  String? _minimumQuantity;
  String? get minimumQuantity => _$this._minimumQuantity;
  set minimumQuantity(String? minimumQuantity) =>
      _$this._minimumQuantity = minimumQuantity;

  int? _priceCentavos;
  int? get priceCentavos => _$this._priceCentavos;
  set priceCentavos(int? priceCentavos) =>
      _$this._priceCentavos = priceCentavos;

  CatalogVolumeTierInputBuilder() {
    CatalogVolumeTierInput._defaults(this);
  }

  CatalogVolumeTierInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _minimumQuantity = $v.minimumQuantity;
      _priceCentavos = $v.priceCentavos;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CatalogVolumeTierInput other) {
    _$v = other as _$CatalogVolumeTierInput;
  }

  @override
  void update(void Function(CatalogVolumeTierInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CatalogVolumeTierInput build() => _build();

  _$CatalogVolumeTierInput _build() {
    final _$result = _$v ??
        _$CatalogVolumeTierInput._(
          minimumQuantity: BuiltValueNullFieldError.checkNotNull(
              minimumQuantity, r'CatalogVolumeTierInput', 'minimumQuantity'),
          priceCentavos: BuiltValueNullFieldError.checkNotNull(
              priceCentavos, r'CatalogVolumeTierInput', 'priceCentavos'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
