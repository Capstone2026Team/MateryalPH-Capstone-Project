// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listing_search_meta.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ListingSearchMeta extends ListingSearchMeta {
  @override
  final String? correlationId;
  @override
  final DiscoveryScope scope;
  @override
  final DateTime currentAsOf;
  @override
  final String eligibilityVersion;
  @override
  final String algorithmVersion;
  @override
  final ListingSearchSort sort;
  @override
  final ListingSearchSort defaultSort;
  @override
  final ListingSearchQuery query;
  @override
  final ListingSearchRanking ranking;
  @override
  final int total;
  @override
  final int perPage;
  @override
  final bool hasMore;
  @override
  final String? nextCursor;
  @override
  final bool candidateLimitReached;
  @override
  final ListingSearchExpansion? expansion;
  @override
  final String tierNote;

  factory _$ListingSearchMeta(
          [void Function(ListingSearchMetaBuilder)? updates]) =>
      (ListingSearchMetaBuilder()..update(updates))._build();

  _$ListingSearchMeta._(
      {this.correlationId,
      required this.scope,
      required this.currentAsOf,
      required this.eligibilityVersion,
      required this.algorithmVersion,
      required this.sort,
      required this.defaultSort,
      required this.query,
      required this.ranking,
      required this.total,
      required this.perPage,
      required this.hasMore,
      this.nextCursor,
      required this.candidateLimitReached,
      this.expansion,
      required this.tierNote})
      : super._();
  @override
  ListingSearchMeta rebuild(void Function(ListingSearchMetaBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ListingSearchMetaBuilder toBuilder() =>
      ListingSearchMetaBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ListingSearchMeta &&
        correlationId == other.correlationId &&
        scope == other.scope &&
        currentAsOf == other.currentAsOf &&
        eligibilityVersion == other.eligibilityVersion &&
        algorithmVersion == other.algorithmVersion &&
        sort == other.sort &&
        defaultSort == other.defaultSort &&
        query == other.query &&
        ranking == other.ranking &&
        total == other.total &&
        perPage == other.perPage &&
        hasMore == other.hasMore &&
        nextCursor == other.nextCursor &&
        candidateLimitReached == other.candidateLimitReached &&
        expansion == other.expansion &&
        tierNote == other.tierNote;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, correlationId.hashCode);
    _$hash = $jc(_$hash, scope.hashCode);
    _$hash = $jc(_$hash, currentAsOf.hashCode);
    _$hash = $jc(_$hash, eligibilityVersion.hashCode);
    _$hash = $jc(_$hash, algorithmVersion.hashCode);
    _$hash = $jc(_$hash, sort.hashCode);
    _$hash = $jc(_$hash, defaultSort.hashCode);
    _$hash = $jc(_$hash, query.hashCode);
    _$hash = $jc(_$hash, ranking.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jc(_$hash, perPage.hashCode);
    _$hash = $jc(_$hash, hasMore.hashCode);
    _$hash = $jc(_$hash, nextCursor.hashCode);
    _$hash = $jc(_$hash, candidateLimitReached.hashCode);
    _$hash = $jc(_$hash, expansion.hashCode);
    _$hash = $jc(_$hash, tierNote.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ListingSearchMeta')
          ..add('correlationId', correlationId)
          ..add('scope', scope)
          ..add('currentAsOf', currentAsOf)
          ..add('eligibilityVersion', eligibilityVersion)
          ..add('algorithmVersion', algorithmVersion)
          ..add('sort', sort)
          ..add('defaultSort', defaultSort)
          ..add('query', query)
          ..add('ranking', ranking)
          ..add('total', total)
          ..add('perPage', perPage)
          ..add('hasMore', hasMore)
          ..add('nextCursor', nextCursor)
          ..add('candidateLimitReached', candidateLimitReached)
          ..add('expansion', expansion)
          ..add('tierNote', tierNote))
        .toString();
  }
}

class ListingSearchMetaBuilder
    implements Builder<ListingSearchMeta, ListingSearchMetaBuilder> {
  _$ListingSearchMeta? _$v;

  String? _correlationId;
  String? get correlationId => _$this._correlationId;
  set correlationId(String? correlationId) =>
      _$this._correlationId = correlationId;

  DiscoveryScopeBuilder? _scope;
  DiscoveryScopeBuilder get scope => _$this._scope ??= DiscoveryScopeBuilder();
  set scope(DiscoveryScopeBuilder? scope) => _$this._scope = scope;

  DateTime? _currentAsOf;
  DateTime? get currentAsOf => _$this._currentAsOf;
  set currentAsOf(DateTime? currentAsOf) => _$this._currentAsOf = currentAsOf;

  String? _eligibilityVersion;
  String? get eligibilityVersion => _$this._eligibilityVersion;
  set eligibilityVersion(String? eligibilityVersion) =>
      _$this._eligibilityVersion = eligibilityVersion;

  String? _algorithmVersion;
  String? get algorithmVersion => _$this._algorithmVersion;
  set algorithmVersion(String? algorithmVersion) =>
      _$this._algorithmVersion = algorithmVersion;

  ListingSearchSort? _sort;
  ListingSearchSort? get sort => _$this._sort;
  set sort(ListingSearchSort? sort) => _$this._sort = sort;

  ListingSearchSort? _defaultSort;
  ListingSearchSort? get defaultSort => _$this._defaultSort;
  set defaultSort(ListingSearchSort? defaultSort) =>
      _$this._defaultSort = defaultSort;

  ListingSearchQueryBuilder? _query;
  ListingSearchQueryBuilder get query =>
      _$this._query ??= ListingSearchQueryBuilder();
  set query(ListingSearchQueryBuilder? query) => _$this._query = query;

  ListingSearchRankingBuilder? _ranking;
  ListingSearchRankingBuilder get ranking =>
      _$this._ranking ??= ListingSearchRankingBuilder();
  set ranking(ListingSearchRankingBuilder? ranking) =>
      _$this._ranking = ranking;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  int? _perPage;
  int? get perPage => _$this._perPage;
  set perPage(int? perPage) => _$this._perPage = perPage;

  bool? _hasMore;
  bool? get hasMore => _$this._hasMore;
  set hasMore(bool? hasMore) => _$this._hasMore = hasMore;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  bool? _candidateLimitReached;
  bool? get candidateLimitReached => _$this._candidateLimitReached;
  set candidateLimitReached(bool? candidateLimitReached) =>
      _$this._candidateLimitReached = candidateLimitReached;

  ListingSearchExpansionBuilder? _expansion;
  ListingSearchExpansionBuilder get expansion =>
      _$this._expansion ??= ListingSearchExpansionBuilder();
  set expansion(ListingSearchExpansionBuilder? expansion) =>
      _$this._expansion = expansion;

  String? _tierNote;
  String? get tierNote => _$this._tierNote;
  set tierNote(String? tierNote) => _$this._tierNote = tierNote;

  ListingSearchMetaBuilder() {
    ListingSearchMeta._defaults(this);
  }

  ListingSearchMetaBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _correlationId = $v.correlationId;
      _scope = $v.scope.toBuilder();
      _currentAsOf = $v.currentAsOf;
      _eligibilityVersion = $v.eligibilityVersion;
      _algorithmVersion = $v.algorithmVersion;
      _sort = $v.sort;
      _defaultSort = $v.defaultSort;
      _query = $v.query.toBuilder();
      _ranking = $v.ranking.toBuilder();
      _total = $v.total;
      _perPage = $v.perPage;
      _hasMore = $v.hasMore;
      _nextCursor = $v.nextCursor;
      _candidateLimitReached = $v.candidateLimitReached;
      _expansion = $v.expansion?.toBuilder();
      _tierNote = $v.tierNote;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ListingSearchMeta other) {
    _$v = other as _$ListingSearchMeta;
  }

  @override
  void update(void Function(ListingSearchMetaBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ListingSearchMeta build() => _build();

  _$ListingSearchMeta _build() {
    _$ListingSearchMeta _$result;
    try {
      _$result = _$v ??
          _$ListingSearchMeta._(
            correlationId: correlationId,
            scope: scope.build(),
            currentAsOf: BuiltValueNullFieldError.checkNotNull(
                currentAsOf, r'ListingSearchMeta', 'currentAsOf'),
            eligibilityVersion: BuiltValueNullFieldError.checkNotNull(
                eligibilityVersion, r'ListingSearchMeta', 'eligibilityVersion'),
            algorithmVersion: BuiltValueNullFieldError.checkNotNull(
                algorithmVersion, r'ListingSearchMeta', 'algorithmVersion'),
            sort: BuiltValueNullFieldError.checkNotNull(
                sort, r'ListingSearchMeta', 'sort'),
            defaultSort: BuiltValueNullFieldError.checkNotNull(
                defaultSort, r'ListingSearchMeta', 'defaultSort'),
            query: query.build(),
            ranking: ranking.build(),
            total: BuiltValueNullFieldError.checkNotNull(
                total, r'ListingSearchMeta', 'total'),
            perPage: BuiltValueNullFieldError.checkNotNull(
                perPage, r'ListingSearchMeta', 'perPage'),
            hasMore: BuiltValueNullFieldError.checkNotNull(
                hasMore, r'ListingSearchMeta', 'hasMore'),
            nextCursor: nextCursor,
            candidateLimitReached: BuiltValueNullFieldError.checkNotNull(
                candidateLimitReached,
                r'ListingSearchMeta',
                'candidateLimitReached'),
            expansion: _expansion?.build(),
            tierNote: BuiltValueNullFieldError.checkNotNull(
                tierNote, r'ListingSearchMeta', 'tierNote'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'scope';
        scope.build();

        _$failedField = 'query';
        query.build();
        _$failedField = 'ranking';
        ranking.build();

        _$failedField = 'expansion';
        _expansion?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ListingSearchMeta', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
