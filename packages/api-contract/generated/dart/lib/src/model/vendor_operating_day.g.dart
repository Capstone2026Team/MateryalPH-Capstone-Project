// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_operating_day.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorOperatingDay extends VendorOperatingDay {
  @override
  final int weekday;
  @override
  final String? opensAt;
  @override
  final String? closesAt;
  @override
  final bool closed;

  factory _$VendorOperatingDay(
          [void Function(VendorOperatingDayBuilder)? updates]) =>
      (VendorOperatingDayBuilder()..update(updates))._build();

  _$VendorOperatingDay._(
      {required this.weekday,
      this.opensAt,
      this.closesAt,
      required this.closed})
      : super._();
  @override
  VendorOperatingDay rebuild(
          void Function(VendorOperatingDayBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorOperatingDayBuilder toBuilder() =>
      VendorOperatingDayBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorOperatingDay &&
        weekday == other.weekday &&
        opensAt == other.opensAt &&
        closesAt == other.closesAt &&
        closed == other.closed;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, weekday.hashCode);
    _$hash = $jc(_$hash, opensAt.hashCode);
    _$hash = $jc(_$hash, closesAt.hashCode);
    _$hash = $jc(_$hash, closed.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorOperatingDay')
          ..add('weekday', weekday)
          ..add('opensAt', opensAt)
          ..add('closesAt', closesAt)
          ..add('closed', closed))
        .toString();
  }
}

class VendorOperatingDayBuilder
    implements Builder<VendorOperatingDay, VendorOperatingDayBuilder> {
  _$VendorOperatingDay? _$v;

  int? _weekday;
  int? get weekday => _$this._weekday;
  set weekday(int? weekday) => _$this._weekday = weekday;

  String? _opensAt;
  String? get opensAt => _$this._opensAt;
  set opensAt(String? opensAt) => _$this._opensAt = opensAt;

  String? _closesAt;
  String? get closesAt => _$this._closesAt;
  set closesAt(String? closesAt) => _$this._closesAt = closesAt;

  bool? _closed;
  bool? get closed => _$this._closed;
  set closed(bool? closed) => _$this._closed = closed;

  VendorOperatingDayBuilder() {
    VendorOperatingDay._defaults(this);
  }

  VendorOperatingDayBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _weekday = $v.weekday;
      _opensAt = $v.opensAt;
      _closesAt = $v.closesAt;
      _closed = $v.closed;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorOperatingDay other) {
    _$v = other as _$VendorOperatingDay;
  }

  @override
  void update(void Function(VendorOperatingDayBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorOperatingDay build() => _build();

  _$VendorOperatingDay _build() {
    final _$result = _$v ??
        _$VendorOperatingDay._(
          weekday: BuiltValueNullFieldError.checkNotNull(
              weekday, r'VendorOperatingDay', 'weekday'),
          opensAt: opensAt,
          closesAt: closesAt,
          closed: BuiltValueNullFieldError.checkNotNull(
              closed, r'VendorOperatingDay', 'closed'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
