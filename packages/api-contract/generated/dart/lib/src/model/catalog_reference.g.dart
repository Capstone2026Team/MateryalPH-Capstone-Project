// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_reference.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CatalogReference extends CatalogReference {
  @override
  final String id;
  @override
  final String code;
  @override
  final String name;

  factory _$CatalogReference(
          [void Function(CatalogReferenceBuilder)? updates]) =>
      (CatalogReferenceBuilder()..update(updates))._build();

  _$CatalogReference._(
      {required this.id, required this.code, required this.name})
      : super._();
  @override
  CatalogReference rebuild(void Function(CatalogReferenceBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CatalogReferenceBuilder toBuilder() =>
      CatalogReferenceBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CatalogReference &&
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
    return (newBuiltValueToStringHelper(r'CatalogReference')
          ..add('id', id)
          ..add('code', code)
          ..add('name', name))
        .toString();
  }
}

class CatalogReferenceBuilder
    implements Builder<CatalogReference, CatalogReferenceBuilder> {
  _$CatalogReference? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  CatalogReferenceBuilder() {
    CatalogReference._defaults(this);
  }

  CatalogReferenceBuilder get _$this {
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
  void replace(CatalogReference other) {
    _$v = other as _$CatalogReference;
  }

  @override
  void update(void Function(CatalogReferenceBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CatalogReference build() => _build();

  _$CatalogReference _build() {
    final _$result = _$v ??
        _$CatalogReference._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'CatalogReference', 'id'),
          code: BuiltValueNullFieldError.checkNotNull(
              code, r'CatalogReference', 'code'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'CatalogReference', 'name'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
