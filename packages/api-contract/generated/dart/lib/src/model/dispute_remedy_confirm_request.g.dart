// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dispute_remedy_confirm_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DisputeRemedyConfirmRequest extends DisputeRemedyConfirmRequest {
  @override
  final String reason;

  factory _$DisputeRemedyConfirmRequest(
          [void Function(DisputeRemedyConfirmRequestBuilder)? updates]) =>
      (DisputeRemedyConfirmRequestBuilder()..update(updates))._build();

  _$DisputeRemedyConfirmRequest._({required this.reason}) : super._();
  @override
  DisputeRemedyConfirmRequest rebuild(
          void Function(DisputeRemedyConfirmRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DisputeRemedyConfirmRequestBuilder toBuilder() =>
      DisputeRemedyConfirmRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DisputeRemedyConfirmRequest && reason == other.reason;
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
    return (newBuiltValueToStringHelper(r'DisputeRemedyConfirmRequest')
          ..add('reason', reason))
        .toString();
  }
}

class DisputeRemedyConfirmRequestBuilder
    implements
        Builder<DisputeRemedyConfirmRequest,
            DisputeRemedyConfirmRequestBuilder> {
  _$DisputeRemedyConfirmRequest? _$v;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  DisputeRemedyConfirmRequestBuilder() {
    DisputeRemedyConfirmRequest._defaults(this);
  }

  DisputeRemedyConfirmRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DisputeRemedyConfirmRequest other) {
    _$v = other as _$DisputeRemedyConfirmRequest;
  }

  @override
  void update(void Function(DisputeRemedyConfirmRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DisputeRemedyConfirmRequest build() => _build();

  _$DisputeRemedyConfirmRequest _build() {
    final _$result = _$v ??
        _$DisputeRemedyConfirmRequest._(
          reason: BuiltValueNullFieldError.checkNotNull(
              reason, r'DisputeRemedyConfirmRequest', 'reason'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
