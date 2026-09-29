// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'explore_category_count.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ExploreCategoryCount extends ExploreCategoryCount {
  @override
  final String id;
  @override
  final String code;
  @override
  final String name;
  @override
  final int vendorListings;

  factory _$ExploreCategoryCount(
          [void Function(ExploreCategoryCountBuilder)? updates]) =>
      (ExploreCategoryCountBuilder()..update(updates))._build();

  _$ExploreCategoryCount._(
      {required this.id,
      required this.code,
      required this.name,
      required this.vendorListings})
      : super._();
  @override
  ExploreCategoryCount rebuild(
          void Function(ExploreCategoryCountBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ExploreCategoryCountBuilder toBuilder() =>
      ExploreCategoryCountBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ExploreCategoryCount &&
        id == other.id &&
        code == other.code &&
        name == other.name &&
        vendorListings == other.vendorListings;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, vendorListings.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ExploreCategoryCount')
          ..add('id', id)
          ..add('code', code)
          ..add('name', name)
          ..add('vendorListings', vendorListings))
        .toString();
  }
}

class ExploreCategoryCountBuilder
    implements Builder<ExploreCategoryCount, ExploreCategoryCountBuilder> {
  _$ExploreCategoryCount? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  int? _vendorListings;
  int? get vendorListings => _$this._vendorListings;
  set vendorListings(int? vendorListings) =>
      _$this._vendorListings = vendorListings;

  ExploreCategoryCountBuilder() {
    ExploreCategoryCount._defaults(this);
  }

  ExploreCategoryCountBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _code = $v.code;
      _name = $v.name;
      _vendorListings = $v.vendorListings;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ExploreCategoryCount other) {
    _$v = other as _$ExploreCategoryCount;
  }

  @override
  void update(void Function(ExploreCategoryCountBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ExploreCategoryCount build() => _build();

  _$ExploreCategoryCount _build() {
    final _$result = _$v ??
        _$ExploreCategoryCount._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'ExploreCategoryCount', 'id'),
          code: BuiltValueNullFieldError.checkNotNull(
              code, r'ExploreCategoryCount', 'code'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'ExploreCategoryCount', 'name'),
          vendorListings: BuiltValueNullFieldError.checkNotNull(
              vendorListings, r'ExploreCategoryCount', 'vendorListings'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
