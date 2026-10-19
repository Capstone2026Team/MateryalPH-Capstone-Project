// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'directory_buyer_profile_ratings_received.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DirectoryBuyerProfileRatingsReceived
    extends DirectoryBuyerProfileRatingsReceived {
  @override
  final int count;
  @override
  final String? inquirySeriousness;
  @override
  final String? communicationQuality;
  @override
  final String? paymentReliability;

  factory _$DirectoryBuyerProfileRatingsReceived(
          [void Function(DirectoryBuyerProfileRatingsReceivedBuilder)?
              updates]) =>
      (DirectoryBuyerProfileRatingsReceivedBuilder()..update(updates))._build();

  _$DirectoryBuyerProfileRatingsReceived._(
      {required this.count,
      this.inquirySeriousness,
      this.communicationQuality,
      this.paymentReliability})
      : super._();
  @override
  DirectoryBuyerProfileRatingsReceived rebuild(
          void Function(DirectoryBuyerProfileRatingsReceivedBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DirectoryBuyerProfileRatingsReceivedBuilder toBuilder() =>
      DirectoryBuyerProfileRatingsReceivedBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DirectoryBuyerProfileRatingsReceived &&
        count == other.count &&
        inquirySeriousness == other.inquirySeriousness &&
        communicationQuality == other.communicationQuality &&
        paymentReliability == other.paymentReliability;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, count.hashCode);
    _$hash = $jc(_$hash, inquirySeriousness.hashCode);
    _$hash = $jc(_$hash, communicationQuality.hashCode);
    _$hash = $jc(_$hash, paymentReliability.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DirectoryBuyerProfileRatingsReceived')
          ..add('count', count)
          ..add('inquirySeriousness', inquirySeriousness)
          ..add('communicationQuality', communicationQuality)
          ..add('paymentReliability', paymentReliability))
        .toString();
  }
}

class DirectoryBuyerProfileRatingsReceivedBuilder
    implements
        Builder<DirectoryBuyerProfileRatingsReceived,
            DirectoryBuyerProfileRatingsReceivedBuilder> {
  _$DirectoryBuyerProfileRatingsReceived? _$v;

  int? _count;
  int? get count => _$this._count;
  set count(int? count) => _$this._count = count;

  String? _inquirySeriousness;
  String? get inquirySeriousness => _$this._inquirySeriousness;
  set inquirySeriousness(String? inquirySeriousness) =>
      _$this._inquirySeriousness = inquirySeriousness;

  String? _communicationQuality;
  String? get communicationQuality => _$this._communicationQuality;
  set communicationQuality(String? communicationQuality) =>
      _$this._communicationQuality = communicationQuality;

  String? _paymentReliability;
  String? get paymentReliability => _$this._paymentReliability;
  set paymentReliability(String? paymentReliability) =>
      _$this._paymentReliability = paymentReliability;

  DirectoryBuyerProfileRatingsReceivedBuilder() {
    DirectoryBuyerProfileRatingsReceived._defaults(this);
  }

  DirectoryBuyerProfileRatingsReceivedBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _count = $v.count;
      _inquirySeriousness = $v.inquirySeriousness;
      _communicationQuality = $v.communicationQuality;
      _paymentReliability = $v.paymentReliability;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DirectoryBuyerProfileRatingsReceived other) {
    _$v = other as _$DirectoryBuyerProfileRatingsReceived;
  }

  @override
  void update(
      void Function(DirectoryBuyerProfileRatingsReceivedBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DirectoryBuyerProfileRatingsReceived build() => _build();

  _$DirectoryBuyerProfileRatingsReceived _build() {
    final _$result = _$v ??
        _$DirectoryBuyerProfileRatingsReceived._(
          count: BuiltValueNullFieldError.checkNotNull(
              count, r'DirectoryBuyerProfileRatingsReceived', 'count'),
          inquirySeriousness: inquirySeriousness,
          communicationQuality: communicationQuality,
          paymentReliability: paymentReliability,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
