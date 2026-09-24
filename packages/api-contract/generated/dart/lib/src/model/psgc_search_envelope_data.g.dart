// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'psgc_search_envelope_data.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PsgcSearchEnvelopeData extends PsgcSearchEnvelopeData {
  @override
  final BuiltList<PsgcArea> items;
  @override
  final int page;
  @override
  final bool hasMore;
  @override
  final String versionId;

  factory _$PsgcSearchEnvelopeData(
          [void Function(PsgcSearchEnvelopeDataBuilder)? updates]) =>
      (PsgcSearchEnvelopeDataBuilder()..update(updates))._build();

  _$PsgcSearchEnvelopeData._(
      {required this.items,
      required this.page,
      required this.hasMore,
      required this.versionId})
      : super._();
  @override
  PsgcSearchEnvelopeData rebuild(
          void Function(PsgcSearchEnvelopeDataBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PsgcSearchEnvelopeDataBuilder toBuilder() =>
      PsgcSearchEnvelopeDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PsgcSearchEnvelopeData &&
        items == other.items &&
        page == other.page &&
        hasMore == other.hasMore &&
        versionId == other.versionId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jc(_$hash, page.hashCode);
    _$hash = $jc(_$hash, hasMore.hashCode);
    _$hash = $jc(_$hash, versionId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PsgcSearchEnvelopeData')
          ..add('items', items)
          ..add('page', page)
          ..add('hasMore', hasMore)
          ..add('versionId', versionId))
        .toString();
  }
}

class PsgcSearchEnvelopeDataBuilder
    implements Builder<PsgcSearchEnvelopeData, PsgcSearchEnvelopeDataBuilder> {
  _$PsgcSearchEnvelopeData? _$v;

  ListBuilder<PsgcArea>? _items;
  ListBuilder<PsgcArea> get items => _$this._items ??= ListBuilder<PsgcArea>();
  set items(ListBuilder<PsgcArea>? items) => _$this._items = items;

  int? _page;
  int? get page => _$this._page;
  set page(int? page) => _$this._page = page;

  bool? _hasMore;
  bool? get hasMore => _$this._hasMore;
  set hasMore(bool? hasMore) => _$this._hasMore = hasMore;

  String? _versionId;
  String? get versionId => _$this._versionId;
  set versionId(String? versionId) => _$this._versionId = versionId;

  PsgcSearchEnvelopeDataBuilder() {
    PsgcSearchEnvelopeData._defaults(this);
  }

  PsgcSearchEnvelopeDataBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _page = $v.page;
      _hasMore = $v.hasMore;
      _versionId = $v.versionId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PsgcSearchEnvelopeData other) {
    _$v = other as _$PsgcSearchEnvelopeData;
  }

  @override
  void update(void Function(PsgcSearchEnvelopeDataBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PsgcSearchEnvelopeData build() => _build();

  _$PsgcSearchEnvelopeData _build() {
    _$PsgcSearchEnvelopeData _$result;
    try {
      _$result = _$v ??
          _$PsgcSearchEnvelopeData._(
            items: items.build(),
            page: BuiltValueNullFieldError.checkNotNull(
                page, r'PsgcSearchEnvelopeData', 'page'),
            hasMore: BuiltValueNullFieldError.checkNotNull(
                hasMore, r'PsgcSearchEnvelopeData', 'hasMore'),
            versionId: BuiltValueNullFieldError.checkNotNull(
                versionId, r'PsgcSearchEnvelopeData', 'versionId'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PsgcSearchEnvelopeData', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
