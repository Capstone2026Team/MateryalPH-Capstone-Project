// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_own_offer.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorOwnOffer extends VendorOwnOffer {
  @override
  final String listingId;
  @override
  final String variantId;
  @override
  final String displayName;
  @override
  final String? variantLabel;
  @override
  final int priceCentavos;
  @override
  final String normalizedPhp;
  @override
  final String taxLabel;
  @override
  final DateTime priceAsOf;

  factory _$VendorOwnOffer([void Function(VendorOwnOfferBuilder)? updates]) =>
      (VendorOwnOfferBuilder()..update(updates))._build();

  _$VendorOwnOffer._(
      {required this.listingId,
      required this.variantId,
      required this.displayName,
      this.variantLabel,
      required this.priceCentavos,
      required this.normalizedPhp,
      required this.taxLabel,
      required this.priceAsOf})
      : super._();
  @override
  VendorOwnOffer rebuild(void Function(VendorOwnOfferBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorOwnOfferBuilder toBuilder() => VendorOwnOfferBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorOwnOffer &&
        listingId == other.listingId &&
        variantId == other.variantId &&
        displayName == other.displayName &&
        variantLabel == other.variantLabel &&
        priceCentavos == other.priceCentavos &&
        normalizedPhp == other.normalizedPhp &&
        taxLabel == other.taxLabel &&
        priceAsOf == other.priceAsOf;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, listingId.hashCode);
    _$hash = $jc(_$hash, variantId.hashCode);
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, variantLabel.hashCode);
    _$hash = $jc(_$hash, priceCentavos.hashCode);
    _$hash = $jc(_$hash, normalizedPhp.hashCode);
    _$hash = $jc(_$hash, taxLabel.hashCode);
    _$hash = $jc(_$hash, priceAsOf.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorOwnOffer')
          ..add('listingId', listingId)
          ..add('variantId', variantId)
          ..add('displayName', displayName)
          ..add('variantLabel', variantLabel)
          ..add('priceCentavos', priceCentavos)
          ..add('normalizedPhp', normalizedPhp)
          ..add('taxLabel', taxLabel)
          ..add('priceAsOf', priceAsOf))
        .toString();
  }
}

class VendorOwnOfferBuilder
    implements Builder<VendorOwnOffer, VendorOwnOfferBuilder> {
  _$VendorOwnOffer? _$v;

  String? _listingId;
  String? get listingId => _$this._listingId;
  set listingId(String? listingId) => _$this._listingId = listingId;

  String? _variantId;
  String? get variantId => _$this._variantId;
  set variantId(String? variantId) => _$this._variantId = variantId;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  String? _variantLabel;
  String? get variantLabel => _$this._variantLabel;
  set variantLabel(String? variantLabel) => _$this._variantLabel = variantLabel;

  int? _priceCentavos;
  int? get priceCentavos => _$this._priceCentavos;
  set priceCentavos(int? priceCentavos) =>
      _$this._priceCentavos = priceCentavos;

  String? _normalizedPhp;
  String? get normalizedPhp => _$this._normalizedPhp;
  set normalizedPhp(String? normalizedPhp) =>
      _$this._normalizedPhp = normalizedPhp;

  String? _taxLabel;
  String? get taxLabel => _$this._taxLabel;
  set taxLabel(String? taxLabel) => _$this._taxLabel = taxLabel;

  DateTime? _priceAsOf;
  DateTime? get priceAsOf => _$this._priceAsOf;
  set priceAsOf(DateTime? priceAsOf) => _$this._priceAsOf = priceAsOf;

  VendorOwnOfferBuilder() {
    VendorOwnOffer._defaults(this);
  }

  VendorOwnOfferBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _listingId = $v.listingId;
      _variantId = $v.variantId;
      _displayName = $v.displayName;
      _variantLabel = $v.variantLabel;
      _priceCentavos = $v.priceCentavos;
      _normalizedPhp = $v.normalizedPhp;
      _taxLabel = $v.taxLabel;
      _priceAsOf = $v.priceAsOf;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorOwnOffer other) {
    _$v = other as _$VendorOwnOffer;
  }

  @override
  void update(void Function(VendorOwnOfferBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorOwnOffer build() => _build();

  _$VendorOwnOffer _build() {
    final _$result = _$v ??
        _$VendorOwnOffer._(
          listingId: BuiltValueNullFieldError.checkNotNull(
              listingId, r'VendorOwnOffer', 'listingId'),
          variantId: BuiltValueNullFieldError.checkNotNull(
              variantId, r'VendorOwnOffer', 'variantId'),
          displayName: BuiltValueNullFieldError.checkNotNull(
              displayName, r'VendorOwnOffer', 'displayName'),
          variantLabel: variantLabel,
          priceCentavos: BuiltValueNullFieldError.checkNotNull(
              priceCentavos, r'VendorOwnOffer', 'priceCentavos'),
          normalizedPhp: BuiltValueNullFieldError.checkNotNull(
              normalizedPhp, r'VendorOwnOffer', 'normalizedPhp'),
          taxLabel: BuiltValueNullFieldError.checkNotNull(
              taxLabel, r'VendorOwnOffer', 'taxLabel'),
          priceAsOf: BuiltValueNullFieldError.checkNotNull(
              priceAsOf, r'VendorOwnOffer', 'priceAsOf'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
