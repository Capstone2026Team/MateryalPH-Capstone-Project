// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_decision.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ChatDecision extends ChatDecision {
  @override
  final String versionId;
  @override
  final String? contentHash;
  @override
  final String? reason;
  @override
  final bool? nrpcAcknowledged;
  @override
  final String? nrpcTermsVersionId;

  factory _$ChatDecision([void Function(ChatDecisionBuilder)? updates]) =>
      (ChatDecisionBuilder()..update(updates))._build();

  _$ChatDecision._(
      {required this.versionId,
      this.contentHash,
      this.reason,
      this.nrpcAcknowledged,
      this.nrpcTermsVersionId})
      : super._();
  @override
  ChatDecision rebuild(void Function(ChatDecisionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChatDecisionBuilder toBuilder() => ChatDecisionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatDecision &&
        versionId == other.versionId &&
        contentHash == other.contentHash &&
        reason == other.reason &&
        nrpcAcknowledged == other.nrpcAcknowledged &&
        nrpcTermsVersionId == other.nrpcTermsVersionId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, versionId.hashCode);
    _$hash = $jc(_$hash, contentHash.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, nrpcAcknowledged.hashCode);
    _$hash = $jc(_$hash, nrpcTermsVersionId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ChatDecision')
          ..add('versionId', versionId)
          ..add('contentHash', contentHash)
          ..add('reason', reason)
          ..add('nrpcAcknowledged', nrpcAcknowledged)
          ..add('nrpcTermsVersionId', nrpcTermsVersionId))
        .toString();
  }
}

class ChatDecisionBuilder
    implements Builder<ChatDecision, ChatDecisionBuilder> {
  _$ChatDecision? _$v;

  String? _versionId;
  String? get versionId => _$this._versionId;
  set versionId(String? versionId) => _$this._versionId = versionId;

  String? _contentHash;
  String? get contentHash => _$this._contentHash;
  set contentHash(String? contentHash) => _$this._contentHash = contentHash;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  bool? _nrpcAcknowledged;
  bool? get nrpcAcknowledged => _$this._nrpcAcknowledged;
  set nrpcAcknowledged(bool? nrpcAcknowledged) =>
      _$this._nrpcAcknowledged = nrpcAcknowledged;

  String? _nrpcTermsVersionId;
  String? get nrpcTermsVersionId => _$this._nrpcTermsVersionId;
  set nrpcTermsVersionId(String? nrpcTermsVersionId) =>
      _$this._nrpcTermsVersionId = nrpcTermsVersionId;

  ChatDecisionBuilder() {
    ChatDecision._defaults(this);
  }

  ChatDecisionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _versionId = $v.versionId;
      _contentHash = $v.contentHash;
      _reason = $v.reason;
      _nrpcAcknowledged = $v.nrpcAcknowledged;
      _nrpcTermsVersionId = $v.nrpcTermsVersionId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChatDecision other) {
    _$v = other as _$ChatDecision;
  }

  @override
  void update(void Function(ChatDecisionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChatDecision build() => _build();

  _$ChatDecision _build() {
    final _$result = _$v ??
        _$ChatDecision._(
          versionId: BuiltValueNullFieldError.checkNotNull(
              versionId, r'ChatDecision', 'versionId'),
          contentHash: contentHash,
          reason: reason,
          nrpcAcknowledged: nrpcAcknowledged,
          nrpcTermsVersionId: nrpcTermsVersionId,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
