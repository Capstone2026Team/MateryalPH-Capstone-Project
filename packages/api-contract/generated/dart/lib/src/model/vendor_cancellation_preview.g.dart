// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_cancellation_preview.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorCancellationPreview extends VendorCancellationPreview {
  @override
  final CancellationPlan vendorCancellation;
  @override
  final CancellationPlan? fullRefund;
  @override
  final CancellationPlan? withNrpcRetained;
  @override
  final int? nrpcRetainableCentavos;
  @override
  final String? notice;

  factory _$VendorCancellationPreview(
          [void Function(VendorCancellationPreviewBuilder)? updates]) =>
      (VendorCancellationPreviewBuilder()..update(updates))._build();

  _$VendorCancellationPreview._(
      {required this.vendorCancellation,
      this.fullRefund,
      this.withNrpcRetained,
      this.nrpcRetainableCentavos,
      this.notice})
      : super._();
  @override
  VendorCancellationPreview rebuild(
          void Function(VendorCancellationPreviewBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorCancellationPreviewBuilder toBuilder() =>
      VendorCancellationPreviewBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorCancellationPreview &&
        vendorCancellation == other.vendorCancellation &&
        fullRefund == other.fullRefund &&
        withNrpcRetained == other.withNrpcRetained &&
        nrpcRetainableCentavos == other.nrpcRetainableCentavos &&
        notice == other.notice;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, vendorCancellation.hashCode);
    _$hash = $jc(_$hash, fullRefund.hashCode);
    _$hash = $jc(_$hash, withNrpcRetained.hashCode);
    _$hash = $jc(_$hash, nrpcRetainableCentavos.hashCode);
    _$hash = $jc(_$hash, notice.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorCancellationPreview')
          ..add('vendorCancellation', vendorCancellation)
          ..add('fullRefund', fullRefund)
          ..add('withNrpcRetained', withNrpcRetained)
          ..add('nrpcRetainableCentavos', nrpcRetainableCentavos)
          ..add('notice', notice))
        .toString();
  }
}

class VendorCancellationPreviewBuilder
    implements
        Builder<VendorCancellationPreview, VendorCancellationPreviewBuilder> {
  _$VendorCancellationPreview? _$v;

  CancellationPlanBuilder? _vendorCancellation;
  CancellationPlanBuilder get vendorCancellation =>
      _$this._vendorCancellation ??= CancellationPlanBuilder();
  set vendorCancellation(CancellationPlanBuilder? vendorCancellation) =>
      _$this._vendorCancellation = vendorCancellation;

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

  VendorCancellationPreviewBuilder() {
    VendorCancellationPreview._defaults(this);
  }

  VendorCancellationPreviewBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _vendorCancellation = $v.vendorCancellation.toBuilder();
      _fullRefund = $v.fullRefund?.toBuilder();
      _withNrpcRetained = $v.withNrpcRetained?.toBuilder();
      _nrpcRetainableCentavos = $v.nrpcRetainableCentavos;
      _notice = $v.notice;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorCancellationPreview other) {
    _$v = other as _$VendorCancellationPreview;
  }

  @override
  void update(void Function(VendorCancellationPreviewBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorCancellationPreview build() => _build();

  _$VendorCancellationPreview _build() {
    _$VendorCancellationPreview _$result;
    try {
      _$result = _$v ??
          _$VendorCancellationPreview._(
            vendorCancellation: vendorCancellation.build(),
            fullRefund: _fullRefund?.build(),
            withNrpcRetained: _withNrpcRetained?.build(),
            nrpcRetainableCentavos: nrpcRetainableCentavos,
            notice: notice,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'vendorCancellation';
        vendorCancellation.build();
        _$failedField = 'fullRefund';
        _fullRefund?.build();
        _$failedField = 'withNrpcRetained';
        _withNrpcRetained?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'VendorCancellationPreview', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
