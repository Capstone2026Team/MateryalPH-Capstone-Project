// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dispute_escalate_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DisputeEscalateRequest extends DisputeEscalateRequest {
  @override
  final String reason;

  factory _$DisputeEscalateRequest(
          [void Function(DisputeEscalateRequestBuilder)? updates]) =>
      (DisputeEscalateRequestBuilder()..update(updates))._build();

  _$DisputeEscalateRequest._({required this.reason}) : super._();
  @override
  DisputeEscalateRequest rebuild(
          void Function(DisputeEscalateRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DisputeEscalateRequestBuilder toBuilder() =>
      DisputeEscalateRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DisputeEscalateRequest && reason == other.reason;
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
    return (newBuiltValueToStringHelper(r'DisputeEscalateRequest')
          ..add('reason', reason))
        .toString();
  }
}

class DisputeEscalateRequestBuilder
    implements Builder<DisputeEscalateRequest, DisputeEscalateRequestBuilder> {
  _$DisputeEscalateRequest? _$v;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  DisputeEscalateRequestBuilder() {
    DisputeEscalateRequest._defaults(this);
  }

  DisputeEscalateRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DisputeEscalateRequest other) {
    _$v = other as _$DisputeEscalateRequest;
  }

  @override
  void update(void Function(DisputeEscalateRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DisputeEscalateRequest build() => _build();

  _$DisputeEscalateRequest _build() {
    final _$result = _$v ??
        _$DisputeEscalateRequest._(
          reason: BuiltValueNullFieldError.checkNotNull(
              reason, r'DisputeEscalateRequest', 'reason'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
