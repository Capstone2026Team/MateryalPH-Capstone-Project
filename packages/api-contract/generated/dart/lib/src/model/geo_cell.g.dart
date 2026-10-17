// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geo_cell.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GeoCell extends GeoCell {
  @override
  final int? value;
  @override
  final bool suppressed;
  @override
  final String? reason;

  factory _$GeoCell([void Function(GeoCellBuilder)? updates]) =>
      (GeoCellBuilder()..update(updates))._build();

  _$GeoCell._({this.value, required this.suppressed, this.reason}) : super._();
  @override
  GeoCell rebuild(void Function(GeoCellBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GeoCellBuilder toBuilder() => GeoCellBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GeoCell &&
        value == other.value &&
        suppressed == other.suppressed &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, value.hashCode);
    _$hash = $jc(_$hash, suppressed.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GeoCell')
          ..add('value', value)
          ..add('suppressed', suppressed)
          ..add('reason', reason))
        .toString();
  }
}

class GeoCellBuilder implements Builder<GeoCell, GeoCellBuilder> {
  _$GeoCell? _$v;

  int? _value;
  int? get value => _$this._value;
  set value(int? value) => _$this._value = value;

  bool? _suppressed;
  bool? get suppressed => _$this._suppressed;
  set suppressed(bool? suppressed) => _$this._suppressed = suppressed;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  GeoCellBuilder() {
    GeoCell._defaults(this);
  }

  GeoCellBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _value = $v.value;
      _suppressed = $v.suppressed;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GeoCell other) {
    _$v = other as _$GeoCell;
  }

  @override
  void update(void Function(GeoCellBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GeoCell build() => _build();

  _$GeoCell _build() {
    final _$result = _$v ??
        _$GeoCell._(
          value: value,
          suppressed: BuiltValueNullFieldError.checkNotNull(
              suppressed, r'GeoCell', 'suppressed'),
          reason: reason,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
