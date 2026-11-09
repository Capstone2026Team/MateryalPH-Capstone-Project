// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buyer_rating_summary.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BuyerRatingSummary extends BuyerRatingSummary {
  @override
  final num? score;
  @override
  final int count;
  @override
  final int minimumCount;
  @override
  final int windowDays;
  @override
  final num? inquirySeriousness;
  @override
  final num? communicationQuality;
  @override
  final num? paymentReliability;

  factory _$BuyerRatingSummary(
          [void Function(BuyerRatingSummaryBuilder)? updates]) =>
      (BuyerRatingSummaryBuilder()..update(updates))._build();

  _$BuyerRatingSummary._(
      {this.score,
      required this.count,
      required this.minimumCount,
      required this.windowDays,
      this.inquirySeriousness,
      this.communicationQuality,
      this.paymentReliability})
      : super._();
  @override
  BuyerRatingSummary rebuild(
          void Function(BuyerRatingSummaryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuyerRatingSummaryBuilder toBuilder() =>
      BuyerRatingSummaryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuyerRatingSummary &&
        score == other.score &&
        count == other.count &&
        minimumCount == other.minimumCount &&
        windowDays == other.windowDays &&
        inquirySeriousness == other.inquirySeriousness &&
        communicationQuality == other.communicationQuality &&
        paymentReliability == other.paymentReliability;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, score.hashCode);
    _$hash = $jc(_$hash, count.hashCode);
    _$hash = $jc(_$hash, minimumCount.hashCode);
    _$hash = $jc(_$hash, windowDays.hashCode);
    _$hash = $jc(_$hash, inquirySeriousness.hashCode);
    _$hash = $jc(_$hash, communicationQuality.hashCode);
    _$hash = $jc(_$hash, paymentReliability.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BuyerRatingSummary')
          ..add('score', score)
          ..add('count', count)
          ..add('minimumCount', minimumCount)
          ..add('windowDays', windowDays)
          ..add('inquirySeriousness', inquirySeriousness)
          ..add('communicationQuality', communicationQuality)
          ..add('paymentReliability', paymentReliability))
        .toString();
  }
}

class BuyerRatingSummaryBuilder
    implements Builder<BuyerRatingSummary, BuyerRatingSummaryBuilder> {
  _$BuyerRatingSummary? _$v;

  num? _score;
  num? get score => _$this._score;
  set score(num? score) => _$this._score = score;

  int? _count;
  int? get count => _$this._count;
  set count(int? count) => _$this._count = count;

  int? _minimumCount;
  int? get minimumCount => _$this._minimumCount;
  set minimumCount(int? minimumCount) => _$this._minimumCount = minimumCount;

  int? _windowDays;
  int? get windowDays => _$this._windowDays;
  set windowDays(int? windowDays) => _$this._windowDays = windowDays;

  num? _inquirySeriousness;
  num? get inquirySeriousness => _$this._inquirySeriousness;
  set inquirySeriousness(num? inquirySeriousness) =>
      _$this._inquirySeriousness = inquirySeriousness;

  num? _communicationQuality;
  num? get communicationQuality => _$this._communicationQuality;
  set communicationQuality(num? communicationQuality) =>
      _$this._communicationQuality = communicationQuality;

  num? _paymentReliability;
  num? get paymentReliability => _$this._paymentReliability;
  set paymentReliability(num? paymentReliability) =>
      _$this._paymentReliability = paymentReliability;

  BuyerRatingSummaryBuilder() {
    BuyerRatingSummary._defaults(this);
  }

  BuyerRatingSummaryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _score = $v.score;
      _count = $v.count;
      _minimumCount = $v.minimumCount;
      _windowDays = $v.windowDays;
      _inquirySeriousness = $v.inquirySeriousness;
      _communicationQuality = $v.communicationQuality;
      _paymentReliability = $v.paymentReliability;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BuyerRatingSummary other) {
    _$v = other as _$BuyerRatingSummary;
  }

  @override
  void update(void Function(BuyerRatingSummaryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BuyerRatingSummary build() => _build();

  _$BuyerRatingSummary _build() {
    final _$result = _$v ??
        _$BuyerRatingSummary._(
          score: score,
          count: BuiltValueNullFieldError.checkNotNull(
              count, r'BuyerRatingSummary', 'count'),
          minimumCount: BuiltValueNullFieldError.checkNotNull(
              minimumCount, r'BuyerRatingSummary', 'minimumCount'),
          windowDays: BuiltValueNullFieldError.checkNotNull(
              windowDays, r'BuyerRatingSummary', 'windowDays'),
          inquirySeriousness: inquirySeriousness,
          communicationQuality: communicationQuality,
          paymentReliability: paymentReliability,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
