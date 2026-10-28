// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quotation_location_search.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$QuotationLocationSearch extends QuotationLocationSearch {
  @override
  final String query;

  factory _$QuotationLocationSearch(
          [void Function(QuotationLocationSearchBuilder)? updates]) =>
      (QuotationLocationSearchBuilder()..update(updates))._build();

  _$QuotationLocationSearch._({required this.query}) : super._();
  @override
  QuotationLocationSearch rebuild(
          void Function(QuotationLocationSearchBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  QuotationLocationSearchBuilder toBuilder() =>
      QuotationLocationSearchBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is QuotationLocationSearch && query == other.query;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, query.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'QuotationLocationSearch')
          ..add('query', query))
        .toString();
  }
}

class QuotationLocationSearchBuilder
    implements
        Builder<QuotationLocationSearch, QuotationLocationSearchBuilder> {
  _$QuotationLocationSearch? _$v;

  String? _query;
  String? get query => _$this._query;
  set query(String? query) => _$this._query = query;

  QuotationLocationSearchBuilder() {
    QuotationLocationSearch._defaults(this);
  }

  QuotationLocationSearchBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _query = $v.query;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(QuotationLocationSearch other) {
    _$v = other as _$QuotationLocationSearch;
  }

  @override
  void update(void Function(QuotationLocationSearchBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  QuotationLocationSearch build() => _build();

  _$QuotationLocationSearch _build() {
    final _$result = _$v ??
        _$QuotationLocationSearch._(
          query: BuiltValueNullFieldError.checkNotNull(
              query, r'QuotationLocationSearch', 'query'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
