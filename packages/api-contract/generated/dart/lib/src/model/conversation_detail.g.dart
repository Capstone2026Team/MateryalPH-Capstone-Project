// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_detail.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ConversationDetail extends ConversationDetail {
  @override
  final ConversationView conversation;
  @override
  final ChatMessagePage messages;
  @override
  final ChatQuotationPage quotations;
  @override
  final BuiltList<SiteInspection>? siteInspections;

  factory _$ConversationDetail(
          [void Function(ConversationDetailBuilder)? updates]) =>
      (ConversationDetailBuilder()..update(updates))._build();

  _$ConversationDetail._(
      {required this.conversation,
      required this.messages,
      required this.quotations,
      this.siteInspections})
      : super._();
  @override
  ConversationDetail rebuild(
          void Function(ConversationDetailBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ConversationDetailBuilder toBuilder() =>
      ConversationDetailBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ConversationDetail &&
        conversation == other.conversation &&
        messages == other.messages &&
        quotations == other.quotations &&
        siteInspections == other.siteInspections;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, conversation.hashCode);
    _$hash = $jc(_$hash, messages.hashCode);
    _$hash = $jc(_$hash, quotations.hashCode);
    _$hash = $jc(_$hash, siteInspections.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ConversationDetail')
          ..add('conversation', conversation)
          ..add('messages', messages)
          ..add('quotations', quotations)
          ..add('siteInspections', siteInspections))
        .toString();
  }
}

class ConversationDetailBuilder
    implements Builder<ConversationDetail, ConversationDetailBuilder> {
  _$ConversationDetail? _$v;

  ConversationViewBuilder? _conversation;
  ConversationViewBuilder get conversation =>
      _$this._conversation ??= ConversationViewBuilder();
  set conversation(ConversationViewBuilder? conversation) =>
      _$this._conversation = conversation;

  ChatMessagePageBuilder? _messages;
  ChatMessagePageBuilder get messages =>
      _$this._messages ??= ChatMessagePageBuilder();
  set messages(ChatMessagePageBuilder? messages) => _$this._messages = messages;

  ChatQuotationPageBuilder? _quotations;
  ChatQuotationPageBuilder get quotations =>
      _$this._quotations ??= ChatQuotationPageBuilder();
  set quotations(ChatQuotationPageBuilder? quotations) =>
      _$this._quotations = quotations;

  ListBuilder<SiteInspection>? _siteInspections;
  ListBuilder<SiteInspection> get siteInspections =>
      _$this._siteInspections ??= ListBuilder<SiteInspection>();
  set siteInspections(ListBuilder<SiteInspection>? siteInspections) =>
      _$this._siteInspections = siteInspections;

  ConversationDetailBuilder() {
    ConversationDetail._defaults(this);
  }

  ConversationDetailBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _conversation = $v.conversation.toBuilder();
      _messages = $v.messages.toBuilder();
      _quotations = $v.quotations.toBuilder();
      _siteInspections = $v.siteInspections?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ConversationDetail other) {
    _$v = other as _$ConversationDetail;
  }

  @override
  void update(void Function(ConversationDetailBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ConversationDetail build() => _build();

  _$ConversationDetail _build() {
    _$ConversationDetail _$result;
    try {
      _$result = _$v ??
          _$ConversationDetail._(
            conversation: conversation.build(),
            messages: messages.build(),
            quotations: quotations.build(),
            siteInspections: _siteInspections?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'conversation';
        conversation.build();
        _$failedField = 'messages';
        messages.build();
        _$failedField = 'quotations';
        quotations.build();
        _$failedField = 'siteInspections';
        _siteInspections?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ConversationDetail', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
