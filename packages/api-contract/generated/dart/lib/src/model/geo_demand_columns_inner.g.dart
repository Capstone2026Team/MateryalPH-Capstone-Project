// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geo_demand_columns_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GeoDemandColumnsInner extends GeoDemandColumnsInner {
  @override
  final String id;
  @override
  final String name;

  factory _$GeoDemandColumnsInner(
          [void Function(GeoDemandColumnsInnerBuilder)? updates]) =>
      (GeoDemandColumnsInnerBuilder()..update(updates))._build();

  _$GeoDemandColumnsInner._({required this.id, required this.name}) : super._();
  @override
  GeoDemandColumnsInner rebuild(
          void Function(GeoDemandColumnsInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GeoDemandColumnsInnerBuilder toBuilder() =>
      GeoDemandColumnsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GeoDemandColumnsInner &&
        id == other.id &&
        name == other.name;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GeoDemandColumnsInner')
          ..add('id', id)
          ..add('name', name))
        .toString();
  }
}

class GeoDemandColumnsInnerBuilder
    implements Builder<GeoDemandColumnsInner, GeoDemandColumnsInnerBuilder> {
  _$GeoDemandColumnsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  GeoDemandColumnsInnerBuilder() {
    GeoDemandColumnsInner._defaults(this);
  }

  GeoDemandColumnsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GeoDemandColumnsInner other) {
    _$v = other as _$GeoDemandColumnsInner;
  }

  @override
  void update(void Function(GeoDemandColumnsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GeoDemandColumnsInner build() => _build();

  _$GeoDemandColumnsInner _build() {
    final _$result = _$v ??
        _$GeoDemandColumnsInner._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'GeoDemandColumnsInner', 'id'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'GeoDemandColumnsInner', 'name'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
