// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nrpc_flag_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$NrpcFlagRequest extends NrpcFlagRequest {
  @override
  final String nrpcId;
  @override
  final String reason;

  factory _$NrpcFlagRequest([void Function(NrpcFlagRequestBuilder)? updates]) =>
      (NrpcFlagRequestBuilder()..update(updates))._build();

  _$NrpcFlagRequest._({required this.nrpcId, required this.reason}) : super._();
  @override
  NrpcFlagRequest rebuild(void Function(NrpcFlagRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  NrpcFlagRequestBuilder toBuilder() => NrpcFlagRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NrpcFlagRequest &&
        nrpcId == other.nrpcId &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, nrpcId.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'NrpcFlagRequest')
          ..add('nrpcId', nrpcId)
          ..add('reason', reason))
        .toString();
  }
}

class NrpcFlagRequestBuilder
    implements Builder<NrpcFlagRequest, NrpcFlagRequestBuilder> {
  _$NrpcFlagRequest? _$v;

  String? _nrpcId;
  String? get nrpcId => _$this._nrpcId;
  set nrpcId(String? nrpcId) => _$this._nrpcId = nrpcId;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  NrpcFlagRequestBuilder() {
    NrpcFlagRequest._defaults(this);
  }

  NrpcFlagRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _nrpcId = $v.nrpcId;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(NrpcFlagRequest other) {
    _$v = other as _$NrpcFlagRequest;
  }

  @override
  void update(void Function(NrpcFlagRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  NrpcFlagRequest build() => _build();

  _$NrpcFlagRequest _build() {
    final _$result = _$v ??
        _$NrpcFlagRequest._(
          nrpcId: BuiltValueNullFieldError.checkNotNull(
              nrpcId, r'NrpcFlagRequest', 'nrpcId'),
          reason: BuiltValueNullFieldError.checkNotNull(
              reason, r'NrpcFlagRequest', 'reason'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
