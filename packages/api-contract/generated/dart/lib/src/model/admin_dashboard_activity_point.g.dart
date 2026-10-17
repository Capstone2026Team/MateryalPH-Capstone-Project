// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_dashboard_activity_point.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminDashboardActivityPoint extends AdminDashboardActivityPoint {
  @override
  final Date date;
  @override
  final int? buyerDau;
  @override
  final int? vendorDau;
  @override
  final int? buyerMau;
  @override
  final int? vendorMau;

  factory _$AdminDashboardActivityPoint(
          [void Function(AdminDashboardActivityPointBuilder)? updates]) =>
      (AdminDashboardActivityPointBuilder()..update(updates))._build();

  _$AdminDashboardActivityPoint._(
      {required this.date,
      this.buyerDau,
      this.vendorDau,
      this.buyerMau,
      this.vendorMau})
      : super._();
  @override
  AdminDashboardActivityPoint rebuild(
          void Function(AdminDashboardActivityPointBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminDashboardActivityPointBuilder toBuilder() =>
      AdminDashboardActivityPointBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDashboardActivityPoint &&
        date == other.date &&
        buyerDau == other.buyerDau &&
        vendorDau == other.vendorDau &&
        buyerMau == other.buyerMau &&
        vendorMau == other.vendorMau;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, date.hashCode);
    _$hash = $jc(_$hash, buyerDau.hashCode);
    _$hash = $jc(_$hash, vendorDau.hashCode);
    _$hash = $jc(_$hash, buyerMau.hashCode);
    _$hash = $jc(_$hash, vendorMau.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminDashboardActivityPoint')
          ..add('date', date)
          ..add('buyerDau', buyerDau)
          ..add('vendorDau', vendorDau)
          ..add('buyerMau', buyerMau)
          ..add('vendorMau', vendorMau))
        .toString();
  }
}

class AdminDashboardActivityPointBuilder
    implements
        Builder<AdminDashboardActivityPoint,
            AdminDashboardActivityPointBuilder> {
  _$AdminDashboardActivityPoint? _$v;

  Date? _date;
  Date? get date => _$this._date;
  set date(Date? date) => _$this._date = date;

  int? _buyerDau;
  int? get buyerDau => _$this._buyerDau;
  set buyerDau(int? buyerDau) => _$this._buyerDau = buyerDau;

  int? _vendorDau;
  int? get vendorDau => _$this._vendorDau;
  set vendorDau(int? vendorDau) => _$this._vendorDau = vendorDau;

  int? _buyerMau;
  int? get buyerMau => _$this._buyerMau;
  set buyerMau(int? buyerMau) => _$this._buyerMau = buyerMau;

  int? _vendorMau;
  int? get vendorMau => _$this._vendorMau;
  set vendorMau(int? vendorMau) => _$this._vendorMau = vendorMau;

  AdminDashboardActivityPointBuilder() {
    AdminDashboardActivityPoint._defaults(this);
  }

  AdminDashboardActivityPointBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _date = $v.date;
      _buyerDau = $v.buyerDau;
      _vendorDau = $v.vendorDau;
      _buyerMau = $v.buyerMau;
      _vendorMau = $v.vendorMau;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDashboardActivityPoint other) {
    _$v = other as _$AdminDashboardActivityPoint;
  }

  @override
  void update(void Function(AdminDashboardActivityPointBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminDashboardActivityPoint build() => _build();

  _$AdminDashboardActivityPoint _build() {
    final _$result = _$v ??
        _$AdminDashboardActivityPoint._(
          date: BuiltValueNullFieldError.checkNotNull(
              date, r'AdminDashboardActivityPoint', 'date'),
          buyerDau: buyerDau,
          vendorDau: vendorDau,
          buyerMau: buyerMau,
          vendorMau: vendorMau,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
