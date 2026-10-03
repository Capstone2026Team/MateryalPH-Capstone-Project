// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fee_credit_proposal_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FeeCreditProposalRequest extends FeeCreditProposalRequest {
  @override
  final String feeAssessmentId;
  @override
  final int returnedExclusiveCentavos;
  @override
  final String reason;

  factory _$FeeCreditProposalRequest(
          [void Function(FeeCreditProposalRequestBuilder)? updates]) =>
      (FeeCreditProposalRequestBuilder()..update(updates))._build();

  _$FeeCreditProposalRequest._(
      {required this.feeAssessmentId,
      required this.returnedExclusiveCentavos,
      required this.reason})
      : super._();
  @override
  FeeCreditProposalRequest rebuild(
          void Function(FeeCreditProposalRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FeeCreditProposalRequestBuilder toBuilder() =>
      FeeCreditProposalRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FeeCreditProposalRequest &&
        feeAssessmentId == other.feeAssessmentId &&
        returnedExclusiveCentavos == other.returnedExclusiveCentavos &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, feeAssessmentId.hashCode);
    _$hash = $jc(_$hash, returnedExclusiveCentavos.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FeeCreditProposalRequest')
          ..add('feeAssessmentId', feeAssessmentId)
          ..add('returnedExclusiveCentavos', returnedExclusiveCentavos)
          ..add('reason', reason))
        .toString();
  }
}

class FeeCreditProposalRequestBuilder
    implements
        Builder<FeeCreditProposalRequest, FeeCreditProposalRequestBuilder> {
  _$FeeCreditProposalRequest? _$v;

  String? _feeAssessmentId;
  String? get feeAssessmentId => _$this._feeAssessmentId;
  set feeAssessmentId(String? feeAssessmentId) =>
      _$this._feeAssessmentId = feeAssessmentId;

  int? _returnedExclusiveCentavos;
  int? get returnedExclusiveCentavos => _$this._returnedExclusiveCentavos;
  set returnedExclusiveCentavos(int? returnedExclusiveCentavos) =>
      _$this._returnedExclusiveCentavos = returnedExclusiveCentavos;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  FeeCreditProposalRequestBuilder() {
    FeeCreditProposalRequest._defaults(this);
  }

  FeeCreditProposalRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _feeAssessmentId = $v.feeAssessmentId;
      _returnedExclusiveCentavos = $v.returnedExclusiveCentavos;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FeeCreditProposalRequest other) {
    _$v = other as _$FeeCreditProposalRequest;
  }

  @override
  void update(void Function(FeeCreditProposalRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FeeCreditProposalRequest build() => _build();

  _$FeeCreditProposalRequest _build() {
    final _$result = _$v ??
        _$FeeCreditProposalRequest._(
          feeAssessmentId: BuiltValueNullFieldError.checkNotNull(
              feeAssessmentId, r'FeeCreditProposalRequest', 'feeAssessmentId'),
          returnedExclusiveCentavos: BuiltValueNullFieldError.checkNotNull(
              returnedExclusiveCentavos,
              r'FeeCreditProposalRequest',
              'returnedExclusiveCentavos'),
          reason: BuiltValueNullFieldError.checkNotNull(
              reason, r'FeeCreditProposalRequest', 'reason'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
