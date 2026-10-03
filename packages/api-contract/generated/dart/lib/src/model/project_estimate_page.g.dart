// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_estimate_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProjectEstimatePage extends ProjectEstimatePage {
  @override
  final ProjectCompiledEstimate? estimate;
  @override
  final BuiltList<ProjectCandidate> items;
  @override
  final int page;
  @override
  final bool hasMore;
  @override
  final int total;
  @override
  final int? suggestedRadiusKm;

  factory _$ProjectEstimatePage(
          [void Function(ProjectEstimatePageBuilder)? updates]) =>
      (ProjectEstimatePageBuilder()..update(updates))._build();

  _$ProjectEstimatePage._(
      {this.estimate,
      required this.items,
      required this.page,
      required this.hasMore,
      required this.total,
      this.suggestedRadiusKm})
      : super._();
  @override
  ProjectEstimatePage rebuild(
          void Function(ProjectEstimatePageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProjectEstimatePageBuilder toBuilder() =>
      ProjectEstimatePageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProjectEstimatePage &&
        estimate == other.estimate &&
        items == other.items &&
        page == other.page &&
        hasMore == other.hasMore &&
        total == other.total &&
        suggestedRadiusKm == other.suggestedRadiusKm;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, estimate.hashCode);
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jc(_$hash, page.hashCode);
    _$hash = $jc(_$hash, hasMore.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jc(_$hash, suggestedRadiusKm.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProjectEstimatePage')
          ..add('estimate', estimate)
          ..add('items', items)
          ..add('page', page)
          ..add('hasMore', hasMore)
          ..add('total', total)
          ..add('suggestedRadiusKm', suggestedRadiusKm))
        .toString();
  }
}

class ProjectEstimatePageBuilder
    implements Builder<ProjectEstimatePage, ProjectEstimatePageBuilder> {
  _$ProjectEstimatePage? _$v;

  ProjectCompiledEstimateBuilder? _estimate;
  ProjectCompiledEstimateBuilder get estimate =>
      _$this._estimate ??= ProjectCompiledEstimateBuilder();
  set estimate(ProjectCompiledEstimateBuilder? estimate) =>
      _$this._estimate = estimate;

  ListBuilder<ProjectCandidate>? _items;
  ListBuilder<ProjectCandidate> get items =>
      _$this._items ??= ListBuilder<ProjectCandidate>();
  set items(ListBuilder<ProjectCandidate>? items) => _$this._items = items;

  int? _page;
  int? get page => _$this._page;
  set page(int? page) => _$this._page = page;

  bool? _hasMore;
  bool? get hasMore => _$this._hasMore;
  set hasMore(bool? hasMore) => _$this._hasMore = hasMore;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  int? _suggestedRadiusKm;
  int? get suggestedRadiusKm => _$this._suggestedRadiusKm;
  set suggestedRadiusKm(int? suggestedRadiusKm) =>
      _$this._suggestedRadiusKm = suggestedRadiusKm;

  ProjectEstimatePageBuilder() {
    ProjectEstimatePage._defaults(this);
  }

  ProjectEstimatePageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _estimate = $v.estimate?.toBuilder();
      _items = $v.items.toBuilder();
      _page = $v.page;
      _hasMore = $v.hasMore;
      _total = $v.total;
      _suggestedRadiusKm = $v.suggestedRadiusKm;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProjectEstimatePage other) {
    _$v = other as _$ProjectEstimatePage;
  }

  @override
  void update(void Function(ProjectEstimatePageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProjectEstimatePage build() => _build();

  _$ProjectEstimatePage _build() {
    _$ProjectEstimatePage _$result;
    try {
      _$result = _$v ??
          _$ProjectEstimatePage._(
            estimate: _estimate?.build(),
            items: items.build(),
            page: BuiltValueNullFieldError.checkNotNull(
                page, r'ProjectEstimatePage', 'page'),
            hasMore: BuiltValueNullFieldError.checkNotNull(
                hasMore, r'ProjectEstimatePage', 'hasMore'),
            total: BuiltValueNullFieldError.checkNotNull(
                total, r'ProjectEstimatePage', 'total'),
            suggestedRadiusKm: suggestedRadiusKm,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'estimate';
        _estimate?.build();
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ProjectEstimatePage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
