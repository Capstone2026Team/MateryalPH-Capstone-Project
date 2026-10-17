// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_material_ref.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AnalyticsMaterialRef extends AnalyticsMaterialRef {
  @override
  final String id;
  @override
  final String name;

  factory _$AnalyticsMaterialRef(
          [void Function(AnalyticsMaterialRefBuilder)? updates]) =>
      (AnalyticsMaterialRefBuilder()..update(updates))._build();

  _$AnalyticsMaterialRef._({required this.id, required this.name}) : super._();
  @override
  AnalyticsMaterialRef rebuild(
          void Function(AnalyticsMaterialRefBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AnalyticsMaterialRefBuilder toBuilder() =>
      AnalyticsMaterialRefBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AnalyticsMaterialRef &&
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
    return (newBuiltValueToStringHelper(r'AnalyticsMaterialRef')
          ..add('id', id)
          ..add('name', name))
        .toString();
  }
}

class AnalyticsMaterialRefBuilder
    implements Builder<AnalyticsMaterialRef, AnalyticsMaterialRefBuilder> {
  _$AnalyticsMaterialRef? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  AnalyticsMaterialRefBuilder() {
    AnalyticsMaterialRef._defaults(this);
  }

  AnalyticsMaterialRefBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AnalyticsMaterialRef other) {
    _$v = other as _$AnalyticsMaterialRef;
  }

  @override
  void update(void Function(AnalyticsMaterialRefBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AnalyticsMaterialRef build() => _build();

  _$AnalyticsMaterialRef _build() {
    final _$result = _$v ??
        _$AnalyticsMaterialRef._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'AnalyticsMaterialRef', 'id'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'AnalyticsMaterialRef', 'name'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
