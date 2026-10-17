// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dispute_message_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DisputeMessageRequest extends DisputeMessageRequest {
  @override
  final String body;

  factory _$DisputeMessageRequest(
          [void Function(DisputeMessageRequestBuilder)? updates]) =>
      (DisputeMessageRequestBuilder()..update(updates))._build();

  _$DisputeMessageRequest._({required this.body}) : super._();
  @override
  DisputeMessageRequest rebuild(
          void Function(DisputeMessageRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DisputeMessageRequestBuilder toBuilder() =>
      DisputeMessageRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DisputeMessageRequest && body == other.body;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, body.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DisputeMessageRequest')
          ..add('body', body))
        .toString();
  }
}

class DisputeMessageRequestBuilder
    implements Builder<DisputeMessageRequest, DisputeMessageRequestBuilder> {
  _$DisputeMessageRequest? _$v;

  String? _body;
  String? get body => _$this._body;
  set body(String? body) => _$this._body = body;

  DisputeMessageRequestBuilder() {
    DisputeMessageRequest._defaults(this);
  }

  DisputeMessageRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _body = $v.body;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DisputeMessageRequest other) {
    _$v = other as _$DisputeMessageRequest;
  }

  @override
  void update(void Function(DisputeMessageRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DisputeMessageRequest build() => _build();

  _$DisputeMessageRequest _build() {
    final _$result = _$v ??
        _$DisputeMessageRequest._(
          body: BuiltValueNullFieldError.checkNotNull(
              body, r'DisputeMessageRequest', 'body'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
