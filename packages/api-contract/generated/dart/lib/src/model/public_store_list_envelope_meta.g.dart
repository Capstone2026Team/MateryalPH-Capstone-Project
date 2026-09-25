// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_store_list_envelope_meta.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PublicStoreListEnvelopeMeta extends PublicStoreListEnvelopeMeta {
  @override
  final int currentPage;
  @override
  final int lastPage;
  @override
  final int total;

  factory _$PublicStoreListEnvelopeMeta(
          [void Function(PublicStoreListEnvelopeMetaBuilder)? updates]) =>
      (PublicStoreListEnvelopeMetaBuilder()..update(updates))._build();

  _$PublicStoreListEnvelopeMeta._(
      {required this.currentPage, required this.lastPage, required this.total})
      : super._();
  @override
  PublicStoreListEnvelopeMeta rebuild(
          void Function(PublicStoreListEnvelopeMetaBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PublicStoreListEnvelopeMetaBuilder toBuilder() =>
      PublicStoreListEnvelopeMetaBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PublicStoreListEnvelopeMeta &&
        currentPage == other.currentPage &&
        lastPage == other.lastPage &&
        total == other.total;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, currentPage.hashCode);
    _$hash = $jc(_$hash, lastPage.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PublicStoreListEnvelopeMeta')
          ..add('currentPage', currentPage)
          ..add('lastPage', lastPage)
          ..add('total', total))
        .toString();
  }
}

class PublicStoreListEnvelopeMetaBuilder
    implements
        Builder<PublicStoreListEnvelopeMeta,
            PublicStoreListEnvelopeMetaBuilder> {
  _$PublicStoreListEnvelopeMeta? _$v;

  int? _currentPage;
  int? get currentPage => _$this._currentPage;
  set currentPage(int? currentPage) => _$this._currentPage = currentPage;

  int? _lastPage;
  int? get lastPage => _$this._lastPage;
  set lastPage(int? lastPage) => _$this._lastPage = lastPage;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  PublicStoreListEnvelopeMetaBuilder() {
    PublicStoreListEnvelopeMeta._defaults(this);
  }

  PublicStoreListEnvelopeMetaBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _currentPage = $v.currentPage;
      _lastPage = $v.lastPage;
      _total = $v.total;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PublicStoreListEnvelopeMeta other) {
    _$v = other as _$PublicStoreListEnvelopeMeta;
  }

  @override
  void update(void Function(PublicStoreListEnvelopeMetaBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PublicStoreListEnvelopeMeta build() => _build();

  _$PublicStoreListEnvelopeMeta _build() {
    final _$result = _$v ??
        _$PublicStoreListEnvelopeMeta._(
          currentPage: BuiltValueNullFieldError.checkNotNull(
              currentPage, r'PublicStoreListEnvelopeMeta', 'currentPage'),
          lastPage: BuiltValueNullFieldError.checkNotNull(
              lastPage, r'PublicStoreListEnvelopeMeta', 'lastPage'),
          total: BuiltValueNullFieldError.checkNotNull(
              total, r'PublicStoreListEnvelopeMeta', 'total'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
