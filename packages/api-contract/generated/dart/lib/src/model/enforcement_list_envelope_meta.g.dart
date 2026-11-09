// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enforcement_list_envelope_meta.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$EnforcementListEnvelopeMeta extends EnforcementListEnvelopeMeta {
  @override
  final int page;
  @override
  final int perPage;
  @override
  final int total;
  @override
  final bool hasMore;
  @override
  final BuiltMap<String, int> counts;

  factory _$EnforcementListEnvelopeMeta(
          [void Function(EnforcementListEnvelopeMetaBuilder)? updates]) =>
      (EnforcementListEnvelopeMetaBuilder()..update(updates))._build();

  _$EnforcementListEnvelopeMeta._(
      {required this.page,
      required this.perPage,
      required this.total,
      required this.hasMore,
      required this.counts})
      : super._();
  @override
  EnforcementListEnvelopeMeta rebuild(
          void Function(EnforcementListEnvelopeMetaBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  EnforcementListEnvelopeMetaBuilder toBuilder() =>
      EnforcementListEnvelopeMetaBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EnforcementListEnvelopeMeta &&
        page == other.page &&
        perPage == other.perPage &&
        total == other.total &&
        hasMore == other.hasMore &&
        counts == other.counts;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, page.hashCode);
    _$hash = $jc(_$hash, perPage.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jc(_$hash, hasMore.hashCode);
    _$hash = $jc(_$hash, counts.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'EnforcementListEnvelopeMeta')
          ..add('page', page)
          ..add('perPage', perPage)
          ..add('total', total)
          ..add('hasMore', hasMore)
          ..add('counts', counts))
        .toString();
  }
}

class EnforcementListEnvelopeMetaBuilder
    implements
        Builder<EnforcementListEnvelopeMeta,
            EnforcementListEnvelopeMetaBuilder> {
  _$EnforcementListEnvelopeMeta? _$v;

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

  MapBuilder<String, int>? _counts;
  MapBuilder<String, int> get counts =>
      _$this._counts ??= MapBuilder<String, int>();
  set counts(MapBuilder<String, int>? counts) => _$this._counts = counts;

  EnforcementListEnvelopeMetaBuilder() {
    EnforcementListEnvelopeMeta._defaults(this);
  }

  EnforcementListEnvelopeMetaBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _page = $v.page;
      _perPage = $v.perPage;
      _total = $v.total;
      _hasMore = $v.hasMore;
      _counts = $v.counts.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EnforcementListEnvelopeMeta other) {
    _$v = other as _$EnforcementListEnvelopeMeta;
  }

  @override
  void update(void Function(EnforcementListEnvelopeMetaBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EnforcementListEnvelopeMeta build() => _build();

  _$EnforcementListEnvelopeMeta _build() {
    _$EnforcementListEnvelopeMeta _$result;
    try {
      _$result = _$v ??
          _$EnforcementListEnvelopeMeta._(
            page: BuiltValueNullFieldError.checkNotNull(
                page, r'EnforcementListEnvelopeMeta', 'page'),
            perPage: BuiltValueNullFieldError.checkNotNull(
                perPage, r'EnforcementListEnvelopeMeta', 'perPage'),
            total: BuiltValueNullFieldError.checkNotNull(
                total, r'EnforcementListEnvelopeMeta', 'total'),
            hasMore: BuiltValueNullFieldError.checkNotNull(
                hasMore, r'EnforcementListEnvelopeMeta', 'hasMore'),
            counts: counts.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'counts';
        counts.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'EnforcementListEnvelopeMeta', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
