// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listing_category_ref.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ListingCategoryRef extends ListingCategoryRef {
  @override
  final String id;
  @override
  final String? name;

  factory _$ListingCategoryRef(
          [void Function(ListingCategoryRefBuilder)? updates]) =>
      (ListingCategoryRefBuilder()..update(updates))._build();

  _$ListingCategoryRef._({required this.id, this.name}) : super._();
  @override
  ListingCategoryRef rebuild(
          void Function(ListingCategoryRefBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ListingCategoryRefBuilder toBuilder() =>
      ListingCategoryRefBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ListingCategoryRef && id == other.id && name == other.name;
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
    return (newBuiltValueToStringHelper(r'ListingCategoryRef')
          ..add('id', id)
          ..add('name', name))
        .toString();
  }
}

class ListingCategoryRefBuilder
    implements Builder<ListingCategoryRef, ListingCategoryRefBuilder> {
  _$ListingCategoryRef? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  ListingCategoryRefBuilder() {
    ListingCategoryRef._defaults(this);
  }

  ListingCategoryRefBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ListingCategoryRef other) {
    _$v = other as _$ListingCategoryRef;
  }

  @override
  void update(void Function(ListingCategoryRefBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ListingCategoryRef build() => _build();

  _$ListingCategoryRef _build() {
    final _$result = _$v ??
        _$ListingCategoryRef._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'ListingCategoryRef', 'id'),
          name: name,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
