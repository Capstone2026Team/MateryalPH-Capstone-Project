// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'volume_tier.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VolumeTier extends VolumeTier {
  @override
  final String priceVersionId;
  @override
  final String minimumQuantity;
  @override
  final int amountCentavos;

  factory _$VolumeTier([void Function(VolumeTierBuilder)? updates]) =>
      (VolumeTierBuilder()..update(updates))._build();

  _$VolumeTier._(
      {required this.priceVersionId,
      required this.minimumQuantity,
      required this.amountCentavos})
      : super._();
  @override
  VolumeTier rebuild(void Function(VolumeTierBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VolumeTierBuilder toBuilder() => VolumeTierBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VolumeTier &&
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
    return (newBuiltValueToStringHelper(r'VolumeTier')
          ..add('priceVersionId', priceVersionId)
          ..add('minimumQuantity', minimumQuantity)
          ..add('amountCentavos', amountCentavos))
        .toString();
  }
}

class VolumeTierBuilder implements Builder<VolumeTier, VolumeTierBuilder> {
  _$VolumeTier? _$v;

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

  VolumeTierBuilder() {
    VolumeTier._defaults(this);
  }

  VolumeTierBuilder get _$this {
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
  void replace(VolumeTier other) {
    _$v = other as _$VolumeTier;
  }

  @override
  void update(void Function(VolumeTierBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VolumeTier build() => _build();

  _$VolumeTier _build() {
    final _$result = _$v ??
        _$VolumeTier._(
          priceVersionId: BuiltValueNullFieldError.checkNotNull(
              priceVersionId, r'VolumeTier', 'priceVersionId'),
          minimumQuantity: BuiltValueNullFieldError.checkNotNull(
              minimumQuantity, r'VolumeTier', 'minimumQuantity'),
          amountCentavos: BuiltValueNullFieldError.checkNotNull(
              amountCentavos, r'VolumeTier', 'amountCentavos'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
