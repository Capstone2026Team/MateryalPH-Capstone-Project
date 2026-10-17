// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_list_meta.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ReviewListMeta extends ReviewListMeta {
  @override
  final int? page;
  @override
  final int? perPage;
  @override
  final int? total;
  @override
  final String? type;
  @override
  final BuiltMap<String, JsonObject?>? summary;
  @override
  final PublicScores? scores;
  @override
  final String? correlationId;

  factory _$ReviewListMeta([void Function(ReviewListMetaBuilder)? updates]) =>
      (ReviewListMetaBuilder()..update(updates))._build();

  _$ReviewListMeta._(
      {this.page,
      this.perPage,
      this.total,
      this.type,
      this.summary,
      this.scores,
      this.correlationId})
      : super._();
  @override
  ReviewListMeta rebuild(void Function(ReviewListMetaBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ReviewListMetaBuilder toBuilder() => ReviewListMetaBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ReviewListMeta &&
        page == other.page &&
        perPage == other.perPage &&
        total == other.total &&
        type == other.type &&
        summary == other.summary &&
        scores == other.scores &&
        correlationId == other.correlationId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, page.hashCode);
    _$hash = $jc(_$hash, perPage.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, summary.hashCode);
    _$hash = $jc(_$hash, scores.hashCode);
    _$hash = $jc(_$hash, correlationId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ReviewListMeta')
          ..add('page', page)
          ..add('perPage', perPage)
          ..add('total', total)
          ..add('type', type)
          ..add('summary', summary)
          ..add('scores', scores)
          ..add('correlationId', correlationId))
        .toString();
  }
}

class ReviewListMetaBuilder
    implements Builder<ReviewListMeta, ReviewListMetaBuilder> {
  _$ReviewListMeta? _$v;

  int? _page;
  int? get page => _$this._page;
  set page(int? page) => _$this._page = page;

  int? _perPage;
  int? get perPage => _$this._perPage;
  set perPage(int? perPage) => _$this._perPage = perPage;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  MapBuilder<String, JsonObject?>? _summary;
  MapBuilder<String, JsonObject?> get summary =>
      _$this._summary ??= MapBuilder<String, JsonObject?>();
  set summary(MapBuilder<String, JsonObject?>? summary) =>
      _$this._summary = summary;

  PublicScoresBuilder? _scores;
  PublicScoresBuilder get scores => _$this._scores ??= PublicScoresBuilder();
  set scores(PublicScoresBuilder? scores) => _$this._scores = scores;

  String? _correlationId;
  String? get correlationId => _$this._correlationId;
  set correlationId(String? correlationId) =>
      _$this._correlationId = correlationId;

  ReviewListMetaBuilder() {
    ReviewListMeta._defaults(this);
  }

  ReviewListMetaBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _page = $v.page;
      _perPage = $v.perPage;
      _total = $v.total;
      _type = $v.type;
      _summary = $v.summary?.toBuilder();
      _scores = $v.scores?.toBuilder();
      _correlationId = $v.correlationId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ReviewListMeta other) {
    _$v = other as _$ReviewListMeta;
  }

  @override
  void update(void Function(ReviewListMetaBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ReviewListMeta build() => _build();

  _$ReviewListMeta _build() {
    _$ReviewListMeta _$result;
    try {
      _$result = _$v ??
          _$ReviewListMeta._(
            page: page,
            perPage: perPage,
            total: total,
            type: type,
            summary: _summary?.build(),
            scores: _scores?.build(),
            correlationId: correlationId,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'summary';
        _summary?.build();
        _$failedField = 'scores';
        _scores?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ReviewListMeta', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
