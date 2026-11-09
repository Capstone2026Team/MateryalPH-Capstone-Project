// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'commission_policy_publish_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CommissionPolicyPublishRequest extends CommissionPolicyPublishRequest {
  @override
  final int commissionBasisPoints;
  @override
  final int expectedVersion;
  @override
  final DateTime? effectiveFrom;
  @override
  final String reason;
  @override
  final String? vendorMessage;
  @override
  final bool? noticeOverride;
  @override
  final String? noticeOverrideReason;
  @override
  final String? supersedesPolicyId;
  @override
  final bool? cancelScheduled;

  factory _$CommissionPolicyPublishRequest(
          [void Function(CommissionPolicyPublishRequestBuilder)? updates]) =>
      (CommissionPolicyPublishRequestBuilder()..update(updates))._build();

  _$CommissionPolicyPublishRequest._(
      {required this.commissionBasisPoints,
      required this.expectedVersion,
      this.effectiveFrom,
      required this.reason,
      this.vendorMessage,
      this.noticeOverride,
      this.noticeOverrideReason,
      this.supersedesPolicyId,
      this.cancelScheduled})
      : super._();
  @override
  CommissionPolicyPublishRequest rebuild(
          void Function(CommissionPolicyPublishRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CommissionPolicyPublishRequestBuilder toBuilder() =>
      CommissionPolicyPublishRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CommissionPolicyPublishRequest &&
        commissionBasisPoints == other.commissionBasisPoints &&
        expectedVersion == other.expectedVersion &&
        effectiveFrom == other.effectiveFrom &&
        reason == other.reason &&
        vendorMessage == other.vendorMessage &&
        noticeOverride == other.noticeOverride &&
        noticeOverrideReason == other.noticeOverrideReason &&
        supersedesPolicyId == other.supersedesPolicyId &&
        cancelScheduled == other.cancelScheduled;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, commissionBasisPoints.hashCode);
    _$hash = $jc(_$hash, expectedVersion.hashCode);
    _$hash = $jc(_$hash, effectiveFrom.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, vendorMessage.hashCode);
    _$hash = $jc(_$hash, noticeOverride.hashCode);
    _$hash = $jc(_$hash, noticeOverrideReason.hashCode);
    _$hash = $jc(_$hash, supersedesPolicyId.hashCode);
    _$hash = $jc(_$hash, cancelScheduled.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CommissionPolicyPublishRequest')
          ..add('commissionBasisPoints', commissionBasisPoints)
          ..add('expectedVersion', expectedVersion)
          ..add('effectiveFrom', effectiveFrom)
          ..add('reason', reason)
          ..add('vendorMessage', vendorMessage)
          ..add('noticeOverride', noticeOverride)
          ..add('noticeOverrideReason', noticeOverrideReason)
          ..add('supersedesPolicyId', supersedesPolicyId)
          ..add('cancelScheduled', cancelScheduled))
        .toString();
  }
}

class CommissionPolicyPublishRequestBuilder
    implements
        Builder<CommissionPolicyPublishRequest,
            CommissionPolicyPublishRequestBuilder> {
  _$CommissionPolicyPublishRequest? _$v;

  int? _commissionBasisPoints;
  int? get commissionBasisPoints => _$this._commissionBasisPoints;
  set commissionBasisPoints(int? commissionBasisPoints) =>
      _$this._commissionBasisPoints = commissionBasisPoints;

  int? _expectedVersion;
  int? get expectedVersion => _$this._expectedVersion;
  set expectedVersion(int? expectedVersion) =>
      _$this._expectedVersion = expectedVersion;

  DateTime? _effectiveFrom;
  DateTime? get effectiveFrom => _$this._effectiveFrom;
  set effectiveFrom(DateTime? effectiveFrom) =>
      _$this._effectiveFrom = effectiveFrom;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  String? _vendorMessage;
  String? get vendorMessage => _$this._vendorMessage;
  set vendorMessage(String? vendorMessage) =>
      _$this._vendorMessage = vendorMessage;

  bool? _noticeOverride;
  bool? get noticeOverride => _$this._noticeOverride;
  set noticeOverride(bool? noticeOverride) =>
      _$this._noticeOverride = noticeOverride;

  String? _noticeOverrideReason;
  String? get noticeOverrideReason => _$this._noticeOverrideReason;
  set noticeOverrideReason(String? noticeOverrideReason) =>
      _$this._noticeOverrideReason = noticeOverrideReason;

  String? _supersedesPolicyId;
  String? get supersedesPolicyId => _$this._supersedesPolicyId;
  set supersedesPolicyId(String? supersedesPolicyId) =>
      _$this._supersedesPolicyId = supersedesPolicyId;

  bool? _cancelScheduled;
  bool? get cancelScheduled => _$this._cancelScheduled;
  set cancelScheduled(bool? cancelScheduled) =>
      _$this._cancelScheduled = cancelScheduled;

  CommissionPolicyPublishRequestBuilder() {
    CommissionPolicyPublishRequest._defaults(this);
  }

  CommissionPolicyPublishRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _commissionBasisPoints = $v.commissionBasisPoints;
      _expectedVersion = $v.expectedVersion;
      _effectiveFrom = $v.effectiveFrom;
      _reason = $v.reason;
      _vendorMessage = $v.vendorMessage;
      _noticeOverride = $v.noticeOverride;
      _noticeOverrideReason = $v.noticeOverrideReason;
      _supersedesPolicyId = $v.supersedesPolicyId;
      _cancelScheduled = $v.cancelScheduled;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CommissionPolicyPublishRequest other) {
    _$v = other as _$CommissionPolicyPublishRequest;
  }

  @override
  void update(void Function(CommissionPolicyPublishRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CommissionPolicyPublishRequest build() => _build();

  _$CommissionPolicyPublishRequest _build() {
    final _$result = _$v ??
        _$CommissionPolicyPublishRequest._(
          commissionBasisPoints: BuiltValueNullFieldError.checkNotNull(
              commissionBasisPoints,
              r'CommissionPolicyPublishRequest',
              'commissionBasisPoints'),
          expectedVersion: BuiltValueNullFieldError.checkNotNull(
              expectedVersion,
              r'CommissionPolicyPublishRequest',
              'expectedVersion'),
          effectiveFrom: effectiveFrom,
          reason: BuiltValueNullFieldError.checkNotNull(
              reason, r'CommissionPolicyPublishRequest', 'reason'),
          vendorMessage: vendorMessage,
          noticeOverride: noticeOverride,
          noticeOverrideReason: noticeOverrideReason,
          supersedesPolicyId: supersedesPolicyId,
          cancelScheduled: cancelScheduled,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
