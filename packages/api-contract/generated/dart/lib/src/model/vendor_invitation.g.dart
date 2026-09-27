// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_invitation.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorInvitation extends VendorInvitation {
  @override
  final bool queued;
  @override
  final String? invitationId;
  @override
  final String? role;
  @override
  final DateTime? expiresAt;

  factory _$VendorInvitation(
          [void Function(VendorInvitationBuilder)? updates]) =>
      (VendorInvitationBuilder()..update(updates))._build();

  _$VendorInvitation._(
      {required this.queued, this.invitationId, this.role, this.expiresAt})
      : super._();
  @override
  VendorInvitation rebuild(void Function(VendorInvitationBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorInvitationBuilder toBuilder() =>
      VendorInvitationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorInvitation &&
        queued == other.queued &&
        invitationId == other.invitationId &&
        role == other.role &&
        expiresAt == other.expiresAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, queued.hashCode);
    _$hash = $jc(_$hash, invitationId.hashCode);
    _$hash = $jc(_$hash, role.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorInvitation')
          ..add('queued', queued)
          ..add('invitationId', invitationId)
          ..add('role', role)
          ..add('expiresAt', expiresAt))
        .toString();
  }
}

class VendorInvitationBuilder
    implements Builder<VendorInvitation, VendorInvitationBuilder> {
  _$VendorInvitation? _$v;

  bool? _queued;
  bool? get queued => _$this._queued;
  set queued(bool? queued) => _$this._queued = queued;

  String? _invitationId;
  String? get invitationId => _$this._invitationId;
  set invitationId(String? invitationId) => _$this._invitationId = invitationId;

  String? _role;
  String? get role => _$this._role;
  set role(String? role) => _$this._role = role;

  DateTime? _expiresAt;
  DateTime? get expiresAt => _$this._expiresAt;
  set expiresAt(DateTime? expiresAt) => _$this._expiresAt = expiresAt;

  VendorInvitationBuilder() {
    VendorInvitation._defaults(this);
  }

  VendorInvitationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _queued = $v.queued;
      _invitationId = $v.invitationId;
      _role = $v.role;
      _expiresAt = $v.expiresAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorInvitation other) {
    _$v = other as _$VendorInvitation;
  }

  @override
  void update(void Function(VendorInvitationBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorInvitation build() => _build();

  _$VendorInvitation _build() {
    final _$result = _$v ??
        _$VendorInvitation._(
          queued: BuiltValueNullFieldError.checkNotNull(
              queued, r'VendorInvitation', 'queued'),
          invitationId: invitationId,
          role: role,
          expiresAt: expiresAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
