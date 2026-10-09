// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geo_activity_point.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GeoActivityPoint extends GeoActivityPoint {
  @override
  final Date date;
  @override
  final int? buyerDau;
  @override
  final int? buyerWau;
  @override
  final int? buyerMau;
  @override
  final int? vendorDau;
  @override
  final int? vendorWau;
  @override
  final int? vendorMau;

  factory _$GeoActivityPoint(
          [void Function(GeoActivityPointBuilder)? updates]) =>
      (GeoActivityPointBuilder()..update(updates))._build();

  _$GeoActivityPoint._(
      {required this.date,
      this.buyerDau,
      this.buyerWau,
      this.buyerMau,
      this.vendorDau,
      this.vendorWau,
      this.vendorMau})
      : super._();
  @override
  GeoActivityPoint rebuild(void Function(GeoActivityPointBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GeoActivityPointBuilder toBuilder() =>
      GeoActivityPointBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GeoActivityPoint &&
        date == other.date &&
        buyerDau == other.buyerDau &&
        buyerWau == other.buyerWau &&
        buyerMau == other.buyerMau &&
        vendorDau == other.vendorDau &&
        vendorWau == other.vendorWau &&
        vendorMau == other.vendorMau;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, date.hashCode);
    _$hash = $jc(_$hash, buyerDau.hashCode);
    _$hash = $jc(_$hash, buyerWau.hashCode);
    _$hash = $jc(_$hash, buyerMau.hashCode);
    _$hash = $jc(_$hash, vendorDau.hashCode);
    _$hash = $jc(_$hash, vendorWau.hashCode);
    _$hash = $jc(_$hash, vendorMau.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GeoActivityPoint')
          ..add('date', date)
          ..add('buyerDau', buyerDau)
          ..add('buyerWau', buyerWau)
          ..add('buyerMau', buyerMau)
          ..add('vendorDau', vendorDau)
          ..add('vendorWau', vendorWau)
          ..add('vendorMau', vendorMau))
        .toString();
  }
}

class GeoActivityPointBuilder
    implements Builder<GeoActivityPoint, GeoActivityPointBuilder> {
  _$GeoActivityPoint? _$v;

  Date? _date;
  Date? get date => _$this._date;
  set date(Date? date) => _$this._date = date;

  int? _buyerDau;
  int? get buyerDau => _$this._buyerDau;
  set buyerDau(int? buyerDau) => _$this._buyerDau = buyerDau;

  int? _buyerWau;
  int? get buyerWau => _$this._buyerWau;
  set buyerWau(int? buyerWau) => _$this._buyerWau = buyerWau;

  int? _buyerMau;
  int? get buyerMau => _$this._buyerMau;
  set buyerMau(int? buyerMau) => _$this._buyerMau = buyerMau;

  int? _vendorDau;
  int? get vendorDau => _$this._vendorDau;
  set vendorDau(int? vendorDau) => _$this._vendorDau = vendorDau;

  int? _vendorWau;
  int? get vendorWau => _$this._vendorWau;
  set vendorWau(int? vendorWau) => _$this._vendorWau = vendorWau;

  int? _vendorMau;
  int? get vendorMau => _$this._vendorMau;
  set vendorMau(int? vendorMau) => _$this._vendorMau = vendorMau;

  GeoActivityPointBuilder() {
    GeoActivityPoint._defaults(this);
  }

  GeoActivityPointBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _date = $v.date;
      _buyerDau = $v.buyerDau;
      _buyerWau = $v.buyerWau;
      _buyerMau = $v.buyerMau;
      _vendorDau = $v.vendorDau;
      _vendorWau = $v.vendorWau;
      _vendorMau = $v.vendorMau;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GeoActivityPoint other) {
    _$v = other as _$GeoActivityPoint;
  }

  @override
  void update(void Function(GeoActivityPointBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GeoActivityPoint build() => _build();

  _$GeoActivityPoint _build() {
    final _$result = _$v ??
        _$GeoActivityPoint._(
          date: BuiltValueNullFieldError.checkNotNull(
              date, r'GeoActivityPoint', 'date'),
          buyerDau: buyerDau,
          buyerWau: buyerWau,
          buyerMau: buyerMau,
          vendorDau: vendorDau,
          vendorWau: vendorWau,
          vendorMau: vendorMau,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
