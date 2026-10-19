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

  factory _$CommissionPolicyPublishRequest(
          [void Function(CommissionPolicyPublishRequestBuilder)? updates]) =>
      (CommissionPolicyPublishRequestBuilder()..update(updates))._build();

  _$CommissionPolicyPublishRequest._(
      {required this.commissionBasisPoints,
      required this.expectedVersion,
      this.effectiveFrom,
      required this.reason})
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
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, commissionBasisPoints.hashCode);
    _$hash = $jc(_$hash, expectedVersion.hashCode);
    _$hash = $jc(_$hash, effectiveFrom.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CommissionPolicyPublishRequest')
          ..add('commissionBasisPoints', commissionBasisPoints)
          ..add('expectedVersion', expectedVersion)
          ..add('effectiveFrom', effectiveFrom)
          ..add('reason', reason))
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
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
