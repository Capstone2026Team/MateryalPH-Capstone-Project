// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fulfillment_assignment_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FulfillmentAssignmentRequest extends FulfillmentAssignmentRequest {
  @override
  final int userId;
  @override
  final String reason;

  factory _$FulfillmentAssignmentRequest(
          [void Function(FulfillmentAssignmentRequestBuilder)? updates]) =>
      (FulfillmentAssignmentRequestBuilder()..update(updates))._build();

  _$FulfillmentAssignmentRequest._({required this.userId, required this.reason})
      : super._();
  @override
  FulfillmentAssignmentRequest rebuild(
          void Function(FulfillmentAssignmentRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FulfillmentAssignmentRequestBuilder toBuilder() =>
      FulfillmentAssignmentRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FulfillmentAssignmentRequest &&
        userId == other.userId &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, userId.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FulfillmentAssignmentRequest')
          ..add('userId', userId)
          ..add('reason', reason))
        .toString();
  }
}

class FulfillmentAssignmentRequestBuilder
    implements
        Builder<FulfillmentAssignmentRequest,
            FulfillmentAssignmentRequestBuilder> {
  _$FulfillmentAssignmentRequest? _$v;

  int? _userId;
  int? get userId => _$this._userId;
  set userId(int? userId) => _$this._userId = userId;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  FulfillmentAssignmentRequestBuilder() {
    FulfillmentAssignmentRequest._defaults(this);
  }

  FulfillmentAssignmentRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _userId = $v.userId;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FulfillmentAssignmentRequest other) {
    _$v = other as _$FulfillmentAssignmentRequest;
  }

  @override
  void update(void Function(FulfillmentAssignmentRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FulfillmentAssignmentRequest build() => _build();

  _$FulfillmentAssignmentRequest _build() {
    final _$result = _$v ??
        _$FulfillmentAssignmentRequest._(
          userId: BuiltValueNullFieldError.checkNotNull(
              userId, r'FulfillmentAssignmentRequest', 'userId'),
          reason: BuiltValueNullFieldError.checkNotNull(
              reason, r'FulfillmentAssignmentRequest', 'reason'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
