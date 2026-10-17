// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geo_demand_cell.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GeoDemandCell extends GeoDemandCell {
  @override
  final String column;
  @override
  final GeoDemandCellValue? value;
  @override
  final bool suppressed;
  @override
  final String? reason;

  factory _$GeoDemandCell([void Function(GeoDemandCellBuilder)? updates]) =>
      (GeoDemandCellBuilder()..update(updates))._build();

  _$GeoDemandCell._(
      {required this.column, this.value, required this.suppressed, this.reason})
      : super._();
  @override
  GeoDemandCell rebuild(void Function(GeoDemandCellBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GeoDemandCellBuilder toBuilder() => GeoDemandCellBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GeoDemandCell &&
        column == other.column &&
        value == other.value &&
        suppressed == other.suppressed &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, column.hashCode);
    _$hash = $jc(_$hash, value.hashCode);
    _$hash = $jc(_$hash, suppressed.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GeoDemandCell')
          ..add('column', column)
          ..add('value', value)
          ..add('suppressed', suppressed)
          ..add('reason', reason))
        .toString();
  }
}

class GeoDemandCellBuilder
    implements Builder<GeoDemandCell, GeoDemandCellBuilder> {
  _$GeoDemandCell? _$v;

  String? _column;
  String? get column => _$this._column;
  set column(String? column) => _$this._column = column;

  GeoDemandCellValueBuilder? _value;
  GeoDemandCellValueBuilder get value =>
      _$this._value ??= GeoDemandCellValueBuilder();
  set value(GeoDemandCellValueBuilder? value) => _$this._value = value;

  bool? _suppressed;
  bool? get suppressed => _$this._suppressed;
  set suppressed(bool? suppressed) => _$this._suppressed = suppressed;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  GeoDemandCellBuilder() {
    GeoDemandCell._defaults(this);
  }

  GeoDemandCellBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _column = $v.column;
      _value = $v.value?.toBuilder();
      _suppressed = $v.suppressed;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GeoDemandCell other) {
    _$v = other as _$GeoDemandCell;
  }

  @override
  void update(void Function(GeoDemandCellBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GeoDemandCell build() => _build();

  _$GeoDemandCell _build() {
    _$GeoDemandCell _$result;
    try {
      _$result = _$v ??
          _$GeoDemandCell._(
            column: BuiltValueNullFieldError.checkNotNull(
                column, r'GeoDemandCell', 'column'),
            value: _value?.build(),
            suppressed: BuiltValueNullFieldError.checkNotNull(
                suppressed, r'GeoDemandCell', 'suppressed'),
            reason: reason,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'value';
        _value?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'GeoDemandCell', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
