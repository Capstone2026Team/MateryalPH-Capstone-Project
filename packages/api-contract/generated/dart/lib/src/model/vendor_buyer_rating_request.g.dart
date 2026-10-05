// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_buyer_rating_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorBuyerRatingRequest extends VendorBuyerRatingRequest {
  @override
  final int inquirySeriousness;
  @override
  final int communicationQuality;
  @override
  final int paymentReliability;
  @override
  final String? comment;

  factory _$VendorBuyerRatingRequest(
          [void Function(VendorBuyerRatingRequestBuilder)? updates]) =>
      (VendorBuyerRatingRequestBuilder()..update(updates))._build();

  _$VendorBuyerRatingRequest._(
      {required this.inquirySeriousness,
      required this.communicationQuality,
      required this.paymentReliability,
      this.comment})
      : super._();
  @override
  VendorBuyerRatingRequest rebuild(
          void Function(VendorBuyerRatingRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorBuyerRatingRequestBuilder toBuilder() =>
      VendorBuyerRatingRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorBuyerRatingRequest &&
        inquirySeriousness == other.inquirySeriousness &&
        communicationQuality == other.communicationQuality &&
        paymentReliability == other.paymentReliability &&
        comment == other.comment;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, inquirySeriousness.hashCode);
    _$hash = $jc(_$hash, communicationQuality.hashCode);
    _$hash = $jc(_$hash, paymentReliability.hashCode);
    _$hash = $jc(_$hash, comment.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorBuyerRatingRequest')
          ..add('inquirySeriousness', inquirySeriousness)
          ..add('communicationQuality', communicationQuality)
          ..add('paymentReliability', paymentReliability)
          ..add('comment', comment))
        .toString();
  }
}

class VendorBuyerRatingRequestBuilder
    implements
        Builder<VendorBuyerRatingRequest, VendorBuyerRatingRequestBuilder> {
  _$VendorBuyerRatingRequest? _$v;

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

  VendorBuyerRatingRequestBuilder() {
    VendorBuyerRatingRequest._defaults(this);
  }

  VendorBuyerRatingRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _inquirySeriousness = $v.inquirySeriousness;
      _communicationQuality = $v.communicationQuality;
      _paymentReliability = $v.paymentReliability;
      _comment = $v.comment;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorBuyerRatingRequest other) {
    _$v = other as _$VendorBuyerRatingRequest;
  }

  @override
  void update(void Function(VendorBuyerRatingRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorBuyerRatingRequest build() => _build();

  _$VendorBuyerRatingRequest _build() {
    final _$result = _$v ??
        _$VendorBuyerRatingRequest._(
          inquirySeriousness: BuiltValueNullFieldError.checkNotNull(
              inquirySeriousness,
              r'VendorBuyerRatingRequest',
              'inquirySeriousness'),
          communicationQuality: BuiltValueNullFieldError.checkNotNull(
              communicationQuality,
              r'VendorBuyerRatingRequest',
              'communicationQuality'),
          paymentReliability: BuiltValueNullFieldError.checkNotNull(
              paymentReliability,
              r'VendorBuyerRatingRequest',
              'paymentReliability'),
          comment: comment,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
