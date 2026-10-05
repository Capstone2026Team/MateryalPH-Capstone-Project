// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'investigation_reason_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$InvestigationReasonRequest extends InvestigationReasonRequest {
  @override
  final String reason;

  factory _$InvestigationReasonRequest(
          [void Function(InvestigationReasonRequestBuilder)? updates]) =>
      (InvestigationReasonRequestBuilder()..update(updates))._build();

  _$InvestigationReasonRequest._({required this.reason}) : super._();
  @override
  InvestigationReasonRequest rebuild(
          void Function(InvestigationReasonRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InvestigationReasonRequestBuilder toBuilder() =>
      InvestigationReasonRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InvestigationReasonRequest && reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'InvestigationReasonRequest')
          ..add('reason', reason))
        .toString();
  }
}

class InvestigationReasonRequestBuilder
    implements
        Builder<InvestigationReasonRequest, InvestigationReasonRequestBuilder> {
  _$InvestigationReasonRequest? _$v;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  InvestigationReasonRequestBuilder() {
    InvestigationReasonRequest._defaults(this);
  }

  InvestigationReasonRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(InvestigationReasonRequest other) {
    _$v = other as _$InvestigationReasonRequest;
  }

  @override
  void update(void Function(InvestigationReasonRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  InvestigationReasonRequest build() => _build();

  _$InvestigationReasonRequest _build() {
    final _$result = _$v ??
        _$InvestigationReasonRequest._(
          reason: BuiltValueNullFieldError.checkNotNull(
              reason, r'InvestigationReasonRequest', 'reason'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
