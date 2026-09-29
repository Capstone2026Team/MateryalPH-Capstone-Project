// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_line_snapshot.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CartLineSnapshot extends CartLineSnapshot {
  @override
  final String? priceVersionId;
  @override
  final int? unitPriceCentavos;
  @override
  final String? stockLabel;
  @override
  final int? publicationVersion;
  @override
  final DateTime addedAt;

  factory _$CartLineSnapshot(
          [void Function(CartLineSnapshotBuilder)? updates]) =>
      (CartLineSnapshotBuilder()..update(updates))._build();

  _$CartLineSnapshot._(
      {this.priceVersionId,
      this.unitPriceCentavos,
      this.stockLabel,
      this.publicationVersion,
      required this.addedAt})
      : super._();
  @override
  CartLineSnapshot rebuild(void Function(CartLineSnapshotBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CartLineSnapshotBuilder toBuilder() =>
      CartLineSnapshotBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CartLineSnapshot &&
        priceVersionId == other.priceVersionId &&
        unitPriceCentavos == other.unitPriceCentavos &&
        stockLabel == other.stockLabel &&
        publicationVersion == other.publicationVersion &&
        addedAt == other.addedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, priceVersionId.hashCode);
    _$hash = $jc(_$hash, unitPriceCentavos.hashCode);
    _$hash = $jc(_$hash, stockLabel.hashCode);
    _$hash = $jc(_$hash, publicationVersion.hashCode);
    _$hash = $jc(_$hash, addedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CartLineSnapshot')
          ..add('priceVersionId', priceVersionId)
          ..add('unitPriceCentavos', unitPriceCentavos)
          ..add('stockLabel', stockLabel)
          ..add('publicationVersion', publicationVersion)
          ..add('addedAt', addedAt))
        .toString();
  }
}

class CartLineSnapshotBuilder
    implements Builder<CartLineSnapshot, CartLineSnapshotBuilder> {
  _$CartLineSnapshot? _$v;

  String? _priceVersionId;
  String? get priceVersionId => _$this._priceVersionId;
  set priceVersionId(String? priceVersionId) =>
      _$this._priceVersionId = priceVersionId;

  int? _unitPriceCentavos;
  int? get unitPriceCentavos => _$this._unitPriceCentavos;
  set unitPriceCentavos(int? unitPriceCentavos) =>
      _$this._unitPriceCentavos = unitPriceCentavos;

  String? _stockLabel;
  String? get stockLabel => _$this._stockLabel;
  set stockLabel(String? stockLabel) => _$this._stockLabel = stockLabel;

  int? _publicationVersion;
  int? get publicationVersion => _$this._publicationVersion;
  set publicationVersion(int? publicationVersion) =>
      _$this._publicationVersion = publicationVersion;

  DateTime? _addedAt;
  DateTime? get addedAt => _$this._addedAt;
  set addedAt(DateTime? addedAt) => _$this._addedAt = addedAt;

  CartLineSnapshotBuilder() {
    CartLineSnapshot._defaults(this);
  }

  CartLineSnapshotBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _priceVersionId = $v.priceVersionId;
      _unitPriceCentavos = $v.unitPriceCentavos;
      _stockLabel = $v.stockLabel;
      _publicationVersion = $v.publicationVersion;
      _addedAt = $v.addedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CartLineSnapshot other) {
    _$v = other as _$CartLineSnapshot;
  }

  @override
  void update(void Function(CartLineSnapshotBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CartLineSnapshot build() => _build();

  _$CartLineSnapshot _build() {
    final _$result = _$v ??
        _$CartLineSnapshot._(
          priceVersionId: priceVersionId,
          unitPriceCentavos: unitPriceCentavos,
          stockLabel: stockLabel,
          publicationVersion: publicationVersion,
          addedAt: BuiltValueNullFieldError.checkNotNull(
              addedAt, r'CartLineSnapshot', 'addedAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
