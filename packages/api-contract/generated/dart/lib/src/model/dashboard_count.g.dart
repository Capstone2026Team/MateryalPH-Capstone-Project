// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_count.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DashboardCount extends DashboardCount {
  @override
  final String key;
  @override
  final int count;

  factory _$DashboardCount([void Function(DashboardCountBuilder)? updates]) =>
      (DashboardCountBuilder()..update(updates))._build();

  _$DashboardCount._({required this.key, required this.count}) : super._();
  @override
  DashboardCount rebuild(void Function(DashboardCountBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DashboardCountBuilder toBuilder() => DashboardCountBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DashboardCount && key == other.key && count == other.count;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, key.hashCode);
    _$hash = $jc(_$hash, count.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DashboardCount')
          ..add('key', key)
          ..add('count', count))
        .toString();
  }
}

class DashboardCountBuilder
    implements Builder<DashboardCount, DashboardCountBuilder> {
  _$DashboardCount? _$v;

  String? _key;
  String? get key => _$this._key;
  set key(String? key) => _$this._key = key;

  int? _count;
  int? get count => _$this._count;
  set count(int? count) => _$this._count = count;

  DashboardCountBuilder() {
    DashboardCount._defaults(this);
  }

  DashboardCountBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _key = $v.key;
      _count = $v.count;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DashboardCount other) {
    _$v = other as _$DashboardCount;
  }

  @override
  void update(void Function(DashboardCountBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DashboardCount build() => _build();

  _$DashboardCount _build() {
    final _$result = _$v ??
        _$DashboardCount._(
          key: BuiltValueNullFieldError.checkNotNull(
              key, r'DashboardCount', 'key'),
          count: BuiltValueNullFieldError.checkNotNull(
              count, r'DashboardCount', 'count'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
