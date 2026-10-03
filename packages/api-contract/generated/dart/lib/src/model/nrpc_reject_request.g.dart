// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nrpc_reject_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$NrpcRejectRequest extends NrpcRejectRequest {
  @override
  final int snapshotVersion;
  @override
  final String nrpcId;
  @override
  final String? reason;

  factory _$NrpcRejectRequest(
          [void Function(NrpcRejectRequestBuilder)? updates]) =>
      (NrpcRejectRequestBuilder()..update(updates))._build();

  _$NrpcRejectRequest._(
      {required this.snapshotVersion, required this.nrpcId, this.reason})
      : super._();
  @override
  NrpcRejectRequest rebuild(void Function(NrpcRejectRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  NrpcRejectRequestBuilder toBuilder() =>
      NrpcRejectRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NrpcRejectRequest &&
        snapshotVersion == other.snapshotVersion &&
        nrpcId == other.nrpcId &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, snapshotVersion.hashCode);
    _$hash = $jc(_$hash, nrpcId.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'NrpcRejectRequest')
          ..add('snapshotVersion', snapshotVersion)
          ..add('nrpcId', nrpcId)
          ..add('reason', reason))
        .toString();
  }
}

class NrpcRejectRequestBuilder
    implements Builder<NrpcRejectRequest, NrpcRejectRequestBuilder> {
  _$NrpcRejectRequest? _$v;

  int? _snapshotVersion;
  int? get snapshotVersion => _$this._snapshotVersion;
  set snapshotVersion(int? snapshotVersion) =>
      _$this._snapshotVersion = snapshotVersion;

  String? _nrpcId;
  String? get nrpcId => _$this._nrpcId;
  set nrpcId(String? nrpcId) => _$this._nrpcId = nrpcId;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  NrpcRejectRequestBuilder() {
    NrpcRejectRequest._defaults(this);
  }

  NrpcRejectRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _snapshotVersion = $v.snapshotVersion;
      _nrpcId = $v.nrpcId;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(NrpcRejectRequest other) {
    _$v = other as _$NrpcRejectRequest;
  }

  @override
  void update(void Function(NrpcRejectRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  NrpcRejectRequest build() => _build();

  _$NrpcRejectRequest _build() {
    final _$result = _$v ??
        _$NrpcRejectRequest._(
          snapshotVersion: BuiltValueNullFieldError.checkNotNull(
              snapshotVersion, r'NrpcRejectRequest', 'snapshotVersion'),
          nrpcId: BuiltValueNullFieldError.checkNotNull(
              nrpcId, r'NrpcRejectRequest', 'nrpcId'),
          reason: reason,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
