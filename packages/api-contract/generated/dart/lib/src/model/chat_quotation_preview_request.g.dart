// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_quotation_preview_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ChatQuotationPreviewRequest extends ChatQuotationPreviewRequest {
  @override
  final ChatDraftContent draft;

  factory _$ChatQuotationPreviewRequest(
          [void Function(ChatQuotationPreviewRequestBuilder)? updates]) =>
      (ChatQuotationPreviewRequestBuilder()..update(updates))._build();

  _$ChatQuotationPreviewRequest._({required this.draft}) : super._();
  @override
  ChatQuotationPreviewRequest rebuild(
          void Function(ChatQuotationPreviewRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChatQuotationPreviewRequestBuilder toBuilder() =>
      ChatQuotationPreviewRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatQuotationPreviewRequest && draft == other.draft;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, draft.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ChatQuotationPreviewRequest')
          ..add('draft', draft))
        .toString();
  }
}

class ChatQuotationPreviewRequestBuilder
    implements
        Builder<ChatQuotationPreviewRequest,
            ChatQuotationPreviewRequestBuilder> {
  _$ChatQuotationPreviewRequest? _$v;

  ChatDraftContentBuilder? _draft;
  ChatDraftContentBuilder get draft =>
      _$this._draft ??= ChatDraftContentBuilder();
  set draft(ChatDraftContentBuilder? draft) => _$this._draft = draft;

  ChatQuotationPreviewRequestBuilder() {
    ChatQuotationPreviewRequest._defaults(this);
  }

  ChatQuotationPreviewRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _draft = $v.draft.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChatQuotationPreviewRequest other) {
    _$v = other as _$ChatQuotationPreviewRequest;
  }

  @override
  void update(void Function(ChatQuotationPreviewRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChatQuotationPreviewRequest build() => _build();

  _$ChatQuotationPreviewRequest _build() {
    _$ChatQuotationPreviewRequest _$result;
    try {
      _$result = _$v ??
          _$ChatQuotationPreviewRequest._(
            draft: draft.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'draft';
        draft.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ChatQuotationPreviewRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
