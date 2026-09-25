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

  factory _$VendorTeamActivityEnvelopeMeta(
          [void Function(VendorTeamActivityEnvelopeMetaBuilder)? updates]) =>
      (VendorTeamActivityEnvelopeMetaBuilder()..update(updates))._build();

  _$VendorTeamActivityEnvelopeMeta._(
      {required this.currentPage, required this.lastPage})
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
        lastPage == other.lastPage;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, currentPage.hashCode);
    _$hash = $jc(_$hash, lastPage.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorTeamActivityEnvelopeMeta')
          ..add('currentPage', currentPage)
          ..add('lastPage', lastPage))
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

  VendorTeamActivityEnvelopeMetaBuilder() {
    VendorTeamActivityEnvelopeMeta._defaults(this);
  }

  VendorTeamActivityEnvelopeMetaBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _currentPage = $v.currentPage;
      _lastPage = $v.lastPage;
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
    final _$result = _$v ??
        _$VendorTeamActivityEnvelopeMeta._(
          currentPage: BuiltValueNullFieldError.checkNotNull(
              currentPage, r'VendorTeamActivityEnvelopeMeta', 'currentPage'),
          lastPage: BuiltValueNullFieldError.checkNotNull(
              lastPage, r'VendorTeamActivityEnvelopeMeta', 'lastPage'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
