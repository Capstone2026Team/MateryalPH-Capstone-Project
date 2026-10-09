// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_team_invitation_list_envelope_meta.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorTeamInvitationListEnvelopeMeta
    extends VendorTeamInvitationListEnvelopeMeta {
  @override
  final int currentPage;
  @override
  final int lastPage;

  factory _$VendorTeamInvitationListEnvelopeMeta(
          [void Function(VendorTeamInvitationListEnvelopeMetaBuilder)?
              updates]) =>
      (VendorTeamInvitationListEnvelopeMetaBuilder()..update(updates))._build();

  _$VendorTeamInvitationListEnvelopeMeta._(
      {required this.currentPage, required this.lastPage})
      : super._();
  @override
  VendorTeamInvitationListEnvelopeMeta rebuild(
          void Function(VendorTeamInvitationListEnvelopeMetaBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorTeamInvitationListEnvelopeMetaBuilder toBuilder() =>
      VendorTeamInvitationListEnvelopeMetaBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorTeamInvitationListEnvelopeMeta &&
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
    return (newBuiltValueToStringHelper(r'VendorTeamInvitationListEnvelopeMeta')
          ..add('currentPage', currentPage)
          ..add('lastPage', lastPage))
        .toString();
  }
}

class VendorTeamInvitationListEnvelopeMetaBuilder
    implements
        Builder<VendorTeamInvitationListEnvelopeMeta,
            VendorTeamInvitationListEnvelopeMetaBuilder> {
  _$VendorTeamInvitationListEnvelopeMeta? _$v;

  int? _currentPage;
  int? get currentPage => _$this._currentPage;
  set currentPage(int? currentPage) => _$this._currentPage = currentPage;

  int? _lastPage;
  int? get lastPage => _$this._lastPage;
  set lastPage(int? lastPage) => _$this._lastPage = lastPage;

  VendorTeamInvitationListEnvelopeMetaBuilder() {
    VendorTeamInvitationListEnvelopeMeta._defaults(this);
  }

  VendorTeamInvitationListEnvelopeMetaBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _currentPage = $v.currentPage;
      _lastPage = $v.lastPage;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorTeamInvitationListEnvelopeMeta other) {
    _$v = other as _$VendorTeamInvitationListEnvelopeMeta;
  }

  @override
  void update(
      void Function(VendorTeamInvitationListEnvelopeMetaBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorTeamInvitationListEnvelopeMeta build() => _build();

  _$VendorTeamInvitationListEnvelopeMeta _build() {
    final _$result = _$v ??
        _$VendorTeamInvitationListEnvelopeMeta._(
          currentPage: BuiltValueNullFieldError.checkNotNull(currentPage,
              r'VendorTeamInvitationListEnvelopeMeta', 'currentPage'),
          lastPage: BuiltValueNullFieldError.checkNotNull(
              lastPage, r'VendorTeamInvitationListEnvelopeMeta', 'lastPage'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
