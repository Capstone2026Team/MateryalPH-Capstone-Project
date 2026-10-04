// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_explanation_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$InvoiceExplanationRequest extends InvoiceExplanationRequest {
  @override
  final String note;

  factory _$InvoiceExplanationRequest(
          [void Function(InvoiceExplanationRequestBuilder)? updates]) =>
      (InvoiceExplanationRequestBuilder()..update(updates))._build();

  _$InvoiceExplanationRequest._({required this.note}) : super._();
  @override
  InvoiceExplanationRequest rebuild(
          void Function(InvoiceExplanationRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InvoiceExplanationRequestBuilder toBuilder() =>
      InvoiceExplanationRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InvoiceExplanationRequest && note == other.note;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'InvoiceExplanationRequest')
          ..add('note', note))
        .toString();
  }
}

class InvoiceExplanationRequestBuilder
    implements
        Builder<InvoiceExplanationRequest, InvoiceExplanationRequestBuilder> {
  _$InvoiceExplanationRequest? _$v;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  InvoiceExplanationRequestBuilder() {
    InvoiceExplanationRequest._defaults(this);
  }

  InvoiceExplanationRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _note = $v.note;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(InvoiceExplanationRequest other) {
    _$v = other as _$InvoiceExplanationRequest;
  }

  @override
  void update(void Function(InvoiceExplanationRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  InvoiceExplanationRequest build() => _build();

  _$InvoiceExplanationRequest _build() {
    final _$result = _$v ??
        _$InvoiceExplanationRequest._(
          note: BuiltValueNullFieldError.checkNotNull(
              note, r'InvoiceExplanationRequest', 'note'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
