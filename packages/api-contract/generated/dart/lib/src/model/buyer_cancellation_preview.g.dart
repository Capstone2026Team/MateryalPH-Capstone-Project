// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buyer_cancellation_preview.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BuyerCancellationPreview extends BuyerCancellationPreview {
  @override
  final OrderCancellation availability;
  @override
  final CancellationPlan fullRefund;
  @override
  final CancellationPlan? withNrpcRetained;
  @override
  final int nrpcRetainableCentavos;
  @override
  final String notice;

  factory _$BuyerCancellationPreview(
          [void Function(BuyerCancellationPreviewBuilder)? updates]) =>
      (BuyerCancellationPreviewBuilder()..update(updates))._build();

  _$BuyerCancellationPreview._(
      {required this.availability,
      required this.fullRefund,
      this.withNrpcRetained,
      required this.nrpcRetainableCentavos,
      required this.notice})
      : super._();
  @override
  BuyerCancellationPreview rebuild(
          void Function(BuyerCancellationPreviewBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuyerCancellationPreviewBuilder toBuilder() =>
      BuyerCancellationPreviewBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuyerCancellationPreview &&
        availability == other.availability &&
        fullRefund == other.fullRefund &&
        withNrpcRetained == other.withNrpcRetained &&
        nrpcRetainableCentavos == other.nrpcRetainableCentavos &&
        notice == other.notice;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, availability.hashCode);
    _$hash = $jc(_$hash, fullRefund.hashCode);
    _$hash = $jc(_$hash, withNrpcRetained.hashCode);
    _$hash = $jc(_$hash, nrpcRetainableCentavos.hashCode);
    _$hash = $jc(_$hash, notice.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BuyerCancellationPreview')
          ..add('availability', availability)
          ..add('fullRefund', fullRefund)
          ..add('withNrpcRetained', withNrpcRetained)
          ..add('nrpcRetainableCentavos', nrpcRetainableCentavos)
          ..add('notice', notice))
        .toString();
  }
}

class BuyerCancellationPreviewBuilder
    implements
        Builder<BuyerCancellationPreview, BuyerCancellationPreviewBuilder> {
  _$BuyerCancellationPreview? _$v;

  OrderCancellationBuilder? _availability;
  OrderCancellationBuilder get availability =>
      _$this._availability ??= OrderCancellationBuilder();
  set availability(OrderCancellationBuilder? availability) =>
      _$this._availability = availability;

  CancellationPlanBuilder? _fullRefund;
  CancellationPlanBuilder get fullRefund =>
      _$this._fullRefund ??= CancellationPlanBuilder();
  set fullRefund(CancellationPlanBuilder? fullRefund) =>
      _$this._fullRefund = fullRefund;

  CancellationPlanBuilder? _withNrpcRetained;
  CancellationPlanBuilder get withNrpcRetained =>
      _$this._withNrpcRetained ??= CancellationPlanBuilder();
  set withNrpcRetained(CancellationPlanBuilder? withNrpcRetained) =>
      _$this._withNrpcRetained = withNrpcRetained;

  int? _nrpcRetainableCentavos;
  int? get nrpcRetainableCentavos => _$this._nrpcRetainableCentavos;
  set nrpcRetainableCentavos(int? nrpcRetainableCentavos) =>
      _$this._nrpcRetainableCentavos = nrpcRetainableCentavos;

  String? _notice;
  String? get notice => _$this._notice;
  set notice(String? notice) => _$this._notice = notice;

  BuyerCancellationPreviewBuilder() {
    BuyerCancellationPreview._defaults(this);
  }

  BuyerCancellationPreviewBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _availability = $v.availability.toBuilder();
      _fullRefund = $v.fullRefund.toBuilder();
      _withNrpcRetained = $v.withNrpcRetained?.toBuilder();
      _nrpcRetainableCentavos = $v.nrpcRetainableCentavos;
      _notice = $v.notice;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BuyerCancellationPreview other) {
    _$v = other as _$BuyerCancellationPreview;
  }

  @override
  void update(void Function(BuyerCancellationPreviewBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BuyerCancellationPreview build() => _build();

  _$BuyerCancellationPreview _build() {
    _$BuyerCancellationPreview _$result;
    try {
      _$result = _$v ??
          _$BuyerCancellationPreview._(
            availability: availability.build(),
            fullRefund: fullRefund.build(),
            withNrpcRetained: _withNrpcRetained?.build(),
            nrpcRetainableCentavos: BuiltValueNullFieldError.checkNotNull(
                nrpcRetainableCentavos,
                r'BuyerCancellationPreview',
                'nrpcRetainableCentavos'),
            notice: BuiltValueNullFieldError.checkNotNull(
                notice, r'BuyerCancellationPreview', 'notice'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'availability';
        availability.build();
        _$failedField = 'fullRefund';
        fullRefund.build();
        _$failedField = 'withNrpcRetained';
        _withNrpcRetained?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'BuyerCancellationPreview', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
