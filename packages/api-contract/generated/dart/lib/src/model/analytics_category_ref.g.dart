// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_category_ref.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AnalyticsCategoryRef extends AnalyticsCategoryRef {
  @override
  final String id;
  @override
  final String code;
  @override
  final String name;

  factory _$AnalyticsCategoryRef(
          [void Function(AnalyticsCategoryRefBuilder)? updates]) =>
      (AnalyticsCategoryRefBuilder()..update(updates))._build();

  _$AnalyticsCategoryRef._(
      {required this.id, required this.code, required this.name})
      : super._();
  @override
  AnalyticsCategoryRef rebuild(
          void Function(AnalyticsCategoryRefBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AnalyticsCategoryRefBuilder toBuilder() =>
      AnalyticsCategoryRefBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AnalyticsCategoryRef &&
        id == other.id &&
        code == other.code &&
        name == other.name;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AnalyticsCategoryRef')
          ..add('id', id)
          ..add('code', code)
          ..add('name', name))
        .toString();
  }
}

class AnalyticsCategoryRefBuilder
    implements Builder<AnalyticsCategoryRef, AnalyticsCategoryRefBuilder> {
  _$AnalyticsCategoryRef? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  AnalyticsCategoryRefBuilder() {
    AnalyticsCategoryRef._defaults(this);
  }

  AnalyticsCategoryRefBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _code = $v.code;
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AnalyticsCategoryRef other) {
    _$v = other as _$AnalyticsCategoryRef;
  }

  @override
  void update(void Function(AnalyticsCategoryRefBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AnalyticsCategoryRef build() => _build();

  _$AnalyticsCategoryRef _build() {
    final _$result = _$v ??
        _$AnalyticsCategoryRef._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'AnalyticsCategoryRef', 'id'),
          code: BuiltValueNullFieldError.checkNotNull(
              code, r'AnalyticsCategoryRef', 'code'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'AnalyticsCategoryRef', 'name'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
