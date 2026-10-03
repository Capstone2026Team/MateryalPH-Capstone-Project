// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_transfer.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ChatTransfer extends ChatTransfer {
  @override
  final int handlerUserId;
  @override
  final int lockVersion;
  @override
  final String reason;

  factory _$ChatTransfer([void Function(ChatTransferBuilder)? updates]) =>
      (ChatTransferBuilder()..update(updates))._build();

  _$ChatTransfer._(
      {required this.handlerUserId,
      required this.lockVersion,
      required this.reason})
      : super._();
  @override
  ChatTransfer rebuild(void Function(ChatTransferBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChatTransferBuilder toBuilder() => ChatTransferBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatTransfer &&
        handlerUserId == other.handlerUserId &&
        lockVersion == other.lockVersion &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, handlerUserId.hashCode);
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ChatTransfer')
          ..add('handlerUserId', handlerUserId)
          ..add('lockVersion', lockVersion)
          ..add('reason', reason))
        .toString();
  }
}

class ChatTransferBuilder
    implements Builder<ChatTransfer, ChatTransferBuilder> {
  _$ChatTransfer? _$v;

  int? _handlerUserId;
  int? get handlerUserId => _$this._handlerUserId;
  set handlerUserId(int? handlerUserId) =>
      _$this._handlerUserId = handlerUserId;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  ChatTransferBuilder() {
    ChatTransfer._defaults(this);
  }

  ChatTransferBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _handlerUserId = $v.handlerUserId;
      _lockVersion = $v.lockVersion;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChatTransfer other) {
    _$v = other as _$ChatTransfer;
  }

  @override
  void update(void Function(ChatTransferBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChatTransfer build() => _build();

  _$ChatTransfer _build() {
    final _$result = _$v ??
        _$ChatTransfer._(
          handlerUserId: BuiltValueNullFieldError.checkNotNull(
              handlerUserId, r'ChatTransfer', 'handlerUserId'),
          lockVersion: BuiltValueNullFieldError.checkNotNull(
              lockVersion, r'ChatTransfer', 'lockVersion'),
          reason: BuiltValueNullFieldError.checkNotNull(
              reason, r'ChatTransfer', 'reason'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
