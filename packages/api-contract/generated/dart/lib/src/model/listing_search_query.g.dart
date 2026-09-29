// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listing_search_query.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ListingSearchQuery extends ListingSearchQuery {
  @override
  final String? text;
  @override
  final String? normalized;

  factory _$ListingSearchQuery(
          [void Function(ListingSearchQueryBuilder)? updates]) =>
      (ListingSearchQueryBuilder()..update(updates))._build();

  _$ListingSearchQuery._({this.text, this.normalized}) : super._();
  @override
  ListingSearchQuery rebuild(
          void Function(ListingSearchQueryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ListingSearchQueryBuilder toBuilder() =>
      ListingSearchQueryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ListingSearchQuery &&
        text == other.text &&
        normalized == other.normalized;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, text.hashCode);
    _$hash = $jc(_$hash, normalized.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ListingSearchQuery')
          ..add('text', text)
          ..add('normalized', normalized))
        .toString();
  }
}

class ListingSearchQueryBuilder
    implements Builder<ListingSearchQuery, ListingSearchQueryBuilder> {
  _$ListingSearchQuery? _$v;

  String? _text;
  String? get text => _$this._text;
  set text(String? text) => _$this._text = text;

  String? _normalized;
  String? get normalized => _$this._normalized;
  set normalized(String? normalized) => _$this._normalized = normalized;

  ListingSearchQueryBuilder() {
    ListingSearchQuery._defaults(this);
  }

  ListingSearchQueryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _text = $v.text;
      _normalized = $v.normalized;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ListingSearchQuery other) {
    _$v = other as _$ListingSearchQuery;
  }

  @override
  void update(void Function(ListingSearchQueryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ListingSearchQuery build() => _build();

  _$ListingSearchQuery _build() {
    final _$result = _$v ??
        _$ListingSearchQuery._(
          text: text,
          normalized: normalized,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
