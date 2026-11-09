// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_automated_choice.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ChatAutomatedChoice extends ChatAutomatedChoice {
  @override
  final String welcomeMessageId;
  @override
  final int optionIndex;
  @override
  final String clientMessageId;

  factory _$ChatAutomatedChoice(
          [void Function(ChatAutomatedChoiceBuilder)? updates]) =>
      (ChatAutomatedChoiceBuilder()..update(updates))._build();

  _$ChatAutomatedChoice._(
      {required this.welcomeMessageId,
      required this.optionIndex,
      required this.clientMessageId})
      : super._();
  @override
  ChatAutomatedChoice rebuild(
          void Function(ChatAutomatedChoiceBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChatAutomatedChoiceBuilder toBuilder() =>
      ChatAutomatedChoiceBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatAutomatedChoice &&
        welcomeMessageId == other.welcomeMessageId &&
        optionIndex == other.optionIndex &&
        clientMessageId == other.clientMessageId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, welcomeMessageId.hashCode);
    _$hash = $jc(_$hash, optionIndex.hashCode);
    _$hash = $jc(_$hash, clientMessageId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ChatAutomatedChoice')
          ..add('welcomeMessageId', welcomeMessageId)
          ..add('optionIndex', optionIndex)
          ..add('clientMessageId', clientMessageId))
        .toString();
  }
}

class ChatAutomatedChoiceBuilder
    implements Builder<ChatAutomatedChoice, ChatAutomatedChoiceBuilder> {
  _$ChatAutomatedChoice? _$v;

  String? _welcomeMessageId;
  String? get welcomeMessageId => _$this._welcomeMessageId;
  set welcomeMessageId(String? welcomeMessageId) =>
      _$this._welcomeMessageId = welcomeMessageId;

  int? _optionIndex;
  int? get optionIndex => _$this._optionIndex;
  set optionIndex(int? optionIndex) => _$this._optionIndex = optionIndex;

  String? _clientMessageId;
  String? get clientMessageId => _$this._clientMessageId;
  set clientMessageId(String? clientMessageId) =>
      _$this._clientMessageId = clientMessageId;

  ChatAutomatedChoiceBuilder() {
    ChatAutomatedChoice._defaults(this);
  }

  ChatAutomatedChoiceBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _welcomeMessageId = $v.welcomeMessageId;
      _optionIndex = $v.optionIndex;
      _clientMessageId = $v.clientMessageId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChatAutomatedChoice other) {
    _$v = other as _$ChatAutomatedChoice;
  }

  @override
  void update(void Function(ChatAutomatedChoiceBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChatAutomatedChoice build() => _build();

  _$ChatAutomatedChoice _build() {
    final _$result = _$v ??
        _$ChatAutomatedChoice._(
          welcomeMessageId: BuiltValueNullFieldError.checkNotNull(
              welcomeMessageId, r'ChatAutomatedChoice', 'welcomeMessageId'),
          optionIndex: BuiltValueNullFieldError.checkNotNull(
              optionIndex, r'ChatAutomatedChoice', 'optionIndex'),
          clientMessageId: BuiltValueNullFieldError.checkNotNull(
              clientMessageId, r'ChatAutomatedChoice', 'clientMessageId'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
