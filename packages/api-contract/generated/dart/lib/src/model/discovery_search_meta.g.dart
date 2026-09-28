// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discovery_search_meta.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DiscoverySearchMeta extends DiscoverySearchMeta {
  @override
  final String? correlationId;
  @override
  final DiscoveryScope scope;
  @override
  final DateTime currentAsOf;
  @override
  final String eligibilityVersion;
  @override
  final String projectionVersion;
  @override
  final DiscoveryCounts counts;
  @override
  final DirectoryAvailability directory;
  @override
  final RadiusExpansion expansion;
  @override
  final int page;
  @override
  final int perPage;
  @override
  final int total;
  @override
  final bool hasMore;

  factory _$DiscoverySearchMeta(
          [void Function(DiscoverySearchMetaBuilder)? updates]) =>
      (DiscoverySearchMetaBuilder()..update(updates))._build();

  _$DiscoverySearchMeta._(
      {this.correlationId,
      required this.scope,
      required this.currentAsOf,
      required this.eligibilityVersion,
      required this.projectionVersion,
      required this.counts,
      required this.directory,
      required this.expansion,
      required this.page,
      required this.perPage,
      required this.total,
      required this.hasMore})
      : super._();
  @override
  DiscoverySearchMeta rebuild(
          void Function(DiscoverySearchMetaBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DiscoverySearchMetaBuilder toBuilder() =>
      DiscoverySearchMetaBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DiscoverySearchMeta &&
        correlationId == other.correlationId &&
        scope == other.scope &&
        currentAsOf == other.currentAsOf &&
        eligibilityVersion == other.eligibilityVersion &&
        projectionVersion == other.projectionVersion &&
        counts == other.counts &&
        directory == other.directory &&
        expansion == other.expansion &&
        page == other.page &&
        perPage == other.perPage &&
        total == other.total &&
        hasMore == other.hasMore;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, correlationId.hashCode);
    _$hash = $jc(_$hash, scope.hashCode);
    _$hash = $jc(_$hash, currentAsOf.hashCode);
    _$hash = $jc(_$hash, eligibilityVersion.hashCode);
    _$hash = $jc(_$hash, projectionVersion.hashCode);
    _$hash = $jc(_$hash, counts.hashCode);
    _$hash = $jc(_$hash, directory.hashCode);
    _$hash = $jc(_$hash, expansion.hashCode);
    _$hash = $jc(_$hash, page.hashCode);
    _$hash = $jc(_$hash, perPage.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jc(_$hash, hasMore.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DiscoverySearchMeta')
          ..add('correlationId', correlationId)
          ..add('scope', scope)
          ..add('currentAsOf', currentAsOf)
          ..add('eligibilityVersion', eligibilityVersion)
          ..add('projectionVersion', projectionVersion)
          ..add('counts', counts)
          ..add('directory', directory)
          ..add('expansion', expansion)
          ..add('page', page)
          ..add('perPage', perPage)
          ..add('total', total)
          ..add('hasMore', hasMore))
        .toString();
  }
}

class DiscoverySearchMetaBuilder
    implements Builder<DiscoverySearchMeta, DiscoverySearchMetaBuilder> {
  _$DiscoverySearchMeta? _$v;

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

  String? _projectionVersion;
  String? get projectionVersion => _$this._projectionVersion;
  set projectionVersion(String? projectionVersion) =>
      _$this._projectionVersion = projectionVersion;

  DiscoveryCountsBuilder? _counts;
  DiscoveryCountsBuilder get counts =>
      _$this._counts ??= DiscoveryCountsBuilder();
  set counts(DiscoveryCountsBuilder? counts) => _$this._counts = counts;

  DirectoryAvailabilityBuilder? _directory;
  DirectoryAvailabilityBuilder get directory =>
      _$this._directory ??= DirectoryAvailabilityBuilder();
  set directory(DirectoryAvailabilityBuilder? directory) =>
      _$this._directory = directory;

  RadiusExpansionBuilder? _expansion;
  RadiusExpansionBuilder get expansion =>
      _$this._expansion ??= RadiusExpansionBuilder();
  set expansion(RadiusExpansionBuilder? expansion) =>
      _$this._expansion = expansion;

  int? _page;
  int? get page => _$this._page;
  set page(int? page) => _$this._page = page;

  int? _perPage;
  int? get perPage => _$this._perPage;
  set perPage(int? perPage) => _$this._perPage = perPage;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  bool? _hasMore;
  bool? get hasMore => _$this._hasMore;
  set hasMore(bool? hasMore) => _$this._hasMore = hasMore;

  DiscoverySearchMetaBuilder() {
    DiscoverySearchMeta._defaults(this);
  }

  DiscoverySearchMetaBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _correlationId = $v.correlationId;
      _scope = $v.scope.toBuilder();
      _currentAsOf = $v.currentAsOf;
      _eligibilityVersion = $v.eligibilityVersion;
      _projectionVersion = $v.projectionVersion;
      _counts = $v.counts.toBuilder();
      _directory = $v.directory.toBuilder();
      _expansion = $v.expansion.toBuilder();
      _page = $v.page;
      _perPage = $v.perPage;
      _total = $v.total;
      _hasMore = $v.hasMore;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DiscoverySearchMeta other) {
    _$v = other as _$DiscoverySearchMeta;
  }

  @override
  void update(void Function(DiscoverySearchMetaBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DiscoverySearchMeta build() => _build();

  _$DiscoverySearchMeta _build() {
    _$DiscoverySearchMeta _$result;
    try {
      _$result = _$v ??
          _$DiscoverySearchMeta._(
            correlationId: correlationId,
            scope: scope.build(),
            currentAsOf: BuiltValueNullFieldError.checkNotNull(
                currentAsOf, r'DiscoverySearchMeta', 'currentAsOf'),
            eligibilityVersion: BuiltValueNullFieldError.checkNotNull(
                eligibilityVersion,
                r'DiscoverySearchMeta',
                'eligibilityVersion'),
            projectionVersion: BuiltValueNullFieldError.checkNotNull(
                projectionVersion, r'DiscoverySearchMeta', 'projectionVersion'),
            counts: counts.build(),
            directory: directory.build(),
            expansion: expansion.build(),
            page: BuiltValueNullFieldError.checkNotNull(
                page, r'DiscoverySearchMeta', 'page'),
            perPage: BuiltValueNullFieldError.checkNotNull(
                perPage, r'DiscoverySearchMeta', 'perPage'),
            total: BuiltValueNullFieldError.checkNotNull(
                total, r'DiscoverySearchMeta', 'total'),
            hasMore: BuiltValueNullFieldError.checkNotNull(
                hasMore, r'DiscoverySearchMeta', 'hasMore'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'scope';
        scope.build();

        _$failedField = 'counts';
        counts.build();
        _$failedField = 'directory';
        directory.build();
        _$failedField = 'expansion';
        expansion.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'DiscoverySearchMeta', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
