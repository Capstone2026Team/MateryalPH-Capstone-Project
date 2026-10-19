// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_arrangement_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ProjectArrangementPageSortEnum
    _$projectArrangementPageSortEnum_BEST_MATCH =
    const ProjectArrangementPageSortEnum._('BEST_MATCH');
const ProjectArrangementPageSortEnum _$projectArrangementPageSortEnum_PRICE =
    const ProjectArrangementPageSortEnum._('PRICE');

ProjectArrangementPageSortEnum _$projectArrangementPageSortEnumValueOf(
    String name) {
  switch (name) {
    case 'BEST_MATCH':
      return _$projectArrangementPageSortEnum_BEST_MATCH;
    case 'PRICE':
      return _$projectArrangementPageSortEnum_PRICE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ProjectArrangementPageSortEnum>
    _$projectArrangementPageSortEnumValues = BuiltSet<
        ProjectArrangementPageSortEnum>(const <ProjectArrangementPageSortEnum>[
  _$projectArrangementPageSortEnum_BEST_MATCH,
  _$projectArrangementPageSortEnum_PRICE,
]);

Serializer<ProjectArrangementPageSortEnum>
    _$projectArrangementPageSortEnumSerializer =
    _$ProjectArrangementPageSortEnumSerializer();

class _$ProjectArrangementPageSortEnumSerializer
    implements PrimitiveSerializer<ProjectArrangementPageSortEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'BEST_MATCH': 'BEST_MATCH',
    'PRICE': 'PRICE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'BEST_MATCH': 'BEST_MATCH',
    'PRICE': 'PRICE',
  };

  @override
  final Iterable<Type> types = const <Type>[ProjectArrangementPageSortEnum];
  @override
  final String wireName = 'ProjectArrangementPageSortEnum';

  @override
  Object serialize(
          Serializers serializers, ProjectArrangementPageSortEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ProjectArrangementPageSortEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ProjectArrangementPageSortEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ProjectArrangementPage extends ProjectArrangementPage {
  @override
  final ProjectArrangementPageSortEnum? sort;
  @override
  final ProjectCompiledEstimate? estimate;
  @override
  final BuiltList<ProjectArrangement> items;
  @override
  final int page;
  @override
  final bool hasMore;
  @override
  final int total;
  @override
  final int unfilteredTotal;

  factory _$ProjectArrangementPage(
          [void Function(ProjectArrangementPageBuilder)? updates]) =>
      (ProjectArrangementPageBuilder()..update(updates))._build();

  _$ProjectArrangementPage._(
      {this.sort,
      this.estimate,
      required this.items,
      required this.page,
      required this.hasMore,
      required this.total,
      required this.unfilteredTotal})
      : super._();
  @override
  ProjectArrangementPage rebuild(
          void Function(ProjectArrangementPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProjectArrangementPageBuilder toBuilder() =>
      ProjectArrangementPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProjectArrangementPage &&
        sort == other.sort &&
        estimate == other.estimate &&
        items == other.items &&
        page == other.page &&
        hasMore == other.hasMore &&
        total == other.total &&
        unfilteredTotal == other.unfilteredTotal;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, sort.hashCode);
    _$hash = $jc(_$hash, estimate.hashCode);
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jc(_$hash, page.hashCode);
    _$hash = $jc(_$hash, hasMore.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jc(_$hash, unfilteredTotal.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProjectArrangementPage')
          ..add('sort', sort)
          ..add('estimate', estimate)
          ..add('items', items)
          ..add('page', page)
          ..add('hasMore', hasMore)
          ..add('total', total)
          ..add('unfilteredTotal', unfilteredTotal))
        .toString();
  }
}

class ProjectArrangementPageBuilder
    implements Builder<ProjectArrangementPage, ProjectArrangementPageBuilder> {
  _$ProjectArrangementPage? _$v;

  ProjectArrangementPageSortEnum? _sort;
  ProjectArrangementPageSortEnum? get sort => _$this._sort;
  set sort(ProjectArrangementPageSortEnum? sort) => _$this._sort = sort;

  ProjectCompiledEstimateBuilder? _estimate;
  ProjectCompiledEstimateBuilder get estimate =>
      _$this._estimate ??= ProjectCompiledEstimateBuilder();
  set estimate(ProjectCompiledEstimateBuilder? estimate) =>
      _$this._estimate = estimate;

  ListBuilder<ProjectArrangement>? _items;
  ListBuilder<ProjectArrangement> get items =>
      _$this._items ??= ListBuilder<ProjectArrangement>();
  set items(ListBuilder<ProjectArrangement>? items) => _$this._items = items;

  int? _page;
  int? get page => _$this._page;
  set page(int? page) => _$this._page = page;

  bool? _hasMore;
  bool? get hasMore => _$this._hasMore;
  set hasMore(bool? hasMore) => _$this._hasMore = hasMore;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  int? _unfilteredTotal;
  int? get unfilteredTotal => _$this._unfilteredTotal;
  set unfilteredTotal(int? unfilteredTotal) =>
      _$this._unfilteredTotal = unfilteredTotal;

  ProjectArrangementPageBuilder() {
    ProjectArrangementPage._defaults(this);
  }

  ProjectArrangementPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _sort = $v.sort;
      _estimate = $v.estimate?.toBuilder();
      _items = $v.items.toBuilder();
      _page = $v.page;
      _hasMore = $v.hasMore;
      _total = $v.total;
      _unfilteredTotal = $v.unfilteredTotal;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProjectArrangementPage other) {
    _$v = other as _$ProjectArrangementPage;
  }

  @override
  void update(void Function(ProjectArrangementPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProjectArrangementPage build() => _build();

  _$ProjectArrangementPage _build() {
    _$ProjectArrangementPage _$result;
    try {
      _$result = _$v ??
          _$ProjectArrangementPage._(
            sort: sort,
            estimate: _estimate?.build(),
            items: items.build(),
            page: BuiltValueNullFieldError.checkNotNull(
                page, r'ProjectArrangementPage', 'page'),
            hasMore: BuiltValueNullFieldError.checkNotNull(
                hasMore, r'ProjectArrangementPage', 'hasMore'),
            total: BuiltValueNullFieldError.checkNotNull(
                total, r'ProjectArrangementPage', 'total'),
            unfilteredTotal: BuiltValueNullFieldError.checkNotNull(
                unfilteredTotal, r'ProjectArrangementPage', 'unfilteredTotal'),
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
            r'ProjectArrangementPage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
