// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_team_activity_envelope_meta.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorTeamActivityEnvelopeMeta extends VendorTeamActivityEnvelopeMeta {
  @override
  final int currentPage;
  @override
  final int lastPage;
  @override
  final int total;
  @override
  final int totalEvents;
  @override
  final int succeededEvents;
  @override
  final int failedEvents;
  @override
  final BuiltList<VendorTeamActivityEnvelopeMetaCategoriesInner> categories;

  factory _$VendorTeamActivityEnvelopeMeta(
          [void Function(VendorTeamActivityEnvelopeMetaBuilder)? updates]) =>
      (VendorTeamActivityEnvelopeMetaBuilder()..update(updates))._build();

  _$VendorTeamActivityEnvelopeMeta._(
      {required this.currentPage,
      required this.lastPage,
      required this.total,
      required this.totalEvents,
      required this.succeededEvents,
      required this.failedEvents,
      required this.categories})
      : super._();
  @override
  VendorTeamActivityEnvelopeMeta rebuild(
          void Function(VendorTeamActivityEnvelopeMetaBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorTeamActivityEnvelopeMetaBuilder toBuilder() =>
      VendorTeamActivityEnvelopeMetaBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorTeamActivityEnvelopeMeta &&
        currentPage == other.currentPage &&
        lastPage == other.lastPage &&
        total == other.total &&
        totalEvents == other.totalEvents &&
        succeededEvents == other.succeededEvents &&
        failedEvents == other.failedEvents &&
        categories == other.categories;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, currentPage.hashCode);
    _$hash = $jc(_$hash, lastPage.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jc(_$hash, totalEvents.hashCode);
    _$hash = $jc(_$hash, succeededEvents.hashCode);
    _$hash = $jc(_$hash, failedEvents.hashCode);
    _$hash = $jc(_$hash, categories.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorTeamActivityEnvelopeMeta')
          ..add('currentPage', currentPage)
          ..add('lastPage', lastPage)
          ..add('total', total)
          ..add('totalEvents', totalEvents)
          ..add('succeededEvents', succeededEvents)
          ..add('failedEvents', failedEvents)
          ..add('categories', categories))
        .toString();
  }
}

class VendorTeamActivityEnvelopeMetaBuilder
    implements
        Builder<VendorTeamActivityEnvelopeMeta,
            VendorTeamActivityEnvelopeMetaBuilder> {
  _$VendorTeamActivityEnvelopeMeta? _$v;

  int? _currentPage;
  int? get currentPage => _$this._currentPage;
  set currentPage(int? currentPage) => _$this._currentPage = currentPage;

  int? _lastPage;
  int? get lastPage => _$this._lastPage;
  set lastPage(int? lastPage) => _$this._lastPage = lastPage;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  int? _totalEvents;
  int? get totalEvents => _$this._totalEvents;
  set totalEvents(int? totalEvents) => _$this._totalEvents = totalEvents;

  int? _succeededEvents;
  int? get succeededEvents => _$this._succeededEvents;
  set succeededEvents(int? succeededEvents) =>
      _$this._succeededEvents = succeededEvents;

  int? _failedEvents;
  int? get failedEvents => _$this._failedEvents;
  set failedEvents(int? failedEvents) => _$this._failedEvents = failedEvents;

  ListBuilder<VendorTeamActivityEnvelopeMetaCategoriesInner>? _categories;
  ListBuilder<VendorTeamActivityEnvelopeMetaCategoriesInner> get categories =>
      _$this._categories ??=
          ListBuilder<VendorTeamActivityEnvelopeMetaCategoriesInner>();
  set categories(
          ListBuilder<VendorTeamActivityEnvelopeMetaCategoriesInner>?
              categories) =>
      _$this._categories = categories;

  VendorTeamActivityEnvelopeMetaBuilder() {
    VendorTeamActivityEnvelopeMeta._defaults(this);
  }

  VendorTeamActivityEnvelopeMetaBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _currentPage = $v.currentPage;
      _lastPage = $v.lastPage;
      _total = $v.total;
      _totalEvents = $v.totalEvents;
      _succeededEvents = $v.succeededEvents;
      _failedEvents = $v.failedEvents;
      _categories = $v.categories.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorTeamActivityEnvelopeMeta other) {
    _$v = other as _$VendorTeamActivityEnvelopeMeta;
  }

  @override
  void update(void Function(VendorTeamActivityEnvelopeMetaBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorTeamActivityEnvelopeMeta build() => _build();

  _$VendorTeamActivityEnvelopeMeta _build() {
    _$VendorTeamActivityEnvelopeMeta _$result;
    try {
      _$result = _$v ??
          _$VendorTeamActivityEnvelopeMeta._(
            currentPage: BuiltValueNullFieldError.checkNotNull(
                currentPage, r'VendorTeamActivityEnvelopeMeta', 'currentPage'),
            lastPage: BuiltValueNullFieldError.checkNotNull(
                lastPage, r'VendorTeamActivityEnvelopeMeta', 'lastPage'),
            total: BuiltValueNullFieldError.checkNotNull(
                total, r'VendorTeamActivityEnvelopeMeta', 'total'),
            totalEvents: BuiltValueNullFieldError.checkNotNull(
                totalEvents, r'VendorTeamActivityEnvelopeMeta', 'totalEvents'),
            succeededEvents: BuiltValueNullFieldError.checkNotNull(
                succeededEvents,
                r'VendorTeamActivityEnvelopeMeta',
                'succeededEvents'),
            failedEvents: BuiltValueNullFieldError.checkNotNull(failedEvents,
                r'VendorTeamActivityEnvelopeMeta', 'failedEvents'),
            categories: categories.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'categories';
        categories.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'VendorTeamActivityEnvelopeMeta', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
