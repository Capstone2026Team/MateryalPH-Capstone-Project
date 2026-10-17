// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dispute_list_meta.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DisputeListMeta extends DisputeListMeta {
  @override
  final int? page;
  @override
  final int? perPage;
  @override
  final int? total;
  @override
  final bool? hasMore;
  @override
  final String? group;
  @override
  final String? status;
  @override
  final BuiltMap<String, int>? counts;

  factory _$DisputeListMeta([void Function(DisputeListMetaBuilder)? updates]) =>
      (DisputeListMetaBuilder()..update(updates))._build();

  _$DisputeListMeta._(
      {this.page,
      this.perPage,
      this.total,
      this.hasMore,
      this.group,
      this.status,
      this.counts})
      : super._();
  @override
  DisputeListMeta rebuild(void Function(DisputeListMetaBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DisputeListMetaBuilder toBuilder() => DisputeListMetaBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DisputeListMeta &&
        page == other.page &&
        perPage == other.perPage &&
        total == other.total &&
        hasMore == other.hasMore &&
        group == other.group &&
        status == other.status &&
        counts == other.counts;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, page.hashCode);
    _$hash = $jc(_$hash, perPage.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jc(_$hash, hasMore.hashCode);
    _$hash = $jc(_$hash, group.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, counts.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DisputeListMeta')
          ..add('page', page)
          ..add('perPage', perPage)
          ..add('total', total)
          ..add('hasMore', hasMore)
          ..add('group', group)
          ..add('status', status)
          ..add('counts', counts))
        .toString();
  }
}

class DisputeListMetaBuilder
    implements Builder<DisputeListMeta, DisputeListMetaBuilder> {
  _$DisputeListMeta? _$v;

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

  String? _group;
  String? get group => _$this._group;
  set group(String? group) => _$this._group = group;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  MapBuilder<String, int>? _counts;
  MapBuilder<String, int> get counts =>
      _$this._counts ??= MapBuilder<String, int>();
  set counts(MapBuilder<String, int>? counts) => _$this._counts = counts;

  DisputeListMetaBuilder() {
    DisputeListMeta._defaults(this);
  }

  DisputeListMetaBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _page = $v.page;
      _perPage = $v.perPage;
      _total = $v.total;
      _hasMore = $v.hasMore;
      _group = $v.group;
      _status = $v.status;
      _counts = $v.counts?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DisputeListMeta other) {
    _$v = other as _$DisputeListMeta;
  }

  @override
  void update(void Function(DisputeListMetaBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DisputeListMeta build() => _build();

  _$DisputeListMeta _build() {
    _$DisputeListMeta _$result;
    try {
      _$result = _$v ??
          _$DisputeListMeta._(
            page: page,
            perPage: perPage,
            total: total,
            hasMore: hasMore,
            group: group,
            status: status,
            counts: _counts?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'counts';
        _counts?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'DisputeListMeta', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
