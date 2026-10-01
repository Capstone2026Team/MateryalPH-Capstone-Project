// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_decision_result.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ChatDecisionResult extends ChatDecisionResult {
  @override
  final String? orderId;

  factory _$ChatDecisionResult(
          [void Function(ChatDecisionResultBuilder)? updates]) =>
      (ChatDecisionResultBuilder()..update(updates))._build();

  _$ChatDecisionResult._({this.orderId}) : super._();
  @override
  ChatDecisionResult rebuild(
          void Function(ChatDecisionResultBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChatDecisionResultBuilder toBuilder() =>
      ChatDecisionResultBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatDecisionResult && orderId == other.orderId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, orderId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ChatDecisionResult')
          ..add('orderId', orderId))
        .toString();
  }
}

class ChatDecisionResultBuilder
    implements Builder<ChatDecisionResult, ChatDecisionResultBuilder> {
  _$ChatDecisionResult? _$v;

  String? _orderId;
  String? get orderId => _$this._orderId;
  set orderId(String? orderId) => _$this._orderId = orderId;

  ChatDecisionResultBuilder() {
    ChatDecisionResult._defaults(this);
  }

  ChatDecisionResultBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _orderId = $v.orderId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChatDecisionResult other) {
    _$v = other as _$ChatDecisionResult;
  }

  @override
  void update(void Function(ChatDecisionResultBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChatDecisionResult build() => _build();

  _$ChatDecisionResult _build() {
    final _$result = _$v ??
        _$ChatDecisionResult._(
          orderId: orderId,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
