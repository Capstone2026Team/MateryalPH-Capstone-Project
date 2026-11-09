// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'withholding_year_limit.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$WithholdingYearLimit extends WithholdingYearLimit {
  @override
  final int taxableYear;
  @override
  final int totalCentavos;
  @override
  final int limitCentavos;
  @override
  final bool crossed;
  @override
  final String status;

  factory _$WithholdingYearLimit(
          [void Function(WithholdingYearLimitBuilder)? updates]) =>
      (WithholdingYearLimitBuilder()..update(updates))._build();

  _$WithholdingYearLimit._(
      {required this.taxableYear,
      required this.totalCentavos,
      required this.limitCentavos,
      required this.crossed,
      required this.status})
      : super._();
  @override
  WithholdingYearLimit rebuild(
          void Function(WithholdingYearLimitBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  WithholdingYearLimitBuilder toBuilder() =>
      WithholdingYearLimitBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is WithholdingYearLimit &&
        taxableYear == other.taxableYear &&
        totalCentavos == other.totalCentavos &&
        limitCentavos == other.limitCentavos &&
        crossed == other.crossed &&
        status == other.status;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, taxableYear.hashCode);
    _$hash = $jc(_$hash, totalCentavos.hashCode);
    _$hash = $jc(_$hash, limitCentavos.hashCode);
    _$hash = $jc(_$hash, crossed.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'WithholdingYearLimit')
          ..add('taxableYear', taxableYear)
          ..add('totalCentavos', totalCentavos)
          ..add('limitCentavos', limitCentavos)
          ..add('crossed', crossed)
          ..add('status', status))
        .toString();
  }
}

class WithholdingYearLimitBuilder
    implements Builder<WithholdingYearLimit, WithholdingYearLimitBuilder> {
  _$WithholdingYearLimit? _$v;

  int? _taxableYear;
  int? get taxableYear => _$this._taxableYear;
  set taxableYear(int? taxableYear) => _$this._taxableYear = taxableYear;

  int? _totalCentavos;
  int? get totalCentavos => _$this._totalCentavos;
  set totalCentavos(int? totalCentavos) =>
      _$this._totalCentavos = totalCentavos;

  int? _limitCentavos;
  int? get limitCentavos => _$this._limitCentavos;
  set limitCentavos(int? limitCentavos) =>
      _$this._limitCentavos = limitCentavos;

  bool? _crossed;
  bool? get crossed => _$this._crossed;
  set crossed(bool? crossed) => _$this._crossed = crossed;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  WithholdingYearLimitBuilder() {
    WithholdingYearLimit._defaults(this);
  }

  WithholdingYearLimitBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _taxableYear = $v.taxableYear;
      _totalCentavos = $v.totalCentavos;
      _limitCentavos = $v.limitCentavos;
      _crossed = $v.crossed;
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(WithholdingYearLimit other) {
    _$v = other as _$WithholdingYearLimit;
  }

  @override
  void update(void Function(WithholdingYearLimitBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  WithholdingYearLimit build() => _build();

  _$WithholdingYearLimit _build() {
    final _$result = _$v ??
        _$WithholdingYearLimit._(
          taxableYear: BuiltValueNullFieldError.checkNotNull(
              taxableYear, r'WithholdingYearLimit', 'taxableYear'),
          totalCentavos: BuiltValueNullFieldError.checkNotNull(
              totalCentavos, r'WithholdingYearLimit', 'totalCentavos'),
          limitCentavos: BuiltValueNullFieldError.checkNotNull(
              limitCentavos, r'WithholdingYearLimit', 'limitCentavos'),
          crossed: BuiltValueNullFieldError.checkNotNull(
              crossed, r'WithholdingYearLimit', 'crossed'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'WithholdingYearLimit', 'status'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
