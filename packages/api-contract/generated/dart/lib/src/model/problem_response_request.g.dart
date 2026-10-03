// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'problem_response_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProblemResponseRequest extends ProblemResponseRequest {
  @override
  final String response;

  factory _$ProblemResponseRequest(
          [void Function(ProblemResponseRequestBuilder)? updates]) =>
      (ProblemResponseRequestBuilder()..update(updates))._build();

  _$ProblemResponseRequest._({required this.response}) : super._();
  @override
  ProblemResponseRequest rebuild(
          void Function(ProblemResponseRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProblemResponseRequestBuilder toBuilder() =>
      ProblemResponseRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProblemResponseRequest && response == other.response;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, response.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProblemResponseRequest')
          ..add('response', response))
        .toString();
  }
}

class ProblemResponseRequestBuilder
    implements Builder<ProblemResponseRequest, ProblemResponseRequestBuilder> {
  _$ProblemResponseRequest? _$v;

  String? _response;
  String? get response => _$this._response;
  set response(String? response) => _$this._response = response;

  ProblemResponseRequestBuilder() {
    ProblemResponseRequest._defaults(this);
  }

  ProblemResponseRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _response = $v.response;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProblemResponseRequest other) {
    _$v = other as _$ProblemResponseRequest;
  }

  @override
  void update(void Function(ProblemResponseRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProblemResponseRequest build() => _build();

  _$ProblemResponseRequest _build() {
    final _$result = _$v ??
        _$ProblemResponseRequest._(
          response: BuiltValueNullFieldError.checkNotNull(
              response, r'ProblemResponseRequest', 'response'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
