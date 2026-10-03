// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_next_opening.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$StoreNextOpening extends StoreNextOpening {
  @override
  final Date date;
  @override
  final String weekday;
  @override
  final String opensAt;

  factory _$StoreNextOpening(
          [void Function(StoreNextOpeningBuilder)? updates]) =>
      (StoreNextOpeningBuilder()..update(updates))._build();

  _$StoreNextOpening._(
      {required this.date, required this.weekday, required this.opensAt})
      : super._();
  @override
  StoreNextOpening rebuild(void Function(StoreNextOpeningBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  StoreNextOpeningBuilder toBuilder() =>
      StoreNextOpeningBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is StoreNextOpening &&
        date == other.date &&
        weekday == other.weekday &&
        opensAt == other.opensAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, date.hashCode);
    _$hash = $jc(_$hash, weekday.hashCode);
    _$hash = $jc(_$hash, opensAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'StoreNextOpening')
          ..add('date', date)
          ..add('weekday', weekday)
          ..add('opensAt', opensAt))
        .toString();
  }
}

class StoreNextOpeningBuilder
    implements Builder<StoreNextOpening, StoreNextOpeningBuilder> {
  _$StoreNextOpening? _$v;

  Date? _date;
  Date? get date => _$this._date;
  set date(Date? date) => _$this._date = date;

  String? _weekday;
  String? get weekday => _$this._weekday;
  set weekday(String? weekday) => _$this._weekday = weekday;

  String? _opensAt;
  String? get opensAt => _$this._opensAt;
  set opensAt(String? opensAt) => _$this._opensAt = opensAt;

  StoreNextOpeningBuilder() {
    StoreNextOpening._defaults(this);
  }

  StoreNextOpeningBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _date = $v.date;
      _weekday = $v.weekday;
      _opensAt = $v.opensAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(StoreNextOpening other) {
    _$v = other as _$StoreNextOpening;
  }

  @override
  void update(void Function(StoreNextOpeningBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  StoreNextOpening build() => _build();

  _$StoreNextOpening _build() {
    final _$result = _$v ??
        _$StoreNextOpening._(
          date: BuiltValueNullFieldError.checkNotNull(
              date, r'StoreNextOpening', 'date'),
          weekday: BuiltValueNullFieldError.checkNotNull(
              weekday, r'StoreNextOpening', 'weekday'),
          opensAt: BuiltValueNullFieldError.checkNotNull(
              opensAt, r'StoreNextOpening', 'opensAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
