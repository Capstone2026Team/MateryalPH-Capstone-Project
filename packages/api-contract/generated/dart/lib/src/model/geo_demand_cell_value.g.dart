// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geo_demand_cell_value.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GeoDemandCellValue extends GeoDemandCellValue {
  @override
  final OneOf oneOf;

  factory _$GeoDemandCellValue(
          [void Function(GeoDemandCellValueBuilder)? updates]) =>
      (GeoDemandCellValueBuilder()..update(updates))._build();

  _$GeoDemandCellValue._({required this.oneOf}) : super._();
  @override
  GeoDemandCellValue rebuild(
          void Function(GeoDemandCellValueBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GeoDemandCellValueBuilder toBuilder() =>
      GeoDemandCellValueBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GeoDemandCellValue && oneOf == other.oneOf;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, oneOf.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GeoDemandCellValue')
          ..add('oneOf', oneOf))
        .toString();
  }
}

class GeoDemandCellValueBuilder
    implements Builder<GeoDemandCellValue, GeoDemandCellValueBuilder> {
  _$GeoDemandCellValue? _$v;

  OneOf? _oneOf;
  OneOf? get oneOf => _$this._oneOf;
  set oneOf(OneOf? oneOf) => _$this._oneOf = oneOf;

  GeoDemandCellValueBuilder() {
    GeoDemandCellValue._defaults(this);
  }

  GeoDemandCellValueBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _oneOf = $v.oneOf;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GeoDemandCellValue other) {
    _$v = other as _$GeoDemandCellValue;
  }

  @override
  void update(void Function(GeoDemandCellValueBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GeoDemandCellValue build() => _build();

  _$GeoDemandCellValue _build() {
    final _$result = _$v ??
        _$GeoDemandCellValue._(
          oneOf: BuiltValueNullFieldError.checkNotNull(
              oneOf, r'GeoDemandCellValue', 'oneOf'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
