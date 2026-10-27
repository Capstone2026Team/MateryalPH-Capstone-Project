// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geo_filter_option.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GeoFilterOption extends GeoFilterOption {
  @override
  final String id;
  @override
  final String name;

  factory _$GeoFilterOption([void Function(GeoFilterOptionBuilder)? updates]) =>
      (GeoFilterOptionBuilder()..update(updates))._build();

  _$GeoFilterOption._({required this.id, required this.name}) : super._();
  @override
  GeoFilterOption rebuild(void Function(GeoFilterOptionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GeoFilterOptionBuilder toBuilder() => GeoFilterOptionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GeoFilterOption && id == other.id && name == other.name;
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
    return (newBuiltValueToStringHelper(r'GeoFilterOption')
          ..add('id', id)
          ..add('name', name))
        .toString();
  }
}

class GeoFilterOptionBuilder
    implements Builder<GeoFilterOption, GeoFilterOptionBuilder> {
  _$GeoFilterOption? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  GeoFilterOptionBuilder() {
    GeoFilterOption._defaults(this);
  }

  GeoFilterOptionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GeoFilterOption other) {
    _$v = other as _$GeoFilterOption;
  }

  @override
  void update(void Function(GeoFilterOptionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GeoFilterOption build() => _build();

  _$GeoFilterOption _build() {
    final _$result = _$v ??
        _$GeoFilterOption._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'GeoFilterOption', 'id'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'GeoFilterOption', 'name'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
