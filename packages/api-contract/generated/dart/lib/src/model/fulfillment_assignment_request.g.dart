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
  @override
  final int? vehicleIndex;
  @override
  final int? lockVersion;
  @override
  final bool? dispatch;

  factory _$FulfillmentAssignmentRequest(
          [void Function(FulfillmentAssignmentRequestBuilder)? updates]) =>
      (FulfillmentAssignmentRequestBuilder()..update(updates))._build();

  _$FulfillmentAssignmentRequest._(
      {required this.userId,
      required this.reason,
      this.vehicleIndex,
      this.lockVersion,
      this.dispatch})
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
        reason == other.reason &&
        vehicleIndex == other.vehicleIndex &&
        lockVersion == other.lockVersion &&
        dispatch == other.dispatch;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, userId.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, vehicleIndex.hashCode);
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, dispatch.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FulfillmentAssignmentRequest')
          ..add('userId', userId)
          ..add('reason', reason)
          ..add('vehicleIndex', vehicleIndex)
          ..add('lockVersion', lockVersion)
          ..add('dispatch', dispatch))
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

  int? _vehicleIndex;
  int? get vehicleIndex => _$this._vehicleIndex;
  set vehicleIndex(int? vehicleIndex) => _$this._vehicleIndex = vehicleIndex;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  bool? _dispatch;
  bool? get dispatch => _$this._dispatch;
  set dispatch(bool? dispatch) => _$this._dispatch = dispatch;

  FulfillmentAssignmentRequestBuilder() {
    FulfillmentAssignmentRequest._defaults(this);
  }

  FulfillmentAssignmentRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _userId = $v.userId;
      _reason = $v.reason;
      _vehicleIndex = $v.vehicleIndex;
      _lockVersion = $v.lockVersion;
      _dispatch = $v.dispatch;
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
          vehicleIndex: vehicleIndex,
          lockVersion: lockVersion,
          dispatch: dispatch,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
