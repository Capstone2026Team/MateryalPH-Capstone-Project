// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'material_category_option.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MaterialCategoryOption extends MaterialCategoryOption {
  @override
  final String id;
  @override
  final String code;
  @override
  final String name;

  factory _$MaterialCategoryOption(
          [void Function(MaterialCategoryOptionBuilder)? updates]) =>
      (MaterialCategoryOptionBuilder()..update(updates))._build();

  _$MaterialCategoryOption._(
      {required this.id, required this.code, required this.name})
      : super._();
  @override
  MaterialCategoryOption rebuild(
          void Function(MaterialCategoryOptionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MaterialCategoryOptionBuilder toBuilder() =>
      MaterialCategoryOptionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MaterialCategoryOption &&
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
    return (newBuiltValueToStringHelper(r'MaterialCategoryOption')
          ..add('id', id)
          ..add('code', code)
          ..add('name', name))
        .toString();
  }
}

class MaterialCategoryOptionBuilder
    implements Builder<MaterialCategoryOption, MaterialCategoryOptionBuilder> {
  _$MaterialCategoryOption? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  MaterialCategoryOptionBuilder() {
    MaterialCategoryOption._defaults(this);
  }

  MaterialCategoryOptionBuilder get _$this {
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
  void replace(MaterialCategoryOption other) {
    _$v = other as _$MaterialCategoryOption;
  }

  @override
  void update(void Function(MaterialCategoryOptionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MaterialCategoryOption build() => _build();

  _$MaterialCategoryOption _build() {
    final _$result = _$v ??
        _$MaterialCategoryOption._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'MaterialCategoryOption', 'id'),
          code: BuiltValueNullFieldError.checkNotNull(
              code, r'MaterialCategoryOption', 'code'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'MaterialCategoryOption', 'name'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
