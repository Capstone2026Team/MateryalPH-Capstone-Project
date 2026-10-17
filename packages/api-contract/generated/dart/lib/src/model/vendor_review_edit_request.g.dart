// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_review_edit_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorReviewEditRequest extends VendorReviewEditRequest {
  @override
  final int lockVersion;
  @override
  final int? inquirySeriousness;
  @override
  final int? communicationQuality;
  @override
  final int? paymentReliability;
  @override
  final String? comment;

  factory _$VendorReviewEditRequest(
          [void Function(VendorReviewEditRequestBuilder)? updates]) =>
      (VendorReviewEditRequestBuilder()..update(updates))._build();

  _$VendorReviewEditRequest._(
      {required this.lockVersion,
      this.inquirySeriousness,
      this.communicationQuality,
      this.paymentReliability,
      this.comment})
      : super._();
  @override
  VendorReviewEditRequest rebuild(
          void Function(VendorReviewEditRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorReviewEditRequestBuilder toBuilder() =>
      VendorReviewEditRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorReviewEditRequest &&
        lockVersion == other.lockVersion &&
        inquirySeriousness == other.inquirySeriousness &&
        communicationQuality == other.communicationQuality &&
        paymentReliability == other.paymentReliability &&
        comment == other.comment;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, inquirySeriousness.hashCode);
    _$hash = $jc(_$hash, communicationQuality.hashCode);
    _$hash = $jc(_$hash, paymentReliability.hashCode);
    _$hash = $jc(_$hash, comment.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorReviewEditRequest')
          ..add('lockVersion', lockVersion)
          ..add('inquirySeriousness', inquirySeriousness)
          ..add('communicationQuality', communicationQuality)
          ..add('paymentReliability', paymentReliability)
          ..add('comment', comment))
        .toString();
  }
}

class VendorReviewEditRequestBuilder
    implements
        Builder<VendorReviewEditRequest, VendorReviewEditRequestBuilder> {
  _$VendorReviewEditRequest? _$v;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  int? _inquirySeriousness;
  int? get inquirySeriousness => _$this._inquirySeriousness;
  set inquirySeriousness(int? inquirySeriousness) =>
      _$this._inquirySeriousness = inquirySeriousness;

  int? _communicationQuality;
  int? get communicationQuality => _$this._communicationQuality;
  set communicationQuality(int? communicationQuality) =>
      _$this._communicationQuality = communicationQuality;

  int? _paymentReliability;
  int? get paymentReliability => _$this._paymentReliability;
  set paymentReliability(int? paymentReliability) =>
      _$this._paymentReliability = paymentReliability;

  String? _comment;
  String? get comment => _$this._comment;
  set comment(String? comment) => _$this._comment = comment;

  VendorReviewEditRequestBuilder() {
    VendorReviewEditRequest._defaults(this);
  }

  VendorReviewEditRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _lockVersion = $v.lockVersion;
      _inquirySeriousness = $v.inquirySeriousness;
      _communicationQuality = $v.communicationQuality;
      _paymentReliability = $v.paymentReliability;
      _comment = $v.comment;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorReviewEditRequest other) {
    _$v = other as _$VendorReviewEditRequest;
  }

  @override
  void update(void Function(VendorReviewEditRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorReviewEditRequest build() => _build();

  _$VendorReviewEditRequest _build() {
    final _$result = _$v ??
        _$VendorReviewEditRequest._(
          lockVersion: BuiltValueNullFieldError.checkNotNull(
              lockVersion, r'VendorReviewEditRequest', 'lockVersion'),
          inquirySeriousness: inquirySeriousness,
          communicationQuality: communicationQuality,
          paymentReliability: paymentReliability,
          comment: comment,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
