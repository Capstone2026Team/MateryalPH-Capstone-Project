// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'support_update.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SupportUpdate extends SupportUpdate {
  @override
  final int lockVersion;
  @override
  final String reason;
  @override
  final SupportStatus? status;
  @override
  final String? assignedAdminId;

  factory _$SupportUpdate([void Function(SupportUpdateBuilder)? updates]) =>
      (SupportUpdateBuilder()..update(updates))._build();

  _$SupportUpdate._(
      {required this.lockVersion,
      required this.reason,
      this.status,
      this.assignedAdminId})
      : super._();
  @override
  SupportUpdate rebuild(void Function(SupportUpdateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SupportUpdateBuilder toBuilder() => SupportUpdateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SupportUpdate &&
        lockVersion == other.lockVersion &&
        reason == other.reason &&
        status == other.status &&
        assignedAdminId == other.assignedAdminId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, assignedAdminId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SupportUpdate')
          ..add('lockVersion', lockVersion)
          ..add('reason', reason)
          ..add('status', status)
          ..add('assignedAdminId', assignedAdminId))
        .toString();
  }
}

class SupportUpdateBuilder
    implements Builder<SupportUpdate, SupportUpdateBuilder> {
  _$SupportUpdate? _$v;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  SupportStatus? _status;
  SupportStatus? get status => _$this._status;
  set status(SupportStatus? status) => _$this._status = status;

  String? _assignedAdminId;
  String? get assignedAdminId => _$this._assignedAdminId;
  set assignedAdminId(String? assignedAdminId) =>
      _$this._assignedAdminId = assignedAdminId;

  SupportUpdateBuilder() {
    SupportUpdate._defaults(this);
  }

  SupportUpdateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _lockVersion = $v.lockVersion;
      _reason = $v.reason;
      _status = $v.status;
      _assignedAdminId = $v.assignedAdminId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SupportUpdate other) {
    _$v = other as _$SupportUpdate;
  }

  @override
  void update(void Function(SupportUpdateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SupportUpdate build() => _build();

  _$SupportUpdate _build() {
    final _$result = _$v ??
        _$SupportUpdate._(
          lockVersion: BuiltValueNullFieldError.checkNotNull(
              lockVersion, r'SupportUpdate', 'lockVersion'),
          reason: BuiltValueNullFieldError.checkNotNull(
              reason, r'SupportUpdate', 'reason'),
          status: status,
          assignedAdminId: assignedAdminId,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
